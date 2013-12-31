Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3LaPa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 10:30:56 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 2/2] [RFC] mac80211: Add all enabled channels to the supported channels element
Date: Tue, 31 Dec 2013 17:32:26 +0200
Message-Id: <1388503946-25862-3-git-send-email-ilan.peer@intel.com> (sfid-20131231_163100_337930_7D3482AD)
In-Reply-To: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
References: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the current implementation, in case that the AP supports
spectrum management, the supported channels information element added
to the association and re-association frames includes only the channels
that where in the same band as that of the operating channel of the AP.
However, the 80211-2012 specification defines in 8.4.2.20 that the supported
channels information element should contain a list of the channel subbands
in which the station is capable to operate.

Fix this gap by including all the channels enabled by the device
(excluding channels that are marked as disabled).

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/mlme.c |   80 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9c2c7ee..04da17d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -540,6 +540,70 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
 }
 
+static void ieee80211_add_supported_channels(struct ieee80211_local *local,
+					     struct sk_buff *skb,
+					     unsigned int n_channels)
+{
+	struct ieee80211_supported_band *sband;
+	unsigned int i, j;
+	u8 *pos, *len_pos;
+
+	if (!n_channels)
+		return;
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
+	len_pos = pos;
+	*len_pos = 0;
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		u8 chan, first_chan = 0, count = 0;
+
+		sband = local->hw.wiphy->bands[i];
+		if (!sband)
+			continue;
+
+		for (j = 0; j < sband->n_channels; j++) {
+			u16 center_freq;
+
+			if (sband->channels[j].flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			center_freq = sband->channels[j].center_freq;
+			chan = ieee80211_frequency_to_channel(center_freq);
+
+			if (first_chan == 0) {
+				/* first subband */
+				first_chan = chan;
+				count = 1;
+			} else if (first_chan + count == chan) {
+				/* continue the subband.
+				 * TODO: this is really only useful for 2.4,
+				 * need to add spacing considerations for other
+				 * bands as well (the definition of a subband
+				 * in the 802.11 spec. is a bit vague).
+				 */
+				count++;
+			} else {
+				/* store the subband and start a new one */
+				pos = skb_put(skb, 2);
+				*pos++ = first_chan;
+				*pos = count;
+				*len_pos += 2;
+				first_chan = chan;
+				count = 1;
+			}
+		}
+
+		if (first_chan) {
+				pos = skb_put(skb, 2);
+				*pos++ = first_chan;
+				*pos = count;
+				*len_pos += 2;
+		}
+	}
+}
+
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -555,6 +619,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
 	u32 rate_flags, rates = 0;
+	unsigned int n_channels;
 
 	sdata_assert_lock(sdata);
 
@@ -597,12 +662,15 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	/* Get the number of enabled channels for spectrum management */
+	n_channels = ieee80211_get_num_enabled_channels(local->hw.wiphy);
+
 	skb = alloc_skb(local->hw.extra_tx_headroom +
 			sizeof(*mgmt) + /* bit too much but doesn't matter */
 			2 + assoc_data->ssid_len + /* SSID */
 			4 + rates_len + /* (extended) rates */
 			4 + /* power capability */
-			2 + 2 * sband->n_channels + /* supported channels */
+			2 + 2 * n_channels + /* supported channels */
 			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
 			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
 			assoc_data->ie_len + /* extra IEs */
@@ -704,15 +772,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = ieee80211_chandef_max_power(&chanctx_conf->def);
 
 		/* 2. supported channels */
-		/* TODO: get this in reg domain format */
-		pos = skb_put(skb, 2 * sband->n_channels + 2);
-		*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
-		*pos++ = 2 * sband->n_channels;
-		for (i = 0; i < sband->n_channels; i++) {
-			*pos++ = ieee80211_frequency_to_channel(
-					sband->channels[i].center_freq);
-			*pos++ = 1; /* one channel in the subband*/
-		}
+		ieee80211_add_supported_channels(local, skb, n_channels);
 	}
 
 	/* if present, add any custom IEs that go before HT */
-- 
1.7.10.4


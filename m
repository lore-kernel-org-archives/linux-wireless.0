Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54942 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKIQue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:34 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so7049872wgh.15
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:33 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/16] mac80211: add supported channels IE during TDLS setup
Date: Sun,  9 Nov 2014 18:50:12 +0200
Message-Id: <1415551822-20121-6-git-send-email-arik@wizery.com> (sfid-20141109_181321_171234_AECC1606)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This information element is mandatory in case TDLS channel-switching is to
be supported. The channels given are ones supported and allowed to be
active in the current regulatory setting.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tdls.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index d4fe091..8fb314b 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -48,6 +48,75 @@ static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
 	*pos++ = WLAN_EXT_CAPA5_TDLS_ENABLED;
 }
 
+static u8
+ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
+			   struct sk_buff *skb, u16 start, u16 end,
+			   u16 spacing)
+{
+	u8 subband_cnt = 0, ch_cnt = 0;
+	struct ieee80211_channel *ch;
+	struct cfg80211_chan_def chandef;
+	int i, subband_start;
+
+	for (i = start; i <= end; i += spacing) {
+		if (!ch_cnt)
+			subband_start = i;
+
+		ch = ieee80211_get_channel(sdata->local->hw.wiphy, i);
+		if (ch) {
+			/* we will be active on the channel */
+			u32 flags = IEEE80211_CHAN_DISABLED |
+				    IEEE80211_CHAN_NO_IR;
+			cfg80211_chandef_create(&chandef, ch,
+						NL80211_CHAN_HT20);
+			if (cfg80211_chandef_usable(sdata->local->hw.wiphy,
+						    &chandef, flags)) {
+				ch_cnt++;
+				continue;
+			}
+		}
+
+		if (ch_cnt) {
+			u8 *pos = skb_put(skb, 2);
+			*pos++ = ieee80211_frequency_to_channel(subband_start);
+			*pos++ = ch_cnt;
+
+			subband_cnt++;
+			ch_cnt = 0;
+		}
+	}
+
+	return subband_cnt;
+}
+
+static void
+ieee80211_tdls_add_supp_channels(struct ieee80211_sub_if_data *sdata,
+				 struct sk_buff *skb)
+{
+	/*
+	 * Add possible channels for TDLS. These are channels that are allowed
+	 * to be active.
+	 */
+	u8 subband_cnt;
+	u8 *pos = skb_put(skb, 2);
+
+	*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
+
+	/*
+	 * 5GHz and 2GHz channels numbers can overlap. Ignore this for now, as
+	 * this doesn't happen in real world scenarios.
+	 */
+
+	/* 2GHz, with 5MHz spacing */
+	subband_cnt = ieee80211_tdls_add_subband(sdata, skb, 2412, 2472, 5);
+
+	/* 5GHz, with 20MHz spacing */
+	subband_cnt += ieee80211_tdls_add_subband(sdata, skb, 5000, 5825, 20);
+
+	/* length */
+	*pos = 2 * subband_cnt;
+}
+
 static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata,
 					u16 status_code)
 {
@@ -190,6 +259,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_add_srates_ie(sdata, skb, false, band);
 	ieee80211_add_ext_srates_ie(sdata, skb, false, band);
+	ieee80211_tdls_add_supp_channels(sdata, skb);
 
 	/* add any custom IEs that go before Extended Capabilities */
 	if (extra_ies_len) {
@@ -526,6 +596,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			       26 + /* max(WMM-info, WMM-param) */
 			       2 + max(sizeof(struct ieee80211_ht_cap),
 				       sizeof(struct ieee80211_ht_operation)) +
+			       50 + /* supported channels */
 			       extra_ies_len +
 			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
-- 
1.9.1


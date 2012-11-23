Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2KWNo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 08:44:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: use DS or HT operation IEs to determine BSS channel
Date: Fri, 23 Nov 2012 14:45:24 +0100
Message-Id: <1353678324-32160-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_144502_888428_2B11BC8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, mac80211 checks the DS params IE if present and
uses it for the (primary) BSS channel, instead of the one
that the frame was received on. This is particularly useful
in the 2.4 GHz band since a frame is often received on one
of the adjacent channels due to overlap.

Move this code to cfg80211 so other drivers also do this.

Additionally, on 5 GHz, in particular with some (possibly)
upcoming changes in 802.11ai and duplicate transmissions
when wider channels are used, something similar happens.
So if present, also use the (primary) channel information
contained in the HT operation IE.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |  9 +--------
 net/wireless/scan.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 13d2329..ddd1a9a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -174,7 +174,6 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	u8 *elements;
 	struct ieee80211_channel *channel;
 	size_t baselen;
-	int freq;
 	bool beacon;
 	struct ieee802_11_elems elems;
 
@@ -209,13 +208,7 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 
 	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
 
-	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0],
-						      rx_status->band);
-	else
-		freq = rx_status->freq;
-
-	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
 
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7f97a08..9596015 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -771,6 +771,38 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	return found;
 }
 
+static struct ieee80211_channel *
+cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
+			 struct ieee80211_channel *channel)
+{
+	const u8 *tmp;
+	u32 freq;
+	int channel_number = -1;
+
+	tmp = cfg80211_find_ie(WLAN_EID_DS_PARAMS, ie, ielen);
+	if (tmp && tmp[1] == 1) {
+		channel_number = tmp[2];
+	} else {
+		tmp = cfg80211_find_ie(WLAN_EID_HT_OPERATION, ie, ielen);
+		if (tmp && tmp[1] >= sizeof(struct ieee80211_ht_operation)) {
+			struct ieee80211_ht_operation *htop = (void *)(tmp + 2);
+
+			channel_number = htop->primary_chan;
+		}
+	}
+
+	if (channel_number < 0)
+		return channel;
+
+	freq = ieee80211_channel_to_frequency(channel_number, channel->band);
+	channel = ieee80211_get_channel(wiphy, freq);
+	if (!channel)
+		return NULL;
+	if (channel->flags & IEEE80211_CHAN_DISABLED)
+		return NULL;
+	return channel;
+}
+
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
@@ -790,6 +822,10 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 			(signal < 0 || signal > 100)))
 		return NULL;
 
+	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, channel);
+	if (!channel)
+		return NULL;
+
 	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
 	if (!res)
 		return NULL;
@@ -839,11 +875,13 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss *res;
-
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 	size_t privsz;
 
+	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
+			offsetof(struct ieee80211_mgmt, u.beacon.variable));
+
 	trace_cfg80211_inform_bss_frame(wiphy, channel, mgmt, len, signal);
 
 	if (WARN_ON(!mgmt))
@@ -861,6 +899,11 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 
 	privsz = wiphy->bss_priv_size;
 
+	channel = cfg80211_get_bss_channel(wiphy, mgmt->u.beacon.variable,
+					   ielen, channel);
+	if (!channel)
+		return NULL;
+
 	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
 	if (!res)
 		return NULL;
-- 
1.8.0


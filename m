Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47678 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab0KVT61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 14:58:27 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] cfg80211/mac80211: improve ad-hoc multicast rate handling
Date: Mon, 22 Nov 2010 20:58:24 +0100
Message-Id: <1290455904-58440-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- store the multicast rate as an index instead of the rate value
  (reduces cpu overhead in a hotpath)
- validate the rate values (must match a bitrate in at least one sband)

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h |    4 ++--
 include/net/mac80211.h |    4 ++--
 net/mac80211/ibss.c    |    3 ++-
 net/mac80211/rate.c    |   25 ++++++++++++-------------
 net/wireless/nl80211.c |   36 +++++++++++++++++++++++++++++++++---
 5 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3884f0d..f4fe812 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -927,7 +927,7 @@ struct cfg80211_disassoc_request {
  * @privacy: this is a protected network, keys will be configured
  *	after joining
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
- * @mcast_rate: multicast tx rate (in 100 kbps)
+ * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -939,7 +939,7 @@ struct cfg80211_ibss_params {
 	u32 basic_rates;
 	bool channel_fixed;
 	bool privacy;
-	int mcast_rate;
+	int mcast_rate[IEEE80211_NUM_BANDS];
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b0fff2..08e97e5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -219,7 +219,7 @@ enum ieee80211_bss_change {
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
- * @mcast_rate: multicast rate for AP and Ad-Hoc (in 100 kbps)
+ * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
  * @channel_type: Channel type for this BSS -- the hardware might be
@@ -259,7 +259,7 @@ struct ieee80211_bss_conf {
 	u16 assoc_capability;
 	u64 timestamp;
 	u32 basic_rates;
-	u32 mcast_rate;
+	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6fe6837..410d104 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -915,7 +915,8 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.basic_rates = params->basic_rates;
-	sdata->vif.bss_conf.mcast_rate = params->mcast_rate;
+	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
+	       sizeof(params->mcast_rate));
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 76de4f8..3d5a2cb 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -211,20 +211,11 @@ static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 	return (info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc);
 }
 
-static void rc_send_low_broadcast(s8 *idx, u32 basic_rates, u32 mcast_rate,
+static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 				  struct ieee80211_supported_band *sband)
 {
 	u8 i;
 
-	if (mcast_rate) {
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].bitrate == mcast_rate) {
-				*idx = i;
-				return;
-			}
-		}
-	}
-
 	if (basic_rates == 0)
 		return; /* assume basic rates unknown and accept rate */
 	if (*idx < 0)
@@ -247,17 +238,25 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 			   struct ieee80211_tx_rate_control *txrc)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
+	struct ieee80211_supported_band *sband = txrc->sband;
+	int mcast_rate;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
 		info->control.rates[0].idx = rate_lowest_index(txrc->sband, sta);
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			1 : txrc->hw->max_rate_tries;
-		if (!sta && txrc->bss)
+		if (!sta && txrc->bss) {
+			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
+			if (mcast_rate > 0) {
+				info->control.rates[0].idx = mcast_rate - 1;
+				return true;
+			}
+
 			rc_send_low_broadcast(&info->control.rates[0].idx,
 					      txrc->bss_conf->basic_rates,
-					      txrc->bss_conf->mcast_rate,
-					      txrc->sband);
+					      sband);
+		}
 		return true;
 	}
 	return false;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 13a40dd..9e2af81 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3603,6 +3603,34 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 				      local_state_change);
 }
 
+static bool
+nl80211_parse_mcast_rate(struct cfg80211_registered_device *rdev,
+			 int mcast_rate[IEEE80211_NUM_BANDS],
+			 int rateval)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	bool found = false;
+	int band, i;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband;
+
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == rateval) {
+				mcast_rate[band] = i + 1;
+				found = true;
+				break;
+			}
+		}
+	}
+
+	return found;
+}
+
 static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -3686,9 +3714,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 		}
 	}
-	if (info->attrs[NL80211_ATTR_MCAST_RATE])
-		ibss.mcast_rate =
-			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
+
+	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
+	    !nl80211_parse_mcast_rate(rdev, ibss.mcast_rate,
+			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
+		return -EINVAL;
 
 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
 		connkeys = nl80211_parse_connkeys(rdev,
-- 
1.7.3.2


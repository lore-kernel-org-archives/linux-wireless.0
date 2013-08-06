Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62879 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3HFVph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 17:45:37 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so1026846pbb.14
        for <linux-wireless@vger.kernel.org>; Tue, 06 Aug 2013 14:45:36 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v2] mac80211: allow lowest basic rate for unicast management for mesh
Date: Tue,  6 Aug 2013 14:45:19 -0700
Message-Id: <1375825519-24568-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130806_234545_966559_20874C17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow lowest basic rate to be used for unicast management frame in
mesh. Otherwise, the lowest supported rate is used for unicast
management frame, such as 1Mbps for 2.4GHz and 6Mbps for 5GHz. Rename
the rc_send_low_broadcast to re_send_low_basicrate since now it is
also applied to unicast management frame in mesh.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---

v2: Refactor to avoid duplication of code (Johannes)

 net/mac80211/rate.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index ba63ac8..4aa7bb6 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -210,7 +210,7 @@ static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 		!ieee80211_is_data(fc);
 }
 
-static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
+static void rc_send_low_basicrate(s8 *idx, u32 basic_rates,
 				  struct ieee80211_supported_band *sband)
 {
 	u8 i;
@@ -263,28 +263,37 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 }
 
 
-bool rate_control_send_low(struct ieee80211_sta *sta,
+bool rate_control_send_low(struct ieee80211_sta *pubsta,
 			   void *priv_sta,
 			   struct ieee80211_tx_rate_control *txrc)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	struct ieee80211_supported_band *sband = txrc->sband;
+	struct sta_info *sta;
 	int mcast_rate;
+	bool use_basicrate = false;
 
-	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
-		__rate_control_send_low(txrc->hw, sband, sta, info);
+	if (!pubsta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
+		__rate_control_send_low(txrc->hw, sband, pubsta, info);
 
-		if (!sta && txrc->bss) {
+		if (!pubsta && txrc->bss) {
 			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
 			if (mcast_rate > 0) {
 				info->control.rates[0].idx = mcast_rate - 1;
 				return true;
 			}
+			use_basicrate = true;
+		} else {
+			sta = container_of(pubsta, struct sta_info, sta);
+			if (ieee80211_vif_is_mesh(&sta->sdata->vif))
+				use_basicrate = true;
+		}
 
-			rc_send_low_broadcast(&info->control.rates[0].idx,
+		if (use_basicrate)
+			rc_send_low_basicrate(&info->control.rates[0].idx,
 					      txrc->bss_conf->basic_rates,
 					      sband);
-		}
+
 		return true;
 	}
 	return false;
-- 
1.7.9.5


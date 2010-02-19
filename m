Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0BSSIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:08:18 -0500
Message-Id: <20100219180736.677926079@sipsolutions.net>
Date: Fri, 19 Feb 2010 19:06:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ar9170: convert to new station add/remove callbacks
References: <20100219180652.409890561@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts ar9170 to use the new station
add/remove callbacks instead of using the
old sta_notify callback.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/main.c |   80 ++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 39 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2010-02-19 18:50:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2010-02-19 18:53:43.000000000 +0100
@@ -2329,54 +2329,55 @@ out:
 	return err;
 }
 
-static void ar9170_sta_notify(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      enum sta_notify_cmd cmd,
-			      struct ieee80211_sta *sta)
+static int ar9170_sta_add(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
 	unsigned int i;
 
-	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		memset(sta_info, 0, sizeof(*sta_info));
-
-		if (!sta->ht_cap.ht_supported)
-			break;
-
-		if (sta->ht_cap.ampdu_density > ar->global_ampdu_density)
-			ar->global_ampdu_density = sta->ht_cap.ampdu_density;
-
-		if (sta->ht_cap.ampdu_factor < ar->global_ampdu_factor)
-			ar->global_ampdu_factor = sta->ht_cap.ampdu_factor;
-
-		for (i = 0; i < AR9170_NUM_TID; i++) {
-			sta_info->agg[i].state = AR9170_TID_STATE_SHUTDOWN;
-			sta_info->agg[i].active = false;
-			sta_info->agg[i].ssn = 0;
-			sta_info->agg[i].tid = i;
-			INIT_LIST_HEAD(&sta_info->agg[i].list);
-			skb_queue_head_init(&sta_info->agg[i].queue);
-		}
+	memset(sta_info, 0, sizeof(*sta_info));
 
-		sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
-		break;
+	if (!sta->ht_cap.ht_supported)
+		return 0;
 
-	case STA_NOTIFY_REMOVE:
-		if (!sta->ht_cap.ht_supported)
-			break;
-
-		for (i = 0; i < AR9170_NUM_TID; i++) {
-			sta_info->agg[i].state = AR9170_TID_STATE_INVALID;
-			skb_queue_purge(&sta_info->agg[i].queue);
-		}
+	if (sta->ht_cap.ampdu_density > ar->global_ampdu_density)
+		ar->global_ampdu_density = sta->ht_cap.ampdu_density;
 
-		break;
+	if (sta->ht_cap.ampdu_factor < ar->global_ampdu_factor)
+		ar->global_ampdu_factor = sta->ht_cap.ampdu_factor;
+
+	for (i = 0; i < AR9170_NUM_TID; i++) {
+		sta_info->agg[i].state = AR9170_TID_STATE_SHUTDOWN;
+		sta_info->agg[i].active = false;
+		sta_info->agg[i].ssn = 0;
+		sta_info->agg[i].tid = i;
+		INIT_LIST_HEAD(&sta_info->agg[i].list);
+		skb_queue_head_init(&sta_info->agg[i].queue);
+	}
 
-	default:
-		break;
+	sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
+
+	return 0;
+}
+
+static int ar9170_sta_remove(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta)
+{
+	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
+	unsigned int i;
+
+	if (!sta->ht_cap.ht_supported)
+		return 0;
+
+	for (i = 0; i < AR9170_NUM_TID; i++) {
+		sta_info->agg[i].state = AR9170_TID_STATE_INVALID;
+		skb_queue_purge(&sta_info->agg[i].queue);
 	}
+
+	return 0;
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
@@ -2495,7 +2496,8 @@ static const struct ieee80211_ops ar9170
 	.bss_info_changed	= ar9170_op_bss_info_changed,
 	.get_tsf		= ar9170_op_get_tsf,
 	.set_key		= ar9170_set_key,
-	.sta_notify		= ar9170_sta_notify,
+	.sta_add		= ar9170_sta_add,
+	.sta_remove		= ar9170_sta_remove,
 	.get_stats		= ar9170_get_stats,
 	.ampdu_action		= ar9170_ampdu_action,
 };



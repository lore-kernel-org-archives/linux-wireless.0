Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53764 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZHRX0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 19:26:34 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: refactor configure_filter
Date: Wed, 19 Aug 2009 01:26:30 +0200
Cc: John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908190126.31928.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to "mac80211: allow configure_filter callback to sleep",
we no longer have to defer the work to the workqueue.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
please test!
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index e6c3ee3..9c4d43c 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -184,10 +184,8 @@ struct ar9170 {
 	bool disable_offload;
 
 	/* filter settings */
-	struct work_struct filter_config_work;
-	u64 cur_mc_hash, want_mc_hash;
-	u32 cur_filter, want_filter;
-	unsigned long filter_changed;
+	u64 cur_mc_hash;
+	u32 cur_filter;
 	unsigned int filter_state;
 	bool sniffer_enabled;
 
@@ -261,10 +259,6 @@ struct ar9170_tx_info {
 #define IS_STARTED(a)		(((struct ar9170 *)a)->state >= AR9170_STARTED)
 #define IS_ACCEPTING_CMD(a)	(((struct ar9170 *)a)->state >= AR9170_IDLE)
 
-#define AR9170_FILTER_CHANGED_MODE		BIT(0)
-#define AR9170_FILTER_CHANGED_MULTICAST		BIT(1)
-#define AR9170_FILTER_CHANGED_FRAMEFILTER	BIT(2)
-
 /* exported interface */
 void *ar9170_alloc(size_t priv_size);
 int ar9170_register(struct ar9170 *ar, struct device *pdev);
@@ -278,8 +272,8 @@ int ar9170_nag_limiter(struct ar9170 *ar);
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int ar9170_init_mac(struct ar9170 *ar);
 int ar9170_set_qos(struct ar9170 *ar);
-int ar9170_update_multicast(struct ar9170 *ar);
-int ar9170_update_frame_filter(struct ar9170 *ar);
+int ar9170_update_multicast(struct ar9170 *ar, const u64 mc_hast);
+int ar9170_update_frame_filter(struct ar9170 *ar, const u32 filter);
 int ar9170_set_operating_mode(struct ar9170 *ar);
 int ar9170_set_beacon_timers(struct ar9170 *ar);
 int ar9170_set_dyn_sifs_ack(struct ar9170 *ar);
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index d9f1f46..6004936 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -238,39 +238,31 @@ static int ar9170_set_mac_reg(struct ar9170 *ar, const u32 reg, const u8 *mac)
 	return ar9170_regwrite_result();
 }
 
-int ar9170_update_multicast(struct ar9170 *ar)
+int ar9170_update_multicast(struct ar9170 *ar, const u64 mc_hash)
 {
 	int err;
 
 	ar9170_regwrite_begin(ar);
-	ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_H,
-		ar->want_mc_hash >> 32);
-	ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_L,
-		ar->want_mc_hash);
-
+	ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_H, mc_hash >> 32);
+	ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_L, mc_hash);
 	ar9170_regwrite_finish();
 	err = ar9170_regwrite_result();
-
 	if (err)
 		return err;
 
-	ar->cur_mc_hash = ar->want_mc_hash;
-
+	ar->cur_mc_hash = mc_hash;
 	return 0;
 }
 
-int ar9170_update_frame_filter(struct ar9170 *ar)
+int ar9170_update_frame_filter(struct ar9170 *ar, const u32 filter)
 {
 	int err;
 
-	err = ar9170_write_reg(ar, AR9170_MAC_REG_FRAMETYPE_FILTER,
-			       ar->want_filter);
-
+	err = ar9170_write_reg(ar, AR9170_MAC_REG_FRAMETYPE_FILTER, filter);
 	if (err)
 		return err;
 
-	ar->cur_filter = ar->want_filter;
-
+	ar->cur_filter = filter;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 6a9462e..0d91f43 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1232,8 +1232,6 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->mutex);
 
-	ar->filter_changed = 0;
-
 	/* reinitialize queues statistics */
 	memset(&ar->tx_stats, 0, sizeof(ar->tx_stats));
 	for (i = 0; i < __AR9170_NUM_TXQ; i++)
@@ -1296,7 +1294,6 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 #ifdef CONFIG_AR9170_LEDS
 	cancel_delayed_work_sync(&ar->led_work);
 #endif
-	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
 
 	mutex_lock(&ar->mutex);
@@ -1973,8 +1970,7 @@ static int ar9170_op_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->cur_filter = 0;
-	ar->want_filter = AR9170_MAC_REG_FTF_DEFAULTS;
-	err = ar9170_update_frame_filter(ar);
+	err = ar9170_update_frame_filter(ar, AR9170_MAC_REG_FTF_DEFAULTS);
 	if (err)
 		goto unlock;
 
@@ -1992,8 +1988,7 @@ static void ar9170_op_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->mutex);
 	ar->vif = NULL;
-	ar->want_filter = 0;
-	ar9170_update_frame_filter(ar);
+	ar9170_update_frame_filter(ar, 0);
 	ar9170_set_beacon_timers(ar);
 	dev_kfree_skb(ar->beacon);
 	ar->beacon = NULL;
@@ -2065,41 +2060,6 @@ out:
 	return err;
 }
 
-static void ar9170_set_filters(struct work_struct *work)
-{
-	struct ar9170 *ar = container_of(work, struct ar9170,
-					 filter_config_work);
-	int err;
-
-	if (unlikely(!IS_STARTED(ar)))
-		return ;
-
-	mutex_lock(&ar->mutex);
-	if (test_and_clear_bit(AR9170_FILTER_CHANGED_MODE,
-			       &ar->filter_changed)) {
-		err = ar9170_set_operating_mode(ar);
-		if (err)
-			goto unlock;
-	}
-
-	if (test_and_clear_bit(AR9170_FILTER_CHANGED_MULTICAST,
-			       &ar->filter_changed)) {
-		err = ar9170_update_multicast(ar);
-		if (err)
-			goto unlock;
-	}
-
-	if (test_and_clear_bit(AR9170_FILTER_CHANGED_FRAMEFILTER,
-			       &ar->filter_changed)) {
-		err = ar9170_update_frame_filter(ar);
-		if (err)
-			goto unlock;
-	}
-
-unlock:
-	mutex_unlock(&ar->mutex);
-}
-
 static u64 ar9170_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 				       struct dev_addr_list *mclist)
 {
@@ -2126,6 +2086,11 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 {
 	struct ar9170 *ar = hw->priv;
 
+	if (unlikely(!IS_STARTED(ar)))
+		return ;
+
+	mutex_lock(&ar->mutex);
+
 	/* mask supported flags */
 	*new_flags &= FIF_ALLMULTI | FIF_CONTROL | FIF_BCN_PRBRESP_PROMISC |
 		      FIF_PROMISC_IN_BSS | FIF_FCSFAIL | FIF_PLCPFAIL;
@@ -2136,12 +2101,10 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 	 */
 
 	if (changed_flags & FIF_ALLMULTI && *new_flags & FIF_ALLMULTI)
-			multicast = ~0ULL;
+		multicast = ~0ULL;
 
-	if (multicast != ar->want_mc_hash) {
-		ar->want_mc_hash = multicast;
-		set_bit(AR9170_FILTER_CHANGED_MULTICAST, &ar->filter_changed);
-	}
+	if (multicast != ar->cur_mc_hash)
+		ar9170_update_multicast(ar, multicast);
 
 	if (changed_flags & FIF_CONTROL) {
 		u32 filter = AR9170_MAC_REG_FTF_PSPOLL |
@@ -2152,24 +2115,21 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 			     AR9170_MAC_REG_FTF_CFE_ACK;
 
 		if (*new_flags & FIF_CONTROL)
-			ar->want_filter = ar->cur_filter | filter;
+			filter |= ar->cur_filter;
 		else
-			ar->want_filter = ar->cur_filter & ~filter;
+			filter &= (~ar->cur_filter);
 
-		set_bit(AR9170_FILTER_CHANGED_FRAMEFILTER,
-			&ar->filter_changed);
+		ar9170_update_frame_filter(ar, filter);
 	}
 
 	if (changed_flags & FIF_PROMISC_IN_BSS) {
 		ar->sniffer_enabled = ((*new_flags) & FIF_PROMISC_IN_BSS) != 0;
-		set_bit(AR9170_FILTER_CHANGED_MODE,
-			&ar->filter_changed);
+		ar9170_set_operating_mode(ar);
 	}
 
-	if (likely(IS_STARTED(ar)))
-		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
+	mutex_unlock(&ar->mutex);
 }
 
 static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
@@ -2423,9 +2384,6 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 	default:
 		break;
 	}
-
-	if (IS_STARTED(ar) && ar->filter_changed)
-		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
@@ -2596,7 +2554,6 @@ void *ar9170_alloc(size_t priv_size)
 		skb_queue_head_init(&ar->tx_pending[i]);
 	}
 	ar9170_rx_reset_rx_mpdu(ar);
-	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
 	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);

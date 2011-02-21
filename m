Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:53 -0500
Received: by gxk8 with SMTP id 8so301890gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52154.792196.761795@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:38 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 15/23] ath9k_htc: Add ANI for AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The time granularity for the ANI task is different for AP and
station mode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    9 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   49 ++++++++++++++++++-------
 3 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b219428..5b0a21a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -32,6 +32,7 @@
 #include "wmi.h"
 
 #define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
+#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
 #define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
@@ -378,6 +379,7 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_LED_DEINIT		   BIT(5)
 #define OP_BT_PRIORITY_DETECTED    BIT(6)
 #define OP_BT_SCAN                 BIT(7)
+#define OP_ANI_RUNNING             BIT(8)
 
 struct ath9k_htc_priv {
 	struct device *dev;
@@ -429,7 +431,7 @@ struct ath9k_htc_priv {
 	struct ath9k_htc_rx rx;
 	struct tasklet_struct tx_tasklet;
 	struct sk_buff_head tx_queue;
-	struct delayed_work ath9k_ani_work;
+	struct delayed_work ani_work;
 	struct work_struct ps_work;
 	struct work_struct fatal_work;
 
@@ -484,8 +486,9 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv);
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
-void ath9k_ani_work(struct work_struct *work);
-void ath_start_ani(struct ath9k_htc_priv *priv);
+void ath9k_htc_ani_work(struct work_struct *work);
+void ath9k_htc_start_ani(struct ath9k_htc_priv *priv);
+void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a7bc26d..52c6af2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -679,7 +679,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 		     (unsigned long)priv);
 	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet,
 		     (unsigned long)priv);
-	INIT_DELAYED_WORK(&priv->ath9k_ani_work, ath9k_ani_work);
+	INIT_DELAYED_WORK(&priv->ani_work, ath9k_htc_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
 	INIT_WORK(&priv->fatal_work, ath9k_fatal_work);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9733580..f384b35 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -124,7 +124,7 @@ static void ath9k_htc_vif_reconfig(struct ath9k_htc_priv *priv)
 	ieee80211_iterate_active_interfaces_atomic(priv->hw,
 						   ath9k_htc_vif_iter, priv);
 	if (priv->rearm_ani)
-		ath_start_ani(priv);
+		ath9k_htc_start_ani(priv);
 
 	if (priv->reconfig_beacon) {
 		ath9k_htc_ps_wakeup(priv);
@@ -192,7 +192,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	ath9k_htc_stop_ani(priv);
 	ieee80211_stop_queues(priv->hw);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -917,7 +917,7 @@ void ath9k_htc_debug_remove_root(void)
 /* ANI */
 /*******/
 
-void ath_start_ani(struct ath9k_htc_priv *priv)
+void ath9k_htc_start_ani(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
@@ -926,15 +926,22 @@ void ath_start_ani(struct ath9k_htc_priv *priv)
 	common->ani.shortcal_timer = timestamp;
 	common->ani.checkani_timer = timestamp;
 
-	ieee80211_queue_delayed_work(common->hw, &priv->ath9k_ani_work,
+	priv->op_flags |= OP_ANI_RUNNING;
+
+	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
 				     msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 }
 
-void ath9k_ani_work(struct work_struct *work)
+void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->ani_work);
+	priv->op_flags &= ~OP_ANI_RUNNING;
+}
+
+void ath9k_htc_ani_work(struct work_struct *work)
 {
 	struct ath9k_htc_priv *priv =
-		container_of(work, struct ath9k_htc_priv,
-			     ath9k_ani_work.work);
+		container_of(work, struct ath9k_htc_priv, ani_work.work);
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool longcal = false;
@@ -943,7 +950,8 @@ void ath9k_ani_work(struct work_struct *work)
 	unsigned int timestamp = jiffies_to_msecs(jiffies);
 	u32 cal_interval, short_cal_interval;
 
-	short_cal_interval = ATH_STA_SHORT_CALINTERVAL;
+	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
+		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
 	/* Only calibrate if awake */
 	if (ah->power_mode != ATH9K_PM_AWAKE)
@@ -1012,7 +1020,7 @@ set_timer:
 	if (!common->ani.caldone)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
-	ieee80211_queue_delayed_work(common->hw, &priv->ath9k_ani_work,
+	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
 				     msecs_to_jiffies(cal_interval));
 }
 
@@ -1166,7 +1174,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&priv->fatal_work);
 	cancel_work_sync(&priv->ps_work);
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	ath9k_htc_stop_ani(priv);
 	ath9k_led_stop_brightness(priv);
 
 	mutex_lock(&priv->mutex);
@@ -1271,6 +1279,10 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	INC_VIF(priv, vif->type);
 	ath9k_htc_set_opmode(priv);
 
+	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
+	    !(priv->op_flags & OP_ANI_RUNNING))
+		ath9k_htc_start_ani(priv);
+
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
 
@@ -1307,6 +1319,17 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	DEC_VIF(priv, vif->type);
 	ath9k_htc_set_opmode(priv);
 
+	/*
+	 * Stop ANI only if there are no associated station interfaces.
+	 */
+	if ((vif->type == NL80211_IFTYPE_AP) && (priv->num_ap_vif == 0)) {
+		priv->rearm_ani = false;
+		ieee80211_iterate_active_interfaces_atomic(priv->hw,
+						   ath9k_htc_vif_iter, priv);
+		if (!priv->rearm_ani)
+			ath9k_htc_stop_ani(priv);
+	}
+
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
 
 	ath9k_htc_ps_restore(priv);
@@ -1582,9 +1605,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->assoc);
 
 		if (bss_conf->assoc)
-			ath_start_ani(priv);
+			ath9k_htc_start_ani(priv);
 		else
-			cancel_delayed_work_sync(&priv->ath9k_ani_work);
+			ath9k_htc_stop_ani(priv);
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
@@ -1713,7 +1736,7 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 	priv->op_flags |= OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
 	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	ath9k_htc_stop_ani(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.4.1


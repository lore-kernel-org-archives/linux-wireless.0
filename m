Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36674 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FYIZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 04:25:43 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20456.8265.752571.604900@gargle.gargle.HOWL> (sfid-20120625_102548_904721_A45ED839)
Date: Mon, 25 Jun 2012 13:54:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_htc: Use atomic operations for op_flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 10 ++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   | 30 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 28 +++++++++++------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  2 +-
 6 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1357952..1ee6548 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -453,7 +453,6 @@ struct ath9k_htc_priv {
 	u8 num_sta_assoc_vif;
 	u8 num_ap_vif;
 
-	u16 op_flags;
 	u16 curtxpow;
 	u16 txpowlimit;
 	u16 nvifs;
@@ -461,6 +460,7 @@ struct ath9k_htc_priv {
 	bool rearm_ani;
 	bool reconfig_beacon;
 	unsigned int rxfilter;
+	unsigned long op_flags;
 
 	struct ath9k_hw_cal_data caldata;
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 2eadffb..77d541f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -207,9 +207,9 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	else
 		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
-	if (priv->op_flags & OP_TSF_RESET) {
+	if (test_bit(OP_TSF_RESET, &priv->op_flags)) {
 		ath9k_hw_reset_tsf(priv->ah);
-		priv->op_flags &= ~OP_TSF_RESET;
+		clear_bit(OP_TSF_RESET, &priv->op_flags);
 	} else {
 		/*
 		 * Pull nexttbtt forward to reflect the current TSF.
@@ -221,7 +221,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		} while (nexttbtt < tsftu);
 	}
 
-	if (priv->op_flags & OP_ENABLE_BEACON)
+	if (test_bit(OP_ENABLE_BEACON, &priv->op_flags))
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
@@ -269,7 +269,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	else
 		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
-	if (priv->op_flags & OP_ENABLE_BEACON)
+	if (test_bit(OP_ENABLE_BEACON, &priv->op_flags))
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
@@ -365,7 +365,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	vif = priv->cur_beacon_conf.bslot[slot];
 	avp = (struct ath9k_htc_vif *)vif->drv_priv;
 
-	if (unlikely(priv->op_flags & OP_SCANNING)) {
+	if (unlikely(test_bit(OP_SCANNING, &priv->op_flags))) {
 		spin_unlock_bh(&priv->beacon_lock);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 1c10e2e..3688bba 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -37,17 +37,18 @@ static void ath_detect_bt_priority(struct ath9k_htc_priv *priv)
 
 	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		priv->op_flags &= ~(OP_BT_PRIORITY_DETECTED | OP_BT_SCAN);
+		clear_bit(OP_BT_PRIORITY_DETECTED, &priv->op_flags);
+		clear_bit(OP_BT_SCAN, &priv->op_flags);
 		/* Detect if colocated bt started scanning */
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(ah), BTCOEX,
 				"BT scan detected\n");
-			priv->op_flags |= (OP_BT_SCAN |
-					 OP_BT_PRIORITY_DETECTED);
+			set_bit(OP_BT_PRIORITY_DETECTED, &priv->op_flags);
+			set_bit(OP_BT_SCAN, &priv->op_flags);
 		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
 			ath_dbg(ath9k_hw_common(ah), BTCOEX,
 				"BT priority traffic detected\n");
-			priv->op_flags |= OP_BT_PRIORITY_DETECTED;
+			set_bit(OP_BT_PRIORITY_DETECTED, &priv->op_flags);
 		}
 
 		btcoex->bt_priority_cnt = 0;
@@ -67,26 +68,23 @@ static void ath_btcoex_period_work(struct work_struct *work)
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	u32 timer_period;
-	bool is_btscan;
 	int ret;
 
 	ath_detect_bt_priority(priv);
 
-	is_btscan = !!(priv->op_flags & OP_BT_SCAN);
-
 	ret = ath9k_htc_update_cap_target(priv,
-				  !!(priv->op_flags & OP_BT_PRIORITY_DETECTED));
+			  test_bit(OP_BT_PRIORITY_DETECTED, &priv->op_flags));
 	if (ret) {
 		ath_err(common, "Unable to set BTCOEX parameters\n");
 		return;
 	}
 
-	ath9k_hw_btcoex_bt_stomp(priv->ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
-			btcoex->bt_stomp_type);
+	ath9k_hw_btcoex_bt_stomp(priv->ah, test_bit(OP_BT_SCAN, &priv->op_flags) ?
+				 ATH_BTCOEX_STOMP_ALL : btcoex->bt_stomp_type);
 
 	ath9k_hw_btcoex_enable(priv->ah);
-	timer_period = is_btscan ? btcoex->btscan_no_stomp :
-		btcoex->btcoex_no_stomp;
+	timer_period = test_bit(OP_BT_SCAN, &priv->op_flags) ?
+		btcoex->btscan_no_stomp : btcoex->btcoex_no_stomp;
 	ieee80211_queue_delayed_work(priv->hw, &priv->duty_cycle_work,
 				     msecs_to_jiffies(timer_period));
 	ieee80211_queue_delayed_work(priv->hw, &priv->coex_period_work,
@@ -104,14 +102,15 @@ static void ath_btcoex_duty_cycle_work(struct work_struct *work)
 	struct ath_hw *ah = priv->ah;
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_common *common = ath9k_hw_common(ah);
-	bool is_btscan = priv->op_flags & OP_BT_SCAN;
 
 	ath_dbg(common, BTCOEX, "time slice work for bt and wlan\n");
 
-	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW ||
+	    test_bit(OP_BT_SCAN, &priv->op_flags))
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
+
 	ath9k_hw_btcoex_enable(priv->ah);
 }
 
@@ -141,7 +140,8 @@ static void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
-	priv->op_flags &= ~(OP_BT_PRIORITY_DETECTED | OP_BT_SCAN);
+	clear_bit(OP_BT_PRIORITY_DETECTED, &priv->op_flags);
+	clear_bit(OP_BT_SCAN, &priv->op_flags);
 	ieee80211_queue_delayed_work(priv->hw, &priv->coex_period_work, 0);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index cac6ff4..a035a38 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -611,7 +611,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	struct ath_common *common;
 	int i, ret = 0, csz = 0;
 
-	priv->op_flags |= OP_INVALID;
+	set_bit(OP_INVALID, &priv->op_flags);
 
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index abbd6ef..e7182b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -250,7 +250,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	u8 cmd_rsp;
 	int ret;
 
-	if (priv->op_flags & OP_INVALID)
+	if (test_bit(OP_INVALID, &priv->op_flags))
 		return -EIO;
 
 	fastcc = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
@@ -304,7 +304,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	htc_start(priv->htc);
 
-	if (!(priv->op_flags & OP_SCANNING) &&
+	if (!test_bit(OP_SCANNING, &priv->op_flags) &&
 	    !(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		ath9k_htc_vif_reconfig(priv);
 
@@ -750,7 +750,7 @@ void ath9k_htc_start_ani(struct ath9k_htc_priv *priv)
 	common->ani.shortcal_timer = timestamp;
 	common->ani.checkani_timer = timestamp;
 
-	priv->op_flags |= OP_ANI_RUNNING;
+	set_bit(OP_ANI_RUNNING, &priv->op_flags);
 
 	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
 				     msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
@@ -759,7 +759,7 @@ void ath9k_htc_start_ani(struct ath9k_htc_priv *priv)
 void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv)
 {
 	cancel_delayed_work_sync(&priv->ani_work);
-	priv->op_flags &= ~OP_ANI_RUNNING;
+	clear_bit(OP_ANI_RUNNING, &priv->op_flags);
 }
 
 void ath9k_htc_ani_work(struct work_struct *work)
@@ -944,7 +944,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		ath_dbg(common, CONFIG,
 			"Failed to update capability in target\n");
 
-	priv->op_flags &= ~OP_INVALID;
+	clear_bit(OP_INVALID, &priv->op_flags);
 	htc_start(priv->htc);
 
 	spin_lock_bh(&priv->tx.tx_lock);
@@ -973,7 +973,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->op_flags & OP_INVALID) {
+	if (test_bit(OP_INVALID, &priv->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -1015,7 +1015,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	ath9k_htc_ps_restore(priv);
 	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
 
-	priv->op_flags |= OP_INVALID;
+	set_bit(OP_INVALID, &priv->op_flags);
 
 	ath_dbg(common, CONFIG, "Driver halt\n");
 	mutex_unlock(&priv->mutex);
@@ -1105,7 +1105,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	ath9k_htc_set_opmode(priv);
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
-	    !(priv->op_flags & OP_ANI_RUNNING)) {
+	    !test_bit(OP_ANI_RUNNING, &priv->op_flags)) {
 		ath9k_hw_set_tsfadjust(priv->ah, 1);
 		ath9k_htc_start_ani(priv);
 	}
@@ -1285,7 +1285,7 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
-	if (priv->op_flags & OP_INVALID) {
+	if (test_bit(OP_INVALID, &priv->op_flags)) {
 		ath_dbg(ath9k_hw_common(priv->ah), ANY,
 			"Unable to configure filter on invalid state\n");
 		mutex_unlock(&priv->mutex);
@@ -1516,7 +1516,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath_dbg(common, CONFIG, "Beacon enabled for BSS: %pM\n",
 			bss_conf->bssid);
 		ath9k_htc_set_tsfadjust(priv, vif);
-		priv->op_flags |= OP_ENABLE_BEACON;
+		set_bit(OP_ENABLE_BEACON, &priv->op_flags);
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
@@ -1529,7 +1529,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			ath_dbg(common, CONFIG,
 				"Beacon disabled for BSS: %pM\n",
 				bss_conf->bssid);
-			priv->op_flags &= ~OP_ENABLE_BEACON;
+			clear_bit(OP_ENABLE_BEACON, &priv->op_flags);
 			ath9k_htc_beacon_config(priv, vif);
 		}
 	}
@@ -1542,7 +1542,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		    (priv->nvifs == 1) &&
 		    (priv->num_ap_vif == 1) &&
 		    (vif->type == NL80211_IFTYPE_AP)) {
-			priv->op_flags |= OP_TSF_RESET;
+			set_bit(OP_TSF_RESET, &priv->op_flags);
 		}
 		ath_dbg(common, CONFIG,
 			"Beacon interval changed for BSS: %pM\n",
@@ -1654,7 +1654,7 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
-	priv->op_flags |= OP_SCANNING;
+	set_bit(OP_SCANNING, &priv->op_flags);
 	spin_unlock_bh(&priv->beacon_lock);
 	cancel_work_sync(&priv->ps_work);
 	ath9k_htc_stop_ani(priv);
@@ -1667,7 +1667,7 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
-	priv->op_flags &= ~OP_SCANNING;
+	clear_bit(OP_SCANNING, &priv->op_flags);
 	spin_unlock_bh(&priv->beacon_lock);
 	ath9k_htc_ps_wakeup(priv);
 	ath9k_htc_vif_reconfig(priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3e40a64..47e61d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -916,7 +916,7 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 {
 	ath9k_hw_rxena(priv->ah);
 	ath9k_htc_opmode_init(priv);
-	ath9k_hw_startpcureceive(priv->ah, (priv->op_flags & OP_SCANNING));
+	ath9k_hw_startpcureceive(priv->ah, test_bit(OP_SCANNING, &priv->op_flags));
 	priv->rx.last_rssi = ATH_RSSI_DUMMY_MARKER;
 }
 
-- 
1.7.11


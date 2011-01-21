Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1AUDAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:00:43 -0500
Received: by iwn9 with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:00:42 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63149.35095.281380@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:29:57 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 06/33] ath9k_htc: Remove OP_ASSOCIATED variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

mac80211 stores the association state in ieee80211_bss_conf.
Use this and remove the local state, which is incorrect anyway
since it is stored globally and not on a per-VIF basis.

Restarting ANI and reconfiguration of HW beacon timers when a
scan run ends requires more work. This is handled by iterating
over the active interfaces.

Finally, remove the useless check for associated status in RX
processing.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |   14 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   19 ++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   56 ++++++++++++++---------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   26 +++++------
 4 files changed, 74 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 79b67a1..425c8d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -335,11 +335,10 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_SCANNING		   BIT(1)
 #define OP_LED_ASSOCIATED	   BIT(2)
 #define OP_LED_ON		   BIT(3)
-#define OP_ASSOCIATED		   BIT(4)
-#define OP_ENABLE_BEACON	   BIT(5)
-#define OP_LED_DEINIT		   BIT(6)
-#define OP_BT_PRIORITY_DETECTED    BIT(7)
-#define OP_BT_SCAN                 BIT(8)
+#define OP_ENABLE_BEACON	   BIT(4)
+#define OP_LED_DEINIT		   BIT(5)
+#define OP_BT_PRIORITY_DETECTED    BIT(6)
+#define OP_BT_SCAN                 BIT(7)
 
 struct ath9k_htc_priv {
 	struct device *dev;
@@ -370,6 +369,8 @@ struct ath9k_htc_priv {
 	u16 nstations;
 	u16 seq_no;
 	u32 bmiss_cnt;
+	bool rearm_ani;
+	bool reconfig_beacon;
 
 	struct ath9k_hw_cal_data caldata;
 
@@ -429,6 +430,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv);
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
+void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv);
 void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending);
 
 void ath9k_htc_rxep(void *priv, struct sk_buff *skb,
@@ -441,7 +443,7 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv);
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
-void ath9k_ani_work(struct work_struct *work);;
+void ath9k_ani_work(struct work_struct *work);
 void ath_start_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 87cc65a..133f628 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -283,3 +283,22 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 		return;
 	}
 }
+
+void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+
+	switch (priv->ah->opmode) {
+	case NL80211_IFTYPE_STATION:
+		ath9k_htc_beacon_config_sta(priv, cur_conf);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
+		break;
+	default:
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Unsupported beaconing mode\n");
+		return;
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fe6e0bb..04b1609 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -116,6 +116,34 @@ void ath9k_ps_work(struct work_struct *work)
 	ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
 }
 
+static void ath9k_htc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath9k_htc_priv *priv = data;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (bss_conf->assoc) {
+		priv->rearm_ani = true;
+		priv->reconfig_beacon = true;
+	}
+}
+
+static void ath9k_htc_vif_reconfig(struct ath9k_htc_priv *priv)
+{
+	priv->rearm_ani = false;
+	priv->reconfig_beacon = false;
+
+	ieee80211_iterate_active_interfaces_atomic(priv->hw,
+						   ath9k_htc_vif_iter, priv);
+	if (priv->rearm_ani)
+		ath_start_ani(priv);
+
+	if (priv->reconfig_beacon) {
+		ath9k_htc_ps_wakeup(priv);
+		ath9k_htc_beacon_reconfig(priv);
+		ath9k_htc_ps_restore(priv);
+	}
+}
+
 void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
@@ -130,9 +158,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
-	if (priv->op_flags & OP_ASSOCIATED)
-		cancel_delayed_work_sync(&priv->ath9k_ani_work);
-
+	cancel_delayed_work_sync(&priv->ath9k_ani_work);
 	ieee80211_stop_queues(priv->hw);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -158,12 +184,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 
 	WMI_CMD(WMI_ENABLE_INTR_CMDID);
 	htc_start(priv->htc);
-
-	if (priv->op_flags & OP_ASSOCIATED) {
-		ath9k_htc_beacon_config(priv, priv->vif);
-		ath_start_ani(priv);
-	}
-
+	ath9k_htc_vif_reconfig(priv);
 	ieee80211_wake_queues(priv->hw);
 
 	ath9k_htc_ps_restore(priv);
@@ -1488,13 +1509,10 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
 
-		if (bss_conf->assoc) {
-			priv->op_flags |= OP_ASSOCIATED;
+		if (bss_conf->assoc)
 			ath_start_ani(priv);
-		} else {
-			priv->op_flags &= ~OP_ASSOCIATED;
+		else
 			cancel_delayed_work_sync(&priv->ath9k_ani_work);
-		}
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
@@ -1619,8 +1637,7 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 	priv->op_flags |= OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
 	cancel_work_sync(&priv->ps_work);
-	if (priv->op_flags & OP_ASSOCIATED)
-		cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	cancel_delayed_work_sync(&priv->ath9k_ani_work);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -1629,14 +1646,11 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 	struct ath9k_htc_priv *priv = hw->priv;
 
 	mutex_lock(&priv->mutex);
-	ath9k_htc_ps_wakeup(priv);
 	spin_lock_bh(&priv->beacon_lock);
 	priv->op_flags &= ~OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
-	if (priv->op_flags & OP_ASSOCIATED) {
-		ath9k_htc_beacon_config(priv, priv->vif);
-		ath_start_ani(priv);
-	}
+	ath9k_htc_ps_wakeup(priv);
+	ath9k_htc_vif_reconfig(priv);
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 884deeb..6ddcf93 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -591,24 +591,22 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
 			   rxbuf->rxstatus.rs_flags);
 
-	if (priv->op_flags & OP_ASSOCIATED) {
-		if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
-		    !rxbuf->rxstatus.rs_moreaggr)
-			ATH_RSSI_LPF(priv->rx.last_rssi,
-				     rxbuf->rxstatus.rs_rssi);
+	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
+	    !rxbuf->rxstatus.rs_moreaggr)
+		ATH_RSSI_LPF(priv->rx.last_rssi,
+			     rxbuf->rxstatus.rs_rssi);
 
-		last_rssi = priv->rx.last_rssi;
+	last_rssi = priv->rx.last_rssi;
 
-		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-			rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
-							     ATH_RSSI_EP_MULTIPLIER);
+	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
+						     ATH_RSSI_EP_MULTIPLIER);
 
-		if (rxbuf->rxstatus.rs_rssi < 0)
-			rxbuf->rxstatus.rs_rssi = 0;
+	if (rxbuf->rxstatus.rs_rssi < 0)
+		rxbuf->rxstatus.rs_rssi = 0;
 
-		if (ieee80211_is_beacon(fc))
-			priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
-	}
+	if (ieee80211_is_beacon(fc))
+		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
-- 
1.7.3.5


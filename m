Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59382 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAUQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:47 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 06/23] ath9k_htc: use common->op_flags
Date: Sat,  1 Mar 2014 21:15:49 +0100
Message-Id: <1393704966-13985-7-git-send-email-linux@rempel-privat.de> (sfid-20140301_211650_896683_95206B75)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h            |  3 ---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  3 +--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 26 ++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  3 ++-
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index d5a1088..707c5b4 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -437,11 +437,8 @@ static inline void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
 }
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
-#define OP_INVALID		   BIT(0)
-#define OP_SCANNING		   BIT(1)
 #define OP_BT_PRIORITY_DETECTED    BIT(3)
 #define OP_BT_SCAN                 BIT(4)
-#define OP_ANI_RUNNING             BIT(5)
 #define OP_TSF_RESET               BIT(6)
 
 struct ath9k_htc_priv {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 4540eac..9ff9e6e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -343,7 +343,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	vif = priv->beacon.bslot[slot];
 	avp = (struct ath9k_htc_vif *)vif->drv_priv;
 
-	if (unlikely(test_bit(OP_SCANNING, &priv->op_flags))) {
+	if (unlikely(test_bit(ATH_OP_SCANNING, &common->op_flags))) {
 		spin_unlock_bh(&priv->beacon_lock);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6eb19b8..4b3b4dd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -459,8 +459,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	struct ath_common *common;
 	int i, ret = 0, csz = 0;
 
-	set_bit(OP_INVALID, &priv->op_flags);
-
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah)
 		return -ENOMEM;
@@ -485,6 +483,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_htc_btcoex_enable == 1;
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 
 	spin_lock_init(&priv->beacon_lock);
 	spin_lock_init(&priv->tx.tx_lock);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 40733d0..6e17c08 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -250,7 +250,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	u8 cmd_rsp;
 	int ret;
 
-	if (test_bit(OP_INVALID, &priv->op_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return -EIO;
 
 	fastcc = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
@@ -304,7 +304,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	htc_start(priv->htc);
 
-	if (!test_bit(OP_SCANNING, &priv->op_flags) &&
+	if (!test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 	    !(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		ath9k_htc_vif_reconfig(priv);
 
@@ -748,7 +748,7 @@ void ath9k_htc_start_ani(struct ath9k_htc_priv *priv)
 	common->ani.shortcal_timer = timestamp;
 	common->ani.checkani_timer = timestamp;
 
-	set_bit(OP_ANI_RUNNING, &priv->op_flags);
+	set_bit(ATH_OP_ANI_RUN, &common->op_flags);
 
 	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
 				     msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
@@ -756,8 +756,9 @@ void ath9k_htc_start_ani(struct ath9k_htc_priv *priv)
 
 void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv)
 {
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	cancel_delayed_work_sync(&priv->ani_work);
-	clear_bit(OP_ANI_RUNNING, &priv->op_flags);
+	clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
 }
 
 void ath9k_htc_ani_work(struct work_struct *work)
@@ -942,7 +943,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		ath_dbg(common, CONFIG,
 			"Failed to update capability in target\n");
 
-	clear_bit(OP_INVALID, &priv->op_flags);
+	clear_bit(ATH_OP_INVALID, &common->op_flags);
 	htc_start(priv->htc);
 
 	spin_lock_bh(&priv->tx.tx_lock);
@@ -971,7 +972,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(OP_INVALID, &priv->op_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -1013,7 +1014,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	ath9k_htc_ps_restore(priv);
 	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
 
-	set_bit(OP_INVALID, &priv->op_flags);
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 
 	ath_dbg(common, CONFIG, "Driver halt\n");
 	mutex_unlock(&priv->mutex);
@@ -1087,7 +1088,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	ath9k_htc_set_opmode(priv);
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
-	    !test_bit(OP_ANI_RUNNING, &priv->op_flags)) {
+	    !test_bit(ATH_OP_ANI_RUN, &common->op_flags)) {
 		ath9k_hw_set_tsfadjust(priv->ah, true);
 		ath9k_htc_start_ani(priv);
 	}
@@ -1245,13 +1246,14 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 				       u64 multicast)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	u32 rfilt;
 
 	mutex_lock(&priv->mutex);
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
-	if (test_bit(OP_INVALID, &priv->op_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(ath9k_hw_common(priv->ah), ANY,
 			"Unable to configure filter on invalid state\n");
 		mutex_unlock(&priv->mutex);
@@ -1670,10 +1672,11 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
-	set_bit(OP_SCANNING, &priv->op_flags);
+	set_bit(ATH_OP_SCANNING, &common->op_flags);
 	spin_unlock_bh(&priv->beacon_lock);
 	cancel_work_sync(&priv->ps_work);
 	ath9k_htc_stop_ani(priv);
@@ -1683,10 +1686,11 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
-	clear_bit(OP_SCANNING, &priv->op_flags);
+	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 	spin_unlock_bh(&priv->beacon_lock);
 	ath9k_htc_ps_wakeup(priv);
 	ath9k_htc_vif_reconfig(priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 47b2bfc..e8149e3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -924,9 +924,10 @@ static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
 
 void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 {
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	ath9k_hw_rxena(priv->ah);
 	ath9k_htc_opmode_init(priv);
-	ath9k_hw_startpcureceive(priv->ah, test_bit(OP_SCANNING, &priv->op_flags));
+	ath9k_hw_startpcureceive(priv->ah, test_bit(ATH_OP_SCANNING, &common->op_flags));
 }
 
 static inline void convert_htc_flag(struct ath_rx_status *rx_stats,
-- 
1.9.0


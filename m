Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41943 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852Ab0FAJvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:51:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:51:33 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.55013.281809.921510@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:16:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/13] ath9k_htc: Add PS wrappers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW has to be awake when registers are accessed.
Ensure this is so by using the PS wrappers at
appropriate places.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 08afd6e..d6c1f2f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1357,6 +1357,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 out:
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
+
 	return ret;
 }
 
@@ -1373,6 +1374,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
@@ -1383,6 +1385,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath9k_htc_remove_station(priv, vif, NULL);
 	priv->vif = NULL;
 
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -1479,8 +1482,8 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	u32 rfilt;
 
 	mutex_lock(&priv->mutex);
-
 	ath9k_htc_ps_wakeup(priv);
+
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
@@ -1503,9 +1506,11 @@ static int ath9k_htc_sta_add(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	ret = ath9k_htc_add_station(priv, vif, sta);
 	if (!ret)
 		ath9k_htc_init_rate(priv, sta);
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -1519,7 +1524,9 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	ret = ath9k_htc_remove_station(priv, vif, sta);
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -1537,6 +1544,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		return 0;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 
 	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
 
@@ -1557,6 +1565,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	if (ret)
 		ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
 
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -1699,7 +1708,9 @@ static u64 ath9k_htc_get_tsf(struct ieee80211_hw *hw)
 	u64 tsf;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	tsf = ath9k_hw_gettsf64(priv->ah);
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
 	return tsf;
@@ -1710,7 +1721,9 @@ static void ath9k_htc_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 	struct ath9k_htc_priv *priv = hw->priv;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	ath9k_hw_settsf64(priv->ah, tsf);
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -1718,11 +1731,11 @@ static void ath9k_htc_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
-	ath9k_htc_ps_wakeup(priv);
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	ath9k_hw_reset_tsf(priv->ah);
-	mutex_unlock(&priv->mutex);
 	ath9k_htc_ps_restore(priv);
+	mutex_unlock(&priv->mutex);
 }
 
 static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
@@ -1780,8 +1793,8 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
-	ath9k_htc_ps_wakeup(priv);
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	spin_lock_bh(&priv->beacon_lock);
 	priv->op_flags &= ~OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
@@ -1789,8 +1802,8 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 	if (priv->op_flags & OP_ASSOCIATED)
 		ath9k_htc_beacon_config(priv, priv->vif);
 	ath_start_ani(priv);
-	mutex_unlock(&priv->mutex);
 	ath9k_htc_ps_restore(priv);
+	mutex_unlock(&priv->mutex);
 }
 
 static int ath9k_htc_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
@@ -1804,8 +1817,10 @@ static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 	priv->ah->coverage_class = coverage_class;
 	ath9k_hw_init_global_settings(priv->ah);
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19826 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:45 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38184.35036.389130@gargle.gargle.HOWL> (sfid-20120222_081148_883536_FB10340F)
Date: Wed, 22 Feb 2012 12:41:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 17/26] ath9k_htc: Start/stop btcoex using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |   24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   15 +++------------
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index da55967..71e877e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -400,6 +400,8 @@ struct ath_btcoex {
 	u32 btscan_no_stomp;
 };
 
+void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv);
+void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv);
 void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv);
 void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv);
 void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 6506e1f..82f02f7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -160,6 +160,30 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 	cancel_delayed_work_sync(&priv->duty_cycle_work);
 }
 
+void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE) {
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
+		ath9k_hw_btcoex_enable(ah);
+		ath_htc_resume_btcoex_work(priv);
+	}
+}
+
+void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+
+	if (ah->btcoex_hw.enabled &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
+		ath9k_hw_btcoex_disable(ah);
+		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+			ath_htc_cancel_btcoex_work(priv);
+	}
+}
+
 /*******/
 /* LED */
 /*******/
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 06101b6..2a29a7c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -957,12 +957,8 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	mod_timer(&priv->tx.cleanup_timer,
 		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE) {
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_LOW_WLAN_WGHT);
-		ath9k_hw_btcoex_enable(ah);
-		ath_htc_resume_btcoex_work(priv);
-	}
+	ath9k_htc_start_btcoex(priv);
+
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -1009,12 +1005,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (ah->btcoex_hw.enabled &&
-	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		ath9k_hw_btcoex_disable(ah);
-		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
-			ath_htc_cancel_btcoex_work(priv);
-	}
+	ath9k_htc_stop_btcoex(priv);
 
 	/* Remove a monitor interface if it's present. */
 	if (priv->ah->is_monitoring)
-- 
1.7.9.1


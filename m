Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6820 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:51 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38189.657547.415193@gargle.gargle.HOWL> (sfid-20120222_081154_782540_C5F42BB9)
Date: Wed, 22 Feb 2012 12:41:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 18/26] ath9k_htc: Init BTCOEX inside htc_drv_gpio.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |   32 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   32 +------------------------
 3 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 71e877e..8046be6 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -400,6 +400,7 @@ struct ath_btcoex {
 	u32 btscan_no_stomp;
 };
 
+void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product);
 void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv);
 void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv);
 void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 82f02f7..2c61d36 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -20,6 +20,8 @@
 /*     BTCOEX     */
 /******************/
 
+#define ATH_HTC_BTCOEX_PRODUCT_ID "wb193"
+
 /*
  * Detects if there is any priority bt traffic
  */
@@ -184,6 +186,36 @@ void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
 	}
 }
 
+void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
+{
+	struct ath_hw *ah = priv->ah;
+	int qnum;
+
+	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
+		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+			return;
+	}
+
+	switch (ath9k_hw_get_btcoex_scheme(priv->ah)) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		priv->ah->btcoex_hw.btactive_gpio = 7;
+		priv->ah->btcoex_hw.btpriority_gpio = 6;
+		priv->ah->btcoex_hw.wlanactive_gpio = 8;
+		priv->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		ath9k_hw_btcoex_init_3wire(priv->ah);
+		ath_htc_init_btcoex_work(priv);
+		qnum = priv->hwq_map[WME_AC_BE];
+		ath9k_hw_init_btcoex_hw(priv->ah, qnum);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+
 /*******/
 /* LED */
 /*******/
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index fc7519c..de5ee15 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -41,8 +41,6 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 	.max_power = 20, \
 }
 
-#define ATH_HTC_BTCOEX_PRODUCT_ID "wb193"
-
 static struct ieee80211_channel ath9k_2ghz_channels[] = {
 	CHAN2G(2412, 0), /* Channel 1 */
 	CHAN2G(2417, 1), /* Channel 2 */
@@ -603,29 +601,6 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
-static void ath9k_init_btcoex(struct ath9k_htc_priv *priv)
-{
-	int qnum;
-
-	switch (ath9k_hw_get_btcoex_scheme(priv->ah)) {
-	case ATH_BTCOEX_CFG_NONE:
-		break;
-	case ATH_BTCOEX_CFG_3WIRE:
-		priv->ah->btcoex_hw.btactive_gpio = 7;
-		priv->ah->btcoex_hw.btpriority_gpio = 6;
-		priv->ah->btcoex_hw.wlanactive_gpio = 8;
-		priv->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		ath9k_hw_btcoex_init_3wire(priv->ah);
-		ath_htc_init_btcoex_work(priv);
-		qnum = priv->hwq_map[WME_AC_BE];
-		ath9k_hw_init_btcoex_hw(priv->ah, qnum);
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-}
-
 static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 			   u16 devid, char *product,
 			   u32 drv_info)
@@ -698,12 +673,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	ath9k_cmn_init_crypto(ah);
 	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
-
-	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
-		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
-		if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE)
-			ath9k_init_btcoex(priv);
-	}
+	ath9k_htc_init_btcoex(priv, product);
 
 	return 0;
 
-- 
1.7.9.1


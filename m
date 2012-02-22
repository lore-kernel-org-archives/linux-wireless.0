Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6832 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:56 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38195.308140.41060@gargle.gargle.HOWL> (sfid-20120222_081200_291940_A0EF9DC2)
Date: Wed, 22 Feb 2012 12:41:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 19/26] ath9k_htc: Use CONFIG_ATH9K_BTCOEX_SUPPORT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_htc can also make use of CONFIG_ATH9K_BTCOEX_SUPPORT
to be compiled without BTCOEX support.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   18 +++++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |   10 +++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 8046be6..1357952 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -400,12 +400,21 @@ struct ath_btcoex {
 	u32 btscan_no_stomp;
 };
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product);
 void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv);
 void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv);
-void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv);
-void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv);
-void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
+#else
+static inline void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
+{
+}
+static inline void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv)
+{
+}
+static inline void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
+{
+}
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 #define OP_INVALID		   BIT(0)
 #define OP_SCANNING		   BIT(1)
@@ -486,7 +495,10 @@ struct ath9k_htc_priv {
 	int cabq;
 	int hwq_map[WME_NUM_AC];
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
+#endif
+
 	struct delayed_work coex_period_work;
 	struct delayed_work duty_cycle_work;
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 2c61d36..6aa7674 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -22,6 +22,8 @@
 
 #define ATH_HTC_BTCOEX_PRODUCT_ID "wb193"
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 /*
  * Detects if there is any priority bt traffic
  */
@@ -113,7 +115,7 @@ static void ath_btcoex_duty_cycle_work(struct work_struct *work)
 	ath9k_hw_btcoex_enable(priv->ah);
 }
 
-void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
+static void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
 {
 	struct ath_btcoex *btcoex = &priv->btcoex;
 
@@ -133,7 +135,7 @@ void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
  * (Re)start btcoex work
  */
 
-void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
+static void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 {
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_hw *ah = priv->ah;
@@ -153,7 +155,7 @@ void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 /*
  * Cancel btcoex and bt duty cycle work.
  */
-void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
+static void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 {
 	if (ath9k_hw_get_btcoex_scheme(priv->ah) == ATH_BTCOEX_CFG_NONE)
 		return;
@@ -216,6 +218,8 @@ void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
 	}
 }
 
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+
 /*******/
 /* LED */
 /*******/
-- 
1.7.9.1


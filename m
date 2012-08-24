Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27362 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab2HXORw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 10:17:52 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 2/3] ath9k_htc: Add a modparam to enable BTCOEX rather than default
Date: Fri, 24 Aug 2012 19:47:30 +0530
Message-ID: <1345817851-8700-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120824_161755_882754_9D0BF4BC)
In-Reply-To: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Enable BTCOEX for WB193(which seems to be the only supported
ath9k_htc BTCOEX chipset)only when it is enabled via modparam,
rather than enabling it by default.

Cc: Vivek Natarajan <nataraja@qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    9 +++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 07df279..fe4836b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -182,8 +182,17 @@ void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
 void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
 {
 	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int qnum;
 
+	/*
+	 * Check if BTCOEX is globally disabled.
+	 */
+	if (!common->btcoex_enabled) {
+		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_NONE;
+		return;
+	}
+
 	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
 		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..d98255e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -30,6 +30,10 @@ int htc_modparam_nohwcrypt;
 module_param_named(nohwcrypt, htc_modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
+static int ath9k_htc_btcoex_enable;
+module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
+MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
+
 #define CHAN2G(_freq, _idx)  { \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
@@ -635,6 +639,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->hw = priv->hw;
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
+	common->btcoex_enabled = ath9k_htc_btcoex_enable == 1;
 
 	spin_lock_init(&priv->beacon_lock);
 	spin_lock_init(&priv->tx.tx_lock);
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966094Ab2DLV6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/24] iwlwifi: move iwl_set_tx_power and make it static
Date: Thu, 12 Apr 2012 14:54:12 -0700
Message-Id: <1334267661-14654-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_060460_76952158)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

This function is used only in iwl-agn-rxon.c,
move it there and mark it static.

Move this function as part of iwl-core.c
cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   55 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   55 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 --
 3 files changed, 55 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 18776ab..d2da1f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -407,6 +407,61 @@ static int iwlagn_rxon_disconn(struct iwl_priv *priv,
 	return 0;
 }
 
+static int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
+{
+	int ret;
+	s8 prev_tx_power;
+	bool defer;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (priv->tx_power_user_lmt == tx_power && !force)
+		return 0;
+
+	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
+		IWL_WARN(priv,
+			 "Requested user TXPOWER %d below lower limit %d.\n",
+			 tx_power,
+			 IWLAGN_TX_POWER_TARGET_POWER_MIN);
+		return -EINVAL;
+	}
+
+	if (tx_power > priv->tx_power_device_lmt) {
+		IWL_WARN(priv,
+			"Requested user TXPOWER %d above upper limit %d.\n",
+			 tx_power, priv->tx_power_device_lmt);
+		return -EINVAL;
+	}
+
+	if (!iwl_is_ready_rf(priv))
+		return -EIO;
+
+	/* scan complete and commit_rxon use tx_power_next value,
+	 * it always need to be updated for newest request */
+	priv->tx_power_next = tx_power;
+
+	/* do not set tx power when scanning or channel changing */
+	defer = test_bit(STATUS_SCANNING, &priv->status) ||
+		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
+	if (defer && !force) {
+		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
+		return 0;
+	}
+
+	prev_tx_power = priv->tx_power_user_lmt;
+	priv->tx_power_user_lmt = tx_power;
+
+	ret = iwlagn_send_tx_power(priv);
+
+	/* if fail to set tx_power, restore the orig. tx power */
+	if (ret) {
+		priv->tx_power_user_lmt = prev_tx_power;
+		priv->tx_power_next = prev_tx_power;
+	}
+	return ret;
+}
+
 static int iwlagn_rxon_connect(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 42789ed..3bd47e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -66,61 +66,6 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
-{
-	int ret;
-	s8 prev_tx_power;
-	bool defer;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-
-	lockdep_assert_held(&priv->mutex);
-
-	if (priv->tx_power_user_lmt == tx_power && !force)
-		return 0;
-
-	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
-		IWL_WARN(priv,
-			 "Requested user TXPOWER %d below lower limit %d.\n",
-			 tx_power,
-			 IWLAGN_TX_POWER_TARGET_POWER_MIN);
-		return -EINVAL;
-	}
-
-	if (tx_power > priv->tx_power_device_lmt) {
-		IWL_WARN(priv,
-			"Requested user TXPOWER %d above upper limit %d.\n",
-			 tx_power, priv->tx_power_device_lmt);
-		return -EINVAL;
-	}
-
-	if (!iwl_is_ready_rf(priv))
-		return -EIO;
-
-	/* scan complete and commit_rxon use tx_power_next value,
-	 * it always need to be updated for newest request */
-	priv->tx_power_next = tx_power;
-
-	/* do not set tx power when scanning or channel changing */
-	defer = test_bit(STATUS_SCANNING, &priv->status) ||
-		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
-	if (defer && !force) {
-		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
-		return 0;
-	}
-
-	prev_tx_power = priv->tx_power_user_lmt;
-	priv->tx_power_user_lmt = tx_power;
-
-	ret = iwlagn_send_tx_power(priv);
-
-	/* if fail to set tx_power, restore the orig. tx power */
-	if (ret) {
-		priv->tx_power_user_lmt = prev_tx_power;
-		priv->tx_power_next = prev_tx_power;
-	}
-	return ret;
-}
-
 void iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 81c287c..fdd314f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -118,11 +118,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 }
 #endif
 
-/*****************************************************
- * TX power
- ****************************************************/
-int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
-
 /*******************************************************************************
  * Scanning
  ******************************************************************************/
-- 
1.7.0.4


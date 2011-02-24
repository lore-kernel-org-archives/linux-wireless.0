Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1BXNYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 08:24:01 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlegacy: do not set tx power when channel is changing
Date: Thu, 24 Feb 2011 14:23:55 +0100
Message-Id: <1298553835-5821-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same fix as f844a709a7d8f8be61a571afc31dfaca9e779621
"iwlwifi: do not set tx power when channel is changing".

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c |   13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 080444c..f5433c7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1319,7 +1319,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);
 	if (ret) {
 		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index c95c3bc..7cc560b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1114,6 +1114,8 @@ int iwl_legacy_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret;
 	s8 prev_tx_power;
+	bool defer;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -1141,10 +1143,15 @@ int iwl_legacy_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	if (!iwl_legacy_is_ready_rf(priv))
 		return -EIO;
 
-	/* scan complete use tx_power_next, need to be updated */
+	/* scan complete and commit_rxon use tx_power_next value,
+	 * it always need to be updated for newest request */
 	priv->tx_power_next = tx_power;
-	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
-		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
+
+	/* do not set tx power when scanning or channel changing */
+	defer = test_bit(STATUS_SCANNING, &priv->status) ||
+		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
+	if (defer && !force) {
+		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
 		return 0;
 	}
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYGBKRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 06:17:11 -0400
From: Helmut Schaa <hschaa@suse.de>
To: linville@tuxdriver.com
Subject: [PATCH] iwlwifi: fix typo which caused iwl_get_tx_fail_reason to ever return an empty string
Date: Wed, 2 Jul 2008 12:17:06 +0200
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	tomas.winkler@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807021217.06829.hschaa@suse.de> (sfid-20080702_121716_111221_5BCE04C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a typo which caused iwl_get_tx_fail_reason to ever return an empty string.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 81ff4c2..5dd72cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1121,7 +1121,7 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 	clear_bit(txq_id, &priv->txq_ctx_active_msk);
 }
 
-#ifdef CONFIG_IWLWIF_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_get_tx_fail_reason(u32 status);
 #else
 static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7296e28..d38241f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1350,7 +1350,7 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 }
 EXPORT_SYMBOL(iwl_txq_check_empty);
 
-#ifdef CONFIG_IWLWIF_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
 const char *iwl_get_tx_fail_reason(u32 status)

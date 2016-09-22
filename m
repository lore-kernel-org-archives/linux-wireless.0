Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45474 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034488AbcIVUw0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:08 +0300
Message-Id: <20160922205210.1778-9-luca@coelho.fi> (sfid-20160922_225242_510981_B12945F7)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 08/10] iwlwifi: mvm: fix typo in TC_CMD_SEC_KEY_FROM_TABLE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This define should really be TX_CMD_SEC_KEY_FROM_TABLE

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 57d29a1..59ca97a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -147,7 +147,7 @@ enum iwl_tx_pm_timeouts {
  * @TX_CMD_SEC_EXT: extended cipher algorithm.
  * @TX_CMD_SEC_GCMP: GCMP encryption algorithm.
  * @TX_CMD_SEC_KEY128: set for 104 bits WEP key.
- * @TC_CMD_SEC_KEY_FROM_TABLE: for a non-WEP key, set if the key should be taken
+ * @TX_CMD_SEC_KEY_FROM_TABLE: for a non-WEP key, set if the key should be taken
  *	from the table instead of from the TX command.
  *	If the key is taken from the key table its index should be given by the
  *	first byte of the TX command key field.
@@ -159,7 +159,7 @@ enum iwl_tx_cmd_sec_ctrl {
 	TX_CMD_SEC_EXT			= 0x04,
 	TX_CMD_SEC_GCMP			= 0x05,
 	TX_CMD_SEC_KEY128		= 0x08,
-	TC_CMD_SEC_KEY_FROM_TABLE	= 0x08,
+	TX_CMD_SEC_KEY_FROM_TABLE	= 0x08,
 };
 
 /* TODO: how does these values are OK with only 16 bit variable??? */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ef4bdfc..a3fe73b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -441,7 +441,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 		 * one.
 		 * Need to handle this.
 		 */
-		tx_cmd->sec_ctl |= TX_CMD_SEC_GCMP | TC_CMD_SEC_KEY_FROM_TABLE;
+		tx_cmd->sec_ctl |= TX_CMD_SEC_GCMP | TX_CMD_SEC_KEY_FROM_TABLE;
 		tx_cmd->key[0] = keyconf->hw_key_idx;
 		iwl_mvm_set_tx_cmd_pn(info, crypto_hdr);
 		break;
-- 
2.9.3

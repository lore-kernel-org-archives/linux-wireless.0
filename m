Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52744 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757601AbdDRWRt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:13 +0300
Message-Id: <20170418221729.28372-10-luca@coelho.fi> (sfid-20170419_001801_324953_643ECA96)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: change TX_CMD_SEC_KEY_FROM_TABLE value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Change the value of TX_CMD_SEC_KEY_FROM_TABLE flag
in TX_CMD security flags to accommodate a FW API change.

Bump min API for 9000 series devices to 30 to keep the driver aligned
aligned the FW.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index d265b279b2ca..110ceefccc15 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -58,7 +58,7 @@
 #define IWL9000_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
-#define IWL9000_UCODE_API_MIN	17
+#define IWL9000_UCODE_API_MIN	30
 
 /* NVM versions */
 #define IWL9000_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index e9f055706a6f..81b98915b1a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -174,7 +174,7 @@ enum iwl_tx_cmd_sec_ctrl {
 	TX_CMD_SEC_EXT			= 0x04,
 	TX_CMD_SEC_GCMP			= 0x05,
 	TX_CMD_SEC_KEY128		= 0x08,
-	TX_CMD_SEC_KEY_FROM_TABLE	= 0x08,
+	TX_CMD_SEC_KEY_FROM_TABLE	= 0x10,
 };
 
 /* TODO: how does these values are OK with only 16 bit variable??? */
-- 
2.11.0

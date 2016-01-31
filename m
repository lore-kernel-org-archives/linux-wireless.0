Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:21579 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbcAaLGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/31] iwlwifi: various comments and code cleanups
Date: Sun, 31 Jan 2016 13:06:02 +0200
Message-Id: <1454238386-27032-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120636_681311_76ADD690)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to include net/ip6_checksum.h twice.
Remove TODOs.
Remove trailing space.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 1 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 1 -
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index e6a5e99..0ca0f13 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -506,7 +506,7 @@ struct iwl_trans_config {
 	bool sw_csum_tx;
 	const struct iwl_hcmd_arr *command_groups;
 	int command_groups_size;
- 
+
 	u32 sdio_adma_addr;
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index fb6d341..ab467cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -287,16 +287,13 @@ enum iwl_rx_mpdu_status {
 	IWL_RX_MPDU_STATUS_KEY_ERROR		= BIT(4),
 	IWL_RX_MPDU_STATUS_ICV_OK		= BIT(5),
 	IWL_RX_MPDU_STATUS_MIC_OK		= BIT(6),
-	/* TODO - verify this is the correct value */
 	IWL_RX_MPDU_RES_STATUS_TTAK_OK		= BIT(7),
 	IWL_RX_MPDU_STATUS_SEC_MASK		= 0x7 << 8,
 	IWL_RX_MPDU_STATUS_SEC_NONE		= 0x0 << 8,
 	IWL_RX_MPDU_STATUS_SEC_WEP		= 0x1 << 8,
 	IWL_RX_MPDU_STATUS_SEC_CCM		= 0x2 << 8,
 	IWL_RX_MPDU_STATUS_SEC_TKIP		= 0x3 << 8,
-	/* TODO - define IWL_RX_MPDU_STATUS_SEC_EXT_ENC - this is a stub */
 	IWL_RX_MPDU_STATUS_SEC_EXT_ENC		= 0x4 << 8,
-	/* TODO - define IWL_RX_MPDU_STATUS_SEC_GCM - this is a stub */
 	IWL_RX_MPDU_STATUS_SEC_GCM		= 0x5 << 8,
 	IWL_RX_MPDU_STATUS_DECRYPTED		= BIT(11),
 	IWL_RX_MPDU_STATUS_WEP_MATCH		= BIT(12),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 89ea70d..6bf2bde 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -392,7 +392,6 @@ static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[PHY_OPS_GROUP] = HCMD_ARR(iwl_mvm_phy_names),
 };
 
-
 /* this forward declaration can avoid to export the function */
 static void iwl_mvm_async_handlers_wk(struct work_struct *wk);
 static void iwl_mvm_d0i3_exit_work(struct work_struct *wk);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index c499345..837a7d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -34,7 +34,6 @@
 #include <linux/sched.h>
 #include <net/ip6_checksum.h>
 #include <net/tso.h>
-#include <net/ip6_checksum.h>
 
 #include "iwl-debug.h"
 #include "iwl-csr.h"
-- 
2.5.0


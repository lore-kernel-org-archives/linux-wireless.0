Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59374 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751335AbdFEUnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:03 +0300
Message-Id: <20170605204218.30151-11-luca@coelho.fi> (sfid-20170605_224329_226082_CCE1D806)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: pcie: support dumping FH in a000 hw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

FH in A000 HW are placed in a different location,
and need to be read as prph, rather than direct.
Support A000 dumping as well as legacy.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h     |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 62f9fe926d78..2a992277c671 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -77,6 +77,8 @@
  */
 #define FH_MEM_LOWER_BOUND                   (0x1000)
 #define FH_MEM_UPPER_BOUND                   (0x2000)
+#define FH_MEM_LOWER_BOUND_GEN2              (0xa06000)
+#define FH_MEM_UPPER_BOUND_GEN2              (0xa08000)
 
 /**
  * Keep-Warm (KW) buffer base address.
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3af02f491e80..375bdca15704 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2575,8 +2575,15 @@ static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
 	(*data)->len = cpu_to_le32(fh_regs_len);
 	val = (void *)(*data)->data;
 
-	for (i = FH_MEM_LOWER_BOUND; i < FH_MEM_UPPER_BOUND; i += sizeof(u32))
-		*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
+	if (!trans->cfg->gen2)
+		for (i = FH_MEM_LOWER_BOUND; i < FH_MEM_UPPER_BOUND;
+		     i += sizeof(u32))
+			*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
+	else
+		for (i = FH_MEM_LOWER_BOUND_GEN2; i < FH_MEM_UPPER_BOUND_GEN2;
+		     i += sizeof(u32))
+			*val++ = cpu_to_le32(iwl_trans_pcie_read_prph(trans,
+								      i));
 
 	iwl_trans_release_nic_access(trans, &flags);
 
@@ -2752,7 +2759,12 @@ static struct iwl_trans_dump_data
 	len += sizeof(*data) + IWL_CSR_TO_DUMP;
 
 	/* FH registers */
-	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
+	if (trans->cfg->gen2)
+		len += sizeof(*data) +
+		       (FH_MEM_UPPER_BOUND_GEN2 - FH_MEM_LOWER_BOUND_GEN2);
+	else
+		len += sizeof(*data) +
+		       (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
 
 	if (dump_rbs) {
 		/* Dump RBs is supported only for pre-9000 devices (1 queue) */
-- 
2.11.0

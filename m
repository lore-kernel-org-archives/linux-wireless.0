Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54408 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaEORFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:31 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so1413830wes.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/24] iwlwifi: update nmi register
Date: Thu, 15 May 2014 20:04:40 +0300
Message-Id: <1400173481-9047-23-git-send-email-egrumbach@gmail.com> (sfid-20140515_190604_132490_5F5F26FD)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In the 8000 HW family the register for forcing an NMI has
changed, so this allows to still be able to force an NMI
while taking into account the HW in order to write to the
correct register.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c      | 18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h      |  1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h    |  3 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |  3 +--
 drivers/net/wireless/iwlwifi/pcie/tx.c     |  6 +++---
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 44cc3cf..5eef4ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -33,6 +33,7 @@
 #include "iwl-io.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
+#include "iwl-prph.h"
 #include "iwl-fh.h"
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
@@ -183,6 +184,23 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 }
 IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
 
+void iwl_force_nmi(struct iwl_trans *trans)
+{
+	/*
+	 * In HW previous to the 8000 HW family, and in the 8000 HW family
+	 * itself when the revision step==0, the DEVICE_SET_NMI_REG is used
+	 * to force an NMI. Otherwise, a different register -
+	 * DEVICE_SET_NMI_8000B_REG - is used.
+	 */
+	if ((trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) ||
+	    ((trans->hw_rev & 0xc) == 0x0))
+		iwl_write_prph(trans, DEVICE_SET_NMI_REG, DEVICE_SET_NMI_VAL);
+	else
+		iwl_write_prph(trans, DEVICE_SET_NMI_8000B_REG,
+			       DEVICE_SET_NMI_8000B_VAL);
+}
+IWL_EXPORT_SYMBOL(iwl_force_nmi);
+
 static const char *get_fh_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 665ddd9..705d12c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -80,6 +80,7 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+void iwl_force_nmi(struct iwl_trans *trans);
 
 /* Error handling */
 int iwl_dump_fh(struct iwl_trans *trans, char **buf);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 7793110..4997e27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -105,6 +105,9 @@
 
 /* Device NMI register */
 #define DEVICE_SET_NMI_REG 0x00a01c30
+#define DEVICE_SET_NMI_VAL 0x1
+#define DEVICE_SET_NMI_8000B_REG 0x00a01c24
+#define DEVICE_SET_NMI_8000B_VAL 0x1000000
 
 /* Shared registers (0x0..0x3ff, via target indirect or periphery */
 #define SHR_BASE	0x00a10000
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e578129..29ca726 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -65,7 +65,6 @@
 #include "mvm.h"
 #include "sta.h"
 #include "iwl-io.h"
-#include "iwl-prph.h"
 #include "debugfs.h"
 #include "iwl-fw-error-dump.h"
 
@@ -691,7 +690,7 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mvm *mvm, char *buf,
 				      size_t count, loff_t *ppos)
 {
-	iwl_write_prph(mvm->trans, DEVICE_SET_NMI_REG, 1);
+	iwl_force_nmi(mvm->trans);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 2841af3..038940a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -201,7 +201,7 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
 			le32_to_cpu(txq->scratchbufs[i].scratch));
 
-	iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
+	iwl_force_nmi(trans);
 }
 
 /*
@@ -1029,7 +1029,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
 				idx, q->write_ptr, q->read_ptr);
-			iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
+			iwl_force_nmi(trans);
 		}
 	}
 
@@ -1600,7 +1600,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 			       get_cmd_string(trans_pcie, cmd->id));
 		ret = -ETIMEDOUT;
 
-		iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
+		iwl_force_nmi(trans);
 		iwl_trans_fw_error(trans);
 
 		goto cancel;
-- 
1.8.3.2


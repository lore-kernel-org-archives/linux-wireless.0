Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA0D473C88
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246392; cv=none; b=sQfhbcVu+JJ7q80XezUg8qsxLQ9EbekaX5UyoktrJYhZW/sdV17XY18lB1buAPb05Bjow9bqAMprPV6SAAzouN4DE/5pgQmJOckepu6DlBbpKJIw5xXhDsntn7IPcshIS8gYPGHhzLpkR2ciIrq2HKs8it4I3Y4Bt4vid2vmVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246392; c=relaxed/simple;
	bh=bkdTw6MzykLha6txiYVoimMmPlAmzM0685P9NiuSYLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SJHnwxUi0xRyozfCITeHydPvMgMbZSHOorE1deAOasS0To0ljOYJihkEBf+LGlV38NhDYvYTi3p1gPK5SKRHe4tdxfmbQibQVsnf+7Q2zBH21b6D/HEF0Be3GhTC7TIokPkiy9ljOrJ9Ni7txB3Md8Bdc3HpujH+tr8iofmn5LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjBmKYoG; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjBmKYoG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246390; x=1821782390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bkdTw6MzykLha6txiYVoimMmPlAmzM0685P9NiuSYLY=;
  b=hjBmKYoGPZDOSmoHc+81SzDLFtS3wEMz/Fz7j92cxxnJcZRkNil88B+G
   RWgS6pYXWcuACW0xwk4MChFaIpbwgNJ8sEn6cXJq+yP2FNKLcaYSxQQ9Y
   vXgk9aNcG2Ilo2VbFUDMMBZT2zthMyB0Iunc+xMQklHuQDHXuR9eg+uTD
   dhNdbkodv1njV/s+KEqYt3xuDcgIizCj2PacSzZJZM1kEB116nlvvxISM
   iSX29NcI8BNBzgf4z497UG9JlFoLwkNEplDQeopQNOPT2tPw/XX9E0srs
   7dIEn5GIgqEAYPFcvgdSUUt2bJddAI0q3A4JY41RsodkiS2WJUBDomRiQ
   g==;
X-CSE-ConnectionGUID: a7jcovlRRj2MvcA6Jh1HGQ==
X-CSE-MsgGUID: aZeKY9gCQ/adx4KKNx6cjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134896"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134896"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:48 -0700
X-CSE-ConnectionGUID: bD67eEgsSymwj2IXHC5GNg==
X-CSE-MsgGUID: 914ESZ7eTm+M7JJx4OvcNA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: move iwl_force_nmi() to where it belongs
Date: Thu, 24 Sep 2026 13:41:25 +0300
Message-Id: <20260924133942.99868bf0286a.Ie0d3ea9b23e35d7ff4b67e129c7b97ccb7c6c453@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

iwl_force_nmi() forces a firmware NMI and has nothing to do with the
register I/O helpers in iwl-io.c. Move it to iwl-trans.c and rename it
to iwl_trans_force_nmi() to match the transport API naming.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c    |  5 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c    | 18 ------------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h    |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 18 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h |  2 ++
 .../net/wireless/intel/iwlwifi/mld/debugfs.c   |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c   |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c  |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c   |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c   |  4 ++--
 12 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8c8d15ac71ac..897538066b7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2055,7 +2055,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		if (trigger->flags & IWL_FW_DBG_FORCE_RESTART) {
 			IWL_WARN(fwrt, "Force restart: trigger %d fired.\n",
 				 trig);
-			iwl_force_nmi(fwrt->trans);
+			iwl_trans_force_nmi(fwrt->trans);
 			return 0;
 		}
 
@@ -2233,7 +2233,8 @@ static void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt, u8 wk_idx)
 	}
 
 	if (fwrt->trans->dbg.last_tp_resetfw == IWL_FW_INI_RESET_FW_MODE_STOP_FW_ONLY)
-		iwl_force_nmi(fwrt->trans);
+		iwl_trans_force_nmi(fwrt->trans);
+
 out:
 	if (iwl_trans_dbg_ini_valid(fwrt->trans)) {
 		iwl_fw_error_dump_data_free(dump_data);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index ef4d97ef0b1b..cc6bf4ea5055 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -10,7 +10,6 @@
 #include "iwl-io.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
-#include "iwl-prph.h"
 
 void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
@@ -216,20 +215,3 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	}
 }
 IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
-
-void iwl_force_nmi(struct iwl_trans *trans)
-{
-	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_9000)
-		iwl_write_prph_delay(trans, DEVICE_SET_NMI_REG,
-				     DEVICE_SET_NMI_VAL_DRV, 1);
-	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-				UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER);
-	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_BZ)
-		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
-				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
-	else
-		iwl_write32(trans, CSR_DOORBELL_VECTOR,
-			    UREG_DOORBELL_TO_ISR6_NMI_BIT);
-}
-IWL_EXPORT_SYMBOL(iwl_force_nmi);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index e66b0c2a0467..e4a9f2ba0de9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -57,7 +57,6 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
-void iwl_force_nmi(struct iwl_trans *trans);
 
 /*
  * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index ad43cf53e8c5..efe657857772 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -10,6 +10,7 @@
 
 #include "iwl-trans.h"
 #include "iwl-drv.h"
+#include "iwl-prph.h"
 #include <linux/dmapool.h>
 #include "fw/api/commands.h"
 #include "pcie/internal.h"
@@ -452,6 +453,23 @@ void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 	return iwl_trans_pcie_write_prph(trans, ofs, val);
 }
 
+void iwl_trans_force_nmi(struct iwl_trans *trans)
+{
+	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_9000)
+		iwl_write_prph_delay(trans, DEVICE_SET_NMI_REG,
+				     DEVICE_SET_NMI_VAL_DRV, 1);
+	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
+		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
+				    UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER);
+	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_BZ)
+		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
+	else
+		iwl_write32(trans, CSR_DOORBELL_VECTOR,
+			    UREG_DOORBELL_TO_ISR6_NMI_BIT);
+}
+IWL_EXPORT_SYMBOL(iwl_trans_force_nmi);
+
 int iwl_trans_read_mem(struct iwl_trans *trans, u32 addr,
 		       void *buf, int dwords)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index f933cba7eee8..a7bb6cee8188 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1055,6 +1055,8 @@ static inline bool iwl_trans_fw_running(struct iwl_trans *trans)
 
 void iwl_trans_sync_nmi(struct iwl_trans *trans);
 
+void iwl_trans_force_nmi(struct iwl_trans *trans);
+
 int iwl_trans_load_pnvm(struct iwl_trans *trans,
 			const struct iwl_pnvm_image *pnvm_data,
 			const struct iwl_ucode_capabilities *capa);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
index 351a4f177e92..dd4bf7cb6a79 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
@@ -69,7 +69,7 @@ static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mld *mld, char *buf,
 	if (count == 6 && !strcmp(buf, "nolog\n"))
 		mld->fw_status.do_not_dump_once = true;
 
-	iwl_force_nmi(mld->trans);
+	iwl_trans_force_nmi(mld->trans);
 
 	return count;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 4db0f29dd21a..06502f57e823 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1102,7 +1102,7 @@ static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mvm *mvm, char *buf,
 	if (count == 6 && !strcmp(buf, "nolog\n"))
 		set_bit(IWL_MVM_STATUS_SUPPRESS_ERROR_LOG_ONCE, &mvm->status);
 
-	iwl_force_nmi(mvm->trans);
+	iwl_trans_force_nmi(mvm->trans);
 
 	return count;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bd246e37943..a4f3d3c2bd35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5258,7 +5258,7 @@ iwl_mvm_switch_vif_chanctx_swap(struct iwl_mvm *mvm,
 
 out_restart:
 	/* things keep failing, better restart the hw */
-	iwl_force_nmi(mvm->trans);
+	iwl_trans_force_nmi(mvm->trans);
 	return ret;
 }
 
@@ -5294,7 +5294,7 @@ iwl_mvm_switch_vif_chanctx_reassign(struct iwl_mvm *mvm,
 
 out_restart:
 	/* things keep failing, better restart the hw */
-	iwl_force_nmi(mvm->trans);
+	iwl_trans_force_nmi(mvm->trans);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 817c6dacfacc..a94eaca0b3ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2703,7 +2703,7 @@ void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 
 	IWL_ERR(mvm, "regular scan timed out\n");
 
-	iwl_force_nmi(mvm->trans);
+	iwl_trans_force_nmi(mvm->trans);
 }
 
 static void iwl_mvm_fill_scan_type(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index d1ef0365b932..db3933b0d197 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1493,7 +1493,7 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 
 out_err:
 	WARN(1, "Invalid rxb from HW %u\n", (u32)vid);
-	iwl_force_nmi(trans);
+	iwl_trans_force_nmi(trans);
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 48ae2440cfe1..1304d8916424 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3596,7 +3596,7 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 	if (interrupts_enabled)
 		iwl_trans_pci_interrupts(trans, false);
 
-	iwl_force_nmi(trans);
+	iwl_trans_force_nmi(trans);
 	while (time_after(timeout, jiffies)) {
 		u32 inta_hw = iwl_read32(trans, inta_addr);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 26d1530cfa37..496435ea93ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -715,7 +715,7 @@ static void iwl_txq_stuck_timer(struct timer_list *t)
 
 	iwl_txq_log_scd_error(trans, txq);
 
-	iwl_force_nmi(trans);
+	iwl_trans_force_nmi(trans);
 }
 
 int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
@@ -1105,7 +1105,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
 				idx, txq->write_ptr, r);
-			iwl_force_nmi(trans);
+			iwl_trans_force_nmi(trans);
 		}
 	}
 
-- 
2.34.1


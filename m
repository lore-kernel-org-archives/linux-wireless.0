Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA73BFE4C
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759880; cv=none; b=K4UJuCfNFf/XUI7UTKXN8YIgdN+VeQ/XUK9PKUJGHRwBsYT6/LCE71fUJu7JxKQnODL/Nl3fEKbd1pVE5rXcm996Nv/ywpdWc0I2uAhph7vgR6OzbrlQxo1lhD2fxntBTFX6IjQ8uzkdNXIyT1y4UWIEDRYGtb7e6b+6Cb9+mT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759880; c=relaxed/simple;
	bh=4MWl3cemTPn8yGNtL4AtjEc0gcAz9k6N7LEzVUOvc3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f3daCTaOLvV6TeYN1VaMu1hZ/WhX0bb5JscurPcOPZZpzsVSJRt6rtfoaAZ64uxxCZg7g+zlq2ovcDep/y7VqSt3vxIB1XRUN8TjAEEFjnKV5L3cLPRIK7qDt6UqCYg+HCFLs0uv9jdBV54a3v82kAgLUJMu1r784cjjmkI1xzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DNde0WoW; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DNde0WoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759879; x=1822295879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4MWl3cemTPn8yGNtL4AtjEc0gcAz9k6N7LEzVUOvc3M=;
  b=DNde0WoWPvwUg0zXbwtw8XR5LpB6r9MmUm8RBLOquXJNsrTe+JaX9MZv
   uNDd8oAF7P0MlGqYSx+gPdtFvDSxJ+aEFbjYMrBB5zYOosxNzdf7+q6Yw
   5Ld/maX7YKt/Guvk6qR77JwoASUyY9zMpFAsIQepPYDld5yxm/S4VIV7g
   NZ4R9OEgYcOSQ3EGkRZoXwR27APOkxoCavsWN9b7kkP2Obwv4mgdFsB+/
   rlMmnzO8JP6Q15XzRvv5WquGffqDioDDFQDLpMAtfk5P+anNKzGy++A8a
   06pT/8Vqb6bsFdy/NjHYNfxlL35YDmvv8QCGnXM6Xap8UtqUcP7qCe8tP
   A==;
X-CSE-ConnectionGUID: nOp9QXsjTpabox/co7Emvg==
X-CSE-MsgGUID: X0YuieA2R+eZdjPQncg5Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447014"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447014"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:17:59 -0700
X-CSE-ConnectionGUID: 4QUbcUY8QbCaA03GDqnGuA==
X-CSE-MsgGUID: to8LakkqRtCbjbUuWdkTJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673506"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:17:57 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 02/15] wifi: iwlwifi: move pcie-only functions to pcie
Date: Wed, 30 Sep 2026 12:19:39 +0300
Message-Id: <20260930121740.480246f9b623.I88de3ad2bbd8a8444ff2a154f7eb1f08ecb7b7ea@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
References: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

There are several helpers that exported to the opmodes but are really only
called from the pcie transport. Define those functions there.

No functional change intended.

Assisted-by: GitHubCopilot:claude-opus-4.8
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 89 -------------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   | 26 ------
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  5 --
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  2 -
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |  5 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |  3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 47 +++++-----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 33 +++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 10 +--
 .../net/wireless/intel/iwlwifi/pcie/utils.c   | 87 +++++++++++++++++-
 .../net/wireless/intel/iwlwifi/pcie/utils.h   | 28 +++++-
 12 files changed, 166 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index d2fa80a3dd04..ba14e583a4ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -501,7 +501,8 @@ enum {
  * to indirectly access device's internal memory or registers that
  * may be powered-down.
  *
- * Use iwl_write_direct32()/iwl_read_direct32() family for these registers;
+ * Use iwl_write_direct32() family for writing to these registers;
+ * A read operation doesn't exist, can be added if needed.
  * host must "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ
  * to make sure the MAC (uCode processor, etc.) is powered up for accessing
  * internal resources.
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 5ce046e3fa5c..297f4550ae72 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -11,13 +11,6 @@
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 
-void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
-{
-	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
-	iwl_trans_write8(trans, ofs, val);
-}
-IWL_EXPORT_SYMBOL(iwl_write8);
-
 void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
@@ -25,14 +18,6 @@ void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 }
 IWL_EXPORT_SYMBOL(iwl_write32);
 
-void iwl_write64(struct iwl_trans *trans, u64 ofs, u64 val)
-{
-	trace_iwlwifi_dev_iowrite64(trans->dev, ofs, val);
-	iwl_trans_write32(trans, ofs, lower_32_bits(val));
-	iwl_trans_write32(trans, ofs + 4, upper_32_bits(val));
-}
-IWL_EXPORT_SYMBOL(iwl_write64);
-
 u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read32(trans, ofs);
@@ -60,19 +45,6 @@ int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
 }
 IWL_EXPORT_SYMBOL(iwl_poll_bits_mask);
 
-u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		u32 value = iwl_read32(trans, reg);
-
-		iwl_trans_release_nic_access(trans);
-		return value;
-	}
-
-	/* return as if we have a HW timeout/failure */
-	return 0x5a5a5a5a;
-}
-
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
@@ -82,29 +54,6 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 }
 IWL_EXPORT_SYMBOL(iwl_write_direct32);
 
-void iwl_write_direct64(struct iwl_trans *trans, u64 reg, u64 value)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_write64(trans, reg, value);
-		iwl_trans_release_nic_access(trans);
-	}
-}
-
-int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
-			int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((iwl_read_direct32(trans, addr) & mask) == mask)
-			return t;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
 u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read_prph(trans, ofs);
@@ -118,13 +67,6 @@ void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 	iwl_trans_write_prph_no_grab(trans, ofs, val);
 }
 
-void iwl_write_prph64_no_grab(struct iwl_trans *trans, u64 ofs, u64 val)
-{
-	trace_iwlwifi_dev_iowrite_prph64(trans->dev, ofs, val);
-	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
-	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
-}
-
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
@@ -150,37 +92,6 @@ void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_m
 }
 IWL_EXPORT_SYMBOL(iwl_write_prph_delay);
 
-int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
-		      u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((iwl_read_prph(trans, addr) & mask) == (bits & mask))
-			return 0;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
-int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
-				    u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((iwl_read_umac_prph_no_grab(trans, addr) & mask) ==
-		    (bits & mask))
-			return 0;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index e4a9f2ba0de9..b24c5eeca206 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -8,9 +8,7 @@
 #include "iwl-devtrace.h"
 #include "iwl-trans.h"
 
-void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val);
 void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val);
-void iwl_write64(struct iwl_trans *trans, u64 ofs, u64 val);
 u32 iwl_read32(struct iwl_trans *trans, u32 ofs);
 
 static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
@@ -30,18 +28,13 @@ static inline int iwl_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
 {
 	return iwl_poll_bits_mask(trans, addr, bits, bits, timeout);
 }
-int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
-			int timeout);
 
-u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
-void iwl_write_direct64(struct iwl_trans *trans, u64 reg, u64 value);
 
 
 u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
 void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
-void iwl_write_prph64_no_grab(struct iwl_trans *trans, u64 ofs, u64 val);
 void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs,
 			  u32 val, u32 delay_ms);
 static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
@@ -49,10 +42,6 @@ static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 	iwl_write_prph_delay(trans, ofs, val, 0);
 }
 
-int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
-		      u32 bits, u32 mask, int timeout);
-int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
-				    u32 bits, u32 mask, int timeout);
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
@@ -79,25 +68,10 @@ static inline u32 iwl_read_umac_prph(struct iwl_trans *trans, u32 ofs)
 	return iwl_read_prph(trans, ofs + trans->mac_cfg->umac_prph_offset);
 }
 
-static inline void iwl_write_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs,
-					       u32 val)
-{
-	iwl_write_prph_no_grab(trans,  ofs + trans->mac_cfg->umac_prph_offset,
-			       val);
-}
-
 static inline void iwl_write_umac_prph(struct iwl_trans *trans, u32 ofs,
 				       u32 val)
 {
 	iwl_write_prph(trans,  ofs + trans->mac_cfg->umac_prph_offset, val);
 }
 
-static inline int iwl_poll_umac_prph_bit(struct iwl_trans *trans, u32 addr,
-					 u32 bits, u32 mask, int timeout)
-{
-	return iwl_poll_prph_bit(trans, addr +
-				 trans->mac_cfg->umac_prph_offset,
-				 bits, mask, timeout);
-}
-
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 1c593fd29d02..b3e39f0bbea4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -428,11 +428,6 @@ void iwl_trans_op_mode_leave(struct iwl_trans *trans)
 }
 IWL_EXPORT_SYMBOL(iwl_trans_op_mode_leave);
 
-void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val)
-{
-	iwl_trans_pcie_write8(trans, ofs, val);
-}
-
 void iwl_trans_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	iwl_trans_pcie_write32(trans, ofs, val);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c59b935ce4bf..c882313eaceb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -910,8 +910,6 @@ int iwl_trans_wait_tx_queues_empty(struct iwl_trans *trans, u32 txqs);
 
 int iwl_trans_wait_txq_empty(struct iwl_trans *trans, int queue);
 
-void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val);
-
 void iwl_trans_write32(struct iwl_trans *trans, u32 ofs, u32 val);
 
 u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index c75210829ec9..c57b17133772 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -7,6 +7,7 @@
 #include "iwl-fh.h"
 #include "iwl-context-info-v2.h"
 #include "internal.h"
+#include "pcie/utils.h"
 #include "iwl-prph.h"
 
 static const struct dmi_system_id dmi_force_scu_active_approved_list[] = {
@@ -314,8 +315,8 @@ void iwl_pcie_ctxt_info_v2_kick(struct iwl_trans *trans)
 	iwl_enable_fw_load_int_ctx_info(trans, trans->do_top_reset);
 
 	/* kick FW self load */
-	iwl_write64(trans, CSR_CTXT_INFO_ADDR, trans_pcie->ctxt_info_dma_addr);
-	iwl_write64(trans, CSR_IML_DATA_ADDR, trans_pcie->iml_dma_addr);
+	iwl_pcie_write64(trans, CSR_CTXT_INFO_ADDR, trans_pcie->ctxt_info_dma_addr);
+	iwl_pcie_write64(trans, CSR_IML_DATA_ADDR, trans_pcie->iml_dma_addr);
 	iwl_write32(trans, CSR_IML_SIZE_ADDR, trans_pcie->iml_len);
 
 	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 23ec968577bd..bc90a2714251 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -7,6 +7,7 @@
 #include "iwl-fh.h"
 #include "iwl-context-info.h"
 #include "internal.h"
+#include "utils.h"
 #include "iwl-prph.h"
 
 static void *_iwl_pcie_ctxt_info_dma_alloc_coherent(struct iwl_trans *trans,
@@ -245,7 +246,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 		iwl_pcie_apply_destination(trans);
 
 	/* kick FW self load */
-	iwl_write64(trans, CSR_CTXT_INFO_BA, trans_pcie->ctxt_info_dma_addr);
+	iwl_pcie_write64(trans, CSR_CTXT_INFO_BA, trans_pcie->ctxt_info_dma_addr);
 
 	/* Context info will be released upon alive or failure to get one */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index db3933b0d197..fec3d6e0b146 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -11,6 +11,7 @@
 #include "iwl-prph.h"
 #include "iwl-io.h"
 #include "internal.h"
+#include "pcie/utils.h"
 #include "iwl-op-mode.h"
 #include "iwl-context-info-v2.h"
 #include "fw/dbg.h"
@@ -147,17 +148,17 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans)
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
 		/* TODO: remove this once fw does it */
 		iwl_write_umac_prph(trans, RFH_RXF_DMA_CFG_AX210, 0);
-		return iwl_poll_umac_prph_bit(trans, RFH_GEN_STATUS_AX210,
-					      RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
+		return iwl_pcie_poll_umac_prph_bit(trans, RFH_GEN_STATUS_AX210,
+						   RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
 	} else if (trans->mac_cfg->mq_rx_supported) {
 		iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
-		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS,
-					   RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
+		return iwl_pcie_poll_prph_bit(trans, RFH_GEN_STATUS,
+					      RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
 	} else {
 		iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-		return iwl_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
-					   FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
-					   1000);
+		return iwl_pcie_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
+						FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+						1000);
 	}
 }
 
@@ -890,7 +891,7 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	iwl_trans_release_nic_access(trans);
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+	iwl_trans_pcie_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 
 	/* W/A for interrupt coalescing bug in 7260 and 3160 */
 	if (trans->cfg->host_interrupt_operation_mode)
@@ -931,17 +932,17 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	for (i = 0; i < trans->info.num_rxqs; i++) {
 		/* Tell device where to find RBD free table in DRAM */
-		iwl_write_prph64_no_grab(trans,
-					 RFH_Q_FRBDCB_BA_LSB(i),
-					 trans_pcie->rxq[i].bd_dma);
+		iwl_pcie_write_prph64_no_grab(trans,
+					      RFH_Q_FRBDCB_BA_LSB(i),
+					      trans_pcie->rxq[i].bd_dma);
 		/* Tell device where to find RBD used table in DRAM */
-		iwl_write_prph64_no_grab(trans,
-					 RFH_Q_URBDCB_BA_LSB(i),
-					 trans_pcie->rxq[i].used_bd_dma);
+		iwl_pcie_write_prph64_no_grab(trans,
+					      RFH_Q_URBDCB_BA_LSB(i),
+					      trans_pcie->rxq[i].used_bd_dma);
 		/* Tell device where in DRAM to update its Rx status */
-		iwl_write_prph64_no_grab(trans,
-					 RFH_Q_URBD_STTS_WPTR_LSB(i),
-					 trans_pcie->rxq[i].rb_stts_dma);
+		iwl_pcie_write_prph64_no_grab(trans,
+					      RFH_Q_URBD_STTS_WPTR_LSB(i),
+					      trans_pcie->rxq[i].rb_stts_dma);
 		/* Reset device indice tables */
 		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_WIDX(i), 0);
 		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_RIDX(i), 0);
@@ -982,7 +983,7 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	iwl_trans_release_nic_access(trans);
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+	iwl_trans_pcie_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 }
 
 void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
@@ -1189,7 +1190,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 int iwl_pcie_gen2_rx_init(struct iwl_trans *trans)
 {
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+	iwl_trans_pcie_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 
 	/*
 	 * We don't configure the RFH.
@@ -2090,8 +2091,8 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		 */
 
 		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(trans, CSR_INT_PERIODIC_REG,
-			    CSR_INT_PERIODIC_DIS);
+		iwl_trans_pcie_write8(trans, CSR_INT_PERIODIC_REG,
+				      CSR_INT_PERIODIC_DIS);
 
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
@@ -2101,8 +2102,8 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		 * to extend the periodic interrupt; one-shot is enough.
 		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(trans, CSR_INT_PERIODIC_REG,
-				   CSR_INT_PERIODIC_ENA);
+			iwl_trans_pcie_write8(trans, CSR_INT_PERIODIC_REG,
+					      CSR_INT_PERIODIC_ENA);
 
 		isr_stats->rx++;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3d1cc49effb4..b81dd7daca6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -751,7 +751,7 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 			return ret;
 
 		/* Notify ucode of loaded section number and status */
-		val = iwl_read_direct32(trans, FH_UCODE_LOAD_STATUS);
+		val = iwl_pcie_read_direct32(trans, FH_UCODE_LOAD_STATUS);
 		val = val | (sec_num << shift_param);
 		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
 
@@ -1079,7 +1079,7 @@ static void iwl_pcie_map_list(struct iwl_trans *trans,
 	int i;
 
 	for (i = 0; i < arr_size; i++) {
-		iwl_write8(trans, CSR_MSIX_IVAR(causes[i].addr), val);
+		iwl_trans_pcie_write8(trans, CSR_MSIX_IVAR(causes[i].addr), val);
 		iwl_clear_bit(trans, causes[i].mask_reg,
 			      BIT(causes[i].bit));
 	}
@@ -1119,8 +1119,8 @@ static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
 	 */
 	val = BIT(MSIX_FH_INT_CAUSES_Q(0));
 	for (idx = 1; idx < trans->info.num_rxqs; idx++) {
-		iwl_write8(trans, CSR_MSIX_RX_IVAR(idx),
-			   MSIX_FH_INT_CAUSES_Q(idx - offset));
+		iwl_trans_pcie_write8(trans, CSR_MSIX_RX_IVAR(idx),
+				      MSIX_FH_INT_CAUSES_Q(idx - offset));
 		val |= BIT(MSIX_FH_INT_CAUSES_Q(idx));
 	}
 	iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~val);
@@ -1128,10 +1128,10 @@ static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
 	val = MSIX_FH_INT_CAUSES_Q(0);
 	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX)
 		val |= MSIX_NON_AUTO_CLEAR_CAUSE;
-	iwl_write8(trans, CSR_MSIX_RX_IVAR(0), val);
+	iwl_trans_pcie_write8(trans, CSR_MSIX_RX_IVAR(0), val);
 
 	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS)
-		iwl_write8(trans, CSR_MSIX_RX_IVAR(1), val);
+		iwl_trans_pcie_write8(trans, CSR_MSIX_RX_IVAR(1), val);
 }
 
 void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
@@ -1754,8 +1754,8 @@ static int iwl_trans_pcie_clear_persistence_bit(struct iwl_trans *trans)
 				"Error, can not clear persistence bit\n");
 			return -EPERM;
 		}
-		iwl_write_umac_prph_no_grab(trans, HPM_DEBUG,
-					    hpm & ~PERSISTENCE_BIT);
+		iwl_pcie_write_umac_prph_no_grab(trans, HPM_DEBUG,
+						 hpm & ~PERSISTENCE_BIT);
 	}
 
 	return 0;
@@ -1864,6 +1864,7 @@ void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 
 void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
+	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
 	writeb(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
@@ -3253,11 +3254,11 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	if (!iwl_trans_grab_nic_access(trans))
 		return 0;
 
-	iwl_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
+	iwl_pcie_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
 	for (i = 0; i < buf_size_in_dwords; i++)
 		buffer[i] = iwl_read_umac_prph_no_grab(trans,
 						       MON_DMARB_RD_DATA_ADDR);
-	iwl_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
+	iwl_pcie_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
 
 	iwl_trans_release_nic_access(trans);
 
@@ -3916,11 +3917,11 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 			return;
 		}
 
-		ret = iwl_poll_umac_prph_bits_no_grab(iwl_trans,
-						      WFPM_RSRCS_4PHS_ACK_STTS,
-						      RSRC_ACK_CNVR_TOP,
-						      RSRC_ACK_CNVR_TOP,
-						      50 * 1000);
+		ret = iwl_pcie_poll_umac_prph_bits_no_grab(iwl_trans,
+							   WFPM_RSRCS_4PHS_ACK_STTS,
+							   RSRC_ACK_CNVR_TOP,
+							   RSRC_ACK_CNVR_TOP,
+							   50 * 1000);
 		if (ret < 0)
 			IWL_ERR(iwl_trans,
 				"WFPM_RSRCS_4PHS_ACK_STTS bit 6 is clear\n");
@@ -3929,7 +3930,7 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	/* Enable access to peripheral registers */
 	val = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
 	val |= WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK;
-	iwl_write_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG, val);
+	iwl_pcie_write_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG, val);
 
 	/* Read crf info */
 	info->hw_crf_id = iwl_read_prph_no_grab(iwl_trans, sd_reg_ver_addr);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 496435ea93ee..bdd330280689 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -523,7 +523,7 @@ void iwl_pcie_tx_start(struct iwl_trans *trans)
 				   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
+	reg_val = iwl_pcie_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
 	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
@@ -549,9 +549,9 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 	     txq_id++) {
 		struct iwl_txq *txq = trans_pcie->txqs.txq[txq_id];
 		if (trans->mac_cfg->gen2)
-			iwl_write_direct64(trans,
-					   FH_MEM_CBBC_QUEUE(trans, txq_id),
-					   txq->dma_addr);
+			iwl_pcie_write_direct64(trans,
+						FH_MEM_CBBC_QUEUE(trans, txq_id),
+						txq->dma_addr);
 		else
 			iwl_write_direct32(trans,
 					   FH_MEM_CBBC_QUEUE(trans, txq_id),
@@ -697,7 +697,7 @@ void iwl_txq_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 			(trans->mac_cfg->base->max_tfd_queue_size - 1),
 			iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id)) &
 			(trans->mac_cfg->base->max_tfd_queue_size - 1),
-			iwl_read_direct32(trans, FH_TX_TRB_REG(fifo)));
+			iwl_pcie_read_direct32(trans, FH_TX_TRB_REG(fifo)));
 }
 
 static void iwl_txq_stuck_timer(struct timer_list *t)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
index 1bb274d8390c..bace3e21989c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2025 Intel Corporation
+ * Copyright (C) 2025-2026 Intel Corporation
  */
 
 #include <linux/pci.h>
@@ -102,3 +102,88 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev)
 	pcie_dbg_dumped_once = 1;
 	kfree(buf);
 }
+
+u32 iwl_pcie_read_direct32(struct iwl_trans *trans, u32 reg)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		u32 value = iwl_read32(trans, reg);
+
+		iwl_trans_release_nic_access(trans);
+		return value;
+	}
+
+	/* return as if we have a HW timeout/failure */
+	return 0x5a5a5a5a;
+}
+
+#define IWL_PCIE_POLL_INTERVAL 10	/* microseconds */
+
+int iwl_pcie_poll_direct_bit(struct iwl_trans *trans,
+			     u32 addr, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_pcie_read_direct32(trans, addr) & mask) == mask)
+			return t;
+		udelay(IWL_PCIE_POLL_INTERVAL);
+		t += IWL_PCIE_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+int iwl_pcie_poll_prph_bit(struct iwl_trans *trans, u32 addr,
+			   u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_prph(trans, addr) & mask) == (bits & mask))
+			return 0;
+		udelay(IWL_PCIE_POLL_INTERVAL);
+		t += IWL_PCIE_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+int iwl_pcie_poll_umac_prph_bit(struct iwl_trans *trans,
+				u32 addr, u32 bits, u32 mask,
+				int timeout)
+{
+	return iwl_pcie_poll_prph_bit(trans, addr +
+				      trans->mac_cfg->umac_prph_offset,
+				      bits, mask, timeout);
+}
+
+int iwl_pcie_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+					 u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_umac_prph_no_grab(trans, addr) & mask) ==
+		    (bits & mask))
+			return 0;
+		udelay(IWL_PCIE_POLL_INTERVAL);
+		t += IWL_PCIE_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+void iwl_pcie_write_prph64_no_grab(struct iwl_trans *trans, u32 ofs, u64 val)
+{
+	trace_iwlwifi_dev_iowrite_prph64(trans->dev, ofs, val);
+	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
+	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
+}
+
+void iwl_pcie_write_direct64(struct iwl_trans *trans, u64 reg, u64 value)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		iwl_pcie_write64(trans, reg, value);
+		iwl_trans_release_nic_access(trans);
+	}
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
index 27437d5e099b..341928cdb64b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2025 Intel Corporation
+ * Copyright (C) 2025-2026 Intel Corporation
  */
 
 #ifndef __iwl_pcie_utils_h__
@@ -10,6 +10,32 @@
 
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev);
 
+u32 iwl_pcie_read_direct32(struct iwl_trans *trans, u32 reg);
+int iwl_pcie_poll_direct_bit(struct iwl_trans *trans,
+			     u32 addr, u32 mask, int timeout);
+int iwl_pcie_poll_prph_bit(struct iwl_trans *trans, u32 addr,
+			   u32 bits, u32 mask, int timeout);
+int iwl_pcie_poll_umac_prph_bit(struct iwl_trans *trans, u32 addr,
+				u32 bits, u32 mask, int timeout);
+int iwl_pcie_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+					 u32 bits, u32 mask, int timeout);
+void iwl_pcie_write_prph64_no_grab(struct iwl_trans *trans, u32 ofs, u64 val);
+void iwl_pcie_write_direct64(struct iwl_trans *trans, u64 reg, u64 value);
+
+static inline void iwl_pcie_write64(struct iwl_trans *trans, u64 ofs, u64 val)
+{
+	trace_iwlwifi_dev_iowrite64(trans->dev, ofs, val);
+	iwl_trans_write32(trans, ofs, lower_32_bits(val));
+	iwl_trans_write32(trans, ofs + 4, upper_32_bits(val));
+}
+
+static inline void iwl_pcie_write_umac_prph_no_grab(struct iwl_trans *trans,
+						    u32 ofs, u32 val)
+{
+	iwl_write_prph_no_grab(trans, ofs + trans->mac_cfg->umac_prph_offset,
+			       val);
+}
+
 static inline void _iwl_trans_set_bits_mask(struct iwl_trans *trans,
 					    u32 reg, u32 mask, u32 value)
 {
-- 
2.34.1


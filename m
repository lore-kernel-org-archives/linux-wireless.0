Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA6B4746AD
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246389; cv=none; b=K7UKjoV5bWPcVf3m6rH+ks2og7cwXwgwSqotpfsXCvbganWRk77LaXryHDofSuNvPs67Dv3v94rvS11Hza1p2RRjXuwueUu9ifmYe4DnFX29iBmf8y5D9D8fzNFOWAGBkOWhW4ImwVhwgk3msjfbsh9jyj+DIg0OtO23mZsEC94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246389; c=relaxed/simple;
	bh=4dRczy4T32x5Nj7BkuVIKQAzbk9Bl3ZVrZ5C7Uhi06Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nrIeDKfSgzoLmkQ6sdjFrK/uGgs82tD/kUlWRBV8n3cmvOFlL79V6z079Gmgt/IEXBE2XQMqgVAafW2LZMWJlHZh6944YmejkoHpIcw6XFHRZJUhzUVVA1O/txW/Wxum53nEfJ6+JaIupxl8NmCJIyoOTe7APWKI3D6cd6cWkzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMVpSI82; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMVpSI82"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246386; x=1821782386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4dRczy4T32x5Nj7BkuVIKQAzbk9Bl3ZVrZ5C7Uhi06Y=;
  b=mMVpSI82Nkt+nelgMlwBbJL8+teVZotPjf05cLN9dLdwJSQlLf7Qyip2
   j0u1ujklMGwbqQMVeBTd2mmv7s75yB6fcbPMXRxmxca/mDrkPgAVNhBRn
   mMPy0CGrk+li+bxSpdyfFmGjXpREML+yRlZGMJ4rfiZuVnPef3yQh7VDs
   QDIVZX6Hh7OEQOfhFWUnNp+zXo8X+NdFmdkvbUKKa6c2DGcqbLa2SpfzA
   o77uCKpJXtadfcBI2l5jV8mf4zwsW1GHcN6UGBY+rnw+I2oGxT6IOktV1
   mqKO1SSW6fYXL1uLvj5HMC/JKmYJvETL7aVJFnobIHOWxbGCQhbPH8yVw
   A==;
X-CSE-ConnectionGUID: vpaPmF7DR+qUW4caM0iDXA==
X-CSE-MsgGUID: kqvvASb5QlCHCjI2sN+Fag==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134888"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134888"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:45 -0700
X-CSE-ConnectionGUID: 1gFi5SiXQ/SreYVmY7oJGg==
X-CSE-MsgGUID: KtDe5zVuRw+lPOKbrBDVeQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:44 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: pcie: remove iwl_dbgfs_fh_reg_read
Date: Thu, 24 Sep 2026 13:41:23 +0300
Message-Id: <20260924133942.0be90a4d2b77.I122eaf364743ffc42bd18a84a766d7920ec5700d@changeid>
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

This is no longer needed, and adds lots of parsing code

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 177 ------------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |   3 -
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  20 --
 3 files changed, 200 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index bb746112ddad..544b8e686dfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -11,7 +11,6 @@
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 #include "iwl-prph.h"
-#include "iwl-fh.h"
 
 void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
@@ -235,182 +234,6 @@ void iwl_force_nmi(struct iwl_trans *trans)
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
-static const char *get_rfh_string(int cmd)
-{
-#define IWL_CMD(x) case x: return #x
-#define IWL_CMD_MQ(arg, reg, q) { if (arg == reg(q)) return #reg; }
-
-	int i;
-
-	for (i = 0; i < IWL_MAX_RX_HW_QUEUES; i++) {
-		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_BA_LSB, i);
-		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_WIDX, i);
-		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_RIDX, i);
-		IWL_CMD_MQ(cmd, RFH_Q_URBD_STTS_WPTR_LSB, i);
-	}
-
-	switch (cmd) {
-	IWL_CMD(RFH_RXF_DMA_CFG);
-	IWL_CMD(RFH_GEN_CFG);
-	IWL_CMD(RFH_GEN_STATUS);
-	IWL_CMD(FH_TSSR_TX_STATUS_REG);
-	IWL_CMD(FH_TSSR_TX_ERROR_REG);
-	default:
-		return "UNKNOWN";
-	}
-#undef IWL_CMD_MQ
-}
-
-struct reg {
-	u32 addr;
-	bool is64;
-};
-
-static int iwl_dump_rfh(struct iwl_trans *trans, char **buf)
-{
-	int i, q;
-	int num_q = trans->info.num_rxqs;
-	static const u32 rfh_tbl[] = {
-		RFH_RXF_DMA_CFG,
-		RFH_GEN_CFG,
-		RFH_GEN_STATUS,
-		FH_TSSR_TX_STATUS_REG,
-		FH_TSSR_TX_ERROR_REG,
-	};
-	static const struct reg rfh_mq_tbl[] = {
-		{ RFH_Q0_FRBDCB_BA_LSB, true },
-		{ RFH_Q0_FRBDCB_WIDX, false },
-		{ RFH_Q0_FRBDCB_RIDX, false },
-		{ RFH_Q0_URBD_STTS_WPTR_LSB, true },
-	};
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (buf) {
-		int pos = 0;
-		/*
-		 * Register (up to 34 for name + 8 blank/q for MQ): 40 chars
-		 * Colon + space: 2 characters
-		 * 0X%08x: 10 characters
-		 * New line: 1 character
-		 * Total of 53 characters
-		 */
-		size_t bufsz = ARRAY_SIZE(rfh_tbl) * 53 +
-			       ARRAY_SIZE(rfh_mq_tbl) * 53 * num_q + 40;
-
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-
-		pos += scnprintf(*buf + pos, bufsz - pos,
-				"RFH register values:\n");
-
-		for (i = 0; i < ARRAY_SIZE(rfh_tbl); i++)
-			pos += scnprintf(*buf + pos, bufsz - pos,
-				"%40s: 0X%08x\n",
-				get_rfh_string(rfh_tbl[i]),
-				iwl_read_prph(trans, rfh_tbl[i]));
-
-		for (i = 0; i < ARRAY_SIZE(rfh_mq_tbl); i++)
-			for (q = 0; q < num_q; q++) {
-				u32 addr = rfh_mq_tbl[i].addr;
-
-				addr += q * (rfh_mq_tbl[i].is64 ? 8 : 4);
-				pos += scnprintf(*buf + pos, bufsz - pos,
-					"%34s(q %2d): 0X%08x\n",
-					get_rfh_string(addr), q,
-					iwl_read_prph(trans, addr));
-			}
-
-		return pos;
-	}
-#endif
-
-	IWL_ERR(trans, "RFH register values:\n");
-	for (i = 0; i < ARRAY_SIZE(rfh_tbl); i++)
-		IWL_ERR(trans, "  %34s: 0X%08x\n",
-			get_rfh_string(rfh_tbl[i]),
-			iwl_read_prph(trans, rfh_tbl[i]));
-
-	for (i = 0; i < ARRAY_SIZE(rfh_mq_tbl); i++)
-		for (q = 0; q < num_q; q++) {
-			u32 addr = rfh_mq_tbl[i].addr;
-
-			addr += q * (rfh_mq_tbl[i].is64 ? 8 : 4);
-			IWL_ERR(trans, "  %34s(q %d): 0X%08x\n",
-				get_rfh_string(addr), q,
-				iwl_read_prph(trans, addr));
-		}
-
-	return 0;
-}
-
-static const char *get_fh_string(int cmd)
-{
-	switch (cmd) {
-	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_WPTR);
-	IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
-	IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
-	IWL_CMD(FH_TSSR_TX_STATUS_REG);
-	IWL_CMD(FH_TSSR_TX_ERROR_REG);
-	default:
-		return "UNKNOWN";
-	}
-#undef IWL_CMD
-}
-
-int iwl_dump_fh(struct iwl_trans *trans, char **buf)
-{
-	int i;
-	static const u32 fh_tbl[] = {
-		FH_RSCSR_CHNL0_STTS_WPTR_REG,
-		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-		FH_RSCSR_CHNL0_WPTR,
-		FH_MEM_RCSR_CHNL0_CONFIG_REG,
-		FH_MEM_RSSR_SHARED_CTRL_REG,
-		FH_MEM_RSSR_RX_STATUS_REG,
-		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
-		FH_TSSR_TX_STATUS_REG,
-		FH_TSSR_TX_ERROR_REG
-	};
-
-	if (trans->mac_cfg->mq_rx_supported)
-		return iwl_dump_rfh(trans, buf);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (buf) {
-		int pos = 0;
-		size_t bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
-
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-
-		pos += scnprintf(*buf + pos, bufsz - pos,
-				"FH register values:\n");
-
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++)
-			pos += scnprintf(*buf + pos, bufsz - pos,
-				"  %34s: 0X%08x\n",
-				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(trans, fh_tbl[i]));
-
-		return pos;
-	}
-#endif
-
-	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++)
-		IWL_ERR(trans, "  %34s: 0X%08x\n",
-			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(trans, fh_tbl[i]));
-
-	return 0;
-}
-
 void iwl_trans_sync_nmi_with_addr(struct iwl_trans *trans, u32 inta_addr,
 				  u32 sw_err_bit)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 6dce2e5267a6..e66b0c2a0467 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -59,9 +59,6 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_force_nmi(struct iwl_trans *trans);
 
-/* Error handling */
-int iwl_dump_fh(struct iwl_trans *trans, char **buf);
-
 /*
  * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
  * device family AX200. So peripheries used in families above and below AX200
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 4771cf3b3e11..97bbc3faa98c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3016,24 +3016,6 @@ static ssize_t iwl_dbgfs_csr_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
-				     char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char *buf = NULL;
-	ssize_t ret;
-
-	ret = iwl_dump_fh(trans, &buf);
-	if (ret < 0)
-		return ret;
-	if (!buf)
-		return -EINVAL;
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
-	kfree(buf);
-	return ret;
-}
-
 static ssize_t iwl_dbgfs_rfkill_read(struct file *file,
 				     char __user *user_buf,
 				     size_t count, loff_t *ppos)
@@ -3133,7 +3115,6 @@ static ssize_t iwl_dbgfs_reset_write(struct file *file,
 }
 
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
-DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(rfkill);
@@ -3157,7 +3138,6 @@ void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 	DEBUGFS_ADD_FILE(tx_queue, dir, 0400);
 	DEBUGFS_ADD_FILE(interrupt, dir, 0600);
 	DEBUGFS_ADD_FILE(csr, dir, 0200);
-	DEBUGFS_ADD_FILE(fh_reg, dir, 0400);
 	DEBUGFS_ADD_FILE(rfkill, dir, 0600);
 	DEBUGFS_ADD_FILE(rf, dir, 0400);
 	DEBUGFS_ADD_FILE(reset, dir, 0200);
-- 
2.34.1


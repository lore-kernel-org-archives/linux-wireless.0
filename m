Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A0F395AD3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759879; cv=none; b=pXg/Z6TmCkZxCA75uCQnYBqjz8U6aSwLg9wX0H/Cvot0TuWS0oTUpTcrQbYXxNQOD7Ivj3wWjYmlRMBUzbV1Ye/iiIvnsIGVIjfGQpipopeXbtS5Uli7oHPEhBYw7461wyhoOUadccE2kH/v4Bgyy4sJKtOk2f0vYTzTog7n6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759879; c=relaxed/simple;
	bh=88R7laAiDnN6pocS5jhcBwhq3m7Iv1xjRb7QxTPnq68=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WQ7ah09V6IN/dCZCY+S4lt9e/lpaBTdS7PQ9l/gXyXrxcBw8YIyHUTxLeGBynbBz4dgNB0uGknXMaXmQOXV+I1n2fWh5R271mPWNy0YJZHwavD/XjqPN3YJp5svwqUXrKgMZt06rhS363+bNePu8I8ZKAeNpCX9aXAaihJBg1fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MO3PNf4R; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MO3PNf4R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759878; x=1822295878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88R7laAiDnN6pocS5jhcBwhq3m7Iv1xjRb7QxTPnq68=;
  b=MO3PNf4RvbglD8qBZCcUFbyJ1W61Sep8pmB1rlqXsJaX7tgXNbe/COX0
   fgWGzCR9ZHLkfgP3ydgpSdT1NdhVjMaj46a59ps3nlbYXo9AsWu3XfFsZ
   YQqxPgBYMJxCaqHXcPoOmP1ROzuYJiR9r73OyXNfeCPJQZ851DFrfkpul
   ocRqYwNcmCs3Hxhh+SIQUv74r/J5CbY3jcThAF93PVGiw8QHBrX2svwHd
   SaUWhq7toWKFfV44TqOCW9UjizoHQc9WR5U0kq9I5p5+GlaYNp4HZJqrq
   KE29sHorCmgKBFjjAgnRMNjUfXE9f6tzebiWozS91m2bRm1FkFIFpIKzu
   Q==;
X-CSE-ConnectionGUID: hOKiI2fkTxuc8K89XtY+bw==
X-CSE-MsgGUID: h46xo4/KQKeq8gBiaPkzpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447013"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447013"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:17:57 -0700
X-CSE-ConnectionGUID: k+SIPDtKQJOg+Azu7F4jyw==
X-CSE-MsgGUID: STlM6rKNTzSyDG7nH85oLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673501"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:17:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 01/15] wifi: iwlwifi: add _no_grab postfix to some functions
Date: Wed, 30 Sep 2026 12:19:38 +0300
Message-Id: <20260930121740.68337f23f322.I38ed9c92bf6358158974b0af025d8bf8fdd7e4f5@changeid>
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

A function that accesses the nic memory without grabbing nic access
first, needs to have a _no_grab postfix. It makes it clear to the caller
that he is responsible for grabbing it.
Add it to iwl_trans_write_prph and iwl_trans_pcie_write_prph as well.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/dbg-old.c   | 32 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 20 ++++++------
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +--
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 8 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
index 19b1bfd0abee..a4e1f82c8bd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
@@ -47,7 +47,7 @@ static void iwl_read_radio_regs(struct iwl_fw_runtime *fwrt,
 		u32 rd_cmd = RADIO_RSP_RD_CMD;
 
 		rd_cmd |= i << RADIO_RSP_ADDR_POS;
-		iwl_trans_write_prph(fwrt->trans, RSP_RADIO_CMD, rd_cmd);
+		iwl_trans_write_prph_no_grab(fwrt->trans, RSP_RADIO_CMD, rd_cmd);
 		*pos = (u8)iwl_trans_read_prph(fwrt->trans, RSP_RADIO_RDDAT);
 
 		pos++;
@@ -97,12 +97,12 @@ static void iwl_fwrt_dump_rxf(struct iwl_fw_runtime *fwrt,
 						RXF_SET_FENCE_MODE + offset));
 
 	/* Lock fence */
-	iwl_trans_write_prph(fwrt->trans, RXF_SET_FENCE_MODE + offset, 0x1);
+	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offset, 0x1);
 	/* Set fence pointer to the same place like WR pointer */
-	iwl_trans_write_prph(fwrt->trans, RXF_LD_WR2FENCE + offset, 0x1);
+	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_LD_WR2FENCE + offset, 0x1);
 	/* Set fence offset */
-	iwl_trans_write_prph(fwrt->trans,
-			     RXF_LD_FENCE_OFFSET_ADDR + offset, 0x0);
+	iwl_trans_write_prph_no_grab(fwrt->trans,
+				     RXF_LD_FENCE_OFFSET_ADDR + offset, 0x0);
 
 	/* Read FIFO */
 	fifo_len /= sizeof(u32); /* Size in DWORDS */
@@ -152,8 +152,8 @@ static void iwl_fwrt_dump_txf(struct iwl_fw_runtime *fwrt,
 						TXF_LOCK_FENCE + offset));
 
 	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
-	iwl_trans_write_prph(fwrt->trans, TXF_READ_MODIFY_ADDR + offset,
-			     TXF_WR_PTR + offset);
+	iwl_trans_write_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_ADDR + offset,
+				     TXF_WR_PTR + offset);
 
 	/* Dummy-read to advance the read pointer to the head */
 	iwl_trans_read_prph(fwrt->trans, TXF_READ_MODIFY_DATA + offset);
@@ -217,7 +217,7 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 		/* Pull TXF data from LMAC1 */
 		for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
 			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(fwrt->trans, TXF_LARC_NUM, i);
+			iwl_trans_write_prph_no_grab(fwrt->trans, TXF_LARC_NUM, i);
 			iwl_fwrt_dump_txf(fwrt, dump_data,
 					  cfg->lmac[0].txfifo_size[i], 0, i);
 		}
@@ -227,9 +227,9 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 			for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries;
 			     i++) {
 				/* Mark the number of TXF we're pulling now */
-				iwl_trans_write_prph(fwrt->trans,
-						     TXF_LARC_NUM +
-						     LMAC2_PRPH_OFFSET, i);
+				iwl_trans_write_prph_no_grab(fwrt->trans,
+							     TXF_LARC_NUM +
+							     LMAC2_PRPH_OFFSET, i);
 				iwl_fwrt_dump_txf(fwrt, dump_data,
 						  cfg->lmac[1].txfifo_size[i],
 						  LMAC2_PRPH_OFFSET,
@@ -262,8 +262,8 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 			fifo_hdr->fifo_num = cpu_to_le32(i);
 
 			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(fwrt->trans, TXF_CPU2_NUM, i +
-				fwrt->smem_cfg.num_txfifo_entries);
+			iwl_trans_write_prph_no_grab(fwrt->trans, TXF_CPU2_NUM, i +
+						     fwrt->smem_cfg.num_txfifo_entries);
 
 			fifo_hdr->available_bytes =
 				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
@@ -282,9 +282,9 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 								TXF_CPU2_LOCK_FENCE));
 
 			/* Set TXF_CPU2_READ_MODIFY_ADDR to TXF_CPU2_WR_PTR */
-			iwl_trans_write_prph(fwrt->trans,
-					     TXF_CPU2_READ_MODIFY_ADDR,
-					     TXF_CPU2_WR_PTR);
+			iwl_trans_write_prph_no_grab(fwrt->trans,
+						     TXF_CPU2_READ_MODIFY_ADDR,
+						     TXF_CPU2_WR_PTR);
 
 			/* Dummy-read to advance the read pointer to head */
 			iwl_trans_read_prph(fwrt->trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 897538066b7d..8d08ce7db3b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -169,8 +169,8 @@ static int iwl_dump_ini_prph_phy_iter_common(struct iwl_fw_runtime *fwrt,
 			continue;
 		}
 
-		iwl_trans_write_prph(fwrt->trans, indirect_wr_addr,
-				     WMAL_INDRCT_CMD(addr + i));
+		iwl_trans_write_prph_no_grab(fwrt->trans, indirect_wr_addr,
+					     WMAL_INDRCT_CMD(addr + i));
 
 		if (fwrt->trans->info.hw_rf_id != IWL_CFG_RF_TYPE_JF1 &&
 		    fwrt->trans->info.hw_rf_id != IWL_CFG_RF_TYPE_JF2 &&
@@ -446,7 +446,7 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 	range->fifo_hdr.num_of_registers = cpu_to_le32(registers_num);
 	range->range_data_size = cpu_to_le32(iter->fifo_size + registers_size);
 
-	iwl_trans_write_prph(fwrt->trans, TXF_LARC_NUM + offs, iter->fifo);
+	iwl_trans_write_prph_no_grab(fwrt->trans, TXF_LARC_NUM + offs, iter->fifo);
 
 	/*
 	 * read txf registers. for each register, write to the dump the
@@ -468,8 +468,8 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
-	iwl_trans_write_prph(fwrt->trans, TXF_READ_MODIFY_ADDR + offs,
-			     TXF_WR_PTR + offs);
+	iwl_trans_write_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_ADDR + offs,
+				     TXF_WR_PTR + offs);
 
 	/* Dummy-read to advance the read pointer to the head */
 	iwl_trans_read_prph(fwrt->trans, TXF_READ_MODIFY_DATA + offs);
@@ -518,8 +518,8 @@ iwl_dump_ini_prph_snps_dphyip_iter(struct iwl_fw_runtime *fwrt,
 			continue;
 		}
 
-		iwl_trans_write_prph(fwrt->trans, indirect_rd_wr_addr,
-				     addr + i);
+		iwl_trans_write_prph_no_grab(fwrt->trans, indirect_rd_wr_addr,
+					     addr + i);
 		/* wait a bit for value to be ready in register */
 		udelay(1);
 		prph_val = iwl_trans_read_prph(fwrt->trans,
@@ -642,11 +642,11 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 	offs = rxf_data.offset;
 
 	/* Lock fence */
-	iwl_trans_write_prph(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);
+	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);
 	/* Set fence pointer to the same place like WR pointer */
-	iwl_trans_write_prph(fwrt->trans, RXF_LD_WR2FENCE + offs, 0x1);
+	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_LD_WR2FENCE + offs, 0x1);
 	/* Set fence offset */
-	iwl_trans_write_prph(fwrt->trans, RXF_LD_FENCE_OFFSET_ADDR + offs, 0x0);
+	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_LD_FENCE_OFFSET_ADDR + offs, 0x0);
 
 	/* Read FIFO */
 	addr =  RXF_FIFO_RD_FENCE_INC + offs;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 4372a171172b..5aca343372d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -912,7 +912,7 @@ static void iwl_dbg_tlv_apply_config(struct iwl_fw_runtime *fwrt,
 			for (count = 0; count < len; count++) {
 				address = le32_to_cpu(config_list->addr_val[count].address);
 				value = le32_to_cpu(config_list->addr_val[count].value);
-				iwl_trans_write_prph(fwrt->trans, address + offset, value);
+				iwl_trans_write_prph_no_grab(fwrt->trans, address + offset, value);
 			}
 			iwl_trans_release_nic_access(fwrt->trans);
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index cc6bf4ea5055..5ce046e3fa5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -115,7 +115,7 @@ u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite_prph32(trans->dev, ofs, val);
-	iwl_trans_write_prph(trans, ofs, val);
+	iwl_trans_write_prph_no_grab(trans, ofs, val);
 }
 
 void iwl_write_prph64_no_grab(struct iwl_trans *trans, u64 ofs, u64 val)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 0a6b7b264aa2..1c593fd29d02 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -448,9 +448,9 @@ u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
 	return iwl_trans_pcie_read_prph(trans, ofs);
 }
 
-void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
+void iwl_trans_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	return iwl_trans_pcie_write_prph(trans, ofs, val);
+	return iwl_pcie_write_prph_no_grab(trans, ofs, val);
 }
 
 void iwl_trans_force_nmi(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 56c5e61b614a..c59b935ce4bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -918,7 +918,7 @@ u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs);
 
 u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs);
 
-void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
+void iwl_trans_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
 
 int iwl_trans_read_mem(struct iwl_trans *trans, u32 addr,
 		       void *buf, int dwords);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index e6b1cb559a0a..550c5c23a52e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1140,7 +1140,7 @@ void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val);
 void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val);
 u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs);
 u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg);
-void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr, u32 val);
+void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val);
 int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 			    void *buf, int dwords);
 int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bda069a6f7eb..3d1cc49effb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1894,7 +1894,7 @@ u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
 	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
-void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
+void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val)
 {
 	u32 mask = iwl_trans_pcie_prph_msk(trans);
 
-- 
2.34.1


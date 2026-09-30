Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328833AEF20
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759892; cv=none; b=dOUNfsBwajUIZUGtvXYcMspAiuYZCVTdwn5WtDl0uNm2h8t3t1P2vpZ93xeav6ovajXIIHsHM33X0w04oRL6BAyMRIxzo8yfY3ppJbSah/mQ5Np7nYXYRivvRApnJO0ZK7xDuqy8qhYBUBF4h7SB6va8vE4jUrcIDPPv7jQA5J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759892; c=relaxed/simple;
	bh=XwUwBuQrM/3luoD6nSkJ1I1oRv1aLEOEb4gdDAL5pcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFqPVCD0Gy+a4ufEN231YO4lmHysnXIjNg4eLwv7dr0Owpcz6CEN2e1E0veNhF4SOf7+BfHHe/QV+GGfldmvn0uoPMnU5qNvZs7xSGDBJbMusAxahzwMNL5zPYpwPohejqBak6D14TAQu4+B+Px52uw7zdW953eBylxHUiuBGBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DODKRaSL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DODKRaSL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759890; x=1822295890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XwUwBuQrM/3luoD6nSkJ1I1oRv1aLEOEb4gdDAL5pcw=;
  b=DODKRaSLNSJD7qZc4sXZhHzwmpxctcN9GWBwkagNQxSR5k64hLQvLj0D
   Ep1qpJx11UtTnHMtPtp76VS7kBB5B64UL52alRHvwCQDtjqR1ujll80lG
   9W1L74ZbFmRpaUPLVQVdzFfmpjXiUtmvS1H/tjmwSRfpBjh3FghVnR6ep
   X0etMJUp6JJjky0xL2JJJdS7tn8ypB+VsPytnWW9yk5p+IRDJUg4W9/el
   8Wk2XZJaJ5cpZhiy4roeRMQBzIsMm8B2ogc/D76ADd24OZut7ZhWEW8dR
   R9ykTpqA26ESl680mumACi+U7mbEnHrhRrDmJrQyGPWP5Vw05Y5kBMXvK
   A==;
X-CSE-ConnectionGUID: rO59ztcARxus355HVhk2DQ==
X-CSE-MsgGUID: f1CwH7bkRom3fT/a+8LaEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447023"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447023"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:08 -0700
X-CSE-ConnectionGUID: seAXLqyLShCzMRCnFCgjYg==
X-CSE-MsgGUID: +p0ulGX0QvOr7mwxjW723w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673534"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 07/15] wifi: iwlwifi: rename iwl_trans_read_prph
Date: Wed, 30 Sep 2026 12:19:44 +0300
Message-Id: <20260930121740.3441b513bd7f.If88dcac92f705918b550fd3e524196be1f8d92d0@changeid>
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

Functions that assume that nic access was acquired should have a
_no_grab postfix, so the caller will know that he is responsible to have
access when calling it.
Add the postfix.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/dbg-old.c   | 86 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 38 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  2 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  8 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  2 +-
 6 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
index a4e1f82c8bd1..320e891b3b03 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
@@ -48,7 +48,7 @@ static void iwl_read_radio_regs(struct iwl_fw_runtime *fwrt,
 
 		rd_cmd |= i << RADIO_RSP_ADDR_POS;
 		iwl_trans_write_prph_no_grab(fwrt->trans, RSP_RADIO_CMD, rd_cmd);
-		*pos = (u8)iwl_trans_read_prph(fwrt->trans, RSP_RADIO_RDDAT);
+		*pos = (u8)iwl_trans_read_prph_no_grab(fwrt->trans, RSP_RADIO_RDDAT);
 
 		pos++;
 	}
@@ -81,20 +81,20 @@ static void iwl_fwrt_dump_rxf(struct iwl_fw_runtime *fwrt,
 
 	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
 	fifo_hdr->available_bytes =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						RXF_RD_D_SPACE + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							RXF_RD_D_SPACE + offset));
 	fifo_hdr->wr_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						RXF_RD_WR_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							RXF_RD_WR_PTR + offset));
 	fifo_hdr->rd_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						RXF_RD_RD_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							RXF_RD_RD_PTR + offset));
 	fifo_hdr->fence_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						RXF_RD_FENCE_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							RXF_RD_FENCE_PTR + offset));
 	fifo_hdr->fence_mode =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						RXF_SET_FENCE_MODE + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							RXF_SET_FENCE_MODE + offset));
 
 	/* Lock fence */
 	iwl_trans_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offset, 0x1);
@@ -107,9 +107,9 @@ static void iwl_fwrt_dump_rxf(struct iwl_fw_runtime *fwrt,
 	/* Read FIFO */
 	fifo_len /= sizeof(u32); /* Size in DWORDS */
 	for (i = 0; i < fifo_len; i++)
-		fifo_data[i] = iwl_trans_read_prph(fwrt->trans,
-						 RXF_FIFO_RD_FENCE_INC +
-						 offset);
+		fifo_data[i] = iwl_trans_read_prph_no_grab(fwrt->trans,
+							   RXF_FIFO_RD_FENCE_INC +
+							   offset);
 	*dump_data = iwl_fw_error_next_data(*dump_data);
 }
 
@@ -136,33 +136,33 @@ static void iwl_fwrt_dump_txf(struct iwl_fw_runtime *fwrt,
 
 	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
 	fifo_hdr->available_bytes =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						TXF_FIFO_ITEM_CNT + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							TXF_FIFO_ITEM_CNT + offset));
 	fifo_hdr->wr_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						TXF_WR_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							TXF_WR_PTR + offset));
 	fifo_hdr->rd_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						TXF_RD_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							TXF_RD_PTR + offset));
 	fifo_hdr->fence_ptr =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						TXF_FENCE_PTR + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							TXF_FENCE_PTR + offset));
 	fifo_hdr->fence_mode =
-		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-						TXF_LOCK_FENCE + offset));
+		cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+							TXF_LOCK_FENCE + offset));
 
 	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
 	iwl_trans_write_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_ADDR + offset,
 				     TXF_WR_PTR + offset);
 
 	/* Dummy-read to advance the read pointer to the head */
-	iwl_trans_read_prph(fwrt->trans, TXF_READ_MODIFY_DATA + offset);
+	iwl_trans_read_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_DATA + offset);
 
 	/* Read FIFO */
 	for (i = 0; i < fifo_len / sizeof(u32); i++)
-		fifo_data[i] = iwl_trans_read_prph(fwrt->trans,
-						  TXF_READ_MODIFY_DATA +
-						  offset);
+		fifo_data[i] = iwl_trans_read_prph_no_grab(fwrt->trans,
+							   TXF_READ_MODIFY_DATA +
+							   offset);
 
 	if (fwrt->sanitize_ops && fwrt->sanitize_ops->frob_txf)
 		fwrt->sanitize_ops->frob_txf(fwrt->sanitize_ctx,
@@ -266,20 +266,20 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 						     fwrt->smem_cfg.num_txfifo_entries);
 
 			fifo_hdr->available_bytes =
-				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								TXF_CPU2_FIFO_ITEM_CNT));
+				cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									TXF_CPU2_FIFO_ITEM_CNT));
 			fifo_hdr->wr_ptr =
-				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								TXF_CPU2_WR_PTR));
+				cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									TXF_CPU2_WR_PTR));
 			fifo_hdr->rd_ptr =
-				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								TXF_CPU2_RD_PTR));
+				cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									TXF_CPU2_RD_PTR));
 			fifo_hdr->fence_ptr =
-				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								TXF_CPU2_FENCE_PTR));
+				cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									TXF_CPU2_FENCE_PTR));
 			fifo_hdr->fence_mode =
-				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								TXF_CPU2_LOCK_FENCE));
+				cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									TXF_CPU2_LOCK_FENCE));
 
 			/* Set TXF_CPU2_READ_MODIFY_ADDR to TXF_CPU2_WR_PTR */
 			iwl_trans_write_prph_no_grab(fwrt->trans,
@@ -287,15 +287,15 @@ static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
 						     TXF_CPU2_WR_PTR);
 
 			/* Dummy-read to advance the read pointer to head */
-			iwl_trans_read_prph(fwrt->trans,
-					    TXF_CPU2_READ_MODIFY_DATA);
+			iwl_trans_read_prph_no_grab(fwrt->trans,
+						    TXF_CPU2_READ_MODIFY_DATA);
 
 			/* Read FIFO */
 			fifo_len /= sizeof(u32); /* Size in DWORDS */
 			for (j = 0; j < fifo_len; j++)
 				fifo_data[j] =
-					iwl_trans_read_prph(fwrt->trans,
-							    TXF_CPU2_READ_MODIFY_DATA);
+					iwl_trans_read_prph_no_grab(fwrt->trans,
+								    TXF_CPU2_READ_MODIFY_DATA);
 			*dump_data = iwl_fw_error_next_data(*dump_data);
 		}
 	}
@@ -514,7 +514,7 @@ static void iwl_read_prph_block(struct iwl_trans *trans, u32 start,
 	u32 i;
 
 	for (i = 0; i < len_bytes; i += 4)
-		*data++ = cpu_to_le32(iwl_trans_read_prph(trans, start + i));
+		*data++ = cpu_to_le32(iwl_trans_read_prph_no_grab(trans, start + i));
 }
 
 static void iwl_dump_prph(struct iwl_fw_runtime *fwrt,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8d08ce7db3b9..3a0318070bfb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -103,7 +103,7 @@ static int iwl_dump_ini_prph_mac_iter_common(struct iwl_fw_runtime *fwrt,
 	range->internal_base_addr = cpu_to_le32(addr);
 	range->range_data_size = size;
 	for (i = 0; i < le32_to_cpu(size); i += 4)
-		*val++ = cpu_to_le32(iwl_trans_read_prph(fwrt->trans, addr + i));
+		*val++ = cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans, addr + i));
 
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
@@ -177,8 +177,8 @@ static int iwl_dump_ini_prph_phy_iter_common(struct iwl_fw_runtime *fwrt,
 		    fwrt->trans->info.hw_rf_id != IWL_CFG_RF_TYPE_HR1 &&
 		    fwrt->trans->info.hw_rf_id != IWL_CFG_RF_TYPE_HR2) {
 			udelay(2);
-			prph_stts = iwl_trans_read_prph(fwrt->trans,
-							WMAL_MRSPF_STTS);
+			prph_stts = iwl_trans_read_prph_no_grab(fwrt->trans,
+								WMAL_MRSPF_STTS);
 
 			/* Abort dump if status is 0xA5A5A5A2 or FIFO1 empty */
 			if (prph_stts == WMAL_TIMEOUT_VAL ||
@@ -186,8 +186,8 @@ static int iwl_dump_ini_prph_phy_iter_common(struct iwl_fw_runtime *fwrt,
 				break;
 		}
 
-		prph_val = iwl_trans_read_prph(fwrt->trans,
-					       indirect_rd_addr);
+		prph_val = iwl_trans_read_prph_no_grab(fwrt->trans,
+						       indirect_rd_addr);
 		*val++ = cpu_to_le32(prph_val);
 	}
 
@@ -456,8 +456,8 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 		addr = le32_to_cpu(reg->addrs[i]) + offs;
 
 		reg_dump->addr = cpu_to_le32(addr);
-		reg_dump->data = cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								 addr));
+		reg_dump->data = cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									 addr));
 
 		reg_dump++;
 	}
@@ -472,13 +472,13 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 				     TXF_WR_PTR + offs);
 
 	/* Dummy-read to advance the read pointer to the head */
-	iwl_trans_read_prph(fwrt->trans, TXF_READ_MODIFY_DATA + offs);
+	iwl_trans_read_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_DATA + offs);
 
 	/* Read FIFO */
 	addr = TXF_READ_MODIFY_DATA + offs;
 	data = (void *)reg_dump;
 	for (i = 0; i < iter->fifo_size; i += sizeof(*data))
-		*data++ = cpu_to_le32(iwl_trans_read_prph(fwrt->trans, addr));
+		*data++ = cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans, addr));
 
 	if (fwrt->sanitize_ops && fwrt->sanitize_ops->frob_txf)
 		fwrt->sanitize_ops->frob_txf(fwrt->sanitize_ctx,
@@ -522,8 +522,8 @@ iwl_dump_ini_prph_snps_dphyip_iter(struct iwl_fw_runtime *fwrt,
 					     addr + i);
 		/* wait a bit for value to be ready in register */
 		udelay(1);
-		prph_val = iwl_trans_read_prph(fwrt->trans,
-					       indirect_rd_wr_addr);
+		prph_val = iwl_trans_read_prph_no_grab(fwrt->trans,
+						       indirect_rd_wr_addr);
 		*val++ = cpu_to_le32((prph_val & DPHYIP_INDIRECT_RD_MSK) >>
 				     DPHYIP_INDIRECT_RD_SHIFT);
 	}
@@ -628,8 +628,8 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 		addr = le32_to_cpu(reg->addrs[i]) + offs;
 
 		reg_dump->addr = cpu_to_le32(addr);
-		reg_dump->data = cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
-								 addr));
+		reg_dump->data = cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans,
+									 addr));
 
 		reg_dump++;
 	}
@@ -652,7 +652,7 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 	addr =  RXF_FIFO_RD_FENCE_INC + offs;
 	data = (void *)reg_dump;
 	for (i = 0; i < rxf_data.size; i += sizeof(*data))
-		*data++ = cpu_to_le32(iwl_trans_read_prph(fwrt->trans, addr));
+		*data++ = cpu_to_le32(iwl_trans_read_prph_no_grab(fwrt->trans, addr));
 
 out:
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
@@ -712,10 +712,10 @@ iwl_dump_ini_dbgi_sram_iter(struct iwl_fw_runtime *fwrt,
 	range->range_data_size = reg->dev_addr.size;
 	for (i = 0; i < (le32_to_cpu(reg->dev_addr.size) / 4); i++) {
 		prph_data =
-			iwl_trans_read_prph(fwrt->trans,
-					    (i % 2) ?
-						DBGI_SRAM_TARGET_ACCESS_RDATA_MSB :
-						DBGI_SRAM_TARGET_ACCESS_RDATA_LSB);
+			iwl_trans_read_prph_no_grab(fwrt->trans,
+						    (i % 2) ?
+						        DBGI_SRAM_TARGET_ACCESS_RDATA_MSB :
+						        DBGI_SRAM_TARGET_ACCESS_RDATA_LSB);
 		if (iwl_trans_is_hw_error_value(prph_data))
 			return -EBUSY;
 		*val++ = cpu_to_le32(prph_data);
@@ -812,7 +812,7 @@ static __le32 iwl_get_mon_reg(struct iwl_fw_runtime *fwrt, u32 alloc_id,
 	if (!reg_info || !reg_info->addr || !reg_info->mask)
 		return 0;
 
-	val = iwl_trans_read_prph(fwrt->trans, reg_info->addr + offs);
+	val = iwl_trans_read_prph_no_grab(fwrt->trans, reg_info->addr + offs);
 
 	return cpu_to_le32(mask_apply_and_normalize(val, reg_info->mask));
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 085074be2549..bc3ef107c4eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -40,7 +40,7 @@ IWL_EXPORT_SYMBOL(iwl_write_direct32);
 
 u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
-	u32 val = iwl_trans_read_prph(trans, ofs);
+	u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
 	trace_iwlwifi_dev_ioread_prph32(trans->dev, ofs, val);
 	return val;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 76cba6ac0c8b..9e02a498b5f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1367,10 +1367,10 @@ static void iwl_set_hw_address_family_8000(struct iwl_trans *trans,
 
 	if (nvm_hw) {
 		/* read the mac address from WFMP registers */
-		__le32 mac_addr0 = cpu_to_le32(iwl_trans_read_prph(trans,
-						WFMP_MAC_ADDR_0));
-		__le32 mac_addr1 = cpu_to_le32(iwl_trans_read_prph(trans,
-						WFMP_MAC_ADDR_1));
+		__le32 mac_addr0 = cpu_to_le32(iwl_trans_read_prph_no_grab(trans,
+									   WFMP_MAC_ADDR_0));
+		__le32 mac_addr1 = cpu_to_le32(iwl_trans_read_prph_no_grab(trans,
+									   WFMP_MAC_ADDR_1));
 
 		iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 2d0bb3de7df5..123eca3f5d0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -440,7 +440,7 @@ u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 }
 IWL_EXPORT_SYMBOL(iwl_trans_read32);
 
-u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
+u32 iwl_trans_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
 	return iwl_trans_pcie_read_prph(trans, ofs);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c882313eaceb..18c1c46c11ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -914,7 +914,7 @@ void iwl_trans_write32(struct iwl_trans *trans, u32 ofs, u32 val);
 
 u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs);
 
-u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs);
+u32 iwl_trans_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 
 void iwl_trans_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
 
-- 
2.34.1


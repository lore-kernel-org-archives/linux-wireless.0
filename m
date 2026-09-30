Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CE7457E66
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754901; cv=none; b=dknlSszPSbZ6ZYPMyjDzUG2omrqZ+9zSrjyZWNYfF0yKZZqBAhvdaWRTnnba+FjryQ1e2BmQy2SAnxa/+PH6wHjLgqIuLBz3qXRHaL7km/xrHcCE5CPF8vTtuHPJUasJMeffukstG4U0OxTOhF5kszzT6+6fwCZJfKYBm5EHiNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754901; c=relaxed/simple;
	bh=J3uJDKWz6X+i950ti0wLEp1YkyaMJlFsYlQdmp851Bw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=goyBEnAu3F8Jr9PBd5nfCi1ptRyVsyVBaLmNGbNe12Xt61p0241vFMbSU9A0dtOiOm4bEKw0bGc4eRMJn8hheMasPqXAsaag9hWZ2nmZABfgchglGTqfAKhpV4KX0TzPNVQ+0xy88rz4UliwHDEZpL9H+klMzTHNCref3l5QBaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HacnGIVx; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HacnGIVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754899; x=1822290899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J3uJDKWz6X+i950ti0wLEp1YkyaMJlFsYlQdmp851Bw=;
  b=HacnGIVxNfpK80h/A/Zmsq6+r2QQuiLYuAW7YeA0ZSgFCvWokjvg1mkN
   qyg3AglEoDqYdrzjKaWBx+zSz7n9ngB4YQ3xskMzvISTHMgMYyC4nWoPN
   /wpLFwt+IhGSQgUffjjQlzZZLkJWCNJAvqONp9LJxocxKlj5qFQ3+ie9S
   EiH+gWFa3fI2XGC4HIvKOyBEfon+9LlWZk8zIRgW6aj/irTvH/ZqWwOrL
   1pWFmwAOCHOfQbmQKy3A2lMjMJLHbm9ujEWSvRdnsUU22c/LlaEKBDI3u
   HQXqs/Y8EzUyZE5mOWmIvmsfXGJ8kUc5yHPDLNxm0+nukLVmeQE6vKddm
   g==;
X-CSE-ConnectionGUID: pKQ2HTpXRWKTmNu4cPl/2A==
X-CSE-MsgGUID: 7amy1AmmRQaClAX/lEPKFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296826"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296826"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:59 -0700
X-CSE-ConnectionGUID: l5UeiKuYSe+Cvb8U/78SDw==
X-CSE-MsgGUID: DV4tYU+JTHeP0JRCLDAlqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962933"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: collapse iwl_read_prph_no_grab() into the transport API
Date: Wed, 30 Sep 2026 10:56:36 +0300
Message-Id: <20260930104825.38a4273ec7a6.I329ccec5de9d0a6ec87538aceabce17149258841@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

iwl_read_prph_no_grab() was a thin wrapper that read via
iwl_trans_read_prph_no_grab() and emitted the ioread_prph32 tracepoint.
Fold the tracepoint into the bus-specific implementation
(iwl_trans_pcie_read_prph()) and remove the wrapper, so callers use the
transport API (or the pcie primitive from within pcie) directly.

No functional change intended.

Assisted-by: GitHubCopilot:claude-opus-4.8
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c    |  6 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c     | 15 ++++-----------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h     |  5 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  9 ++++++---
 4 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index eef89c141564..7b9e98a21704 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -360,7 +360,7 @@ static void iwl_fwrt_dump_fseq_regs(struct iwl_fw_runtime *fwrt)
 
 	for (i = 0; i < ARRAY_SIZE(fseq_regs); i++)
 		IWL_ERR(fwrt, "0x%08X | %s\n",
-			iwl_read_prph_no_grab(trans, fseq_regs[i].addr),
+			iwl_trans_read_prph_no_grab(trans, fseq_regs[i].addr),
 			fseq_regs[i].str);
 
 	iwl_trans_release_nic_access(trans);
@@ -398,8 +398,8 @@ void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 		     count++, pc_data++)
 			IWL_ERR(fwrt, "%s: 0x%x\n",
 				pc_data->pc_name,
-				iwl_read_prph_no_grab(fwrt->trans,
-						      pc_data->pc_address));
+				iwl_trans_read_prph_no_grab(fwrt->trans,
+							    pc_data->pc_address));
 		iwl_trans_release_nic_access(fwrt->trans);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index bc3ef107c4eb..515d6b2becc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -38,17 +38,10 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 }
 IWL_EXPORT_SYMBOL(iwl_write_direct32);
 
-u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
-{
-	u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
-	trace_iwlwifi_dev_ioread_prph32(trans->dev, ofs, val);
-	return val;
-}
-
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
-		u32 val = iwl_read_prph_no_grab(trans, ofs);
+		u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
 
 		iwl_trans_release_nic_access(trans);
 
@@ -74,7 +67,7 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		iwl_trans_write_prph_no_grab(trans, ofs,
-					     iwl_read_prph_no_grab(trans, ofs) |
+					     iwl_trans_read_prph_no_grab(trans, ofs) |
 					     mask);
 		iwl_trans_release_nic_access(trans);
 	}
@@ -86,7 +79,7 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		iwl_trans_write_prph_no_grab(trans, ofs,
-					     (iwl_read_prph_no_grab(trans, ofs) &
+					     (iwl_trans_read_prph_no_grab(trans, ofs) &
 					      mask) | bits);
 		iwl_trans_release_nic_access(trans);
 	}
@@ -98,7 +91,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	u32 val;
 
 	if (iwl_trans_grab_nic_access(trans)) {
-		val = iwl_read_prph_no_grab(trans, ofs);
+		val = iwl_trans_read_prph_no_grab(trans, ofs);
 		iwl_trans_write_prph_no_grab(trans, ofs, (val & ~mask));
 		iwl_trans_release_nic_access(trans);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index b33bc4822e5c..a26c6525ec40 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -29,7 +29,6 @@ static inline int iwl_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
-u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
 void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs,
 			  u32 val, u32 delay_ms);
@@ -55,8 +54,8 @@ static inline u32 iwl_umac_prph(struct iwl_trans *trans, u32 ofs)
 
 static inline u32 iwl_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
-	return iwl_read_prph_no_grab(trans, ofs +
-				     trans->mac_cfg->umac_prph_offset);
+	return iwl_trans_read_prph_no_grab(trans, ofs +
+					   trans->mac_cfg->umac_prph_offset);
 }
 
 static inline u32 iwl_read_umac_prph(struct iwl_trans *trans, u32 ofs)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 8dc8924564e5..709c2499ffc8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1893,10 +1893,13 @@ static u32 iwl_trans_pcie_prph_msk(struct iwl_trans *trans)
 u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
 {
 	u32 mask = iwl_trans_pcie_prph_msk(trans);
+	u32 val;
 
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_RADDR,
 			       ((reg & mask) | (3 << 24)));
-	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
+	val = iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
+	trace_iwlwifi_dev_ioread_prph32(trans->dev, reg, val);
+	return val;
 }
 
 void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val)
@@ -3938,10 +3941,10 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	iwl_pcie_write_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG, val);
 
 	/* Read crf info */
-	info->hw_crf_id = iwl_read_prph_no_grab(iwl_trans, sd_reg_ver_addr);
+	info->hw_crf_id = iwl_trans_pcie_read_prph(iwl_trans, sd_reg_ver_addr);
 
 	/* Read cnv info */
-	info->hw_cnv_id = iwl_read_prph_no_grab(iwl_trans, CNVI_AUX_MISC_CHIP);
+	info->hw_cnv_id = iwl_trans_pcie_read_prph(iwl_trans, CNVI_AUX_MISC_CHIP);
 
 	/* For BZ-W, take B step also when A step is indicated */
 	if (CSR_HW_REV_TYPE(info->hw_rev) == IWL_CFG_MAC_TYPE_BZ_W)
-- 
2.34.1


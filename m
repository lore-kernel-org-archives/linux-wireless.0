Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A7C459AD2
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754904; cv=none; b=HtJ3bMLOTiELHsnIzkOxrPASSsdrNIlVmUUWWpAq45xUJWdebKGRFhsyrUXYdMFHfbSz+Uwmepy9Q674aX7TasUmgOoFjzisAv0AwNfA7v0/SDE/90R5aFzUIAIyX/6hrzrAAG++8NEofOAVZOv/zjYAtEWTotXgaq6ozV3ie5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754904; c=relaxed/simple;
	bh=jOKZqjzRwnHRWzTTj2gGYavOslfdoVZHUiojHEAyoH0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E/+mLlC/II/HLlphJb0VkR6Qc8jtorl3gWN8wH8L9BCCX7Pp8nElkZYYRuWrjuAaL+C9XvFckFuj5Dg88TIO/Vz/mSABAAfcIjbMXowbJyZzPCDWe9rAgO6U4kSO7XNe9U/qfp/sVkfRkhnhXOpKkU2JFYX6Vkr4dKfadLXzcqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOGl9gi4; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOGl9gi4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754901; x=1822290901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOKZqjzRwnHRWzTTj2gGYavOslfdoVZHUiojHEAyoH0=;
  b=FOGl9gi47BntUtRVzhZxi0TbzOt9tcgsqjcNgu7skQas4EOc4GdT6N3y
   4Ux9w0HpLyJ+89OZHE8xfSE3FQVVn466Mf48hpgw258oQaqZ9ngrDvMJK
   nd8MSM5qQNFF0Zg+K/4NZIx/uzsdf7+BrrwpO76NkbCDb8r8DzpY/vw+K
   TwiQ9fOHI4ZnEV8itHURYS2wdIwqFj+1KhBIQgjHVecavgBZprRr1LadY
   vNtpbCMD0qfObSNuWLAlJ1MPSu2xwJEoXKQ6iXIMX/JG1bjCMm9CsgKmJ
   W54vpi3qRDrMj8GwElscrWj2OZ4TABYjI8oZr+w795lXlDJyxPPRR7gqZ
   w==;
X-CSE-ConnectionGUID: ttzelGueQfKvL+PDQwobDA==
X-CSE-MsgGUID: 9nb0ILfDQvCpV/sfpzAhVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296827"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296827"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:00 -0700
X-CSE-ConnectionGUID: FNd/zmT+TWGOe3FkHUgL2g==
X-CSE-MsgGUID: y2OBy8htRAKsaAbn10io0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962937"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: pcie: rename pcie-internal functions
Date: Wed, 30 Sep 2026 10:56:37 +0300
Message-Id: <20260930104825.d9902d3ac94c.I5867c6f937d569349e1950733361bf83a5e49fbb@changeid>
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

Functions that are in pcie level should have the pcie prefix.
In particular, the functions renamed in this commit are easy to be
confused with the generic trans ones. Rename those functions to have a
pcie prefix.

Assisted-by: GitHubCopilot:claude-opus-4.8
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 28 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  4 +--
 .../net/wireless/intel/iwlwifi/pcie/utils.h   | 12 ++++----
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 709c2499ffc8..ce7d01a36688 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -334,8 +334,8 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	u32 dl_cfg_reg;
 
 	/* Force XTAL ON */
-	iwl_trans_set_bit(trans, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+	iwl_pcie_set_bit(trans, CSR_GP_CNTRL,
+			 CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
 
 	ret = iwl_trans_pcie_sw_reset(trans, true);
 
@@ -344,8 +344,8 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 
 	if (WARN_ON(ret)) {
 		/* Release XTAL ON request */
-		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+		iwl_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
 		return;
 	}
 
@@ -396,12 +396,12 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* Activates XTAL resources monitor */
-	iwl_trans_set_bit(trans, CSR_MONITOR_CFG_REG,
-			  CSR_MONITOR_XTAL_RESOURCES);
+	iwl_pcie_set_bit(trans, CSR_MONITOR_CFG_REG,
+			 CSR_MONITOR_XTAL_RESOURCES);
 
 	/* Release XTAL ON request */
-	iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
+	iwl_pcie_clear_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
 	udelay(10);
 
 	/* Release APMG XTAL */
@@ -2359,7 +2359,7 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 	}
 
 	/* this bit wakes up the NIC */
-	iwl_trans_set_bit(trans, CSR_GP_CNTRL, write);
+	iwl_pcie_set_bit(trans, CSR_GP_CNTRL, write);
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_8000)
 		udelay(2);
 
@@ -2452,11 +2452,11 @@ void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
-		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
+		iwl_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
 	else
-		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	/*
 	 * Above we read the CSR_GP_CNTRL register, which will flush
 	 * any previous writes, but we need the write that clears the
@@ -2681,7 +2681,7 @@ void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	spin_lock_bh(&trans_pcie->reg_lock);
-	_iwl_trans_set_bits_mask(trans, reg, mask, value);
+	iwl_pcie_set_bits_mask(trans, reg, mask, value);
 	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index f5aa456180d8..cd744f7002b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -205,8 +205,8 @@ static void iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
 	}
 
 	trans_pcie->cmd_hold_nic_awake = false;
-	iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl_pcie_clear_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock(&trans_pcie->reg_lock);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
index 2d92bff513df..74c23ec199e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
@@ -36,8 +36,8 @@ static inline void iwl_pcie_write_umac_prph_no_grab(struct iwl_trans *trans,
 				    val);
 }
 
-static inline void _iwl_trans_set_bits_mask(struct iwl_trans *trans,
-					    u32 reg, u32 mask, u32 value)
+static inline void iwl_pcie_set_bits_mask(struct iwl_trans *trans,
+					  u32 reg, u32 mask, u32 value)
 {
 	u32 v;
 
@@ -51,16 +51,16 @@ static inline void _iwl_trans_set_bits_mask(struct iwl_trans *trans,
 	iwl_trans_pcie_write32(trans, reg, v);
 }
 
-static inline void iwl_trans_clear_bit(struct iwl_trans *trans,
+static inline void iwl_pcie_clear_bit(struct iwl_trans *trans,
 				       u32 reg, u32 mask)
 {
-	_iwl_trans_set_bits_mask(trans, reg, mask, 0);
+	iwl_pcie_set_bits_mask(trans, reg, mask, 0);
 }
 
-static inline void iwl_trans_set_bit(struct iwl_trans *trans,
+static inline void iwl_pcie_set_bit(struct iwl_trans *trans,
 				     u32 reg, u32 mask)
 {
-	_iwl_trans_set_bits_mask(trans, reg, mask, mask);
+	iwl_pcie_set_bits_mask(trans, reg, mask, mask);
 }
 
 #endif /* __iwl_pcie_utils_h__ */
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754964766B2
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759895; cv=none; b=H2zsBY8P/NDKZmMwR4ZTc/yLDbY4N6w2390TjggVNuq9wuz8hsNg4j8fjdYNibaHw2XdewmJxrzxVvEBjifBtiwnqSSrgg44/5P7hemi9zML18kaVV+LLGRV3cxTkTK3M5jmKq1Uzq5O+a8KhpJYAFkYxBvhYacd4Q/I4n9KSyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759895; c=relaxed/simple;
	bh=jOKZqjzRwnHRWzTTj2gGYavOslfdoVZHUiojHEAyoH0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qnxn+ujLvZ/tjxwZS0xbjG1/I04n/sQ5N+8cSVMfxq0guD8n3AbESe7UCN/Joho8SlOQJONQJcM7YPzavVyoh0hnE4yJ+TdqvRH8iMdlAmOsMwxE0yoX80EEKOJtWi8a5MvjlqDrvHcrGvTrdN1y3i3A6+w3ByNx/VXZK8IKGyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0Jm9PJm; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0Jm9PJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759893; x=1822295893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOKZqjzRwnHRWzTTj2gGYavOslfdoVZHUiojHEAyoH0=;
  b=Q0Jm9PJm6Q28awgrw38IgKf6xirueiZA2DXxAHKfDBWFwq/Gl+UlFHIV
   tIq0sbGs5aTFthT841ZWtduAFziH3evw0/i63WPDCzPb0eJ9cp9IpEz8a
   DwuJm697KunwrkDvjvL5NaNAr+c3vPAokwNiVgwydmLdlxa3PnlZyV+lY
   XejFDb3Qw2TzJy9Jh06x+nCp/yubsz0NRUUkX7MIMgLtbQ27pu4CDVWtH
   r+Vqmfd0s4n5ZFX74hHaKHQnFr1YidV+OwJ+hFFp8I/lW3LRTxkNsFy3x
   RLYFeI0ZWuBcDRh10hOe7y+BZVaebXALyOSvkJIhYGMiB1z0ysokifwoC
   g==;
X-CSE-ConnectionGUID: WiB+g3YDTri1XbVnoEfKNw==
X-CSE-MsgGUID: zm2yVLDTQMST5Mz0py16lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447025"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447025"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:12 -0700
X-CSE-ConnectionGUID: wxLBqtCNQAaGCXMKQ2DVCw==
X-CSE-MsgGUID: kwT9LwRVSAmo56nuZgriAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673554"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:10 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 09/15] wifi: iwlwifi: pcie: rename pcie-internal functions
Date: Wed, 30 Sep 2026 12:19:46 +0300
Message-Id: <20260930121740.09af8a4d712b.I5867c6f937d569349e1950733361bf83a5e49fbb@changeid>
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


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEE473C64
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246389; cv=none; b=E0b0HFisAtvlZAW8Ddufaa/J16K4mDd4Yi/UzVEgAnjceigiVOTRejfw38Zk/jRFclCAkIPVhhXWkOScavUkAYjEc5A3nimAsYkvyIjTNT2Rz0FA0tWUpRLv42JaOgPDZN3Xqlo0RN2VeMRRae42r4AD5yeqVIf52Y6T183wXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246389; c=relaxed/simple;
	bh=7gJ1lhFBbFpdxHVN23oXfqbbyeqL/fF9iwSPPudDRmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYheNB4t2dzj3I/OiKxal/M6+/d0j4eoRAq0Dh/+vhTQ24Qd/ezC+D0nPBLOWsrNgSqji/dY5Ym3mgGpaY0IpaOMjUD+Z8jgJN5mjSwfC/zE5uY6Qv8i8WVz3iciVSV8GKYlryJaMemMTjgyg+ZiDKTEZCl80JTItfWIyL31aI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nwTJYM5X; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nwTJYM5X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246387; x=1821782387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7gJ1lhFBbFpdxHVN23oXfqbbyeqL/fF9iwSPPudDRmY=;
  b=nwTJYM5Xq/nL8APFpKuxb/oxk09SVBjHXMRmoAHOEORz+/U3XE10cv2h
   O3jzfwPqs2AFZ59fTxs78iKLdnjnxAqZXYYm41lC8/krrQ0fGZItIRL2p
   yDL4jyYM+/eS5LW7RqkTOa2/6SXcc48hZdGldLUE0eCzo+rcvvBQmwSsT
   hCdAilHJ1mBMYcDJkXQNXrxEl2fRElI0vspg1ABeXBi0mzwUuVaM487XQ
   JRnktpQp9jwTdA4vckdAK0r6GOj211QUN3Pep4agmDMDqgf0ru3SwRgcd
   qF1BdXlxwU5tq/V1dWGdKi5cubMENHIveajwuazvbXjCvLhcW/hHlL3Zk
   w==;
X-CSE-ConnectionGUID: GVo/6ZQ3SgOpatePzbeW6g==
X-CSE-MsgGUID: HdD2q2JNSD2M4V5qM93dqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134892"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134892"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:47 -0700
X-CSE-ConnectionGUID: rGpZw1CaSpqq/azWycUa6A==
X-CSE-MsgGUID: 3rmgNSvCTjayAW2cTuydMA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: open code iwl_trans_sync_nmi_with_addr()
Date: Thu, 24 Sep 2026 13:41:24 +0300
Message-Id: <20260924133942.822d6954940e.I23611eb40d875c6a69df0c08add3834f6f7d8528@changeid>
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

iwl_trans_sync_nmi_with_addr() had a single caller,
iwl_trans_pcie_sync_nmi(). There is no reason to keep it as a separate
exported function in iwl-io.c, so embed its body directly in the caller
and drop the now-unused declaration.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 36 -------------------
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  5 ---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  5 ---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 33 +++++++++++++++--
 4 files changed, 31 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 544b8e686dfe..ef4d97ef0b1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -233,39 +233,3 @@ void iwl_force_nmi(struct iwl_trans *trans)
 			    UREG_DOORBELL_TO_ISR6_NMI_BIT);
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
-
-void iwl_trans_sync_nmi_with_addr(struct iwl_trans *trans, u32 inta_addr,
-				  u32 sw_err_bit)
-{
-	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
-	bool interrupts_enabled = test_bit(STATUS_INT_ENABLED, &trans->status);
-
-	/* if the interrupts were already disabled, there is no point in
-	 * calling iwl_disable_interrupts
-	 */
-	if (interrupts_enabled)
-		iwl_trans_interrupts(trans, false);
-
-	iwl_force_nmi(trans);
-	while (time_after(timeout, jiffies)) {
-		u32 inta_hw = iwl_read32(trans, inta_addr);
-
-		/* Error detected by uCode */
-		if (inta_hw & sw_err_bit) {
-			/* Clear causes register */
-			iwl_write32(trans, inta_addr, inta_hw & sw_err_bit);
-			break;
-		}
-
-		mdelay(1);
-	}
-
-	/* enable interrupts only if there were already enabled before this
-	 * function to avoid a case were the driver enable interrupts before
-	 * proper configurations were made
-	 */
-	if (interrupts_enabled)
-		iwl_trans_interrupts(trans, true);
-
-	iwl_trans_fw_error(trans, IWL_ERR_TYPE_NMI_FORCED);
-}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 24bf45f06746..ad43cf53e8c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -523,11 +523,6 @@ int iwl_trans_d3_resume(struct iwl_trans *trans, bool reset)
 }
 IWL_EXPORT_SYMBOL(iwl_trans_d3_resume);
 
-void iwl_trans_interrupts(struct iwl_trans *trans, bool enable)
-{
-	iwl_trans_pci_interrupts(trans, enable);
-}
-
 void iwl_trans_sync_nmi(struct iwl_trans *trans)
 {
 	iwl_trans_pcie_sync_nmi(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index dfad839dd2e6..f933cba7eee8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1055,9 +1055,6 @@ static inline bool iwl_trans_fw_running(struct iwl_trans *trans)
 
 void iwl_trans_sync_nmi(struct iwl_trans *trans);
 
-void iwl_trans_sync_nmi_with_addr(struct iwl_trans *trans, u32 inta_addr,
-				  u32 sw_err_bit);
-
 int iwl_trans_load_pnvm(struct iwl_trans *trans,
 			const struct iwl_pnvm_image *pnvm_data,
 			const struct iwl_ucode_capabilities *capa);
@@ -1078,8 +1075,6 @@ static inline bool iwl_trans_dbg_ini_valid(struct iwl_trans *trans)
 		trans->dbg.external_ini_cfg != IWL_INI_CFG_STATE_NOT_LOADED;
 }
 
-void iwl_trans_interrupts(struct iwl_trans *trans, bool enable);
-
 int iwl_trans_activate_nic(struct iwl_trans *trans);
 
 static inline void iwl_trans_finish_sw_reset(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 97bbc3faa98c..48ae2440cfe1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3574,8 +3574,10 @@ void iwl_trans_pci_interrupts(struct iwl_trans *trans, bool enable)
 
 void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 {
-	u32 inta_addr, sw_err_bit;
+	bool interrupts_enabled = test_bit(STATUS_INT_ENABLED, &trans->status);
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
+	u32 inta_addr, sw_err_bit;
 
 	if (trans_pcie->msix_enabled) {
 		inta_addr = CSR_MSIX_HW_INT_CAUSES_AD;
@@ -3588,7 +3590,34 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 		sw_err_bit = CSR_INT_BIT_SW_ERR;
 	}
 
-	iwl_trans_sync_nmi_with_addr(trans, inta_addr, sw_err_bit);
+	/* if the interrupts were already disabled, there is no point in
+	 * calling iwl_disable_interrupts
+	 */
+	if (interrupts_enabled)
+		iwl_trans_pci_interrupts(trans, false);
+
+	iwl_force_nmi(trans);
+	while (time_after(timeout, jiffies)) {
+		u32 inta_hw = iwl_read32(trans, inta_addr);
+
+		/* Error detected by uCode */
+		if (inta_hw & sw_err_bit) {
+			/* Clear causes register */
+			iwl_write32(trans, inta_addr, inta_hw & sw_err_bit);
+			break;
+		}
+
+		mdelay(1);
+	}
+
+	/* enable interrupts only if there were already enabled before this
+	 * function to avoid a case were the driver enable interrupts before
+	 * proper configurations were made
+	 */
+	if (interrupts_enabled)
+		iwl_trans_pci_interrupts(trans, true);
+
+	iwl_trans_fw_error(trans, IWL_ERR_TYPE_NMI_FORCED);
 }
 
 static int iwl_trans_pcie_alloc_txcmd_pool(struct iwl_trans *trans)
-- 
2.34.1


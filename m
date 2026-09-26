Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0529128DB55
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442952; cv=none; b=XJGz9tH65AWKKvJpwVIgbJHqyYL3zluiP8lpnFg4v5plQ1DMrRn8MXI7HmLpEpAdNJcVIBmc0Ot55nqqSkbr9zOAMDbcaLBDcd7P/6NksGh5Pvt4MvYFVvoTb26qxq0awazWBvE57wPrxZG2s1OUp2/4FeyGfWB4dANRf1qftm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442952; c=relaxed/simple;
	bh=7gJ1lhFBbFpdxHVN23oXfqbbyeqL/fF9iwSPPudDRmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FjlfI1NVeGntiAu2NMf3lL1GURAMJ9yn24rLQdJLq/HXW1tPsd72awkq+ofbQgxWteW6fSaVAcJrCIBhQFYrC2MLXzVRBh7BqC9x4JXt7H624jdU2ilwUKa1BunrgsKwAbHl+PRDPnwbJs7iJEy3JZkRKREiepXnafa/TIGqXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEWwQXm/; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEWwQXm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442951; x=1821978951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7gJ1lhFBbFpdxHVN23oXfqbbyeqL/fF9iwSPPudDRmY=;
  b=OEWwQXm/4V4cS/qKPJC+FCwBMptfoUSJ4XdC5vIw3/56hghnGJwn01lc
   PAqS8UyckWK40jTUApSHt+ylM6jIEmiuadEOuzBZdz9scaM0cwDMEIjJj
   3xE4jJg8QHp8ixWruO5+XVeTP4zc1UJyyypnVdrzIpiwD12spdNh6nOXL
   VdRNRlEJ/WuQhMxJhljgmPDBXtfRGKx1eJb8sPKAU+UZJK8dlO8kq+904
   1OwcI/O17ppd4QBly8kCwzOYl9xq8ObF9BgLEbVcFhPvkq6j9lO6lp2sg
   ZESR7Ea8xkrriwJjx6K6BSA0T3YMPIf504aBLZGd114NXCAitQ/88CAxc
   g==;
X-CSE-ConnectionGUID: B3bzXiwTSp+eh6L1pCJCfg==
X-CSE-MsgGUID: QMgmEvJSQ+qYlOOpi2NzHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533292"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533292"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:51 -0700
X-CSE-ConnectionGUID: NOLu+rz4SrChY1j6njGC8g==
X-CSE-MsgGUID: SRcWzE8TRJmYucgB4Jd9Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274197007"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:50 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 10/15] wifi: iwlwifi: open code iwl_trans_sync_nmi_with_addr()
Date: Sat, 26 Sep 2026 20:17:29 +0300
Message-Id: <20260926201527.a2048732f45f.I23611eb40d875c6a69df0c08add3834f6f7d8528@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
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


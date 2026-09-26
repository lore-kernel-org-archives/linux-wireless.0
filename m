Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076BB2F12A1
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442940; cv=none; b=pvMUnbq6cfGvxZlJ2E7J4RsNKu/l3udH/XywO5Kc7XxJtMHJwVZ8wlI71gB8ec/9XuBWevFgq9t17QJHRS8a2sl+ZR9tl9v62NiYDwpQ2vZukr0/620ON6Wb5uFxT99+U24tDge6FAGoOAn/12VK7UDcErSn+nWbz7N+q5PUjok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442940; c=relaxed/simple;
	bh=9R52JNKb+1M9weqGkC/6UA416nRgkFMwAwkM8hURmxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tKxUg/W0/Au/6CvSJ8wQFksxewuq4Jqn8IgH/MS/8hVLjwv7sWvypgItLZ5fGqkdsl21ws7oYfZOyIiLl1WTmjWt6o+kLkIpm8zfR72tw0hJsjtp94SPvLU3ZnCz71w6HX4LBxR5bp5CFAiaSLDRKMxkxpFUvbdIyTGiYrUhmKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JF3WaJW/; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JF3WaJW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442938; x=1821978938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9R52JNKb+1M9weqGkC/6UA416nRgkFMwAwkM8hURmxM=;
  b=JF3WaJW/pKYpizqxs56zVy1evmsT1z37/P1+szlt0Rykpl8gE0KAAf6h
   /OntBC56y5TQOwUNgbDClLTwd3g3jtPAvt8NlBrAyHFr1BrA898sOB5GQ
   tkAW9j/OGBpNhK1aUyhDwyKjfgw/6cjRUDZ6XWS4KwJp/YIlDzcwE/kDq
   2Ue9yB45FHWbFQQGFALgJ/isqr7Z0yAPpga9VRPYYeFP5v418SoOtwpxJ
   ShH6DeeIfUBAqcLYKbuC6BYB2hSQC7LIraKUElkK/+1IMwxciiz/XgcZS
   WhYvt/e5D2J2QG8JvOSHbZwRAq+ib6tl32ugXA3SbwHAq+8tC2l3m3w14
   w==;
X-CSE-ConnectionGUID: W2UGOSVJRGyKhsO8iQI9LQ==
X-CSE-MsgGUID: KZuXQJFFTraOVNuhbFGYeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533272"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533272"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:38 -0700
X-CSE-ConnectionGUID: 3P46CYm8RGiEeFSDGOmi8w==
X-CSE-MsgGUID: KUBlksFAQ6GSk9fpq9G+vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196896"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:37 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 01/15] wifi: iwlwifi: pcie: drop gen1_2 prefix from several functions
Date: Sat, 26 Sep 2026 20:17:20 +0300
Message-Id: <20260926201527.dc1a22771b0e.I20e77f228e1536c6eb327dc077b030dbea889ac2@changeid>
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

As a preparation of a future pcie-transport, we added a gen1_2 prefix to
some functions to distinguish them from the new implementation.
Since the new pcie-transport will not happen eventaully, remove this
prefix from those functions.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 +-
 .../intel/iwlwifi/pcie/gen1_2/internal.h      | 19 +++++++++----------
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 11 +++++------
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index a1545e9d2cd8..8cc8f6c4e934 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -333,14 +333,14 @@ IWL_EXPORT_SYMBOL(iwl_trans_send_cmd);
 
 struct iwl_device_tx_cmd *iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
-	return iwl_pcie_gen1_2_alloc_tx_cmd(trans);
+	return iwl_pcie_alloc_tx_cmd(trans);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_alloc_tx_cmd);
 
 void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
 			   struct iwl_device_tx_cmd *dev_cmd)
 {
-	iwl_pcie_gen1_2_free_tx_cmd(trans, dev_cmd);
+	iwl_pcie_free_tx_cmd(trans, dev_cmd);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_free_tx_cmd);
 
@@ -395,7 +395,7 @@ void iwl_trans_op_mode_enter(struct iwl_trans *trans,
 
 	WARN_ON_ONCE(!trans->conf.rx_mpdu_cmd);
 
-	iwl_pcie_gen1_2_op_mode_enter(trans);
+	iwl_trans_pcie_op_mode_enter(trans);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_op_mode_enter);
 
@@ -821,13 +821,13 @@ IWL_EXPORT_SYMBOL(iwl_trans_is_pm_supported);
 
 bool iwl_trans_is_ltr_enabled(struct iwl_trans *trans)
 {
-	return iwl_pcie_gen1_2_is_ltr_enabled(trans);
+	return iwl_pcie_is_ltr_enabled(trans);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_is_ltr_enabled);
 
 int iwl_trans_activate_nic(struct iwl_trans *trans)
 {
-	return iwl_pcie_gen1_2_activate_nic(trans);
+	return iwl_pcie_activate_nic(trans);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_activate_nic);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a117c378b1f1..04a4fa8ddb79 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1188,7 +1188,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -EIO;
 	}
 
-	return iwl_pci_gen1_2_probe(pdev, ent, mac_cfg, hw_base, hw_rev);
+	return _iwl_pci_probe(pdev, ent, mac_cfg, hw_base, hw_rev);
 }
 
 static void iwl_pci_remove(struct pci_dev *pdev)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
index f0e70b0fedfe..ee3825954f65 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
@@ -850,7 +850,7 @@ static inline u16 iwl_txq_gen1_tfd_tb_get_len(struct iwl_trans *trans,
 }
 
 static inline struct iwl_device_tx_cmd *
-iwl_pcie_gen1_2_alloc_tx_cmd(struct iwl_trans *trans)
+iwl_pcie_alloc_tx_cmd(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -858,8 +858,8 @@ iwl_pcie_gen1_2_alloc_tx_cmd(struct iwl_trans *trans)
 }
 
 static inline void
-iwl_pcie_gen1_2_free_tx_cmd(struct iwl_trans *trans,
-			    struct iwl_device_tx_cmd *dev_cmd)
+iwl_pcie_free_tx_cmd(struct iwl_trans *trans,
+		     struct iwl_device_tx_cmd *dev_cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1132,7 +1132,7 @@ static inline void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans) { }
 void iwl_pcie_rx_allocator_work(struct work_struct *data);
 
 /* common trans ops for all generations transports */
-void iwl_pcie_gen1_2_op_mode_enter(struct iwl_trans *trans);
+void iwl_trans_pcie_op_mode_enter(struct iwl_trans *trans);
 int _iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 int iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans);
@@ -1164,10 +1164,9 @@ void iwl_trans_pcie_resched_with_nic_access(struct iwl_trans *trans);
 void __releases(nic_access_nobh)
 iwl_trans_pcie_release_nic_access(struct iwl_trans *trans);
 void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power);
-int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
-			 const struct pci_device_id *ent,
-			 const struct iwl_mac_cfg *mac_cfg,
-			 u8 __iomem *hw_base, u32 hw_rev);
+int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
+		   const struct iwl_mac_cfg *mac_cfg,
+		   u8 __iomem *hw_base, u32 hw_rev);
 void iwl_pcie_gen1_2_remove(struct iwl_trans *trans);
 
 /* transport gen 1 exported functions */
@@ -1193,7 +1192,7 @@ int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
 			   struct iwl_dma_ptr *ptr, size_t size);
 void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr);
 void iwl_pcie_apply_destination(struct iwl_trans *trans);
-int iwl_pcie_gen1_2_activate_nic(struct iwl_trans *trans);
+int iwl_pcie_activate_nic(struct iwl_trans *trans);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
@@ -1223,7 +1222,7 @@ static inline bool iwl_pcie_gen1_is_pm_supported(struct iwl_trans *trans)
 	return trans_pcie->pm_support;
 }
 
-static inline bool iwl_pcie_gen1_2_is_ltr_enabled(struct iwl_trans *trans)
+static inline bool iwl_pcie_is_ltr_enabled(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 71c4746c61a6..0b46431ce68f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -1903,7 +1903,7 @@ void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-void iwl_pcie_gen1_2_op_mode_enter(struct iwl_trans *trans)
+void iwl_trans_pcie_op_mode_enter(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -4076,10 +4076,9 @@ static void iwl_pcie_check_me_status(struct iwl_trans *trans)
 	schedule_delayed_work(&trans_pcie->me_recheck_wk, HZ);
 }
 
-int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
-			 const struct pci_device_id *ent,
-			 const struct iwl_mac_cfg *mac_cfg,
-			 u8 __iomem *hw_base, u32 hw_rev)
+int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
+		   const struct iwl_mac_cfg *mac_cfg,
+		   u8 __iomem *hw_base, u32 hw_rev)
 {
 	const struct iwl_dev_info *dev_info;
 	struct iwl_trans_info info = {
@@ -4240,7 +4239,7 @@ void iwl_pcie_gen1_2_remove(struct iwl_trans *trans)
 	iwl_trans_pcie_free(trans);
 }
 
-int iwl_pcie_gen1_2_activate_nic(struct iwl_trans *trans)
+int iwl_pcie_activate_nic(struct iwl_trans *trans)
 {
 	const struct iwl_mac_cfg *mac_cfg = trans->mac_cfg;
 	u32 poll_ready;
-- 
2.34.1


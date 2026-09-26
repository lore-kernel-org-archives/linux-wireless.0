Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768C346AFD
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442941; cv=none; b=H1KoaOYX50z9xxqOzz4yWUOfECxuIFEiaLXre5id0HF398V8W5DwR8+04fcWRAnOX2IwZx+ax/z7NM3g0LEuW/ueJQV0HKSnDLinXNBFYPFzfuG9uzKbDmQuYONgiFSkdooHLqV8O3NEw4G2wdKPP0uHgphMlvfgqZGW0APED9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442941; c=relaxed/simple;
	bh=Ug1zSfUdgJuUbplJcbwzORFz6KEfP1I9p4SJsDt39zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RFiDy6f9wLZNW2w6TLX9V9Fhl5WXYJGMX4WdsRq2Q6+OvHYS8f20CaOOtmQyLtrxU/5s1pJUNE5/vx5pmKsNDww7juuU1QTSJ2smeapRqSjAdN7n220KcYVrIzAlk9/ynPlMRx6Ix6+PA7Iu4J2RcpVYttEUN1RbGjmmSaENkNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jUzA5DP8; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jUzA5DP8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442940; x=1821978940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ug1zSfUdgJuUbplJcbwzORFz6KEfP1I9p4SJsDt39zc=;
  b=jUzA5DP8bM3rtz/mT7AbPVBWn50u2iNyD9Vaza7+vp5APtuJuP8BahhU
   MUOTuug/vYgDi0pFPbzbqah+mGB9Xw92K3Rvdzhv6fSakcup57n/RZXzU
   uj9pxTYoAeaSRyTP34fsG3pZfFuQDqXQ+qQaeDUB7NmAXanLPHYWBxNuD
   uhfF/FTIhhBW79uKPFEwyROCSd3OSkTvszWMNBMq5XSQvgTuhvl5uBzcO
   Pzw30N5m+JSzUECH0eDqNg44QnRb0YXE4Cz5WvWKH0J3WIqeZJBTzD4hP
   Rm5AhH4kGBMN07i2pQgTfu7aINhrQcPTTA0KM5+W5Myl8c7TK0Kv215IB
   g==;
X-CSE-ConnectionGUID: TBiJKXV1SuqlyCKWYlXJsw==
X-CSE-MsgGUID: SfcZjeq6Q6iQr9IiMD6fWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533275"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533275"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:39 -0700
X-CSE-ConnectionGUID: 0UtdUFh9RDyVrbv7h79fVg==
X-CSE-MsgGUID: yOniBHlcTe+ugXvFpF5a6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196914"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 02/15] wifi: iwlwifi: Revert "wifi: iwlwifi: gen1_2: move gen specific code to a function"
Date: Sat, 26 Sep 2026 20:17:21 +0300
Message-Id: <20260926201527.44edf3234ede.Ic19d96486253518e2107d91e512654596689a426@changeid>
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

This reverts commit df70a9a86eee ("wifi: iwlwifi: gen1_2: move gen
specific code to a function").

The remove flow body was factored out into into a new function to
prepare for a new pcie-transport, which will not happen eventually.
Inline the code back.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |  7 ++++++-
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h |  1 -
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c    | 11 -----------
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 04a4fa8ddb79..4fa514ba9975 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1194,11 +1194,16 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 static void iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (!trans)
 		return;
 
-	iwl_pcie_gen1_2_remove(trans);
+	cancel_delayed_work_sync(&trans_pcie->me_recheck_wk);
+
+	iwl_drv_stop(trans->drv);
+
+	iwl_trans_pcie_free(trans);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
index ee3825954f65..cff02afa4e26 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
@@ -1167,7 +1167,6 @@ void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power);
 int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 		   const struct iwl_mac_cfg *mac_cfg,
 		   u8 __iomem *hw_base, u32 hw_rev);
-void iwl_pcie_gen1_2_remove(struct iwl_trans *trans);
 
 /* transport gen 1 exported functions */
 void iwl_trans_pcie_fw_alive(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 0b46431ce68f..db92c5c954e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4228,17 +4228,6 @@ int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 	return ret;
 }
 
-void iwl_pcie_gen1_2_remove(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	cancel_delayed_work_sync(&trans_pcie->me_recheck_wk);
-
-	iwl_drv_stop(trans->drv);
-
-	iwl_trans_pcie_free(trans);
-}
-
 int iwl_pcie_activate_nic(struct iwl_trans *trans)
 {
 	const struct iwl_mac_cfg *mac_cfg = trans->mac_cfg;
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4244562A1
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246378; cv=none; b=Z7MEJ54W2YAjBNiqp0JjxkIaI+fiiZH4H+mBUg8zyuU8dB+Rm3KlvPBQPVUQh/B8P1oAx66u/CAP5iZKq16XL8ZWSRMf5sKUJqwwaAKvqa8D78O6wpg1HH9rq3wM0a7AkH4RuhNhRAHLwtbb0zIEfQvuIJGcWj6mcA/ivEL7eyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246378; c=relaxed/simple;
	bh=Ug1zSfUdgJuUbplJcbwzORFz6KEfP1I9p4SJsDt39zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qn6rOiYVI/ve6hJ6J9AMufWSQaJXqqtQ4wQIxa3HopxAWYz50uHF3FljHnUEcmuNorxskHEUCUBwQ/RTLFc5annyeLFKHJFodMckqDpImTQQ+JseqNlsw3DgRD2v89r0A96yBM8jClyrrQaGB61R73NyqCHg3rPv+6fIQZ5dx74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CFDCVSq/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CFDCVSq/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246377; x=1821782377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ug1zSfUdgJuUbplJcbwzORFz6KEfP1I9p4SJsDt39zc=;
  b=CFDCVSq/qpZR+aQPYj3SAMhd5FXrtxaCWYc4hh+Q1p/m3R45YsuUWFe4
   LcRac+Mk/DzX8N4RlOTxO36lBuf7QinBOeTEbas9ZEN4JAjtvJtcLHYyH
   8ly6Ibq1UGDdFEe0sr8vzzEMIdDk4byfT8OL1WbUJLLFIrRQs1YpSS7y/
   YQEbybu3mCbkuq9wZOcEFG0221AaGS/Wk1ydKPAULR6ze29dhA3fAcwa+
   cbZdgXWZi9/ckXwmE+tZTfrm+K4gmYG9g8c9txKozM87pZVM/pmDWw7tx
   c6j7Ms2N59SdmfkqP1dXgsEyftaKLybf9fVgvWfx2XOQQjDm7irYr0UOI
   A==;
X-CSE-ConnectionGUID: KqVtZpBBS/CbEf+LuEWQ4w==
X-CSE-MsgGUID: VhWzNhuwRAWjNeNIUivGQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134868"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134868"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:35 -0700
X-CSE-ConnectionGUID: EG8uXUMGQ9iaMKa1XL3yOQ==
X-CSE-MsgGUID: iwUQSR5rSee5T0oGo9DtAw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: Revert "wifi: iwlwifi: gen1_2: move gen specific code to a function"
Date: Thu, 24 Sep 2026 13:41:16 +0300
Message-Id: <20260924133942.b63865fa5317.Ic19d96486253518e2107d91e512654596689a426@changeid>
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


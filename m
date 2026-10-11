Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FCE432313
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716731; cv=none; b=jauHv4qc8y5JGATEn3zSlMAXBmoZjzDA65DOaWjnBy++zVimEEOczApiA4YSQ17P7ZteNEsppZ01cXQoUrfPdWq6SHPD5V5HGQcqBFY2+/i8JTtDI1C7m3WsowIWk/gNSty1yFxcBytfL59NA91EMWhJznziMbJOkNiyuqSk6mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716731; c=relaxed/simple;
	bh=5TKQ6b5le/E1yhgcw+vSGPDQqc1kEbbfIfvfS83HEBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hBhlOe0USIUvLxacp24mCaBfgfGQF+MG67GdnLifcri+jz0Nj4bio317b/e7MLlPBWCZGBeK3zB6n6NhY6NfMnr/zCn7LhcHObTuqxSYtuceLGiK2R+AK1GPI13tRotRL3rHBDCHF50MONWQZnplC5Ze/HJeANzdUso7+k7xfow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgnHciRu; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgnHciRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716730; x=1823252730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5TKQ6b5le/E1yhgcw+vSGPDQqc1kEbbfIfvfS83HEBI=;
  b=cgnHciRuh472Dk+xzKjf+m8nggJeicvEHSXFKhNLgXkGZUI8r6+KZS8v
   MZCvZUm7sE9HM5L0tp2R+TrhF/Q6koPscdM67aIHkC/bYKI9MOgGNNR5b
   71yI7RgfxU7BDMMS4x5cCUycerRP3nfzIW1jV+HT9BByqQp4zXLRNhUju
   f5qMhS1a8A6gRdUi3Hs9BGpQJ3mPBfYxhzsQu1ErOn1/j0y8xuaBRCnW+
   UaKESebglLFgkUS4hL+YfCqQZh0G/zohMjtoeyHL1aDdVZ58hc9P8+yS2
   2bUWBq4/+u9MQUHfz0oJlr5mZKiqzDxwbagoFtCX0K0Y+5dRrTCdv+A5E
   w==;
X-CSE-ConnectionGUID: kVmywvEOQrCWCRnvxjYDAQ==
X-CSE-MsgGUID: JaJ1E7j8Rh2f7QOey8xEAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454179"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454179"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:30 -0700
X-CSE-ConnectionGUID: BJbuGGE8Sz+TqUEQ+/a9Og==
X-CSE-MsgGUID: T2FEM4tjSJW8S4908nkmyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651001"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:28 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 07/13] wifi: iwlwifi: pcie: correctly read WFPM_OTP_CFG1_ADDR
Date: Sun, 11 Oct 2026 14:07:08 +0300
Message-Id: <20261011140453.74912aba718d.I9568d08c280c0ca148c3918439c6beb8c4647a40@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We shouldn't read this without having NIC access, which I
had broken in the past. Enabling clang's context analysis
now surfaced this bug. Luckily, it only applies to blank
OTP devices, which aren't really common/shipping at all.
Keep the value from earlier, and use zero (as in the past
before I broke it) if it can't be read at all.

Fixes: 0b205d0f0f50 ("wifi: iwlwifi: trans: remove hw_wfpm_id")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c905b6d5db3d..bd6e38d5f631 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3995,10 +3995,10 @@ int iwl_trans_pcie_copy_imr(struct iwl_trans *trans,
  * Read rf id and cdb info from prph register and store it
  */
 static void get_crf_id(struct iwl_trans *iwl_trans,
-		       struct iwl_trans_info *info)
+		       struct iwl_trans_info *info,
+		       u32 *hw_wfpm_id)
 {
 	u32 sd_reg_ver_addr;
-	u32 hw_wfpm_id;
 	u32 val = 0;
 	u8 step;
 
@@ -4064,10 +4064,10 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	}
 
 	/* Read cdb info (also contains the jacket info if needed in the future */
-	hw_wfpm_id = iwl_trans_read_umac_prph_no_grab(iwl_trans, WFPM_OTP_CFG1_ADDR);
+	*hw_wfpm_id = iwl_trans_read_umac_prph_no_grab(iwl_trans, WFPM_OTP_CFG1_ADDR);
 
 	IWL_INFO(iwl_trans, "Detected crf-id 0x%x, cnv-id 0x%x wfpm id 0x%x\n",
-		 info->hw_crf_id, info->hw_cnv_id, hw_wfpm_id);
+		 info->hw_crf_id, info->hw_cnv_id, *hw_wfpm_id);
 }
 
 /*
@@ -4075,14 +4075,13 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
  * from the prph registers.
  */
 static int map_crf_id(struct iwl_trans *iwl_trans,
-		      struct iwl_trans_info *info)
+		      struct iwl_trans_info *info,
+		      u32 hw_wfpm_id)
 {
 	int ret = 0;
 	u32 val = info->hw_crf_id;
 	u32 step_id = REG_CRF_ID_STEP(val);
 	u32 slave_id = REG_CRF_ID_SLAVE(val);
-	u32 hw_wfpm_id = iwl_trans_read_umac_prph_no_grab(iwl_trans,
-							  WFPM_OTP_CFG1_ADDR);
 	u32 cdb_id_wfpm = WFPM_OTP_CFG1_IS_CDB(hw_wfpm_id);
 
 	/* Map between crf id to rf id */
@@ -4195,6 +4194,7 @@ int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 	};
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
+	u32 hw_wfpm_id = 0;
 	int ret;
 
 	iwl_trans = iwl_trans_pcie_alloc(pdev, mac_cfg, &info, hw_base);
@@ -4222,7 +4222,7 @@ int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 		if (ret)
 			goto out_free_trans;
 		if (iwl_trans_grab_nic_access(iwl_trans)) {
-			get_crf_id(iwl_trans, &info);
+			get_crf_id(iwl_trans, &info, &hw_wfpm_id);
 			/* all good */
 			iwl_trans_release_nic_access(iwl_trans);
 		} else {
@@ -4239,7 +4239,8 @@ int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 	 * This is relevant only for family 9000 and up.
 	 */
 	if (iwl_trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_9000 &&
-	    !CSR_HW_RFID_TYPE(info.hw_rf_id) && map_crf_id(iwl_trans, &info)) {
+	    !CSR_HW_RFID_TYPE(info.hw_rf_id) &&
+	    map_crf_id(iwl_trans, &info, hw_wfpm_id)) {
 		ret = -EINVAL;
 		goto out_free_trans;
 	}
-- 
2.34.1


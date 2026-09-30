Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9364772B3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759901; cv=none; b=RobQy5qor55iRY2HcMoK0/yNR7crPVQdPn0Dd/0ve2tkNCE8bpvB14uVBQ+bIiqwRGudVYPR1ONY54Yrp9hDNpUP4b6qnITw702dZ6ib5i31qzxDfTEkKZLVbExjiNDJ/edJ44FjooDFuDuIH1ilYEsK45fk0Yq3V1zafkLXXKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759901; c=relaxed/simple;
	bh=RHDFmTkDXaekxJnmJjG0kKhGWCBuzABDOL0Xg+6zCtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T+LOr/SYb1M/WJFObgjwI1SCXeL7tl/YSoHD/yQkY00nc5QYSnjbvaqKHrZw56E+F7ouuYkqGB23r6jI7SL4CNN15LhVMXhoUnWIfW+lEHNA9CHiFm0V96zgyze0vP8RT/LkAQU5pBFPbWuDYizd8cM9w94S3+9Hed7MG1SMP9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QH0TXiLZ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QH0TXiLZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759898; x=1822295898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RHDFmTkDXaekxJnmJjG0kKhGWCBuzABDOL0Xg+6zCtI=;
  b=QH0TXiLZ/CAX3izR9if9TwTl7kL5EKG3cMGfWNnK0wlqL7EKsVYEqaNq
   LggFHTUK50I5Y1kgG8qZ39wh/suz3hoO0Muuf6K8jTVmNUVrEPR8+Nq9S
   k0WRrAUecp0BtW10ob0sIhDg0wNhJ0yvU5conqcgUUP0UcT5hk5i5S0gL
   FOl9Ou0N5f5OfQWkIE0qSfXgzfWIUaLqFXh8VRUIBxfh0U5qtBFvWDQrG
   5heEP81MTfk+uUypbq99vblJFm82wpn0EN2rbF1EpC0xYz++7I/GAOBNo
   SvgrEQeFazjl5E3fhKNoKqoIRWSQ/ydnB/HL5ljnYjinnvHP0fBIHWNst
   Q==;
X-CSE-ConnectionGUID: Bowe6Q52TaGX5y+ngdM9kA==
X-CSE-MsgGUID: NoMQ+0DUS3GzPvmlIdN20g==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447028"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447028"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:17 -0700
X-CSE-ConnectionGUID: cIn7NIFZRjSeeYLEwK4W4g==
X-CSE-MsgGUID: MNmDttVEScmX1dw1B3KcEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673576"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:15 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 12/15] wifi: iwlwifi: call generic trans API and not pcie one
Date: Wed, 30 Sep 2026 12:19:49 +0300
Message-Id: <20260930121740.444e257d5a49.I4c4892ca6bcae0095639341f3c2aba76bcd1ee86@changeid>
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

iwl_trans_pcie_reset is currently called from outside of pcie,
like in mvm opmode. This is wrong and contradicts the architecture.
Add a generic trans API which will call the PCIE implementation.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     | 9 ++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 1 -
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 09e5b606df26..b0eb3deba23d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -261,7 +261,7 @@ static void iwl_trans_restart_wk(struct work_struct *wk)
 		iwl_trans_schedule_reprobe(trans, 0);
 		break;
 	default:
-		iwl_trans_pcie_reset(trans, mode);
+		iwl_trans_reset(trans, mode);
 		break;
 	}
 }
@@ -929,3 +929,10 @@ int iwl_trans_activate_nic(struct iwl_trans *trans)
 }
 IWL_EXPORT_SYMBOL(iwl_trans_activate_nic);
 
+
+void iwl_trans_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
+{
+	iwl_trans_pcie_reset(trans, mode);
+}
+IWL_EXPORT_SYMBOL(iwl_trans_reset);
+
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a32b03f19c3f..719b6c9ba360 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1216,7 +1216,7 @@ enum iwl_reset_mode {
 	IWL_RESET_MODE_BACKOFF,
 };
 
-void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
+void iwl_trans_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
 void iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans);
 
 /* Internal helper */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 9b4637a3d1ef..ae109e3ea141 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -640,8 +640,7 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm)
 		/* if we needed reset then fail here, but notify and remove */
 		if (mvm->fw_product_reset) {
 			iwl_mei_alive_notif(false);
-			iwl_trans_pcie_reset(mvm->trans,
-					     IWL_RESET_MODE_RESCAN);
+			iwl_trans_reset(mvm->trans, IWL_RESET_MODE_RESCAN);
 		}
 
 		goto error;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index e0ac9f2e6526..fab73693e683 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1148,6 +1148,7 @@ int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
 				    void *buf, u32 dwords);
 int iwl_trans_pcie_sw_reset(struct iwl_trans *trans, bool retake_ownership);
+void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
 struct iwl_trans_dump_data *
 iwl_trans_pcie_dump_data(struct iwl_trans *trans, u32 dump_mask,
 			 const struct iwl_dump_sanitize_ops *sanitize_ops,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 8da0cc603070..59e9ef0d6b51 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2329,7 +2329,6 @@ void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
 	pci_dev_get(removal->pdev);
 	schedule_work(&removal->work);
 }
-EXPORT_SYMBOL(iwl_trans_pcie_reset);
 
 /*
  * This version doesn't disable BHs but rather assumes they're
-- 
2.34.1


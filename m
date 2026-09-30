Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C764944C51D
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754906; cv=none; b=b0bX/O/JiONHNWkuO6NclZ8EZtKENi88kfsppGM5XCBWqz0fRsjKlRJASW1IFgU7rrFadixqhXv4e/0Mz9Bf8QqrfNwVrrrukp1MrCeCx80JOJrae+KcZoI9rcm99yjJO4tDHf5LKi4A7Vfah4TexkVZ3GPFiKSA9vKvyc7EACY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754906; c=relaxed/simple;
	bh=RHDFmTkDXaekxJnmJjG0kKhGWCBuzABDOL0Xg+6zCtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tVJJRb8PPYp0X50zWKw/vatzDvug2e1Lm3CC8UtD/C/m4RALC32H0cQMF76xVIc0xviLNG9YJMdCpH1TKFvf4BNa3uPrCd7ugjsCUWo6LxHndQLc/lXmWJpSBmTV3CtOtZLBzAeRTI8VnVGzZZmfSoxFfLImjN42WX42uelueVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VsjQL8Gw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VsjQL8Gw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754905; x=1822290905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RHDFmTkDXaekxJnmJjG0kKhGWCBuzABDOL0Xg+6zCtI=;
  b=VsjQL8Gw+6pKMACF5KHhhPJIOyRjxR61eeDcUvOAANd84T6gKeYsTNNe
   I5k1H1ESoxM7JWWRAniJLr1dY+2HBSsmN4YdK+CShhrdw0IDJqGV+J/6E
   R2xqcytK3ECZuDm8Zy4JdlyzpLUwhhVBQlyBXZuuNd4AOwMKVMWnidgTY
   3snMIR0T4NB+qVpOsU5qs0WmDalZT5iikdFuNXAYuX2a6n2xUvYAM8w2e
   iqlWXx3rRpJb3/IEFoT8GXtDP1IC4NLmrKX/j2iG3EO8hWWN2JVZll92u
   pUwAv/9AevQyvDOxxFFjjRKrZXD2OsNz8orBLQetDXJo2x5vc7aFayfBg
   A==;
X-CSE-ConnectionGUID: FnWS6PtZQP6HesZ/0nVMuQ==
X-CSE-MsgGUID: PAb/56G0TSSaBx0p7fSVbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296832"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296832"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:05 -0700
X-CSE-ConnectionGUID: Ej3cIiL7RUGvyUyDVqF4IA==
X-CSE-MsgGUID: aCpD9azPRL+5U2qkVQMtig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962950"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: call generic trans API and not pcie one
Date: Wed, 30 Sep 2026 10:56:40 +0300
Message-Id: <20260930104825.6599ab856dd7.I4c4892ca6bcae0095639341f3c2aba76bcd1ee86@changeid>
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


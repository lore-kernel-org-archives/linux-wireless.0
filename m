Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A33475332
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246394; cv=none; b=TVr3TaxClBCKoiuHrL6MCmJSIuvQLUqn6fXQsjWX/79VXnaHFOpS8aTCtkWkiNla+z7c184wjR+ETEtMvs+JrAyz8AJYSLvLoxuPe/pIt5QiH7KzYIQCXwlnxmvy8OSskGE19lJLODLCs2tUQ8QMzmkYW3rycC/OB5lHQBV9gCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246394; c=relaxed/simple;
	bh=9sg5NnZkciLVGwwM95zEFBeCZgc/3KfAhuyB45xIjGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gdZSW6wqUdv159cV2wlSBASSNGlu8lMx4gi2tNDofttxkbPm0opiqBgai61YFIxzlzHLzeyyzS9gdcBAyrtNRJ5DtUvAWPJbTm4YbPN4VduS/4kq1emVwtAisqHMSBnliC26kacz7HZK62ww5A8xGCTc5tW5Qjp6iKR6hu0OpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/5vXFkq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/5vXFkq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246392; x=1821782392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9sg5NnZkciLVGwwM95zEFBeCZgc/3KfAhuyB45xIjGA=;
  b=i/5vXFkqHVi+83cfYSERdnnB97QerVBsc4VUypSzzzliTO5dyijWPczB
   i9WWhK3fR19v0qZNHMie9jqXiTV98W03kKNM4aguIhOVyzhBUUiLsnPYS
   K4ODpl/6zhc5dUwkjn2uNd+rP8u0WncVBrqGLIQwtmiNAB7+v2lR29bmN
   Gy4AjGZxgU+jskib4+9uVKspeCQGQ8pvGshLsSi1S20sa1WwQnmGjeUyB
   daTW5FNguZcmatROTRR89SEbZBN8kIeT04LRvxXyoZHzTy0SvhHdrE/Vw
   7LgJeLCd5nXY0btGNnwPDf2nDQCMEswqnueHUmDTzNMJtsvnqeM2pwuSz
   w==;
X-CSE-ConnectionGUID: VHVddh1LRMaAX79TdnDClQ==
X-CSE-MsgGUID: XXmMWy73SQy9w0fK4czvKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134912"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134912"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:52 -0700
X-CSE-ConnectionGUID: nkVJE4VSSdic0HSBRiNEEw==
X-CSE-MsgGUID: Jm6sG1BtRbalJvAPufxCSA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:51 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: drop the orphaned nic_access annotations
Date: Thu, 24 Sep 2026 13:41:28 +0300
Message-Id: <20260924133942.511143ed3e33.Iccecaabe0f37525430377ae1c0db6fd7bbf7625a@changeid>
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

commit 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
deleted the Sparse implementation of the lock annotations.
__acquires()/__releases()/__acquire()/__release() are gone; the macros
now only map onto clang's context analysis and expand to nothing for gcc.

The nic_access annotations describe nothing anymore:
 - Every one of them is a __releases() with no matching __acquires().
   The acquire side was the __cond_lock() wrapper around
   _iwl_trans_grab_nic_access(), which went away together with
   __cond_lock() itself. The names don't even agree - PCIe releases
   nic_access_nobh while the generic wrapper calling it claims
   nic_access.

 - The __acquire()/__release(reg_lock) pairs only existed
   to silence Sparse

Use lockdep_assert_held() instead, which unlike the annotations actually
runs, and add the missing assertion to
iwl_trans_pcie_resched_with_nic_access().

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c |  3 +--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h |  3 +--
 .../net/wireless/intel/iwlwifi/pcie/internal.h |  3 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c    | 18 ++++++------------
 4 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index efe657857772..0a6b7b264aa2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -576,8 +576,7 @@ void iwl_trans_resched_with_nic_access(struct iwl_trans *trans)
 	iwl_trans_pcie_resched_with_nic_access(trans);
 }
 
-void __releases(nic_access)
-iwl_trans_release_nic_access(struct iwl_trans *trans)
+void iwl_trans_release_nic_access(struct iwl_trans *trans)
 {
 	iwl_trans_pcie_release_nic_access(trans);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a7bb6cee8188..56c5e61b614a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -992,8 +992,7 @@ bool iwl_trans_grab_nic_access(struct iwl_trans *trans);
  */
 void iwl_trans_resched_with_nic_access(struct iwl_trans *trans);
 
-void __releases(nic_access)
-iwl_trans_release_nic_access(struct iwl_trans *trans);
+void iwl_trans_release_nic_access(struct iwl_trans *trans);
 
 static inline void iwl_trans_schedule_reset(struct iwl_trans *trans,
 					    enum iwl_fw_error_type type)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index e10aa8e7e061..e6b1cb559a0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1161,8 +1161,7 @@ int iwl_trans_pcie_read_config32(struct iwl_trans *trans, u32 ofs,
 				 u32 *val);
 bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
 void iwl_trans_pcie_resched_with_nic_access(struct iwl_trans *trans);
-void __releases(nic_access_nobh)
-iwl_trans_pcie_release_nic_access(struct iwl_trans *trans);
+void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans);
 void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power);
 int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 		   const struct iwl_mac_cfg *mac_cfg,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 1304d8916424..bda069a6f7eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2402,10 +2402,10 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 
 out:
 	/*
-	 * Fool sparse by faking we release the lock - sparse will
-	 * track nic_access anyway.
+	 * Deliberately return with reg_lock held; the caller must drop it via
+	 * iwl_trans_pcie_release_nic_access(), or explicitly if it wants to
+	 * keep the NIC awake past the critical section (cmd_hold_nic_awake).
 	 */
-	__release(&trans_pcie->reg_lock);
 	return true;
 }
 
@@ -2427,24 +2427,19 @@ void iwl_trans_pcie_resched_with_nic_access(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	lockdep_assert_held(&trans_pcie->reg_lock);
+
 	spin_unlock_bh(&trans_pcie->reg_lock);
 	cond_resched();
 	spin_lock_bh(&trans_pcie->reg_lock);
 }
 
-void __releases(nic_access_nobh)
-iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
+void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	lockdep_assert_held(&trans_pcie->reg_lock);
 
-	/*
-	 * Fool sparse by faking we acquiring the lock - sparse will
-	 * track nic_access anyway.
-	 */
-	__acquire(&trans_pcie->reg_lock);
-
 	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
@@ -2460,7 +2455,6 @@ iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 out:
-	__release(nic_access_nobh);
 	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
-- 
2.34.1


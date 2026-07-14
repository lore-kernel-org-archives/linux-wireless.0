Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46544160F
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037765; cv=none; b=no6KA5Um7PEAJx3mmQUzLAmo33xjx2FwEjIPPiJay/QoslDmFh5TT8DtDVNrI01APOpQAJT7AI0IKVEgKeLxS7bauLJGQkMEtbsDgXfVyWCCNbK/PhjvXZXTJIsW1znna7zLy9+4OstlF1M4IJxPXtAqM9Nqibbhefcl6UXpdbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037765; c=relaxed/simple;
	bh=ssOes/gDOzh4JySWLZ1Me8sXtQsshqtcUsbLBH8XzrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGh6FhZBDBDhfRkbnKQRG4cGKDBB4+QJLkGkk4F5aYEQTJk0fRtx5jmzvizTOFWakkdgosnjTJVE1LT5THtMZ+Kti17siDY+mqmuGq5TXaqkUlE1vqzOkoOE/kUhf523/6IGu9pUaBnGco0kXTJugfiovmnbPUt+SXe3rZ94E3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rn9Q3UPh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rn9Q3UPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037764; x=1815573764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ssOes/gDOzh4JySWLZ1Me8sXtQsshqtcUsbLBH8XzrY=;
  b=Rn9Q3UPhWVU1TYfvsUNXFES0LsQjhKxb/6KgcNMLBj4LArcTZCPo11Cu
   7NzuxXmkWazcYMhNYwIkNROwE5C/VDzsx2d0pbtl0DawVxamLZcW/EC9X
   oXvrwwsNG7PrOxTq4AHuPK+qGPGxIAVi/xdri7lsl0WF4AvvWRB2aVlE7
   IrUILnaNZDJME1IV5BxKp++SY9qQcrA34zo9gsdB0OCzfnuqKvTlX6KMH
   9I0oSY+lblzqvB10IMM/C5jJBXxCyhVexvwO6fnSAfeLSlxJ1BplQVjVK
   /3y+JxEnd77H+aIxPV5JJ/+aD9Q0OpT0j4u2cY+uO3HduBUzu7krpEXx3
   g==;
X-CSE-ConnectionGUID: YrUzl/glToyTcVVe68mnag==
X-CSE-MsgGUID: LILWAvTASrGqm8aWziaCbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84855063"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84855063"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:43 -0700
X-CSE-ConnectionGUID: WHzQsOWTSimAQAc1+CYV3A==
X-CSE-MsgGUID: +P204XImQUmB1VlX9o2GHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="254737841"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:42 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 02/15] wifi: iwlwifi: mvm: remove iwl_mvm_recalc_tcm()
Date: Tue, 14 Jul 2026 17:02:05 +0300
Message-Id: <20260714165826.dd9f49714128.I65fbe6890d67ec424d333c362aa7041a117aed44@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
References: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes@sipsolutions.net>

This function is only called in the worker, so it doesn't
need to exist at all, simply move the code there.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 16 +++++-----------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1b56a2695bde..4420005ef69e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2412,7 +2412,6 @@ bool iwl_mvm_is_vif_assoc(struct iwl_mvm *mvm);
 #define MVM_TCM_PERIOD (HZ * MVM_TCM_PERIOD_MSEC / 1000)
 #define MVM_LL_PERIOD (10 * HZ)
 void iwl_mvm_tcm_work(struct work_struct *work);
-void iwl_mvm_recalc_tcm(struct iwl_mvm *mvm);
 void iwl_mvm_pause_tcm(struct iwl_mvm *mvm, bool with_cancel);
 void iwl_mvm_resume_tcm(struct iwl_mvm *mvm);
 void iwl_mvm_tcm_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 849342c96ae7..7eae10982869 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1055,7 +1055,7 @@ static unsigned long iwl_mvm_calc_tcm_stats(struct iwl_mvm *mvm,
 	/*
 	 * If the current load isn't low we need to force re-evaluation
 	 * in the TCM period, so that we can return to low load if there
-	 * was no traffic at all (and thus iwl_mvm_recalc_tcm didn't get
+	 * was no traffic at all (and thus iwl_mvm_tcm_work() didn't get
 	 * triggered by traffic).
 	 */
 	if (load != IWL_MVM_TRAFFIC_LOW)
@@ -1081,8 +1081,11 @@ static unsigned long iwl_mvm_calc_tcm_stats(struct iwl_mvm *mvm,
 	return 0;
 }
 
-void iwl_mvm_recalc_tcm(struct iwl_mvm *mvm)
+void iwl_mvm_tcm_work(struct work_struct *work)
 {
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct iwl_mvm *mvm = container_of(delayed_work, struct iwl_mvm,
+					   tcm.work);
 	unsigned long ts = jiffies;
 	bool handle_uapsd =
 		time_after(ts, mvm->tcm.uapsd_nonagg_ts +
@@ -1119,15 +1122,6 @@ void iwl_mvm_recalc_tcm(struct iwl_mvm *mvm)
 	iwl_mvm_tcm_results(mvm);
 }
 
-void iwl_mvm_tcm_work(struct work_struct *work)
-{
-	struct delayed_work *delayed_work = to_delayed_work(work);
-	struct iwl_mvm *mvm = container_of(delayed_work, struct iwl_mvm,
-					   tcm.work);
-
-	iwl_mvm_recalc_tcm(mvm);
-}
-
 void iwl_mvm_pause_tcm(struct iwl_mvm *mvm, bool with_cancel)
 {
 	spin_lock_bh(&mvm->tcm.lock);
-- 
2.34.1


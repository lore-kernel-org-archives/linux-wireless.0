Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBFC33A71A
	for <linux-wireless@vger.kernel.org>; Sun, 10 May 2026 20:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778446141; cv=none; b=GwsqsrPRzhHqdFXuzaj3b915PRL4/G9XyABOUq/EojKXun0Y6ToWFUzYM9PddJo4V7aOSv635XtJJq0oF9twjERwseCzrjT1XdwV8PlX8b5jT5+75KlBcItAfJyRY0lTq/8MKKbQaIyLF/TuOnOs8wfgagFBmAI5L2bOxnqoGxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778446141; c=relaxed/simple;
	bh=kHMmKfRD4HV8lJyWPj9M3EOPdlLO6K0ulT7wUr6IV2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=grrnLXFN8vILAAyKZ5ZqN0GwacDSRIP+fwcUhmT1X6UbUF2yhRyh9zhYRhn+6xc+fLNBpfub0vTBKh73UJqS0q93jmyk9suzuh6aRsmm3xx2+YUJOVVr6VsZHBULWSODZYAglnQbk9JE45a3ADAYT9QiI3CYxCIblvS0u+F9kj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JkLCBCsR; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JkLCBCsR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778446139; x=1809982139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kHMmKfRD4HV8lJyWPj9M3EOPdlLO6K0ulT7wUr6IV2Q=;
  b=JkLCBCsR7k6o8MrR2MOF0zw10xCMRfQouDspvO3CFZNZJmzCpKmjSWdE
   TAyDBUaJKeIIam7nVZT73Ory3lqZkGD7KyhDKQ05JPOpIo4bkddxD0cRc
   Wxvo7ptZ2lA6RFAQmtLSNb9+CvJ9LYPp9/v8kurwbO46FtI2b479QRmMe
   eYyP8WVUTtSjKV2Nzv29e7J5dJf6BHYDYQgQxyzTesHKTfkbQPPLwaV0V
   8tYy3uYFgFx8qlYpd3pwH4rJwLMYeRTODfKM1WzaxQwPO0aBLI9L1brg9
   Xk20Q/AlUKPYVZmfoKYxB/oqHZtZxGTn1yHdxBkLN5Y9nE08fDfZA1E9u
   w==;
X-CSE-ConnectionGUID: 6qFQrbsMRD2MWzcoUCLIRA==
X-CSE-MsgGUID: Wgkz/KTBTrC91a/C8wR8tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="81904751"
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="81904751"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 13:48:59 -0700
X-CSE-ConnectionGUID: c14h2K5EQXqe8/nYy/waAA==
X-CSE-MsgGUID: BQaJ2iIDR5CE4exMpBVR1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="239095032"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 13:48:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 03/15] wifi: iwlwifi: mld: disable queue hang detection for NAN data
Date: Sun, 10 May 2026 23:48:28 +0300
Message-Id: <20260510234534.9886987db700.Ifd879478bc30af25de0eada6143dbc3e6a548068@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260510204840.133723-1-miriam.rachel.korenblit@intel.com>
References: <20260510204840.133723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Since peers on NAN data might just use ULW and/or break the
schedule, disable queue hang detection for them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 546d09a38dab..7903ce2b0beb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024 - 2025 Intel Corporation
+ * Copyright (C) 2024 - 2026 Intel Corporation
  */
 #include <net/ip.h>
 
@@ -71,14 +71,19 @@ static int iwl_mld_allocate_txq(struct iwl_mld *mld, struct ieee80211_txq *txq)
 {
 	u8 tid = txq->tid == IEEE80211_NUM_TIDS ? IWL_MGMT_TID : txq->tid;
 	u32 fw_sta_mask = iwl_mld_fw_sta_id_mask(mld, txq->sta);
-	/* We can't know when the station is asleep or awake, so we
-	 * must disable the queue hang detection.
-	 */
-	unsigned int watchdog_timeout = txq->vif->type == NL80211_IFTYPE_AP ?
-				IWL_WATCHDOG_DISABLED :
-				mld->trans->mac_cfg->base->wd_timeout;
+	unsigned int watchdog_timeout;
 	int queue, size;
 
+	switch (txq->vif->type) {
+	case NL80211_IFTYPE_AP:		/* STA might go to PS */
+	case NL80211_IFTYPE_NAN_DATA:	/* peer might ULW/break schedule */
+		watchdog_timeout = IWL_WATCHDOG_DISABLED;
+		break;
+	default:
+		watchdog_timeout = mld->trans->mac_cfg->base->wd_timeout;
+		break;
+	}
+
 	lockdep_assert_wiphy(mld->wiphy);
 
 	if (tid == IWL_MGMT_TID)
-- 
2.34.1


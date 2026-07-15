Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE35400989
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142352; cv=none; b=fcBqbm1PKzaoCcrM2XOcanH6/bTpEJV2tcj1fiY85Hk7kB4XUDvxhfIEPr0pmWSUpaz3Yw+4ng8SSAmvxvd5dk1ufRJYPvzwzNF5Fwz9TT0CpYltywpQP1YzuNNg6Om0KgYMkZJQsxFbsuva5L6Za7bYgAPS/rGujvYdbAn8POQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142352; c=relaxed/simple;
	bh=bN7QwHXfz5m/HGCrdFeEhKWZJAiG1aflht8aOQ7Q7AM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uj1NMnryPKKdGGx8wlzQEUWWd9vXKT1JDLmmopj7a3LZekbpCIsZzul8BNZQevEZHCBuHYdp39EiYgx64/o+ehhHPmhikHwLvHnaGnfTMfQdzwQjWcsYWd0uRWdOZDic+3RM6TtQ13Ex8yaldwZh4P7YJ7KF9VOerhwnDmPW1yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAWKktv/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAWKktv/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142341; x=1815678341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bN7QwHXfz5m/HGCrdFeEhKWZJAiG1aflht8aOQ7Q7AM=;
  b=PAWKktv/C97FCTjs8Q107ercGHfI6n2v2Bsw7FBBpRcCJWIe5vrOOdsy
   KTSxL/2L7YqXTpk3g9XOxwrKyfMCvXulMkreGutjfZtufUOUMCOxbs0Oi
   3CTOtzLP0b0zdySo5m7jjTTMteRa/P7+lNrVkZXgpZvOjW/JMWVe9vG2s
   GO7GgQcUjQX9f65PGtyWZOJB04NN4fF8+if8m2RX9AushtifFZFw7X7FR
   pPjnLdgyMUNGAWhAhABKhe0HFJEGdiM38f6khIZafi3w5QvxecgJoOwrw
   h7QTM2YgFNymrYLgsD7hrR+RK1jHgQRPt/Kwc0uC9ifdCDt3dN9OnQWTy
   Q==;
X-CSE-ConnectionGUID: Z/TYimH6SzOuAwYVZ9EsPA==
X-CSE-MsgGUID: ybonl3vjRgqB2/1Xw9tJUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340743"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340743"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:11 -0700
X-CSE-ConnectionGUID: HtlMCmIHS1669C6YNgY0Ew==
X-CSE-MsgGUID: WjoStA3BSbCkgCbDuqxdLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852049"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:11 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
Date: Wed, 15 Jul 2026 22:04:29 +0300
Message-Id: <20260715220243.60121deecf2c.Iebc891c95a7bd1b2a093b0bb88532db446a758ee@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Make sure we don't end-up with a num_frags = 0 situation.
For that, check that the required size is not 0 and put a checker on
num_frags as well.

Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index d021b24d04d6..8b0f091ff4c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -602,6 +602,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 	    cpu_to_le32(IWL_FW_INI_LOCATION_DRAM_PATH))
 		return 0;
 
+	if (!fw_mon_cfg->req_size)
+		return -EIO;
+
 	num_frags = le32_to_cpu(fw_mon_cfg->max_frags_num);
 	if (fwrt->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
 		if (alloc_id != IWL_FW_INI_ALLOCATION_ID_DBGC1)
@@ -612,6 +615,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 		return -EIO;
 	}
 
+	if (!num_frags)
+		return -EIO;
+
 	remain_pages = DIV_ROUND_UP(le32_to_cpu(fw_mon_cfg->req_size),
 				    PAGE_SIZE);
 	num_frags = min_t(u32, num_frags, BUF_ALLOC_MAX_NUM_FRAGS);
-- 
2.34.1


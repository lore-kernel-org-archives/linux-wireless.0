Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4042D76C
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141889; cv=none; b=WL5y0nSyxXHk+kDs/+ZQoVS+o/6PM0r9hhYJVehvjUFGAimzMm1lQJLzvIJcwysC8E5c91jJ2lQcWAMyH2kFCRv/07fLFcluQR5gIZvowbDMGuSClw66XIBIeCg3LFJ9CR0kXufOkC6V9uUFDZ4r/O3LNJwCrJwvQIG2B+ywDx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141889; c=relaxed/simple;
	bh=U4TTmthro0fIsetoYlZk4kOXlcWPhRl2RjLKvbGG1as=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=inD5DHKJQ0ybCWTG2/ea4OThQwPsTWAPigP5vV24pgug2pqqcwPfPaNc3eKLDbCglzCcYJO7VtNGHV2nosTnipvJI4vX0EL9m2FYbr4Z9tIet5v1qNFGTdXyGXs6Vx0HOFNUkqo54txwvg29ed7hl2LbmDDs8ZZ6XQjeDlcStS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMzolnwQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMzolnwQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141884; x=1815677884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4TTmthro0fIsetoYlZk4kOXlcWPhRl2RjLKvbGG1as=;
  b=mMzolnwQD4Qbv4tg0gt720i9IczYGbWt02TQgyQaW8XukfW+aMCIAQWf
   yTFwuJTDhg7a5fjCTJ2XjPtS4yBKRW3pLht6TV5CS0hlAgkdmuCmfMFJH
   2ZPrMJTcFjWMG/V++s5OGZNiG1hLwseUq0YGOsWGxIeE85jkbqma90aYn
   eAqSww3Ih7U+ivAhcO8+Mc69SGBO9YORI2a7kBQL9vW72OwituEgAyEqv
   zXohv5lVsvUmD2A6SK8UmrVUrKTGqIo05UjTNbOHZVs2O+Uu2oiCAwnLL
   M7SEL1xPy2luCJdQ/Kdf9cRUKCe024BlDmN8+TcyYFym3BKN26c87TQhS
   A==;
X-CSE-ConnectionGUID: RO2bd++JRZCihNJ0aoW1yg==
X-CSE-MsgGUID: FvfnKaQAQ2SDSYuuq2vtCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160915"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160915"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:53 -0700
X-CSE-ConnectionGUID: FTGIDGEzR9mUoHSSdkGMKw==
X-CSE-MsgGUID: kYjOneeJR/aiHYu9FWVbrA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:52 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 10/15] wifi: iwlwifi: pcie: validate FW section counts in iwl_pcie_init_fw_sec
Date: Wed, 15 Jul 2026 21:57:10 +0300
Message-Id: <20260715215523.34db46ca12f3.I1aa225492a62f25293c147aa7293afa80a5d4215@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_pcie_init_fw_sec() iterates over LMAC, UMAC, and paging
firmware sections and writes to ctxt_dram->lmac_img[i],
ctxt_dram->umac_img[i], and ctxt_dram->virtual_img[i] without
first verifying that the counts derived from the firmware image
do not exceed the array size. An oversized firmware image could
cause out-of-bounds writes into the fixed-size context-info DRAM
arrays.

Add explicit WARN_ON checks for all three section counts and
return -EINVAL if any is exceeded.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index d5eb895144ef..7f886200d693 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include "iwl-trans.h"
 #include "iwl-fh.h"
@@ -99,6 +99,11 @@ int iwl_pcie_init_fw_sec(struct iwl_trans *trans,
 	/* add 2 due to separators */
 	paging_cnt = iwl_pcie_get_num_sections(fw, lmac_cnt + umac_cnt + 2);
 
+	if (WARN_ON(lmac_cnt > ARRAY_SIZE(ctxt_dram->lmac_img) ||
+		    umac_cnt > ARRAY_SIZE(ctxt_dram->umac_img) ||
+		    paging_cnt > ARRAY_SIZE(ctxt_dram->virtual_img)))
+		return -EINVAL;
+
 	dram->fw = kzalloc_objs(*dram->fw, umac_cnt + lmac_cnt);
 	if (!dram->fw)
 		return -ENOMEM;
-- 
2.34.1


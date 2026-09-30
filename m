Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F84D4718E9
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760191; cv=none; b=tfVQwNDqR69Cry4vKGK5vo/0IJsP0wsxJf8/uiV7Dw50p69d3uk9WMeUy1ERWXmAX6IUCHshJHgbmDjBTGWpoUAmN+kdjMGU4OLWSH7ObMo1b4lErWQ80LEERUKedZ88vDoEJRiwCLszgTCyXpH2O+0cb7X6ocGjwElVfGERN3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760191; c=relaxed/simple;
	bh=3NjvVFPDjMEIU6wP8x3WVqT0gAfQB54VVu1g6dR7HwM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ps0bLXGtNo236eRGQW3c4oFPOykCs892JAXniR2jNfVjK6Uh8WUVMe+dhrLQLFRQ6nzpzbELQbeyqoXFT2dMJ8Sgim3dN7eScld2YNc1ShqFeSSpyMCvFQFzLjzVE+iMcaZJZqrUdsjzDyPCbaGV5k47WgnZOYq1JGocKHZlyxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vi7sFpeI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vi7sFpeI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790760191; x=1822296191;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3NjvVFPDjMEIU6wP8x3WVqT0gAfQB54VVu1g6dR7HwM=;
  b=Vi7sFpeIwrnosUcuH0u1XD2AENo3g7Ba1s3RXa4p2fVFj9YWIPGDVD1G
   vIz2leh9DlKTKcefRraHbL8h6VBCDW0AESw89xJ62Y5OoQM9Ih+qpg2hL
   6W4N4FXkv01JLPzX5qJGe7BxuQa4x7vybz5rTHJHksBkcVNjTgLp+XLnx
   OR+KXH0/xN+DMWX8xZpVGP4XIePqzi21hgttqOg9IBphSpoyO+TW1RaBR
   b2V/ZT0ulMo9p6AdD93TzugUUcCvOXwP6YH22UC9q9d/C/LLE9x1Kt8Ok
   rJGsu9yY7xnr26M2cKp5y7UMap/wOPtpqWPzxW1J4SEs0Lqz8q7sBw53P
   A==;
X-CSE-ConnectionGUID: OwJY0dQETPaSrM1SxbyEkA==
X-CSE-MsgGUID: kTDPlbb8SYu2rgt7kCj8xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102020371"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102020371"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:10 -0700
X-CSE-ConnectionGUID: VcypHz36Sa2E7FZX5PsJzQ==
X-CSE-MsgGUID: 2ICe1cJJTRmGOzqvwkJuDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275202751"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 1/5] wifi: iwlwifi: mvm: debugfs: avoid zero divisor in RSS writer
Date: Wed, 30 Sep 2026 12:25:03 +0300
Message-Id: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Reject writes that produce nbytes==0 before pattern repetition logic
that divides and mods by nbytes.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index e6b9896dc4ac..ae04f84fe9ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2023, 2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2023, 2025-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1226,6 +1226,9 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	};
 	int ret, i, num_repeats, nbytes = count / 2;
 
+	if (!nbytes || nbytes > sizeof(cmd.indirection_table))
+		return -EINVAL;
+
 	ret = hex2bin(cmd.indirection_table, buf, nbytes);
 	if (ret)
 		return ret;
-- 
2.34.1


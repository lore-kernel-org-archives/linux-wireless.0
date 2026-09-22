Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0F04D4898
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074478; cv=none; b=d4RTPLlKppAyGWP3E1qpqaFodpHy0yWiiw4Ts2TnScEWPPfywyOX+tymq+1ui8VXif5BjJ6FuXpfQVqLobgi0CGeu48rZ0AGBKjL1Jr0kR9wAA1s8apdbowPdLilkf9nWp9ukgeZj6P5XgyJ3Qe1kUpVGZN7YFQBmfxaiqa1zik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074478; c=relaxed/simple;
	bh=cMh85a/tZD0Nmb8osIbV1ZoEGIS7Pp+zjOtD3IYL75o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lyCYABs5Ufyo43bzE1i8tuiSjMzcp2KaSf+LYNG+77B2ssSBi9jXDsVVIc85NDPuPq9b/gI7nCSuo0OkGK7xtC3IEAflErDMc8QaQFh8aqBoNrj+XmHe9IjCgTOWnvRZfYWF/YYewLx3dkRfBqmd63TDPNRtdQRzAFegC9QSRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3JeDXcL; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3JeDXcL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790074470; x=1821610470;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cMh85a/tZD0Nmb8osIbV1ZoEGIS7Pp+zjOtD3IYL75o=;
  b=Q3JeDXcL6gvra6QlD7TLaVCZ/oNJjtE8QSA0CRc+byxz42+e6OrAg/DT
   BUNYbsihtT+Ggf9p3qe73yFRZS+hAOxbbs4dAkc1+5xPDutbLzttYW5Tg
   iQwR8r2Ur0H4JFFCIAppadzVnXJdFJshf6QorSqL/rhqaXjMM8urzM12Y
   pN7yLUxWYIErYxI7fMJUKia6LxzyWf/gfjnoehbCoOHY1HJ6USLx2dxBh
   1nj7r4Kq+m9eZHhQH0NRDY0R5u2Z58hCzoEdx+DgLQ5lotMvgmyRu9WYK
   DSzD2DUqd5L6/YRr7VCi6ywblW7rfwOW/2FIJKLflusyId9CYIzSlgRpF
   A==;
X-CSE-ConnectionGUID: BopbaL8RRIqdDyBXQazk1Q==
X-CSE-MsgGUID: DeAKKl2tR+GUoV/2dRTRRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101327462"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="101327462"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:54:27 -0700
X-CSE-ConnectionGUID: Loxz+gf4SGiEbDB3nfgJJw==
X-CSE-MsgGUID: Um1vPiETSmCVqJ4rSbScbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273250397"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:54:25 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 wireless-next] wifi: cfg80211: use sysfs_emit_at() in addresses_show
Date: Tue, 22 Sep 2026 13:56:19 +0300
Message-Id: <20260922135556.49646df6da77.If5066fce4d8f42221009e77d76c68132e18c6a0d@changeid>
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

This is now the standard way to print data for sysfs read
callbacks.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 3ec25d3f004e..89ca3f080b7c 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -5,7 +5,7 @@
  *
  * Copyright 2005-2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2020-2021, 2023-2024 Intel Corporation
+ * Copyright (C) 2020-2021, 2023-2024, 2026 Intel Corporation
  */
 
 #include <linux/device.h>
@@ -52,16 +52,16 @@ static ssize_t addresses_show(struct device *dev,
 			      char *buf)
 {
 	struct wiphy *wiphy = &dev_to_rdev(dev)->wiphy;
-	char *start = buf;
-	int i;
+	int i, len = 0;
 
 	if (!wiphy->addresses)
-		return sprintf(buf, "%pM\n", wiphy->perm_addr);
+		return sysfs_emit(buf, "%pM\n", wiphy->perm_addr);
 
 	for (i = 0; i < wiphy->n_addresses; i++)
-		buf += sprintf(buf, "%pM\n", wiphy->addresses[i].addr);
+		len += sysfs_emit_at(buf, len, "%pM\n",
+				     wiphy->addresses[i].addr);
 
-	return buf - start;
+	return len;
 }
 static DEVICE_ATTR_RO(addresses);
 
-- 
2.34.1


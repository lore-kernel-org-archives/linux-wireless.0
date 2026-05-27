Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AA33B6C0B
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 20:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779912344; cv=none; b=Hg4AQ/KbBVw5P+K5TWeruEbEU1cCEaAnghZKlFjZhZh6m4DYvGVBW2uTzx7aPyP2XAb/617nYV2X2ga4SWWEy+QI8cIzuW41LYH4H0hpEz47IMY02kaqW7j2yKvnyoXp9sIT8rvgWs9mmWQu3qchMChSLCivN/GAoCpmonlItgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779912344; c=relaxed/simple;
	bh=Zw7EpVjPLprnj5JvBrWPQi7GT0TBzyiA+XBHg/B/aJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H9RbovhUJwQwKknPshsyzHKwvltgnWerax5Kv+dEO+Ar/sdCk0QOk857lA9bU99uBcmspK7oYa9qEAgcKBrnHt4uyJiWX7mDL++HKZxk9jvgPD7fU3SEPvq6N9oExeO/YdZzrL+hXivwM9t19VXZWJ9Eb2ffTR3uv1Qc1YxWShQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i6rlN0wh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i6rlN0wh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779912343; x=1811448343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zw7EpVjPLprnj5JvBrWPQi7GT0TBzyiA+XBHg/B/aJY=;
  b=i6rlN0wha1aXLhp9+GrCcctU+kZEdJX53vX36EY1Hlf/IEUBkTrvETzF
   pGV4yv8mb7409Rxhd9IhRlws0wK07Yc6xJgFKzBiV1qJgtLRa3SLpH47H
   doNuSi+Q3r/BHVW5tt8r3ntP5flgsl1ggz01d1yANaNndMPu1oNsxedBW
   BCjj+i28No+zu8tmuoqLD1W0Q90G2BYzGf51VeRIh9g6uOCfPVC1LdRgc
   RND6BJl1AHswC65wukrMrR0fdG6xYqwOv4auvuHGI3J/fxNYJwOJWYyxd
   SdUGBLofua8tqw51bMdA82zIeaK4WXiDo+MDiXFGYylmRORTlJKHBLaXu
   Q==;
X-CSE-ConnectionGUID: WeT6HdBcQYGcpMPrFpf9SA==
X-CSE-MsgGUID: CHqX2V0ZSiKZHp2gkC0WRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80940874"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80940874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:41 -0700
X-CSE-ConnectionGUID: +yoyyV8VSGSlu25eBtQDWw==
X-CSE-MsgGUID: 8MyDBNbFR6+hBrKa76ouTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247286976"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: mld: set fast-balance scan for active EMLSR
Date: Wed, 27 May 2026 23:05:07 +0300
Message-Id: <20260527230313.32d278842b0e.Ia3d73e4085eefc4d3921e93de4107b2d6a6f922e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
References: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

While associated to MLD AP with active EMLSR, set all scan
operations as fast-balance scans. The only exception is when a
fragmented scan is planned (high traffic or low latency), in
which case the fragmented scan is preserved.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index b3836423e53e..d80a1cfc2ed5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #include <linux/crc32.h>
 
@@ -237,6 +237,12 @@ iwl_mld_scan_type iwl_mld_get_scan_type(struct iwl_mld *mld,
 	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		return IWL_SCAN_TYPE_FRAGMENTED;
 
+	/* While associated to MLD AP with active EMLSR, set all scan
+	 * operations as fast-balance scans.
+	 */
+	if (iwl_mld_emlsr_active(vif))
+		return IWL_SCAN_TYPE_FAST_BALANCE;
+
 	/* In case of DCM with P2P GO set all scan requests as
 	 * fast-balance scan
 	 */
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A8D522683
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168604; cv=none; b=bKAV4e8c4jKnUjgzbf92uQQZpChCCF2tnxqID/hYC+xahHlt9m2Ra2dNcjJKyrXYX2yHJrlqL8gwG1dsUQg7dJT+fNooUezW0w+glj+7HMd4CHL7UHScd+W3ePRi4i1mqBksqvdTIdhfOJQES4I49a4pOXS9uuIz8rf7dcpGRuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168604; c=relaxed/simple;
	bh=6L68RnN3XiqJqYD2aTJlMcwJqdy62BF+qWQAWygx/cE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oD+Mqg+paIUv+tTE3zypPmY/YxnxnznAXsblenXH/VYP9ekwxOohCLqMDn//eJISyfAtgcaf7IrdyB6KUAxfFLT9wS87Op1EB7cRIt/kh+fV27TXwMrCxNjbK2UrPDJ7mXf2EQ7kNO3hvsPo/aopzldef4hhQa91bZz0JntfHnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JtoUNr4E; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JtoUNr4E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168603; x=1821704603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6L68RnN3XiqJqYD2aTJlMcwJqdy62BF+qWQAWygx/cE=;
  b=JtoUNr4ED2Q7vH92om3UDXCC29xbln+QKyaS50v2v0TWm+Na9kTJpg5j
   SsAlHKbUs2ZI7wIZ5dd5efiYoITSxKdf5j5vfYw1OgDlC4bAMqBxFOsUQ
   HO7VRrdy0YA2iFPqi4q611wyTQWnh+sOHnb76bKbopqMWbmDoVfhykdvq
   f3HXseBQ1ldMyyLYfh+OddattO487Q817zOjRShpR5AQLauQoUp79D8HQ
   cp6P3iWVuVOQUThkKqCRthIq2c4Hm6HDn5F60n3AH6r0sXu+Qhxp172kK
   KehC1qmuPoBP666LhDG9Sr735FbR/Z4299nrXp2UM+d3NEDVsAuTeB6Ex
   A==;
X-CSE-ConnectionGUID: iahr7smDTPet1OTN9g7GOw==
X-CSE-MsgGUID: AOVKoHiWQP61l37XHnlBOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781360"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781360"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:19 -0700
X-CSE-ConnectionGUID: ZyLjnPgXTTuX+uD9+vxkxQ==
X-CSE-MsgGUID: SoBXcI6XT96Sn3IRNFc8XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697109"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:19 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: mvm: validate BAID from FW
Date: Wed, 23 Sep 2026 16:04:57 +0300
Message-Id: <20260923160318.22624c6dfa10.I9a99a140ab72cb1790a03a130ae7c8aa93cfac01@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The BAID from the ADD_STA response is used to access mvm->baid_map[]
without an upper bound check.
Check and reject an invalid value.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 2d0811be7346..a66128a62546 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2015, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2015, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -2792,7 +2792,11 @@ static int iwl_mvm_fw_baid_op_sta(struct iwl_mvm *mvm,
 		if (WARN_ON(start && iwl_mvm_has_new_rx_api(mvm) &&
 			    !(status & IWL_ADD_STA_BAID_VALID_MASK)))
 			return -EINVAL;
-		return u32_get_bits(status, IWL_ADD_STA_BAID_MASK);
+		ret = u32_get_bits(status, IWL_ADD_STA_BAID_MASK);
+		if (IWL_FW_CHECK(mvm, start && ret >= ARRAY_SIZE(mvm->baid_map),
+				 "invalid BAID %d from FW\n", ret))
+			return -EINVAL;
+		return ret;
 	case ADD_STA_IMMEDIATE_BA_FAILURE:
 		IWL_WARN(mvm, "RX BA Session refused by fw\n");
 		return -ENOSPC;
-- 
2.34.1


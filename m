Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A603630AE
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028028; cv=none; b=Zk/ooqqHeV0L+UyJW0XJbpOUX0yHPpy3TWsEPZWKe2LPMZK360c7ywwdm6QCmGdtx212ZYPRMFa9JGNifoGpr/G6MRaFSydt/qwNoVoneAPcFSeVF7X5KbLyilAPiUhvjYhmekQiL+A8Un40K5JtKHiabBA8XfyASolc/cEFG54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028028; c=relaxed/simple;
	bh=YBFVZkqnp6Fik8amhU3+Cc7FhBzgGruU8exu13z9KO8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UbOGu198AU9iG+bIf/06OUz/Sd9isESdWnO4wNo1H47NQOcSooxDIiRmJBP0lg4Nfg2Rb3w3TIXHv+hSmtnS1GArZ3Vgp24rzssjAgLwid+rp/nfLVy/IoMrlL0J4Eucs9WTILWsocThc2Y7u6bSdN7Y+OBxF8bocrvkTiO9SBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CxNWev9x; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CxNWev9x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028026; x=1815564026;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YBFVZkqnp6Fik8amhU3+Cc7FhBzgGruU8exu13z9KO8=;
  b=CxNWev9xqes6U05N+cKKNeO947K2w9rsUADe6q6WWzw/IVnEXl+4Eb8A
   RyD7IsCoiVE+65S47bloWLx74oWCWB6XQF7mXf3y+Gr+1EaqP7QseQGWw
   QfQxIfblAUYUvkjBACjNjpJPgiqcMln3n5vYmhaRF5YynP7PxW87Rwuhz
   rnVm0J1EwOXqkbRpDGPn1a+wxxG4W/1aABxf8QAu7TSyTET+9Fd48NALO
   arxMk4TlboSGmUl7buyyCnKRR4sfXVQbms/ElGhlEjaA58AbWvLyDWfV5
   zHLDvLz/QyC69JiceF3oiL+fS7WzwlcgLbXTIr+5p/mg1wNxsTqAb+cek
   w==;
X-CSE-ConnectionGUID: q8FPy+ljQkKzqOrCPoICRQ==
X-CSE-MsgGUID: 0LEUAEXnSY+Cirx2bGq7YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200291"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200291"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:25 -0700
X-CSE-ConnectionGUID: QltVVsRCSBmHA78oPYgG8Q==
X-CSE-MsgGUID: VsBFfRGPQpG2vEJhSSFJIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250143"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:24 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-fixes 01/15] wifi: iwlwifi: mvm: verify scan id reported by firmware
Date: Tue, 14 Jul 2026 14:19:50 +0300
Message-Id: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

The scan id reported by firmware in scan complete notification is
used as an index to the scan status array. Verify the reported id
does not exceed the array size.

Fixes: 8d14ccd878e5 ("iwlwifi: mvm: make UMAC scans use the stopping scan status")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 79829f775c89..42f9d9a713b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -3217,6 +3217,10 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 
 	mvm->mei_scan_filter.is_mei_limited_scan = false;
 
+	if (IWL_FW_CHECK(mvm, uid >= ARRAY_SIZE(mvm->scan_uid_status),
+			 "FW reports out-of-range scan UID %d\n", uid))
+		return;
+
 	IWL_DEBUG_SCAN(mvm,
 		       "Scan completed: uid=%u type=%u, status=%s, EBS=%s\n",
 		       uid, mvm->scan_uid_status[uid],
-- 
2.34.1


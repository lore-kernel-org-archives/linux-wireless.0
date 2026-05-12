Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1DD3672A7
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614498; cv=none; b=BBvXNsW0yYQvADQVEjAoBMQQEdaOinRAg+ZesvpMaSiGwcA9MpvHezPj5zhhNX1TyXDAAXTJIOWEvFF/e8SBb1rC1vlTgXu2FPMWd/wLwmJyUUI5bfuCWVJzovo6zrmVQtKTkmeo0EEjIiF8tz2fsjYFd8STD0Zj0xHiSRD/nmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614498; c=relaxed/simple;
	bh=Qdpx4SvoNwWdtlBeOdZt3Rw0r8ABHLi5UWrdBLUVjV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jAqtoK3rMD8l+/OE654DdiRo8uxrXumsMKznqoVFVxJ/7ark6XPt/mZaxkTD6yhPy16Fe7t9RC3YMHFnWHiJhXc+ozjtJCe1ObD5tz/tLsqJB7/23l6kgqQ1bl5AUDmOyph+3lJntS4oIold7NF/MHsDxcluqFEIZAX+8eh6mrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FuMPySi7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FuMPySi7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778614497; x=1810150497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qdpx4SvoNwWdtlBeOdZt3Rw0r8ABHLi5UWrdBLUVjV4=;
  b=FuMPySi7kXddgZhvRXdD7KnEjafXglUqW22Q57P3V8dmAXiGiuD2jA+8
   pck7VT+aY8W6JHYWnK8Vh7cnzEB6YBoo98epY3FQC6VSMo9KJYUrjjIXt
   jG1LLUypBjk3fMzeKa4Hw3l8T+I28hlVJ/7kQaRNGVOnaYFygps+muNjH
   z26mSF0CweUn/sCF8T4/++KNIQAcE0nk+uytYOc3lip1JzRCbBE1V8KLw
   6FlKtuX5pwRJ2kKCVNL8W1T3GBh4Hu4MWfdYKbx+JhDjECAX5ymjWYKwu
   v8fv8MHXXaqk6rQiPMoaadRS8BFjFspxJStuRClVgo0ZXGEWHNjEcC/LL
   g==;
X-CSE-ConnectionGUID: 4e3MGHpnQ16ob4eT0+gGmQ==
X-CSE-MsgGUID: O1HJkh8ATIS52dnUWphxtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83148768"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83148768"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:34:57 -0700
X-CSE-ConnectionGUID: hSLT+nclTvWveKPFY4W7Pg==
X-CSE-MsgGUID: KqdsS75zQrCNVf06pXVrqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="231471678"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:34:55 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: tighten flags in debugfs command sending
Date: Tue, 12 May 2026 22:34:28 +0300
Message-Id: <20260512222731.71b8cda9c4e8.I0cccfd67675989b48d003833f5813c8fbded45a6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
References: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The only flags that could reasonably be used here are
CMD_WANT_SKB and CMD_ASYNC, CMD_SEND_IN_RFKILL doesn't
really make sense and CMD_BLOCK_TXQS just triggers a
warning, as does CMD_WANT_SKB | CMD_ASYNC.

Clear CMD_WANT_SKB since the response SKB isn't used
anyway, and refuse flags other than CMD_ASYNC to avoid
the warnings or other issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index ddee7c2deb36..f06978d5b5ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -275,16 +275,19 @@ static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
 		goto out;
 	}
 
+	/* ignore this flag, we cannot use the response */
+	hcmd.flags &= ~CMD_WANT_SKB;
+	/* reject flags other than async, they cannot be used this way */
+	if (hcmd.flags & ~CMD_ASYNC) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (fwrt->ops && fwrt->ops->send_hcmd)
 		ret = fwrt->ops->send_hcmd(fwrt->ops_ctx, &hcmd);
 	else
 		ret = -EPERM;
 
-	if (ret < 0)
-		goto out;
-
-	if (hcmd.flags & CMD_WANT_SKB)
-		iwl_free_resp(&hcmd);
 out:
 	kfree(data);
 	return ret ?: count;
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9151B417D81
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141890; cv=none; b=J+IOLhxA6i/l04smNQEPwgOShOPXz/oHvwX753WlMfkb0TLmAdzyPIrUSqQ6e+4wqhhNg6K94+a6fGqYsVT3/7UtpL6R/v/GZ6iBnadSPvEOlTcS32/47ckrac0XqOFezpwJOh/UBWjr8HbutkVBc1O5b0cwactWFXeqIuiW0zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141890; c=relaxed/simple;
	bh=qDZNihaZxUEaDPTDFpeVgXtqevJevwf2/7dVOlusKio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZkYPUWEq5rNN0rL1oK5QNlfEnCIe2SOJ0oCZBrYJjTPNtEsCj9U2WZBaEk3n7nRVFlY4dB3R4sg5BcOkwk5wPhpUtGbmu/Euftv0AyUmIg1u8Q/eFvHmyUDBCYZvjAJKMYS6d4CuRCnWH/7JF1uSoT+mo2y7kedtYRZBu+besc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+1/nMpT; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+1/nMpT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141883; x=1815677883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qDZNihaZxUEaDPTDFpeVgXtqevJevwf2/7dVOlusKio=;
  b=S+1/nMpTwWu1ePlcqweuNg+0JWHj5RIdV7KLP9l9DLQ+qsPiNzhcncRh
   wKQPr0h15E3kxmnyegc1auj0r9kjtBwe6z3A5rZ45DQd+9A2/JdPG4Qo6
   ijp/SbqoOHQBrPbuO5wqZxK/E5WzXXKij4IOmLJdfEHdYL4gPAFfd1slM
   CuYeORnASNDtMjI7lnHApd1J0d3x2RrjQ42kaYBBeRY99HHw3gRz3iolX
   nyCJlAL8egODniCgtZhcOevEptsuU1n/O3N5AK0YcdUQbM+Sm0E9cJfjt
   FtM32ViIK/1e7M/wH2wU5QTGywp321YwK8WP9az/aD+wXjoJjkGJ+phU2
   g==;
X-CSE-ConnectionGUID: SNOsbB4FRtiHG82niGR+4A==
X-CSE-MsgGUID: BYEu4QYtRDqIxXAv/dgCpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160912"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160912"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:51 -0700
X-CSE-ConnectionGUID: dY0A4gmTSbSQifM5lp5udQ==
X-CSE-MsgGUID: RswX63sBQySDSwrKzKElsQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:50 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 09/15] wifi: iwlwifi: mvm: ptp: free response on success path
Date: Wed, 15 Jul 2026 21:57:09 +0300
Message-Id: <20260715215523.31b38bef398b.Ib6a5a8bdd800779c8911da6859fd450d3d19c9e9@changeid>
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

Release CMD_WANT_SKB response buffer after successful timestamp parsing
to avoid leaking response allocations.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index f39eb48864eb..49dcb1388007 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2021 - 2023, 2025 Intel Corporation
+ * Copyright (C) 2021 - 2023, 2025-2026 Intel Corporation
  */
 
 #include "mvm.h"
@@ -121,6 +121,8 @@ iwl_mvm_get_crosstimestamp_fw(struct iwl_mvm *mvm, u32 *gp2, u64 *sys_time)
 	*sys_time = (u64)le32_to_cpu(resp->platform_timestamp_hi) << 32 |
 		le32_to_cpu(resp->platform_timestamp_lo);
 
+	iwl_free_resp(&cmd);
+
 	return ret;
 }
 
-- 
2.34.1


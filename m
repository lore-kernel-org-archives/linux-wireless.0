Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E156E511E90
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860734; cv=none; b=dA5wc4FW7CFzPSIixgEb1mKjoI/krYwd0VLtD7KSyY8gMfM+KiYpZxgyOFlBPfEEioWjVp9C9MTOW6sWU5HfIoA95axAOP/Zc1ZXvmp20jwxx0MNIOqa5xO4GF28KJC5PhOjdFgxo1w+z+BYoppbTsX25HeRsyOJ69R+mToFSHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860734; c=relaxed/simple;
	bh=kGCczUXyFZEsUWy0ZnXv1rdTQe046OXoBZrGL2H6nlA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Atpe9SG5vBPvh1ynBQjCKDqTyIw3CkyB7p8KiUWNs/njLuPJ2fzfyQuVrVKUZTKHDZ4IaeU17HU/tG6iDUn/IiIy5zm0/+VQlLVfLWRb5lE763NlfSOaQel43U1+/6RdijDq5d6rGKq8FR+I9Pnc69KIV9IG765qLXH7ID/Ebko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WuK/3xkc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WuK/3xkc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860733; x=1822396733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kGCczUXyFZEsUWy0ZnXv1rdTQe046OXoBZrGL2H6nlA=;
  b=WuK/3xkcJDG8IgYMY97h/bcFAdRGPMn3afsyx4I3T85qp4Mhi2umsaxy
   kplC8fjy218w+NgdsT79wetVo3p4sc87zqjCtybSCQieHN0HfrIMNRhC2
   pMhX490iL6fuhaQpGQWetjVMVl0tluVXYb5Gm72H4MuzQAa0tq/rskr63
   Qz2yBvpA4aFwdL4iKL8+89P/nSxLMygmR+mdgFb+Yj+B18vhvs3G4C1OU
   MYNO+qd1QQGXHqpnJSwRIWEDicKqXhSBxzUSnYo1aRgAhVVa3dgvTFAl7
   bcqsm/Wn+Sb5oq3sr7XGPUfw0T4zbc9J265RU0DQWY02lcjdMUyOezgYQ
   A==;
X-CSE-ConnectionGUID: P4tfMxQIT6O8Wz5icb6Z+Q==
X-CSE-MsgGUID: +OOT4co+TsOU1/v1UG5ppg==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423644"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423644"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:52 -0700
X-CSE-ConnectionGUID: 5KD20alIRpC/iOggQBqHzQ==
X-CSE-MsgGUID: Za1WoqjtRUihNkXyB0N5uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485571"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:52 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: dbg: validate the index before accessing an array
Date: Thu,  1 Oct 2026 16:20:28 +0300
Message-Id: <20261001161715.dd857cfe0d6b.I8162af7b34d03b1b30be5914cde6248ad84b6a9f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If the worker index is bad, then the pointer to the containing
array cannot be determined. Avoid it, and just make it a WARN_ONCE()
since it should never happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 1d34ad59bb71..e29c58575859 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2304,8 +2304,13 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 {
 	struct iwl_fwrt_wk_data *wks =
 		container_of(work, typeof(*wks), wk.work);
-	struct iwl_fw_runtime *fwrt =
-		container_of(wks, typeof(*fwrt), dump.wks[wks->idx]);
+	struct iwl_fw_runtime *fwrt;
+
+	if (WARN_ONCE(wks->idx >= IWL_FW_RUNTIME_DUMP_WK_NUM,
+		      "invalid worker index %d\n", wks->idx))
+		return;
+
+	fwrt = container_of(wks, typeof(*fwrt), dump.wks[wks->idx]);
 
 	/* assumes the op mode mutex is locked in dump_start since
 	 * iwl_fw_dbg_collect_sync can't run in parallel
-- 
2.34.1


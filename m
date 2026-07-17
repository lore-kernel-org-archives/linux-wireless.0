Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434793B813D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298700; cv=none; b=bCOblzNSh+9ZxqzO6bOjFN9VXaBtGUe+sGg3hsTIdXkiOVjIp5hCApTStwOmYNmHNE7N2hWCVnAp8G4fyWI9Yn7UpWYr6Z2WOOVRcMT9gh7xlKiOBpO7mruOsbZCIfh9HMi8jd0tiif6kRQMx0k0ID4lOLMuhcyvlJcqS+zc2Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298700; c=relaxed/simple;
	bh=PTyBQew3RmQk8U/SzFBnqsxVJGMwL0s0+AC+zSa0lGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLH07rbrCZBq1bhkx1d6Kv0GP8wH3eABTz+JGu8yI+vzDJmBtxCcQaWb4rYTaad/yqCajXYRxJikEAK6NxG4RXQZgShVZ3WBfywjvIxD/5jTPyahHMhAxEmCHtdlYqCXvFZ1YTbNuw8BBN3f27tWMW6IGp9pyDsAs0zn8mN7yg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zmr+U+vT; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zmr+U+vT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298698; x=1815834698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PTyBQew3RmQk8U/SzFBnqsxVJGMwL0s0+AC+zSa0lGg=;
  b=Zmr+U+vTTSwfSU94a0ghSOPZrbtEjvHJBd6NZUAZawCimEsdelt0n4ez
   ZKcUDm7lIgWigr+Y9Lv858QVMzXCZkQH8+ZhQbd+91e8PzyZ27FcGMe67
   quK4O0YXUvgqwyd8943O8dKTnit+yxUkE2lOco1bpLuhNBiBDOPe+DhwX
   TIvqHJYV6P8G8VDq6G04ohzrA7tHDEoS3iBfiwhimt8u05XrAkiffzkG9
   Mpl7pkSKAZxkotgODlk7w82hfJfrmpfmM09iGW3UX6LmW4C+FjagCo24X
   1FCX7GCBhRIaC0NQBDAfZfLiR8HRXz6T52Y9km1VHNmg760mAwdKrSmkm
   Q==;
X-CSE-ConnectionGUID: MacUZsBVQEqqTpHUSV8x7w==
X-CSE-MsgGUID: 8jAmuYkgSEeDjq9EZ80GDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925979"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925979"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:38 -0700
X-CSE-ConnectionGUID: NuLgmWPGQka9P88hkXXR+w==
X-CSE-MsgGUID: tRsIhVC1Rd6XSbgncRfF3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885724"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 2/8] wifi: iwlwifi: mld: initialize scan-abort status
Date: Fri, 17 Jul 2026 17:31:06 +0300
Message-Id: <20260717172958.9d804f466534.I4e10270bd1dde4a80940a47ef5d383729cc66cb1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Initialize abort status before issuing the abort command so debug
logging never reads an uninitialized value on error paths.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index d80a1cfc2ed5..0faca402bc14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -1681,7 +1681,8 @@ iwl_mld_scan_send_abort_cmd_status(struct iwl_mld *mld, int uid, u32 *status)
 static int
 iwl_mld_scan_abort(struct iwl_mld *mld, int type, int uid, bool *wait)
 {
-	enum iwl_umac_scan_abort_status status;
+	enum iwl_umac_scan_abort_status status =
+		IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND;
 	int ret;
 
 	*wait = true;
-- 
2.34.1


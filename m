Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15C53D0A4
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077709; cv=none; b=LSVyzOMR0qAAqs9ogcXo4un2iO5akkL3DqRaUAMsoGqkkmMORWmFQp0KsyyeB953PUaGx2k/Hw40yCYF36X62/q3K+lJ7bITrdijFwFHy9JzHdw7Pj/9+Kf3xa2+Lvs9czmIpcVXzGAeMAJOO3k01HOVsXSrZw+0QNyFtKbSNxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077709; c=relaxed/simple;
	bh=TidY16EnKC5A6AoKnBPReeJ45K5zVvvdgWmyljFkCVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QsJNQ35jH5r8RYEBbZ1Z7WnIJb+BtSvXz7qEFeztOyC68O+S25h8Rd8IM0ezQz0WgpOBimnedyM6j5q2KDZmv0iokSnGEBWkpbTUlLdvxoGwXSLkXDTeuGbVuwDH1ThmxFz7SPZyDjYGEUlkhz36niqHxWPWQceACy+TNMD67JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bB6JXqXl; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bB6JXqXl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077706; x=1821613706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TidY16EnKC5A6AoKnBPReeJ45K5zVvvdgWmyljFkCVs=;
  b=bB6JXqXlc3+Q079F++HNkp7W+Rq0/ly7MBz8JGJPutkknD/DlV2TG2dE
   JiJ6+Yv6IrP95JGdplzoN6pHk/iY9L9/TosmsBp1bdnmRZRpWmxlXEPwv
   rJA4uvPvYnFZYXviCFPzpKhvq0cqvYlEMNpO+84BObwsKqaXZxI6LT8Ay
   qHN34Andu1sSNjLaCumMQFGaOpQChI8orREX1Slfjilp1sN6BKBj49Cp0
   4Pzh4vh3PqGXp6Lo0+9ThgLEuEXtBAqMB+BaXIij9ZINAjCdQItC2athS
   B4Snb7h+Bq1p9ECsNJAKq/LKTrfA48wbCWkXlvKSOXtAOPyIPYyvCCO/C
   Q==;
X-CSE-ConnectionGUID: eYBXKmMpSROgJ0IJFyI6rA==
X-CSE-MsgGUID: uETYiI3YSse+jiPAe68gnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170553"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170553"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:21 -0700
X-CSE-ConnectionGUID: b13wdXahTkGbdR+rc/giIQ==
X-CSE-MsgGUID: FiHD2DqvTPqcmOZMZ6zRiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275421"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: mld: avoid leaking error recovery buffer
Date: Tue, 22 Sep 2026 14:49:59 +0300
Message-Id: <20260922144819.36e637b8162a.Ida6e834d7f5d1e69d46c47e2e46db1e87a57ac71@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

If we allocated a recovery buffer, but didn't eventually send the
recovery command (for example because we failed to load the FW),
We won't free the buffer until the module is unloaded.
If in between another FW error occured, we will override the pointer
with a new allocated buffer without freeing the previous one.

Fix this by freeing a previous buffer before allocating a new one.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 6e991fb99ff3..b7b1e3686336 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -621,6 +621,13 @@ static void iwl_mld_read_error_recovery_buffer(struct iwl_mld *mld)
 	if (!src_size)
 		return;
 
+	/*
+	 * If we have a the recovery buffer from a previous (failing) recovery -
+	 * free it here
+	 */
+	kfree(mld->error_recovery_buf);
+	mld->error_recovery_buf = NULL;
+
 	recovery_buf = kzalloc(src_size, GFP_ATOMIC);
 	if (!recovery_buf)
 		return;
-- 
2.34.1


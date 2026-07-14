Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C668270552
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028792; cv=none; b=uYoVTQW5aDs2M7ZRo9pGrtclCHknRmQ6LkFjbG5rerWI6bZSUVqLKwYVwE0c96fW/hjsoZ0fUo1Jra2Q5DGsmYp+ptEDGmFh4roTxQsttK3BOtZxIKvR0bOjmarEMWuq1G2SDWFQuOj7krxSlm06MA90aWlaVFRIt72h6TI3C3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028792; c=relaxed/simple;
	bh=S9V2CGgXTfY9sZnVk5ism3Adjgx7xGDoqZ/ZT7D46C8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwSN09JWR9TOpsByv2LOf4sLSXnHUqD+UTMDDrHcfSB/u8ur3scA+Rk/eUmHPP3q8AvzvxKTrlMEWg5BzgwQ9k2lCMimFDhYn1Yf748MeAQS0CgmUDPH1bXHIgFsK45ttjbYJy9GslxcdB4Won9qvvBgFgN3YqrVADtBxEtM1cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g6c3mrtV; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g6c3mrtV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028791; x=1815564791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S9V2CGgXTfY9sZnVk5ism3Adjgx7xGDoqZ/ZT7D46C8=;
  b=g6c3mrtVW5SDS7DpSmYy087/WmVMiQ2lZFmRZ40VOUxgynuvoJwjvfn/
   geO5dbNy77kBpM7SsIb3kT96ECqXGq1q8osf0LGWeGqUQ7sjU3rK/DL7S
   9iWWhoLPgQNevQ+liqpCFHRQ/+tvm8pSiosRL9kn1VQ7Pf76NWtdrLBoE
   u7vbzsYDxkoiJH9Q5ztNxQvlFARMof2Fej8lRzgaVTfC0Uaw0Rrxmyu4P
   Fr7wX4XJCXE99vcLDUUoigYd0jCy1hYGAZaGniBpob0nR4MVTvRAs/8lP
   vTv+f2UzxjUlPtM63fAnfiYhYYxyF5ion7VqluSLQsEqRYoTPcM1O9F8Y
   Q==;
X-CSE-ConnectionGUID: WS9DRVzHSqyBJRESYRRXLQ==
X-CSE-MsgGUID: 8U7NPQB8RuC+aUCl1lwJEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469580"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469580"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:10 -0700
X-CSE-ConnectionGUID: ocxtgTXETzav/XbNBF8TZw==
X-CSE-MsgGUID: +BhTd1YnR9+RBjn/LxOVsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882917"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mvm: fix the FCS truncation logic in d3
Date: Tue, 14 Jul 2026 14:32:31 +0300
Message-Id: <20260714143119.a7d094168ed3.I1a4d13f276c7e75514ab2032ae387873337470b8@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fix a harmless mistake in the wake packet management code in the d3
wakeup flow. If the FCS is truncated, we want to detect it, but we
cleared the icvlen before updating the truncated variable that holds the
number of bytes having been truncated.
Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9a74f60c9185..d7ceb385ae0b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1539,8 +1539,8 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 
 			/* if truncated, FCS/ICV is (partially) gone */
 			if (truncated >= icvlen) {
-				icvlen = 0;
 				truncated -= icvlen;
+				icvlen = 0;
 			} else {
 				icvlen -= truncated;
 				truncated = 0;
-- 
2.34.1


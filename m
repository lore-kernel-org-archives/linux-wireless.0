Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E143A1E7B
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 05:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034245; cv=none; b=Kp8hNzX5cBdHIfCiiH8VaYNgJxsiYT5B6iUUNWI0dghHDCDRg7FoYDjcV73PEXxEZca6A2B6TP+WLUs3oOasMhosp898zasiSkiIB/H59WLXWMYusOsxYLJ+ocP5EBRWtA6BQSbEZL560HYCgze7P/Oey3AW/mxr4IW4Ig46I9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034245; c=relaxed/simple;
	bh=f+ss/Lz2EhVsGD6yPwGqK1McgfqpZfGekgFWognfaEI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=YZ+fAjNLdgQ/SMu2hiTn8+/8CLAGpPzBt9wKL3aJ2/84kLtVsfpOtD/te9wmvuxJn3TtXmhLdTI6er0HG0KdXkjeGH80VD5NEr2i0h93Kt4puwQmVsxObJBD4z8OfiR2H5QevV/QVTZ7tfiY5LaBZShhRL4kTtGC5EjpOEQCWzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ltw/UmoY; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ltw/UmoY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780034243; x=1811570243;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f+ss/Lz2EhVsGD6yPwGqK1McgfqpZfGekgFWognfaEI=;
  b=ltw/UmoYh6lp+M7mtarBm221dF3ojEfzxfBTKK4OZOosIfhnDDIQBI7S
   hFYw0udLktvrzteqRwAxnuCpcKRRlREt9hvJK32VnkJGWR8ebnOQt9vR/
   1/hkWOzC+5Y/nwgUTcOkjr0dcAyaWXSM3jKTyznmAAJ4vh4QDyeMB73IS
   A+e7FhIRjF9nuvoe8pQN1rhs0I/WO1vkLdJ8mKkcZ0IG+N6VwpbMenFr5
   fFH1ywPFukEPYn6asizLi4rhg9bb76jO0Y3Z4RLYlDVddIpJ7Zx7ztYTh
   aBZRzJ3IL8GKHXCnDvpfddRVwR0MY+HvcKkwIhH3bS39V4GATgHuMy88f
   g==;
X-CSE-ConnectionGUID: t0DJLYO3SB+pxBfVi48aDA==
X-CSE-MsgGUID: QbXVezeqSg6zPk8BNuMGUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="84741129"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="84741129"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 22:57:22 -0700
X-CSE-ConnectionGUID: E548VhKUS4KJGAkUGo/tgg==
X-CSE-MsgGUID: PfvrXbN6SVKmDRdMmy3yuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="238572712"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 22:57:21 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 wireless-fixes 0/3] iwlwifi -fixes: 2026-05-29
Date: Fri, 29 May 2026 08:57:04 +0300
Message-Id: <20260529055707.24862-1-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Hi,

Fixed from our internal tree.

Thanks,
Miri
---

Emmanuel Grumbach (2):
  wifi: iwlwifi: mvm: don't support the reset handshake for old
    firmwares
  wifi: iwlwifi: mvm: avoid oversized UATS command copy

Pagadala Yesu Anjaneyulu (1):
  wifi: iwlwifi: mld: send tx power constraints before link activation

 drivers/net/wireless/intel/iwlwifi/mld/ap.c   |  4 ---
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  7 +++++
 .../net/wireless/intel/iwlwifi/mld/power.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 26 +++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  6 +++++
 5 files changed, 35 insertions(+), 10 deletions(-)

-- 
2.34.1
---
v2: removing 'res' file from "wifi: iwlwifi: mvm: avoid oversized UATS command copy"

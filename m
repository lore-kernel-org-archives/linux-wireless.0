Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55204246BCD
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298697; cv=none; b=AldJ3yypCddLk2+kd9cST+wAdyDU81Je4BealVP5Jv6wa/nmUjYSkdTwHCIYLRoSNAd/Xu1wVFr92wYx5FToRv1SzbhAnaqoXqc4rVg4G1ZJIgK5KNsp7GnI+mQxqrXvFwxk06V/BpgfI+ShqKwzrGTnaBDUFpaOuQvfqpchLuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298697; c=relaxed/simple;
	bh=b2WLQBOtLtaROYvA1H60zQJnc2tS0hvYIsPAU23aOck=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZO+hq1dI1q67HoprLakWyqpczufJpvm1AMnQy4sJ4VuAFNqNksuq+3l7BxtUqnY2aivCtVJV3RAyDiTlZrB29GK9LZ9g8G843Hh3j6FQ7NHSLGHge1A5nBcNYATf54a7OJf9j4bSOFBV7gRTcNpIVVSawfupMYETAVhPZXNduWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5cXqOnn; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5cXqOnn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298695; x=1815834695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b2WLQBOtLtaROYvA1H60zQJnc2tS0hvYIsPAU23aOck=;
  b=L5cXqOnn0P8SD/9kr1TXyWXzEcLQJdDn3eKNAcbzLBYhe7xHekB8NU/b
   5hVZpartI48p3Mww8VORGChrFmtzi/L5W+kYszyPXDqwZeACVF5y02+F+
   pVNbTSHA7WldKM63mLGgkOBkf2BmcE9dWeEJXL+b/X5FVtuJWR7d2HTcn
   drx60SNx9qqc5bFxPNt0rqALLPkvG4NMFp8JQ5QMtJ3V7H+Y6SnnX4Ra4
   gfN4u1an2MMgz0Y9A9UhpqCaSBpb+kIq6ZbfW+IsxZYvDd6JPjFFu7v/W
   Q4doZCJeL6ezT5yzSJQok5fhb3KcjkO+GmtX0nguFgdxHxARtlVFrbIz5
   w==;
X-CSE-ConnectionGUID: Ly585SY+R6KmEefB3elIrg==
X-CSE-MsgGUID: Yrq+yfg7Rn+S9OKNB4c+CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925968"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925968"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:35 -0700
X-CSE-ConnectionGUID: fuXop8goTQq4BEqEEc7KbA==
X-CSE-MsgGUID: sFEgzfNUTIW61+YiCUZJXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885713"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:33 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 0/8] wifi: iwlwifi: updates - 07-17-2026
Date: Fri, 17 Jul 2026 17:31:04 +0300
Message-Id: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
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
A couple of fixes, features and cleanups.

Miri

Avinash Bhatt (1):
  wifi: iwlwifi: fw: move SAR defines from acpi.h to regulatory.h

Ayala Beker (1):
  wifi: iwlwifi: mld: drop connection on D3 resume failure

Emmanuel Grumbach (3):
  wifi: iwlwifi: mld: validate wake packet crypto overhead
  wifi: iwlwifi: mld: initialize scan-abort status
  wifi: iwlwifi: mvm: ignore sync frames when sync is disabled

Miri Korenblit (1):
  wifi: iwlwifi: mld: move BIOS reading code to where it belongs

Pagadala Yesu Anjaneyulu (2):
  wifi: iwlwifi: mld: support update_mcc notification v2
  wifi: iwlwifi: mld: add debug log after AP type command

 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  5 +-
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  5 +-
 .../wireless/intel/iwlwifi/fw/regulatory.h    |  3 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   | 66 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  2 -
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  3 +-
 .../wireless/intel/iwlwifi/mld/regulatory.c   |  5 ++
 drivers/net/wireless/intel/iwlwifi/mld/scan.c |  3 +-
 .../wireless/intel/iwlwifi/mvm/time-sync.h    |  4 ++
 9 files changed, 80 insertions(+), 16 deletions(-)

-- 
2.34.1


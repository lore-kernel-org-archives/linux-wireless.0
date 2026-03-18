Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11DE37107C
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2026 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867284; cv=none; b=Md4tMvEMOsaasaJbkpCM7gtIElsE8JEpebQ4HUN9tkNui2vHWFieVnW0FpRXD3Bwz22aLw+JYG31Thfl620c0ceTpMTHnsPTySxZdyK+H/udqaJ1HX+S03247IwTHnszMAAherN0IFnNmx/rqMANIDjl9kNEs5s52ttGi/s7b+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867284; c=relaxed/simple;
	bh=ST/3/3H9VEICm8uDxslB3/ij/OsncXPXx9ecuvILI5A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=nA3l8dqq7StQB0OQRdXj0vYYCr1/VkY4kpDhhQ9KJT1XvgKF0SUI/MB925xg9w+OkrhYEUmFWGf+tiOD8ICHhNBO5mjyJsS/lj8soxyJWkXnOVmVat8VB7O4zN+0fwtRUsR+U1LuDaIT5BI8bLhR7FCi+tknZvgyElSTZg4Zu8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bkrWZnTl; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bkrWZnTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773867283; x=1805403283;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ST/3/3H9VEICm8uDxslB3/ij/OsncXPXx9ecuvILI5A=;
  b=bkrWZnTlmEVvYTFD4wNTnunJPJ+WZVv93xBp9FNiWwKvPO2Vut3DouhF
   FDio3zfCLIvlLRk/qTu2pA0Uw6sUmOdkWie/c16lSXS58956FjvFl+nq1
   6LV+AerVQdoXaOClB1W5DbxCSxYUbMJ7XSaC7PpHWabU3bl5q/beLSMC1
   LfmmDOOPgIRZKW570kOMU5WBEyo/6ImTnMGG0PG8MVSLA+ZRzGQ3APHMO
   hyXvzHIOrqPk0q7VlZMa/2dOSXIdotg1qToXK6RpJt5ManMAwIeJo/6im
   nDw2Q51M4tEjystn1IBlU1K+RtFcbFzcg3/MxaZtuBPbs+2Sx0nlloqnJ
   A==;
X-CSE-ConnectionGUID: 4FxJsdKCTAmXtFqRzmoP+g==
X-CSE-MsgGUID: wIC8QyhsSCK9bQSgR5Zdvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75010007"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="75010007"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:42 -0700
X-CSE-ConnectionGUID: mVMv+B7QTe+hvuOC/st9bA==
X-CSE-MsgGUID: 7H9CFIhbQRG5Pzpm1K3CWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="222793841"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2025-03-18
Date: Wed, 18 Mar 2026 22:54:15 +0200
Message-Id: <20260318205430.614577-1-miriam.rachel.korenblit@intel.com>
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

features and cleanups from our internal tree.

Thanks,
Miri
---

Emmanuel Grumbach (9):
  wifi: iwlwifi: mld: add support for iwl_mcc_allowed_ap_type_cmd v2
  wifi: iwlwifi: ensure we don't read SAR values past the limit
  wifi: iwlwifi: uefi: decouple UEFI and firmware APIs
  wifi: iwlwifi: acpi: better use ARRAY_SIZE than a define
  wifi: iwlwifi: uefi: open code the PPAG table store operation
  wifi: iwlwifi: bring iwl_fill_ppag_table to the iwlmvm
  wifi: iwlwifi: regulatory: support a new command for PPAG
  wifi: iwlwifi: acpi: check the size of the ACPI PPAG tables
  wifi: iwlwifi: acpi: add support for PPAG rev5

Ilan Peer (2):
  wifi: iwlwifi: mld: Refactor scan command handling
  wifi: iwlwifi: mld: Introduce scan command version 18

Johannes Berg (1):
  wifi: iwlwifi: mld: correctly set wifi generation data

Miri Korenblit (1):
  wifi: iwlwifi: mld: add support for sta command version 3

Nidhish A N (1):
  wifi: iwlwifi: mvm: cleanup some more MLO code

Pagadala Yesu Anjaneyulu (1):
  wifi: iwlwifi: mld: remove unused scan expire time constants

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  31 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  21 +-
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  94 +++++-
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  14 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h |   8 +
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  45 +++
 .../wireless/intel/iwlwifi/fw/regulatory.c    | 151 ++-------
 .../wireless/intel/iwlwifi/fw/regulatory.h    |  10 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  |  60 +++-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  |  32 +-
 .../wireless/intel/iwlwifi/mld/constants.h    |   1 -
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mld/iface.c    | 101 ++++--
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  19 ++
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c  |   1 -
 .../wireless/intel/iwlwifi/mld/regulatory.c   |  98 +++++-
 .../wireless/intel/iwlwifi/mld/regulatory.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 218 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/mld/scan.h |   2 +
 drivers/net/wireless/intel/iwlwifi/mld/sta.c  |  42 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 153 ++++++++-
 .../net/wireless/intel/iwlwifi/mvm/mld-key.c  |  46 ---
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 132 --------
 .../net/wireless/intel/iwlwifi/mvm/mld-sta.c  | 291 +-----------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   4 -
 27 files changed, 834 insertions(+), 757 deletions(-)

-- 
2.34.1


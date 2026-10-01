Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101564A7CB7
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860714; cv=none; b=KZU46MhxPTnbG21iUwb7GppVBE7SMHTjClwJikMkCTVQXcfPx4k94d2C6ztqt1vDeYuEKI6khw0whW/i4XFp+kh4Hd+bT8jA5XcePrJ/i61jJCRohttLt9YrUqGwDj9cWD0qlW+KmZA7F95bgi7vihDGWIj9fbA7e5S2ZYLxnZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860714; c=relaxed/simple;
	bh=mGUqxURPn9AQdiMkIhuqBk7J7NW/e+rNaag0UO0bXO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dMNbrpV/e0Ydi+FP5ZkrRK+iQoUCOqwyDwS4hdzfBAc8DFp5w7PGe42ahMMCspvOUmHO+NxY/fWX0goEXkrDv3mDrJrvVN0dARWQV4MPIOjOVNw4X2T/LbHlf6IXIw6yI05J7BXmKPwYLP4Q4lJi41pZrWjeUA3xzw4rW84boGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VP6kRnnd; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VP6kRnnd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860712; x=1822396712;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mGUqxURPn9AQdiMkIhuqBk7J7NW/e+rNaag0UO0bXO4=;
  b=VP6kRnnd+2zSDLDU8Co2Vor0aNLPj/MrLBdL+2Qe+Ij2ebnHbipeoxZg
   YSxqcKzXdcOKMYG2n+ghaAfpy092n/8ylXN1VSQ1XRlfmLszZxJ3t25x6
   dxQLYCaahURcFLbpT0nRJW+NGId0NBkx1rbFzCk5mKgqL+VmRh9bHmmp7
   GYrEOF5+dw+dBIHI2obFd2X/vVUGLDVADNWdrQ8NjlUHHWpr/6uBxmTkf
   /cbq8zcrZCFBSeIKxaMetV23BoI3bpUKodOu/NJZcz4pTOsdCCYdMoukF
   qB9R8YbKaouSMtJ0MxMBzz0JefOoK2YXFd0YLKfIhfMy2EnluPSE6Nj8z
   g==;
X-CSE-ConnectionGUID: nlbmf1dsQDyCT4B4jf+NuA==
X-CSE-MsgGUID: MI3PImVaSLyFvfVGhm1iOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423614"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423614"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:31 -0700
X-CSE-ConnectionGUID: b/5mxRA4R5C7kPXqnEYD9Q==
X-CSE-MsgGUID: +s4GFAYoR/mwB2RTL1nLvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485494"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:31 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-10-01
Date: Thu,  1 Oct 2026 16:20:13 +0300
Message-Id: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
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
Features, cleanups, and fixes from our internal tree.

Thanks,
Miri
---

Emmanuel Grumbach (3):
  wifi: iwlwifi: mld: add STA_CONFIG_CMD version 4
  wifi: iwlwifi: mld: add support for WoWLAN CIGTK API
  wifi: iwlwifi: don't mask ucode_ver in iwl_sar_geo_support()

Johannes Berg (12):
  wifi: iwlwifi: mld: add UHR sniffer support
  wifi: iwlwifi: mld: report UHR LTF symbols for non-TB PPDUs
  wifi: iwlwifi: mld: fix some radiotap field reports
  wifi: iwlwifi: mld: report UHR per-user NSS
  wifi: iwlwifi: mld: report beamforming in UHR sniffer
  wifi: iwlwifi: correctly report TB sounding PPDUs in sniffer
  wifi: iwlwifi: mld: remove UHR TB U-SIG2 B2 validate bit
  wifi: iwlwifi: mld: detect UHR sounding packets
  wifi: iwlwifi: mld: report the guard interval for UHR
  wifi: iwlwifi: mld: set RX_FLAG_FAILED_PLCP_CRC for bad U-SIG CRC
  wifi: iwlwifi: advertise UHR Co-BF support
  wifi: iwlwifi: dbg: validate the index before accessing an array

 .../wireless/intel/iwlwifi/fw/api/commands.h  |   5 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |  63 +-
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  15 +-
 .../wireless/intel/iwlwifi/fw/api/offload.h   |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |   9 +-
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  21 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   |  71 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   | 738 ++++++++++++++++--
 9 files changed, 844 insertions(+), 84 deletions(-)

-- 
2.34.1


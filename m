Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08563386426
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861482; cv=none; b=stFn0YsDA2CgXMtBxaFS/Z2Yzfq7bXhb97Zdy/YuDvv8vktDwmTaZqWbuKnPVPYxndMvp5y1VvgnmNKFyOs8x7JeLI8oND38ir+0SzS3ahSabiHoiXMzBrVp1pILHYVjqc9NeIoAxtHQifmPQWIBbA1LOHakArQkz8lAe4GVkyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861482; c=relaxed/simple;
	bh=lMzjsuO1qt9cs7nHzAsR2D9AI1nKtPsE5Uwpg+y+ayg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mpdgr5Q/1uzxg/0MYWviyCaYecCn9mbN6lYOxY6To6ohho8ScV/BmL/K+LGrdvrHj6o3Ph+vX/eBKqv2xoe8oVnkjKB/dRRF8hZQ/QHvivR2E9/Grbbm6xsLbNiLZLUrYHLiMFdYVpBgsPDUCGBWoSoWbqjyMpKHMbPwYTAjjt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M9aMhKxq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9aMhKxq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861477; x=1822397477;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lMzjsuO1qt9cs7nHzAsR2D9AI1nKtPsE5Uwpg+y+ayg=;
  b=M9aMhKxq8J6/1eF85TYZUBkbM6ajOei7vpP2MmFH1+bkdoyfuAafAFfm
   3zxhBJc6L2gWFSiEcpGfQ5OfYvw/aDf5lya4L7io+vofLcc9dSw+3UZwt
   dipx0WNpEPK9L9c4ajlhjg6eNmqIF9gXt2j2YLgYaqxpuQhFUNKpGdssR
   F+8A1wlIfHP9hCNcmekXkpBhz1ZvFv1yFgYv+N6E9V43l2Rz61NMWtjJ1
   06ZwiLXc5vWCe5TgTI+t6Gh7/EvGmLjI4leNsSsJ+rFBYw67/Gnwx2zgf
   5ZS3v7GPHQw3A/Xj65cHedqE/IlGvrgFLvd/Pnp7YZxBqAkSXvzeLG1rW
   Q==;
X-CSE-ConnectionGUID: R1mb0LV9TUO+ulfgG+ZFnA==
X-CSE-MsgGUID: l0BSMLr8TY2gXCE0a5qHFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750512"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750512"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:14 -0700
X-CSE-ConnectionGUID: oPKiuSOhQq6Jw3sWGFdDtg==
X-CSE-MsgGUID: eIYcgabmTrqP9jM0Bw9lbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26418"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/7] wifi: cfg80211/mac80211: add NAN Instant Communication support
Date: Thu,  1 Oct 2026 16:33:04 +0300
Message-Id: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
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
This series adds support for NAN Instant Communication, including hwsim
support.

Thanks,
Miri
--- 

Ilan Peer (7):
  wifi: cfg80211: nan: add Instant Communication support
  wifi: mac80211: nan: Update NAN configuration copy
  wifi: cfg80211: nan: check Rx registration for NAN beacons
  wifi: mac80211: nan: allow Rx registration for NAN beacons
  wifi: ieee80211: add NAN service ID list attribute definitions
  wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
  wifi: mac80211_hwsim: add NAN Instant Communication support

 .../wireless/virtual/mac80211_hwsim_main.c    |   7 +-
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 246 +++++++++++++++---
 .../net/wireless/virtual/mac80211_hwsim_nan.h |   8 +
 include/linux/ieee80211-nan.h                 |  28 ++
 include/net/cfg80211.h                        |   9 +-
 include/uapi/linux/nl80211.h                  |  12 +
 net/mac80211/cfg.c                            |   1 +
 net/mac80211/main.c                           |   7 +-
 net/mac80211/rx.c                             |  11 +-
 net/mac80211/scan.c                           |   4 +
 net/wireless/core.c                           |   5 +
 net/wireless/mlme.c                           |   9 +
 net/wireless/nl80211.c                        |  22 ++
 13 files changed, 323 insertions(+), 46 deletions(-)

-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EFB1F5821
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120369; cv=none; b=ScXcesS9aOh6dnR8OlxaPHHiF54imNQkU4n3EuKaJuAlR9IENFNsQoFCWkrdyi/Bt7iBRPago3rJW+E3lQn3lqnrr3rZl5bl8tA5hBLIGKIKvvzOboy5R5xDdWLbx6OqSELBN3IeZp1veVgR+ixgZMxGewBk62k5zElx7A9GWSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120369; c=relaxed/simple;
	bh=EjE5brS7fbQZyTanxnz4RCkRJPjZslYPqbV2VNyA1fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jkTs6DvBrZ/09y2YQJjSb/9Iig16FktcqCht3NTnPiJdxwu4t8bHT10lMp/TwyOqThOgd+vArAi22TRijs125LrcnYjzF8CtVU/Xx2UGICf3OSwQud8mtzNeCGpKJVvCxyIG6o6k6pVijsA48wd5tHo/ZQ3Q5kc0kPlzBrziKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eI3DKws0; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eI3DKws0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120368; x=1822656368;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EjE5brS7fbQZyTanxnz4RCkRJPjZslYPqbV2VNyA1fM=;
  b=eI3DKws0VlbCUbBfcTettw5514/mLKG+araF9BAYUC44iU5dgPIxCGn1
   qMVw8p4YiVuBvQJb/CXxQZNVpIWuQDkQsEPtLEl15Ahv+IC+rTsgP+fld
   5kfEW6G/i0bduiGtySUWSyXsHK4lgvAdKlYNHesgMgyqApbtAmO+gscXs
   JnqFA8gw79DIFAkldYZFth697cMyeIdgFeahal5ZovW8AsALBx67k/v27
   ZAPps7lNIjfa+uGp23c9iJ8gmkSU5hCRom+NSGhs7AVFIa/upu9ywRPfD
   FkzoVgcjU17lJH+s3HZv5H3rr1qKIn7qNpxPbP8RUwuwc/g6iLRON7C60
   Q==;
X-CSE-ConnectionGUID: rzKnthvlQeiW0SiLkSxQpg==
X-CSE-MsgGUID: DjR0hxaHQIaMMu/wNHr9Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328685"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328685"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:08 -0700
X-CSE-ConnectionGUID: 17q0kBmfQ8WBXyti/VwFdw==
X-CSE-MsgGUID: iQBcBWbIROWJSvFV/du2dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569085"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:06 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 00/11] wifi: cfg80211/mac80211: add NAN Instant Communication support
Date: Mon,  5 Oct 2026 10:40:25 +0300
Message-ID: <20261005074037.3506633-1-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for NAN Instant Communication, including hwsim support.

Changes in v2:

- Refactored the NAN beacon filtering based on review comments.
- Split the mac80211_hwsim patches, to first refactor the NAN code before
  introducing the Instant Communication support.

Ilan Peer (11):
  wifi: cfg80211: nan: add Instant Communication support
  wifi: mac80211: nan: Update NAN configuration copy
  wifi: cfg80211: nan: check Rx registration for NAN beacons
  wifi: cfg80211: do not use NAN beacons to update the BSS table
  wifi: mac80211: nan: allow Rx registration for NAN beacons
  wifi: mac80211: accept NAN beacons only when IC is enabled
  wifi: ieee80211: add NAN service ID list attribute definitions
  wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
  wifi: mac80211_hwsim: nan: prepare for more configurable NAN settings
  wifi: mac80211_hwsim: nan: Handle more of the NAN configuration
  wifi: mac80211_hwsim: add NAN Instant Communication support

 .../wireless/virtual/mac80211_hwsim_main.c    |   7 +-
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 245 +++++++++++++++---
 .../net/wireless/virtual/mac80211_hwsim_nan.h |   7 +
 include/linux/ieee80211-nan.h                 |  28 ++
 include/net/cfg80211.h                        |   9 +-
 include/uapi/linux/nl80211.h                  |  12 +
 net/mac80211/cfg.c                            |   1 +
 net/mac80211/main.c                           |   7 +-
 net/mac80211/rx.c                             |   6 +-
 net/wireless/core.c                           |  12 +
 net/wireless/nl80211.c                        |  22 ++
 net/wireless/scan.c                           |   4 +
 12 files changed, 315 insertions(+), 45 deletions(-)

-- 
2.55.0


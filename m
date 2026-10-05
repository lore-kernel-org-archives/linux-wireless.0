Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BCE45516B
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124215; cv=none; b=EJSu4AO3RgrmG1ILzThY+Lg9KBUI47hp2ZfHgD+d37aiqubMNnqhQJ798lQzKJbBuzOufumgO0fr6OOC0FUHc0Twt1p385lmlwRKMJ2UAq01CU7aqJfqwGxM0TpPbSjh/aKnwYa5itM9BuRJZ9Qi5io62hSoSdSyPa8ur75VM+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124215; c=relaxed/simple;
	bh=B+QzJGHruxW7aDApf5NnRZPB5fIKliVSLpByl50dXow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FZdwNm/KqrfvCpVGrqA3QqDIvgYgBKi+GdIQMbBKSTt01IlW5n0ymuA4+3zACn0YH8QfgdFdgyR3HtD/uLlgmYMMrlWmqvQ+pwZIA2BQc4zvyOx4E5ZN35N4KlnQflCxE4ozSikxAwm6KJ7oyDxjG9Ra8zgq/khHJgKpWTNozoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VmY62KNA; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VmY62KNA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124213; x=1822660213;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B+QzJGHruxW7aDApf5NnRZPB5fIKliVSLpByl50dXow=;
  b=VmY62KNA3+Rc2pA5kcpux891pUgiPZWjo+HFJQsDCHjC+MpHpBUZUIsO
   RyXBKzubf02wG/ufy42ULkkwd3ZyVTmna2WUWbjWagDuP5m0BXoMsYVah
   CMOcZrmL+WKf8HYA574twR7pd2n2sRDFDexcalB+of3l1oj+C1xqYWi8W
   8FbqIGLlB98887+BqNfMixvJMivO+a8zfFgfR1O4vocPCN2gFIF6QzMg5
   atf+kNDIcLbdRC4YiYTUXH7rkOmPZ6q7/Fn/pCUaqk8ND5YBlz80Kj/aE
   +ucniNipe9Vc+7Y1LTanjUMcESzsqsDxjg6JfXta8dlCEpbvnD2uqsWuD
   g==;
X-CSE-ConnectionGUID: gopn5LM7TBS4649X8OkGLg==
X-CSE-MsgGUID: F/9oSvVFQnCI1PRg76QhfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591417"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591417"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:12 -0700
X-CSE-ConnectionGUID: LhkdDVqBSk6S/12wkO1Xng==
X-CSE-MsgGUID: udI0nnTOTL+ebzjrgf7IEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576872"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:10 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 00/11] wifi: cfg80211/mac80211: add NAN Instant Communication support
Date: Mon,  5 Oct 2026 11:44:47 +0300
Message-ID: <20261005084458.3666739-1-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for NAN Instant Communication, including hwsim support.

Changes in v3:

- Patches applied on top of latest wirless-next main branch.

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


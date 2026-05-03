Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DA33AE18F
	for <linux-wireless@vger.kernel.org>; Sun,  3 May 2026 08:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798764; cv=none; b=er9RqrvRQmWjB/suLwQ83i6Ot1pFGk5IXhAOroIBEmIBvfTjEPu9BbRThnn2d6l644fqlGvQDeJ8ernvQolXuaW8gXtXS/SThZfv3biCHIwUnPFDkmykxgm49EqUjWPebD45VC/Mgjq0xtEZMHuW8wlXl9fUoWQap4vc5JAC4fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798764; c=relaxed/simple;
	bh=aLf+dyIt2muoas3cgrkUbT++iiv80YmHz7r4WlhPkSU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=FQYEVe+M6Q8S5SdgwtzlqtElKllsVCqs/xr1mg7UZD6l24yJJZRhtaambPJDaj5XJWbOI2rYMlEU9eqEI5TMrhVvKmCiof7RqLnw2etLpnFYbCXzatMAHFwI1LOihjyPFX3CcMdOZ98vFl22/Oy/hMDIxgp5ocWIT5KNw7Q/14g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5e1zGc/; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5e1zGc/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777798762; x=1809334762;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aLf+dyIt2muoas3cgrkUbT++iiv80YmHz7r4WlhPkSU=;
  b=E5e1zGc/HUinAOY2qwc47YyBHdDYFsJOUnM7lYDnN1jDfzlNGNuMaymQ
   qz5twt0Pqn+9/WIChlOXJ8SzkHpjm1huicKinLMGOVof14xl2QAdQN+NJ
   G0T8LNWCCtx2CEIu9lt7FRyrqJT8KrliuK2HA7YKHd9ddSlr0cAJSMrfL
   AK0BBjPHqR933hv5bjZBdTqM1XbNErHxMxIpzD5l0Y14hFWxHlELJvBVI
   8ZJYL9eQ2ptLNhrtIuqGqzObxVrzkkmRzGUd8yjOLmSz6Y8SpTmlL2Llr
   5CfaSDizxd/e0MKoS5GvzQ+Dw2gaVgMgCguccLc+ZPelScDhHtqxpL5MA
   Q==;
X-CSE-ConnectionGUID: 4WeJbFoVTfiVQahmTZW1qg==
X-CSE-MsgGUID: kws1fc4mQuaThL2Xt10Isg==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="89380321"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="89380321"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:21 -0700
X-CSE-ConnectionGUID: quntajmLQKWCGnXCo0DDnA==
X-CSE-MsgGUID: 2lvk43FAQISuErKHGTH3Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="235123735"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 wireless-next 00/15] wifi: mac80211: more NAN patches
Date: Sun,  3 May 2026 11:58:52 +0300
Message-Id: <20260503085907.257378-1-miriam.rachel.korenblit@intel.com>
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
This series adds a few more NAN features to mac80211 and mainly hwsim
support.

Thanks,
Miri
---

Andrei Otcheretianski (1):
  wifi: mac80211: Fix a kernel panic in ieee80211_encrypt_tx_skb()

Avraham Stern (1):
  wifi: mac80211: accept protected frames for NAN device

Benjamin Berg (8):
  wifi: mac80211_hwsim: remove unused nan_vif struct member
  wifi: mac80211_hwsim: move NAN related variables into a struct
  wifi: mac80211_hwsim: split NAN handling into separate file
  wifi: mac80211_hwsim: rename and switch simulation time to boottime
  wifi: mac80211_hwsim: move timestamp writing later in the datapath
  wifi: mac80211_hwsim: register beacon timer by calculating TBTT
  wifi: mac80211_hwsim: refactor NAN timer handling
  wifi: mac80211_hwsim: switch to use TXQs

Ilan Peer (2):
  wifi: mac80211: allow userspace TX/RX over NAN Data interfaces
  wifi: mac80211: Allow setting MAC address on interface creation

Miri Korenblit (3):
  wifi: mac80211: track the id of the NAN cluster we joined
  wifi: mac80211: avoid out-of-bounds access in monitor
  wifi: mac80211: add NAN channel evacuation support

 MAINTAINERS                                   |   2 +-
 drivers/net/wireless/virtual/Makefile         |   2 +
 .../net/wireless/virtual/mac80211_hwsim_i.h   | 139 +++++
 ...mac80211_hwsim.c => mac80211_hwsim_main.c} | 508 +++++-------------
 .../net/wireless/virtual/mac80211_hwsim_nan.c | 233 ++++++++
 .../net/wireless/virtual/mac80211_hwsim_nan.h |  36 ++
 include/net/mac80211.h                        |  29 +
 net/mac80211/cfg.c                            |  19 +
 net/mac80211/chan.c                           |  28 +-
 net/mac80211/iface.c                          |   7 +-
 net/mac80211/main.c                           |   4 +
 net/mac80211/nan.c                            | 126 +++++
 net/mac80211/offchannel.c                     |   9 +-
 net/mac80211/rx.c                             |  26 +-
 net/mac80211/status.c                         |   9 +-
 net/mac80211/tx.c                             |  18 +-
 16 files changed, 786 insertions(+), 409 deletions(-)
 create mode 100644 drivers/net/wireless/virtual/mac80211_hwsim_i.h
 rename drivers/net/wireless/virtual/{mac80211_hwsim.c => mac80211_hwsim_main.c} (94%)
 create mode 100644 drivers/net/wireless/virtual/mac80211_hwsim_nan.c
 create mode 100644 drivers/net/wireless/virtual/mac80211_hwsim_nan.h

-- 
2.34.1
---
v2: fix MAINTAINERS file to include the newly added files
v3: fix an "always true" check in commit "split NAN handling into separate file"

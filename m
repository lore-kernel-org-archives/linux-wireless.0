Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBBB2030A
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2026 05:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778651058; cv=none; b=Mlwc7lsdmyqQBtbD1U8jh5oD9Y8wjsHMf+NcIyMmakiDI7sMFe0biaYNcEuGjEzruPPp54hhTHvdGQPoOD88VcGIKIMJ/52cfVe10+G5HPTtLxOTJlcO25ymlVBVskTY8BPnQzRoPTUsMt0zgnxrxgmFUpYpSfMYwtH6r8843fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778651058; c=relaxed/simple;
	bh=B8+jeGZMEYk4zs7bR1Ko7ft0/cpqNJwiN5qmL6lTdl4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Li8Ugu04Ex2Bda4250glBcW+fefS7aJNCw2Qi9wl6La9+nCOG9dN4Uyui4WqRPJW/T1VyybmjgqqvnHud67c+eBE6L5qMjs/oaQXyBWfBDbIwQdcRtFMcbVousuc7Otj2/Xsobm7NyjKMxAHxeD95W6gObl3RPaFOnlboPxT6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OzdyMBiK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OzdyMBiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778651057; x=1810187057;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B8+jeGZMEYk4zs7bR1Ko7ft0/cpqNJwiN5qmL6lTdl4=;
  b=OzdyMBiKZp7Rzn7PapnsXH7slqSgex+/G2I1W2gi/oKCPjwoGIU9DwHq
   e26i4SUEuwNpMn9I06YeTLd8n7qcua1CnRMnVNKXvP21CTg/+DC3vdghi
   x4ldmO0PQdSWdpPCcJU+fcWWEePN80ypDlmRmQLLrXtiStX6VbUaKBdB1
   LNdv5TDyTbqfgtIQeaWZbxDfx81PZNO3T85t1jHxPFOnqiskMDEkkbZhU
   AHXzukbnw5EqOYTyXzb+D2wWp11w8HRw8mVHhdQpZP/94oMuCqrRvSwCR
   xKp0KEJn0Gy928fe5DEXhi91a3KXXqa1MQr5NUPzxOmq3ZNUOVhlHYTfu
   g==;
X-CSE-ConnectionGUID: T8ReEEnnTnmxJPMx+omdMA==
X-CSE-MsgGUID: j+UhOYmtRK6W94eOYcjJdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79552800"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="79552800"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:44:17 -0700
X-CSE-ConnectionGUID: P9m438YMSHyvMvPKU7WrwQ==
X-CSE-MsgGUID: OIG/9k78Rwmk9oHQ8xhz+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="238077884"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:44:16 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-05-13
Date: Wed, 13 May 2026 08:43:47 +0300
Message-Id: <20260513054402.2897702-1-miriam.rachel.korenblit@intel.com>
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

Features, cleanups and fixes from our internal tree.

Thanks,
Miri
---

Avinash Bhatt (2):
  wifi: iwlwifi: mld: implement PSD/EIRP RSSI adjustment
  wifi: iwlwifi: mld: update link grading tables per bandwidth

Avraham Stern (1):
  wifi: iwlwifi: mld: add handler for NAN ULW attribute notification

Emmanuel Grumbach (4):
  wifi: iwlwifi: led_compensation is needed for iwldvm only
  wifi: iwlwifi: shadow_ram_support is needed for iwldvm only.
  wifi: iwlwifi: max_event_log_size is needed for iwldvm only
  wifi: iwlwifi: smem_offset smem_len are not needed from 22000 and up

Ilan Peer (2):
  wifi: iwlwifi: mld: Replace static declarations of IWL_MLD_ALLOC_FN
  wifi: iwlwifi: mld: Add support for NAN multicast data

Johannes Berg (4):
  wifi: iwlwifi: mld: support NPCA capability for UHR devices
  wifi: iwlwifi: mld: implement UHR DPS
  wifi: iwlwifi: mld: give link STA debugfs files a namespace
  wifi: iwlwifi: mld: set correct key mask for NAN

Miri Korenblit (2):
  wifi: iwlwifi: bump core version for BZ/SC/DR to 104
  wifi: iwlwifi: define MODULE_FIRMWARE with the correct API

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  23 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |   5 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |   5 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   5 +-
 .../net/wireless/intel/iwlwifi/cfg/ax210.c    |  38 +-
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c   |  13 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c   |  13 +-
 .../net/wireless/intel/iwlwifi/cfg/rf-gf.c    |  13 -
 .../net/wireless/intel/iwlwifi/cfg/rf-hr.c    |  24 --
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c   |  13 +-
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  32 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   4 +
 .../net/wireless/intel/iwlwifi/mld/debugfs.c  |  18 +-
 .../net/wireless/intel/iwlwifi/mld/iface.c    |  10 +-
 .../net/wireless/intel/iwlwifi/mld/iface.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/mld/key.c  |  50 ++-
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 396 +++++++++++++++---
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  72 +++-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.h  |   3 +
 drivers/net/wireless/intel/iwlwifi/mld/nan.c  |  62 ++-
 drivers/net/wireless/intel/iwlwifi/mld/nan.h  |   7 +
 .../net/wireless/intel/iwlwifi/mld/notif.c    |   3 +
 drivers/net/wireless/intel/iwlwifi/mld/phy.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c  | 104 ++++-
 drivers/net/wireless/intel/iwlwifi/mld/sta.h  |  11 +
 .../intel/iwlwifi/mld/tests/link-selection.c  |   6 +-
 .../wireless/intel/iwlwifi/mld/tests/utils.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |  11 +-
 29 files changed, 780 insertions(+), 197 deletions(-)

-- 
2.34.1


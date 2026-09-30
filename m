Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB828030E
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754888; cv=none; b=tg7mY/QKABTGeNYku5K6sJJrKZC27Sn2Zp3cNL/1MdeE+cIKz/j6PPlxAt9bgOilQMJG5GmqJHERsBp6WVjxxkGjx1agiBYTD0XXHTg4QEI5WPJUsB1lPV/eK6AwTcXayo8efGQeZbEKsHjCNXQZHfeoTmgDqwL8lZ0NRundt90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754888; c=relaxed/simple;
	bh=pjn2pkIRvBGjVI7TeyErQ6Ez5aaEZH/6fbjrsz8XAxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B/HeGhXIAPpiZNDQuKODbqjaYrme2hW1sPJ9OImdczZOOo5xIehRiXN7PGw7Q9g7K/lShOmBMh+lScUZWX9pc97r+siWM3UEmG18KBUJbep5UcoPDvKHZUd2RMxVDsz60wrYVun64o6SynWgvA+wB7hs6eKX4LFaDqpzqaRAPzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b0AAYD28; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b0AAYD28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754887; x=1822290887;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pjn2pkIRvBGjVI7TeyErQ6Ez5aaEZH/6fbjrsz8XAxc=;
  b=b0AAYD28lyBquxrZ73vTm/CKQ2/gV8kJvbFzpFljjCgJM0jmtkkcCSZk
   f8Jpb+xaUB+ZVRvKMkhW5bN6nt7F5IRjSo720PDVNjmrLbu36bZN8KSvy
   W729Q1kglDCAEzBa8ElALuk6IF5UseIUy/K9eWOSqq3B3vJByzjdbQI81
   ZKLPhBS8VfcukGylw0DPjc16+9GDFml5OcdvQke0lD/hmTMHLRJCOUDv7
   X/XdusXsLsPSIaW/MR3soxhdfRbUe1ZHuR6mZFSQTXbhCo20tLejw6kKA
   tzXRJ49+0A1Ae4/9rKYc5Jsg3brjqPyuTgPTb3DfL9VSyBv0nOhfYX6Sk
   w==;
X-CSE-ConnectionGUID: nhyyOGfkTradq1tfQ7Beag==
X-CSE-MsgGUID: 2f93qD3yRdeN55W8KG7ZWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296810"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296810"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:46 -0700
X-CSE-ConnectionGUID: r+zeVbFtQU+SZOhXBYoKBw==
X-CSE-MsgGUID: e/NauLr9RM2dzaLEWTZvgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962903"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-30
Date: Wed, 30 Sep 2026 10:56:28 +0300
Message-Id: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
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
Features, cleanups, and bugfixes from our internal tree.

Miri
---

Benjamin Berg (1):
  wifi: iwlwifi: mld: report RX time from channel survey

Daniel Gabay (2):
  wifi: iwlwifi: mld: add gp2 timestamps to TX commands
  wifi: iwlwifi: mld: test TX gp2 timestamps

Emmanuel Grumbach (2):
  wifi: iwlwifi: mld: fake a valid NSS field when needed
  wifi: iwlwifi: mld: remove unused fields from the firmware API

Miri Korenblit (10):
  wifi: iwlwifi: add _no_grab postfix to some functions
  wifi: iwlwifi: move pcie-only functions to pcie
  wifi: iwlwifi: avoid unnecessary indirection
  wifi: iwlwifi: rename iwl_trans_read_prph
  wifi: iwlwifi: collapse iwl_read_prph_no_grab() into the transport API
  wifi: iwlwifi: pcie: rename pcie-internal functions
  wifi: iwlwifi: rename io helpers to iwl_trans_ prefix
  wifi: iwlwifi: move iwl-io functions to iwl-trans
  wifi: iwlwifi: call generic trans API and not pcie one
  wifi: iwlwifi: trans: bring virtualization back

 drivers/net/wireless/intel/iwlwifi/Makefile   |   1 -
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |   5 +-
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |  32 +-
 .../net/wireless/intel/iwlwifi/dvm/eeprom.c   |  88 +--
 drivers/net/wireless/intel/iwlwifi/dvm/led.c  |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c  |   2 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  36 +-
 .../net/wireless/intel/iwlwifi/dvm/power.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |  19 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c   |  14 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |   3 +-
 .../net/wireless/intel/iwlwifi/dvm/ucode.c    |   3 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |   3 +-
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |  11 +-
 .../net/wireless/intel/iwlwifi/fw/dbg-old.c   | 120 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  96 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  13 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   4 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-io.h  |  18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 217 ------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   | 103 ---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h  |  22 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 142 +++-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 215 +++++-
 .../wireless/intel/iwlwifi/mld/constants.h    |   4 +
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   |   5 +
 .../net/wireless/intel/iwlwifi/mld/debugfs.c  |   2 +-
 .../intel/iwlwifi/mld/ftm-initiator.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |  15 +-
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |   2 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  13 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.h  |   6 +
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c  |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |   9 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c |   5 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c  |   7 +-
 .../wireless/intel/iwlwifi/mld/tests/Makefile |   2 +-
 .../wireless/intel/iwlwifi/mld/tests/tx-gp2.c | 154 ++++
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   | 131 ++++
 drivers/net/wireless/intel/iwlwifi/mld/tx.h   |  41 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   6 +-
 .../intel/iwlwifi/mvm/ftm-initiator.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  37 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c  |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c |   4 +-
 .../wireless/intel/iwlwifi/mvm/time-event.c   |   1 -
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   4 +-
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |  11 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  68 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 189 ++---
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  92 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 655 ++++++++++--------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 107 +--
 .../net/wireless/intel/iwlwifi/pcie/utils.c   |  91 ++-
 .../net/wireless/intel/iwlwifi/pcie/utils.h   |  46 +-
 69 files changed, 1763 insertions(+), 1238 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c

-- 
2.34.1


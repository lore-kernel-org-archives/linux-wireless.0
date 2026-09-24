Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23F361957
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246376; cv=none; b=uyoBC85V1u002f1ihl1ZOcWhx7ZwrOLft48hsgdPPECDQtCmpyIyxI3HunSRmfG18eqLjHEyYYES1lvZlbka1zG1GS+3z9mGhgAps5/vjZ5K2J13oFrYhWsG9u+BUdzJygQ/Wp0bkFUacxOGu8ht6dSf20YHdd/UgIjUDLH6Shs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246376; c=relaxed/simple;
	bh=cWc9wXLxC7WOgs0FGRP92gnE+C3il9RcDNcseL7LglM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LihJzRftwwlb+O4VFVpmC6WeVAxxq0P+gbIRut37w7gJseVGK5OXH1dNJ3RmB/nQ0WajivNLGChPA6UUUw1FmXpPVvO/xVdPwn5O4PNQZLWUpoM919/9R8t8eKu3KoD5Gv/bL5EZPj5V6aANej4XrKnqitRMIthSBIIdMUxTylo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JGEuXvS0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JGEuXvS0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246374; x=1821782374;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cWc9wXLxC7WOgs0FGRP92gnE+C3il9RcDNcseL7LglM=;
  b=JGEuXvS02HOzi/MDOxAJa3UbTPlIFPYrVm8WvSZmIcYpdSqAi1Hx4/hS
   sZfqOGowU6qxSLywkBK6GjzXhZPwl04TET8ZauurIwYMDaeYJVGx24FUd
   AV4s7Jl3OP1/lgwPhjXqWnOF9u+qg+gajGVrabP1ALWjW3XKkz47SjLbB
   T4Aor4MhM+gcYF7fyx051opFdVwLNq3trVX0EDs1J1o1MeBgxvC1OuAcg
   dykvLv0oao+/M5Rqj1hP4P1FTuOhL22p3+W+4a1K2X/kTztRXWAbZcfWC
   XBeEQ0QLjjkPlOw9AuZH3tfSWwUFFDdf6AaoYu03LdilgLDp47Km/giXV
   g==;
X-CSE-ConnectionGUID: FQRRV7HsT2CZYjaE4SEnnw==
X-CSE-MsgGUID: JfkvR0jdS1eA0Rh40Hv9LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134864"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134864"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:33 -0700
X-CSE-ConnectionGUID: MFIDeoJUQBiR6gKu0/awAA==
X-CSE-MsgGUID: UyjMjXYbQYm6Fxn8qVt8cA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:31 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-24
Date: Thu, 24 Sep 2026 13:41:14 +0300
Message-Id: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
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
Usual fixes, cleanups and features from our internal driver.

Thanks,
Miri
---

Emmanuel Grumbach (3):
  wifi: iwlwifi: pcie: order RX reads after the write pointer
  wifi: iwlwifi: add support for the new MPDU descriptor
  wifi: iwlwifi: support RX BAID modify command version 3

Miri Korenblit (7):
  wifi: iwlwifi: pcie: drop gen1_2 prefix from is_ltr_enabled
  wifi: iwlwifi: Revert "wifi: iwlwifi: gen1_2: move gen specific code
    to a function"
  wifi: iwlwifi: Revert "wifi: iwlwifi: pcie: move generation specific
    files to a folder"
  wifi: iwlwifi: pcie: remove iwl_dbgfs_fh_reg_read
  wifi: iwlwifi: open code iwl_trans_sync_nmi_with_addr()
  wifi: iwlwifi: move iwl_force_nmi() to where it belongs
  wifi: iwlwifi: drop the orphaned nic_access annotations

Pagadala Yesu Anjaneyulu (4):
  wifi: iwlwifi: send standalone SAR to firmware
  wifi: iwlwifi: uefi: Fix SAR enable check to use mode parameter
    correctly
  wifi: iwlwifi: fw: harden UEFI reduced-power TLV parsing
  wifi: iwlwifi: fw: add Samsung to TAS and PPAG allow lists

Shahar Tzarfati (1):
  wifi: iwlwifi: disable HE ER mode

 drivers/net/wireless/intel/iwlwifi/Makefile   |   6 +-
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |  29 ++-
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  14 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  19 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |   5 +-
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  40 ++-
 .../wireless/intel/iwlwifi/fw/regulatory.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  |  53 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 231 ------------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |   4 -
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   2 -
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  38 ++-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.c  |   7 +-
 .../net/wireless/intel/iwlwifi/mld/debugfs.c  |   2 +-
 .../net/wireless/intel/iwlwifi/mld/power.c    |   2 +-
 .../wireless/intel/iwlwifi/mld/regulatory.c   |  80 +++++-
 .../wireless/intel/iwlwifi/mld/regulatory.h   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   3 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   2 +-
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |   2 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  11 +-
 .../iwlwifi/pcie/{gen1_2 => }/internal.h      |  25 +-
 .../intel/iwlwifi/pcie/{gen1_2 => }/rx.c      |   9 +-
 .../iwlwifi/pcie/{gen1_2 => }/trans-gen2.c    |   4 +-
 .../intel/iwlwifi/pcie/{gen1_2 => }/trans.c   |  95 ++++---
 .../intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c |   0
 .../intel/iwlwifi/pcie/{gen1_2 => }/tx.c      |   4 +-
 31 files changed, 316 insertions(+), 395 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/internal.h (98%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/rx.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans-gen2.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans.c (98%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c (100%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx.c (99%)

-- 
2.34.1


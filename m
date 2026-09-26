Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA861E7660
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442939; cv=none; b=i7xDTICCOIJmMKGGW/6huLlgBpSSzeMBfD2euM3HW9Ozh/aSMo5WSgbHto4f/0t8O/pivSReccw2e/qDLGixZBJilQw1ZL0b5vHAOjWqcauqlngD+5LcyHo2FgrX957aWOiwWq/7LAuWCBLWteJTeRgbiRaK5Y9g+TORrJU3hHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442939; c=relaxed/simple;
	bh=ZBiqfCc6OpJ1K+F8X6LaLHpTrlndf6aEEkn9XQBTE2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZikIkuQf4wwK0W0ocIk/HR5Mfh5W+JAXhjOvl2wcrJcqvaXMtpPCbCpMZjMhkIPfQGCh+5heLw3JNYbX5sLZFIMe4jKgLgtidCNgSdeqxYjbndXQLTvcOa4CpfoIzJPJ0ay5uWOGCd0dATi0+L1AW3GyKdmHTl7HyCtaGIvbROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i3b6zCOQ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i3b6zCOQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442937; x=1821978937;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZBiqfCc6OpJ1K+F8X6LaLHpTrlndf6aEEkn9XQBTE2k=;
  b=i3b6zCOQpsgapCuIaYU+KxjBJ9gSLHgP3iKD+M9zgQX7k0SZKgVMpQyo
   tLxlFCB5kV+XFm2dRiaTtiCIMwy43mW5GrALV4WZHRueakXMHbYrfVo1D
   qIEvnv+wTJeIMaGklkceeqcOWi+Z9IPA2Ejm/UyUoffvygzW6NpwhEOeP
   ynF2E8MWW0PMDlAOztCS9scDM2ZMsoxodLuVGi+aMsTA12mszm1pKX8LH
   Tk7mvk43Y4YEVjCAt17IqAa6v0yGrKIq6dFhsKOPxBY90YuLnMWmQYMcv
   GhQuAv4VLfYXQZNVS5lhZ5rNfq8L8+cjj9m6TNgv1QLK7hNPvViuy1+jv
   g==;
X-CSE-ConnectionGUID: iEgvCguRSnuqzv3la7agrg==
X-CSE-MsgGUID: c+1gNNs7ROaxA+8cjuY9EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533270"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533270"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:37 -0700
X-CSE-ConnectionGUID: mWVqigyuQmKPc/rls5d3Zg==
X-CSE-MsgGUID: AhtCqcD6QveIrxM7j5HGsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196887"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-24
Date: Sat, 26 Sep 2026 20:17:19 +0300
Message-Id: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Resending the series again since it was not rebased.
Miri
---

Emmanuel Grumbach (3):
  wifi: iwlwifi: pcie: order RX reads after the write pointer
  wifi: iwlwifi: add support for the new MPDU descriptor
  wifi: iwlwifi: support RX BAID modify command version 3

Miri Korenblit (7):
  wifi: iwlwifi: pcie: drop gen1_2 prefix from several functions
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


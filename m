Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E847D44F
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077687; cv=none; b=iU7/4pAZ27z/q8GWtEFPZ5tEjseUnXoCwGZHzgJvrXycwzAdo4V/GSfj2a75f2hBW2kZBy6JfQ68jvShYCIvuQuKhqwr7qvvVU31d4BmBry05KLopbSILPqI/cb+IRUY3hTeRd8xFCzdQw5KhvUCEaOhCrkdGWAFAK9PSWHWE6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077687; c=relaxed/simple;
	bh=vPScQCpKCFl3XyZSzFl9gW2CV4tzZ1WBfufUtq7PWtY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mlYK8BVB+D786CDb1N2WrqAEOzm3/mAesiQ/l1mFcnertRmtNUanb45Dd1zOmfIto6x8+VeXzwMsK4mNN4tifMTDpTZFRYX0uk/u8ip3gkfixqrOEosQ6yxG1HcK9F7W7DWidGCehfRK53DdXDOxDm0xT7ufut1yXu+uKUdckmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1PTM+kW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1PTM+kW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077685; x=1821613685;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vPScQCpKCFl3XyZSzFl9gW2CV4tzZ1WBfufUtq7PWtY=;
  b=O1PTM+kWI4B4qTrNC9KV++SqMV3HtNr7r3oRwcyt63HI39FmGrzpAlfx
   MgSEhwLLKNsP/a3hHnchyBCsYb+kU19cdqEx/5WOu8FlJaab3bGRJTAiZ
   ANPo0Ii5ileRBHooUNKoo/XdBqv7JVvd4t+I0DcNKR0ME6abKhRa1h9PE
   HpYRg0jvNLKtPG/ZxMmOeBa/e3a8qiAllJDQ8svqiQ0ht0nK0TeaG0gVW
   6fZOuwGptzILQMoC6KtxVZuHzihz6FMC7m60YQ4IZZYYSgrWElU3yw0/s
   zqpW8w0Yky3b9zhLMDWGfIZm2frjNmFZQQk5uLEuazWB5rqawGV5xWTrc
   w==;
X-CSE-ConnectionGUID: PVifUZIHQNSr4G1emYgp4A==
X-CSE-MsgGUID: pMKuX2nlR3q/6Zu5zsogUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170490"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170490"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:04 -0700
X-CSE-ConnectionGUID: r94KiF/XSk6yQd+CTBB1xg==
X-CSE-MsgGUID: tQd44dlvSVW/nTX3QS0UDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275303"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-22
Date: Tue, 22 Sep 2026 14:49:47 +0300
Message-Id: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
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

Benjamin Berg (1):
  wifi: iwlwifi: mld: pass phy status explicitly for sniffer

Emmanuel Grumbach (7):
  wifi: iwlwifi: mld: support operational statistics notif ver 5
  wifi: iwlwifi: poke the config space in case of command timeout
  wifi: iwlwifi: pcie: remove monitor_data debugfs file
  wifi: iwlwifi: mld: stop filling link fields unused by the firmware
  wifi: iwlwifi: add multi-BSS/EMCCA max BSSID indicator to LINK cmd
  wifi: iwlwifi: pcie: fix TSO page leak in iwl_pcie_prep_tso()
  wifi: iwlwifi: fix ctxt-info-v2 unwind UAF

Ilan Peer (1):
  wifi: iwlwifi: mld: Add support for scan iteration complete
    notification v3

Johannes Berg (1):
  wifi: iwlwifi: mld: separate HT/VHT/HE/EHT LDPC/STBC capabilities

Miri Korenblit (2):
  wifi: iwlwifi: mld: log error when missing a recovery buffer
  wifi: iwlwifi: mld: avoid leaking error recovery buffer

Pagadala Yesu Anjaneyulu (3):
  wifi: iwlwifi: mvm: validate NVM read response length
  wifi: iwlwifi: fw: reject empty UEFI DSM query bitmap
  wifi: iwlwifi: fw: fix dbg dest TLV size check by version

 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  28 ++-
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  40 +++-
 .../net/wireless/intel/iwlwifi/fw/api/stats.h |  58 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  |   6 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   9 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |   7 -
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   4 -
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/link.c |  14 +-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |   7 +
 .../net/wireless/intel/iwlwifi/mld/notif.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  14 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c |  15 +-
 .../net/wireless/intel/iwlwifi/mld/stats.c    |  35 +++-
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c  | 173 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  |  15 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   2 +-
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |  17 +-
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |  43 -----
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 153 ----------------
 .../wireless/intel/iwlwifi/pcie/gen1_2/tx.c   |  44 ++++-
 22 files changed, 387 insertions(+), 309 deletions(-)

-- 
2.34.1


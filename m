Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD2A43F08A
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141865; cv=none; b=XTuoS0yGvY+ae8RflVmm1Ei0WPOJOa0ye6FlB/Ku7fy0cvQp8EnPe43lyVjlbaaFKPAR0lbGyvlMn+oKhmOdtgqAQo465JY+wMsoAyK+PFExkaTjb5Y/ZsgxqbwwA2NCH1kxoxSWlmkP0n0ZHz4JqqQmw0k23I5qU1JNy5rplI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141865; c=relaxed/simple;
	bh=vl8/mnpTllFFJBhSrJEXpPuodd6bEBHP9E24goVEQIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mdyfrHJPmWnCA8klu9+rMy787rbwLASZnEv0LWgYqjvsO451Drwi7V0BBt6SbGrF86aCXtDBvh8ySr2WhvVOHmLBDzPFrrl6LayhhJdwgxdxdm4HZcmzQCiTtwxKRKt3eMoTgK5qMEchvx4xX9vWbhQaVcz3kwxVSgsGvD7q4XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OU/o580b; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OU/o580b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141862; x=1815677862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vl8/mnpTllFFJBhSrJEXpPuodd6bEBHP9E24goVEQIQ=;
  b=OU/o580bJR77WvO48uE43V2S8nJm+67HK4RtPiZOEXWh2Txdno6BhXRY
   X367S0UPSAPHEgalnIV06pFZLDpsMcV+fvS9NcWq+n7zOu5+BTN6m04/W
   1Tze8J0AzyuqLfjHtZuNheNv95PPRJ9lqXForK7CxX3WPeIZOKMe/2F6g
   EvwomCdr1efmMqN1HYDLdoR8EuyIL1MQRXA3BOkeaAB7kGEh2vc+Bf7Wp
   ak7yM7FX1X3FLGq1IaX1H97BXDgzi+HPwtF/NPt6aFFM2/p+NfshMp+0J
   msNsRBqa+l7Q9Wzs6IeIoqXy/cOYw6exyUHUBpfSksIMiZc3HCxjGM1R+
   Q==;
X-CSE-ConnectionGUID: U/thWdzITwePVGDgju4K2w==
X-CSE-MsgGUID: hFcbLgQ6RPm6QhXA1q6Y3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160877"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160877"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:37 -0700
X-CSE-ConnectionGUID: ferFabGVRfOlcSUdJzAMdA==
X-CSE-MsgGUID: Rs0aTY5tS8Cam/uXnl/RCw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-fixes 00/15] wifi: iwlwifi: fixes - 07-15-2026
Date: Wed, 15 Jul 2026 21:57:00 +0300
Message-Id: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

bugfixes...

Avraham Stern (1):
  wifi: iwlwifi: mvm: copy the correct TK length for ranging

Emmanuel Grumbach (11):
  wifi: iwlwifi: mld: validate txq_id in TX response handler
  wifi: iwlwifi: add support for additional channels in NVM_GET_INFO
  wifi: iwlwifi: mvm: validate TX_CMD response layout
  wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list
  wifi: iwlwifi: validate payload length in iwl_pnvm_complete_fn
  wifi: iwlwifi: mvm: ptp: free response on success path
  wifi: iwlwifi: pcie: validate FW section counts in
    iwl_pcie_init_fw_sec
  wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
  wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
  wifi: iwlwifi: mvm: fix a possible underflow
  wifi: iwlwifi: adapt ND match notif sizing to fixed matches array

Pagadala Yesu Anjaneyulu (1):
  wifi: iwlwifi: mvm: validate SAR GEO response payload size

Shahar Tzarfati (2):
  wifi: iwlwifi: fw: validate SMEM response size
  wifi: iwlwifi: mvm: fix read in wake packet notification handler

 .../net/wireless/intel/iwlwifi/cfg/rf-pe.c    |  1 +
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 33 +++++++++-
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  |  9 ++-
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c  | 28 ++++++--
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 64 ++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 31 ++++++---
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 55 +++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 10 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c  |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 45 ++++++++++++-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |  7 +-
 15 files changed, 236 insertions(+), 63 deletions(-)

-- 
2.34.1


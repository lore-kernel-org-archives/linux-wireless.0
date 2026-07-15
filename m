Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0C33B9DB6
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142299; cv=none; b=tVKW4Qoumdsi4JWJMpgf8MzYmXtpM7MaE6PJTHyYGBb9a55YBIWaGHzrObADz+d0PwCNepyplLBpaAARswmMxedGxrseLV6ezws/2Y6CxTRjneYRvXOcTENfqX6ONGh5cxC9OMET5ykepQqvILgx9JWAO7XfYeZjSJnGZb8C0HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142299; c=relaxed/simple;
	bh=Nu3X9+ljQVC+K9NUxzHGEUXEvZs5V/nnvLOEepvJMFI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dA+psBWBUrENT+ZWAev4mSTOV6EXYkaLQ0igbshxD9wzgegzJhKPdcbVMg/qgDHn6CdWPojdeeuo7gLR2QcYexfFrcFVucQ33SUXOR6G7nqSEepR2lbxt+dJFmRE+ReB9h71MsR1oI+3DfmgzsoV8jxdwtZhwb7Lo7AYF2YeKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eC8uQQKv; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eC8uQQKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142295; x=1815678295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nu3X9+ljQVC+K9NUxzHGEUXEvZs5V/nnvLOEepvJMFI=;
  b=eC8uQQKv5nHR+Lxtk2RpObuQZvzz5Q9s5n1QmOsm0yAeuGH/QtxjnLeu
   63DKuBvU4/7vG5jMt9MBckeEbrErj1CtCfayXgBpE23OhuPeWZTGe8jbM
   5n+1OLaE34QhpQyl9JK40fT/Mq2iWIRqNw5oiSXYEgLgdTEx7NorybR2a
   lwFVALjWz2EA8fon/Z7/fia++Hnk3huE4fKBlc9O6bl5jmdcWoQh7u5Ho
   1tMamusD2bNOoh/u/KBnjJ7V7n2bpH29Zv2NnPb7aTHCYKvdBr8eVqEuU
   Oi67RAxr84cEhOO//+v7P7FdSzuzcGrBhHCg5JFXxMBJ1XQZi5l+XS6EZ
   g==;
X-CSE-ConnectionGUID: sRSR2CQoQvaQKhEKvpOUeg==
X-CSE-MsgGUID: S3dgtexYQ0O7fdxn5FL3Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340686"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340686"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:52 -0700
X-CSE-ConnectionGUID: m0E1o2vFSCm9liFxrHVPqg==
X-CSE-MsgGUID: xq+INGpTQY6uvoVfxe30Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851886"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:52 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 07-15-2026
Date: Wed, 15 Jul 2026 22:04:16 +0300
Message-Id: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
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

Cleanups, features, and fixes from our internal tree.

Thanks,
Miri

Avraham Stern (4):
  wifi: iwlwifi: mld: support aborting an ongoing ftm request
  wifi: iwlwifi: mei: check SAP message length before reading it
  wifi: iwlwifi: mei: skip data read if length is too short
  wifi: iwlwifi: mei: pass correct argument to function

Emmanuel Grumbach (5):
  wifi: iwlwifi: mld: validate WoWLAN notif header
  wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
  wifi: iwlwifi: mld: fix validation fallback in iwl_mld_notif_is_valid
  wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
  wifi: iwlwifi: guard against division by zero in
    iwl_dbg_tlv_alloc_fragments

Ilan Peer (1):
  wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead

Johannes Berg (1):
  wifi: iwlwifi: mvm/mld: fix PPE threshold debug print loop

Miri Korenblit (1):
  wifi: iwlwifi: mld: add PNVM_INIT_COMPLETE_NTFY to the hcmd names

Pagadala Yesu Anjaneyulu (2):
  wifi: iwlwifi: mld: honor FW puncturing capability in MCC response
  wifi: iwlwifi: mvm: add LARI_CONFIG_EXTENSION command

Shahar Tzarfati (1):
  wifi: iwlwifi: mld: fix read in wake packet notification handler

 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 26 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  8 ++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 30 +++++++++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.h    | 22 ++++++-
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 28 ++++++---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   | 60 ++++++++++++-------
 .../intel/iwlwifi/mld/ftm-initiator.c         | 21 +++++++
 .../intel/iwlwifi/mld/ftm-initiator.h         |  1 +
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 16 ++++-
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c  | 24 +++++---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  1 +
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c  |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 36 +++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  7 +--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 +-
 17 files changed, 242 insertions(+), 50 deletions(-)

-- 
2.34.1


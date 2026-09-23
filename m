Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A6329E55
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168586; cv=none; b=eqPI1vRbkVtQZCul8yhUqXN1+4Ih74I+ds7ERbbNBsV82+SPw7qKyechEv0UZv2x9PqzuxnvKBN1Scq/B0zE0Mm21uSOOVm7PQzWsBbjVzglPXxZ7x2EqQJngMW8b2nSilr+u9IAy8vOVshJMreGYDDeTuopyQran5FczmjlkIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168586; c=relaxed/simple;
	bh=ZQHYWciTKu4rnifK3vDWMXaxr6Afi4fhHTjPkG0j6Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ak0w+TlDokB4kpzipeZ6dnGuoGogRaXftbyKMyn0ujWg83ZWaNKwnAi1TmNX0vFvU3h57zfpbBrGyybgJSgEurFaxVZidjzGkHVjaNZxPiZr3s1+419SpR67R6lXcAevBx+chspijyiwez9YOb4AorQwVYn7iX+HvFB41L9pCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QNrFbuVb; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNrFbuVb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168584; x=1821704584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZQHYWciTKu4rnifK3vDWMXaxr6Afi4fhHTjPkG0j6Tg=;
  b=QNrFbuVbALLKVYN7JBdp0aJQ9pGCb+d2XxIS/anH7xGkz0aiBdn8nFY1
   eVFZOTIx11CW0mtbvtf6X50E49/NyQEYwfLwrtttcHEXaLHsGV821UNqC
   aeVWPjyyvW68uYNPiW+4DkkCqCmjGdmwN4lQGKdbA7xqA9Vf88p0jvtOu
   qZhP/L2si3ugdfPGe5B5LU319EWlwlhldwOIZD0AKaYnNuxwEuT1TyKeV
   pVuHn3fbs88jYUyxkaD2/dKK5jfu0LckZuK0Y6GgKPe5lrDspXdhim8Pq
   Ew1egMGCnlbH/GS22KghSSZX4g5o+9UowlslF3hImvTo1sybf3ivioGVF
   g==;
X-CSE-ConnectionGUID: 1eI32DjXRnahyy6bnvjXSA==
X-CSE-MsgGUID: xo0ISSl4SOO8LNU5SvWQTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781313"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781313"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:03 -0700
X-CSE-ConnectionGUID: wKo67A/BReq1VbL6z1HWLw==
X-CSE-MsgGUID: 4UVSGlOiSKK+Hkyx+sCR0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4696983"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-23
Date: Wed, 23 Sep 2026 16:04:43 +0300
Message-Id: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
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

Emmanuel Grumbach (1):
  wifi: iwlwifi: mvm: remove indirection_tbl debugfs entry

Johannes Berg (3):
  wifi: iwlwifi: advertise 2xLDPC RX support for UHR
  wifi: iwlwifi: mld: fix some UHR ELR bits
  wifi: iwlwifi: mld: correct EHT U-SIG-1 B20:25 report

Miri Korenblit (4):
  wifi: iwlwifi: support net detect match info version 3
  wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 108
  wifi: iwlwifi: mvm: validate mpdu len before relying on it
  wifi: iwlwifi: support for another device ID

Pagadala Yesu Anjaneyulu (3):
  wifi: iwlwifi: mvm: debugfs: validate TAS response and loop bounds
  wifi: iwlwifi: mvm: fix LARI_CONFIG_EXTENSION version check
  wifi: iwlwifi: add standalone WRSS/EWSS BIOS table loading

Shahar Tzarfati (4):
  wifi: iwlwifi: uefi: add UEFI GUID Lock Indicator (GLUI) definitions
  wifi: iwlwifi: uefi: add a way to probe connectivity UEFI variables
  wifi: iwlwifi: regulatory: use GLUI as root-of-trust for connectivity
    variables
  wifi: iwlwifi: mvm: validate BAID from FW

 drivers/net/wireless/intel/iwlwifi/cfg/bz.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c   |   2 +-
 .../net/wireless/intel/iwlwifi/cfg/rf-fm.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 276 ++++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  20 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  28 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |   6 +-
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  30 +-
 .../wireless/intel/iwlwifi/fw/regulatory.h    |  22 ++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 355 +++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  |  26 ++
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   6 +-
 .../wireless/intel/iwlwifi/mld/regulatory.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  89 +++--
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  65 +---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   1 +
 23 files changed, 758 insertions(+), 243 deletions(-)

-- 
2.34.1


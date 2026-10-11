Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF9A42C4FA
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716722; cv=none; b=s1am9L2kyj2tLM948mCD11/ssj2PnGONkXNGKyugFyvz/m9zhnLBMBmFD9ToKY/Ur/QBjY9Q/+C0NpaZbBbtsoMVG9pmhSWhCIWBx/SoQe6l6jCIKPDN4Co49g/9wVIx122rkbIka5XeCYB+sy1ICMFwn21wiS7AI3SVZH+w+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716722; c=relaxed/simple;
	bh=/xEOS8RHeQ02Wi+oQM5wB0RwbdrtQmWB4H8s0PPMFZE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LoKJXaihMyn64cL3N8nnaSONb4qk2mBRuifjbsB6XSBkEzNpvNXbHD9cOLu5eW4+NsH9d/Et7HAPx7pWz3/5Gh4a3dWGB9zP/XT2kNIv5OUg2ryDzC8Jzn8pZZMJyWb5WyYBYMm2LsUXsk6zWwtmyCLyX/+8HipJRDbETg2+VQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWwH7Crr; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWwH7Crr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716720; x=1823252720;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/xEOS8RHeQ02Wi+oQM5wB0RwbdrtQmWB4H8s0PPMFZE=;
  b=RWwH7Crr5iIA051lnlyEvxMeCw2HXXkDflkLpxbutIdgCkMIQS+LNPeg
   Jp2M7m8B/t3JMvi8bvx50BqFCd0oeBJ4yBb3/+k0h8RO4dqGbBLhC+4dI
   XD+do/PwmYbcKTCaab/bQj09GpPQazT0+ssnJDiKapfeLw24DgDZNuZfy
   OmUTHx6efFMQPqG7bJySlGgexC80MedGXtj9sYC59AsvvxHX/iYLhQk5T
   b11uR2YCYju5Y8a6Mw2RNN+havyIvWCZReoxIwjPo0+E+DbBoO70jjklG
   vO/yd8tjcHjowgmVTmZiBf12HO3WBu3eC/gt3XkgOhMcZfacE6xnyPeVc
   w==;
X-CSE-ConnectionGUID: MZtn2AnJTtinnEEmHcJfIQ==
X-CSE-MsgGUID: wB50gdN2T4W4N+UiRFpflQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454166"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454166"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:19 -0700
X-CSE-ConnectionGUID: GfU0QzueT7mvUE+nniQaSQ==
X-CSE-MsgGUID: FQkKr4J6TeCddrZ6m1Evdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650909"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:17 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/13] wifi: iwlwifi: updates - 2026-10-11
Date: Sun, 11 Oct 2026 14:07:01 +0300
Message-Id: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
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

Thanks,
Miri
---

Emmanuel Grumbach (2):
  wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware
  wifi: iwlwifi: mvm: remove dead sta check in rx_monitor_no_data

Johannes Berg (7):
  wifi: iwlwifi: fw: api: fix D3 sequence counter docs
  wifi: iwlwifi: pcie: correctly read WFPM_OTP_CFG1_ADDR
  wifi: iwlwifi: mld: avoid const in iwl_mld_chan_load_update_iter()
  wifi: iwlwifi: mld: fix const in iwl_mld_mu_mimo_iface_iterator
  wifi: iwlwifi: mvm: fix beacon flags compiler warning
  wifi: iwlwifi: mvm: uninline iwl_mvm_ftm_start versions
  wifi: iwlwifi: support SCD_QUEUE_CONFIG_CMD version 4

Miri Korenblit (4):
  wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 109
  wifi: iwlwifi: move context info APIs to a separate file
  wifi: iwlwifi: mld: don't enable RSS if there is one queue.
  wifi: iwlwifi: trans: remove the unused write8 operation

 drivers/net/wireless/intel/iwlwifi/cfg/bz.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c   |   2 +-
 .../intel/iwlwifi/fw/api/ctxt-info-v2.h       | 328 ++++++++++++++++++
 .../wireless/intel/iwlwifi/fw/api/ctxt-info.h | 185 ++++++++++
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |  22 +-
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |  20 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   2 -
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |   3 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c  |   4 +-
 .../net/wireless/intel/iwlwifi/mld/notif.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |   4 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         |  49 +--
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   4 +-
 .../intel/iwlwifi/pcie/iwl-context-info-v2.h  | 320 +----------------
 .../intel/iwlwifi/pcie/iwl-context-info.h     | 177 +---------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  20 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   3 +-
 20 files changed, 607 insertions(+), 557 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/ctxt-info-v2.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/ctxt-info.h

-- 
2.34.1


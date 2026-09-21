Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226E0439F88
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023174; cv=none; b=omavs2iBwuXdwN10sS+6Psw5YqlCIrUeuw9CXBNW5H9GUCBQCTl0bMJJjiH4V46eNHo3yhSwpreHYfoCRY6U0D5x41rE/QXVL3gYYxqMaVJy5uMmpuqgbyjJujhPyuMcq31iDWOYUp4MI7/GAilmHTzrUBsAARidknrxsSqrAYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023174; c=relaxed/simple;
	bh=VnQfnH43K7duMERG9nBMsG1yzQ90+K8HvBQb78iBAnU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I3uTP1zrrQwmi78cUcI1oTXoHn2E7TEd0o3Nbqr28IvIXpDfZDrtdoe4rbxQjZzrr0pQwzXcGrL4r1eniRjVhG8MBikrdTCKykZt23OC9G9S1bmuWhR7akdTu7Pab2jNyyPO+LefI7sKICjWJP09C9j5FRYDFdNU/vCiPE21fwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XI+go16G; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XI+go16G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023172; x=1821559172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VnQfnH43K7duMERG9nBMsG1yzQ90+K8HvBQb78iBAnU=;
  b=XI+go16G0hwVaBKJz1FdPyADZNAlhh9KUgxqUsyWwQLKIoZt8hYemVZw
   irpRz4cLzfccbOnW0CLMEeCSD2DEYCZgfEOXMR6Zw0XcdMr0aGAvEG988
   avT9MIcP1BKjY0wRF+bHMI4GOSL+OuTM6NL5NLA8gN2E3aM98vDjKh2WF
   MVuA/s97M9dL6rnLJEXCMefB57WP/AMuJQW/JbPJ0xVemNio0jwA5kf9z
   6y+PX2KJ0WAjP8omF2pgxiqjLQsXRlqnDoc4ONp6curBwkXMfQHP5SEJ9
   kqkZyceFz8N87ncDuZYmB8nuvBdjHJncBXsbx1oh4Xl8WgHCNZS9pDmkz
   Q==;
X-CSE-ConnectionGUID: IgnA0SkXSZKW12MaXM51rg==
X-CSE-MsgGUID: Nv6YGrtqQlaIYgBvoPhhYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128765"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128765"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:31 -0700
X-CSE-ConnectionGUID: tPdWweVZRg6P46R8UgPApA==
X-CSE-MsgGUID: zLq04hfQRv+k8c0LeTUprA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761910"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:30 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-09-21
Date: Mon, 21 Sep 2026 23:41:10 +0300
Message-Id: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
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

A bunch of features, cleanups and fixes from our internal tree.

Thanks,
Miri
---

Avraham Stern (1):
  wifi: iwlwifi: mld: config TLC only after attaching station to a link

Ayala Beker (1):
  wifi: iwlwifi: mld: remove NAN keys before removing internal stations

Benjamin Berg (1):
  wifi: iwlwifi: document MIC delay resolution

Emmanuel Grumbach (6):
  wifi: iwlwifi: mvm: wait for 6 missed beacons before disconnection
  wifi: iwlwifi: pcie: validate txq_id in txq_disable
  wifi: iwlwifi: mvm: remove SRAM access through debugfs
  wifi: iwlwifi: dbg: validate dram_alloc_id from debug TLV
  wifi: iwlwifi: mld: explicitly include mld.h in hcmd.h
  wifi: iwlwifi: mld: explicitly include ieee80211-p2p.h in mac-cfg.h

Ilan Peer (1):
  wifi: iwlwifi: mld: Add support for (Re)association req/resp
    encryption

Miri Korenblit (2):
  wifi: iwlwifi: mld: don't use bss_conf in NAN
  wifi: iwlwifi: Don't allocate a DRAM buffer with an invalid ID

Pagadala Yesu Anjaneyulu (1):
  wifi: iwlwifi: fw: add Google-ASUS TAS approved DMI match

Shahar Tzarfati (2):
  wifi: iwlwifi: fw: fix integer overflow in INI dump size calc
  wifi: iwlwifi: validate TLV length before reading fields

 .../wireless/intel/iwlwifi/fw/api/datapath.h  |  2 +
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 10 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 46 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 +
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  6 ++
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 50 ++++++++++----
 drivers/net/wireless/intel/iwlwifi/mld/hcmd.h |  2 +
 drivers/net/wireless/intel/iwlwifi/mld/key.c  |  6 ++
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  4 ++
 drivers/net/wireless/intel/iwlwifi/mld/nan.c  | 35 ++++++----
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c  |  9 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 68 -------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
 .../wireless/intel/iwlwifi/pcie/gen1_2/tx.c   | 12 +++-
 14 files changed, 146 insertions(+), 109 deletions(-)

-- 
2.34.1


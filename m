Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D433389E1A
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778787891; cv=none; b=uI08ZgoP1b86id2IIKquxiKMnq0Kkgn8MrvMXnpiFwGb7vKFfNV/RdTAgcXggQbIh8LWKMSbbD7LOlnIKS1326RBvg9CKGPFTBxJsrFzu/L3kDLFuZdpiGTM5iLRe7ZntUtszbVbHQHcbw+LQ4QOC6gDUAAAzll1xkSrP3qmp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778787891; c=relaxed/simple;
	bh=q13KuHYi9IHUi3Pjmb+fZsIcryLTCkVmI5xjEAMcgsU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=FC7ZJp0imAs4Jiu7KT9N+EUmz3IvvmQTRtRwmuQK5irtVC3O48GSkxT+zBk/Wg3w8ImL9x9NT2VJzJ2EEmthj9QyoJ3HJh2JHgN3JnPsxehQAoHG75KBE/OJjym15ZNZjxXf8bH/nt9ZumD9haHm0Z+zOY3vRV1pILKplNJr+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UDoFTfpa; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UDoFTfpa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778787890; x=1810323890;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q13KuHYi9IHUi3Pjmb+fZsIcryLTCkVmI5xjEAMcgsU=;
  b=UDoFTfpaYJxUlcqB+BZTfvIIsCTGd9hXmcSkaAjnpU10KSMyrK2Y1/la
   LWWOyS2smMNz4z8oLYj/9k5PuY/9qD8tyF1eVR48OwwWDy7nLHMJfFOH+
   sUhzyh+Gp4eH1rnwBhx71FWcs8SYESYDLxuD7oqF0+/BDpeYSri4hQJFa
   08etvvjj8MnMo6CQwaFXNdauSAViFkt5TWr0i7PRrEYEfERPxCvZ/Zppa
   53V1OyZ1W3/6rFRSe5S96UwnqP+pmeWXa1YclqaHKGofQUCcZaClGmKdz
   hQmxisVPfWAZyk8LpdGryquHhnditoWLHfEPqdJteV12TJ/3A+aUiw/mV
   g==;
X-CSE-ConnectionGUID: LgRgsAH6Q/67/cY/Q9Ficg==
X-CSE-MsgGUID: /oyxSEY2Q5C5heawwZDP6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="83352571"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="83352571"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:44:50 -0700
X-CSE-ConnectionGUID: 5v6NnHBsQfqes+qt3nZpqg==
X-CSE-MsgGUID: 3ZSixSoxRtGhh4OZlASBpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="237616232"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:44:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-05-14
Date: Thu, 14 May 2026 22:44:19 +0300
Message-Id: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
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

features, fixes and cleanups from our internal tree.

Thanks,
Miri
---

Avraham Stern (2):
  wifi: iwlwifi: mld: nan: add availability attribute to schedule config
  wifi: iwlwifi: mld: add support for deferred nan schedule config

Daniel Gabay (1):
  wifi: iwlwifi: print UHR rate type

Emmanuel Grumbach (1):
  wifi: iwlwifi: reduce the log level of firmware debug buffer size
    mismatch

Ilan Peer (1):
  wifi: iwlwifi: mld: Disallow using a per-STA GTK for Tx

Johannes Berg (7):
  wifi: iwlwifi: mld: add UHR DUO support
  wifi: iwlwifi: mld: implement UHR multi-link PM
  wifi: iwlwifi: mld: rename LINK_DEBUGFS_WRITE_FILE_OPS
  wifi: iwlwifi: mld: add link and link station FW IDs to debugfs
  wifi: iwlwifi: api: remove NAN_GROUP
  wifi: iwlwifi: api: clean up/fix some kernel-doc references
  wifi: iwlwifi: pcie: add two LNL PCI IDs

Miri Korenblit (1):
  wifi: iwlwifi: mld: evacuate NAN channels on link switch

Pagadala Yesu Anjaneyulu (1):
  wifi: iwlwifi: mld: disallow puncturing in US/CA for WH

Shahar Tzarfati (1):
  wifi: iwlwifi: mld: expose beacon avg signal

 .../wireless/intel/iwlwifi/fw/api/commands.h  |  9 +-
 .../wireless/intel/iwlwifi/fw/api/location.h  |  7 +-
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 33 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/rs.c    |  5 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  1 +
 .../net/wireless/intel/iwlwifi/mld/debugfs.c  | 53 +++++++++-
 drivers/net/wireless/intel/iwlwifi/mld/key.c  |  6 ++
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 10 ++
 drivers/net/wireless/intel/iwlwifi/mld/link.h |  3 +
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 97 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c  | 13 ++-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mld/nan.c  | 60 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/mld/nan.h  |  5 +
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  4 +
 .../net/wireless/intel/iwlwifi/mld/stats.c    | 47 ++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 +
 .../intel/iwlwifi/pcie/gen1_2/trans.c         |  8 +-
 18 files changed, 344 insertions(+), 20 deletions(-)

-- 
2.34.1


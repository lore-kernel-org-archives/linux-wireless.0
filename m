Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC022DF3FD
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2026 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773946152; cv=none; b=CGy4dj63Hg35FIkcU9Wx/81GSA11o7Ih94poeM87mb4vufkqsRTwrpL3b7CJ7WelEp6oSrlmO20G5fX8QzEZgkVlN7qFmEb6Is2Ljn3fQRJWWwu88mehwGlUnoXap/3wO/JlUfSgtwHJ5LS9eYsqxibQXA4ixCgQtAnqjlzsmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773946152; c=relaxed/simple;
	bh=bLL8EeLY++OSoO/LgdW0A7UfjHKTvSwvBOUZfTBNy6g=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=OMK6aht7LlClyUUnii8McEosVR+GZKPJYHA15z/yMHfVM5ZvKMnf29x95ODRh6szpVlL2SKSuWe3UGL7QAlf5DUUBW1Y/hJr2q19Rsc5i4KiENX58n44JAF+Lcv7jDyEVuLW99zC4K713peAEO6bKAd1FAGQ/nrSjELnHM8tBR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKCmerSG; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKCmerSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773946151; x=1805482151;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bLL8EeLY++OSoO/LgdW0A7UfjHKTvSwvBOUZfTBNy6g=;
  b=kKCmerSGjvGSeYyp5++6PNNH+qtSAApCzYGBJ9nPv/oAS+fjTRjaeFM6
   YHkv7pfbGLXrtBskbP14Ybiy0I3BdRkGwGMrX03JIPseb8P8+/uKbJsQX
   GerKBcvdwmkYp5MgNrxY2ppKkuopYZyFxJpwb9NFf/RwIfA6AuuElHqR4
   Z5gLkRepzLx87QpjXeE7SthwtEzHqF9iL3TPZ7giiiWAuap/GSMH6zKw3
   zFGOfiBlUtWkPTCjK8CIRR1dRLBbP2DhEI91yFBpcANLCfx2TgnPAydz/
   JSovgIpGEw9HrqYdFVXFLvnHmtzL6ocRN0IXaM5EgNr9TND1tw9xwMeoo
   Q==;
X-CSE-ConnectionGUID: hRl/caR2QZ6acO7isNltGQ==
X-CSE-MsgGUID: 8evbMd7fTKmbDigar0C78Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="85656464"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="85656464"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 11:49:07 -0700
X-CSE-ConnectionGUID: ukU4PHy+TsKlEgvLkQirMA==
X-CSE-MsgGUID: 60k09BnKQH+EYNb/n0hWmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="227998474"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 11:49:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates - 2026-03-19
Date: Thu, 19 Mar 2026 20:48:40 +0200
Message-Id: <20260319184855.1981384-1-miriam.rachel.korenblit@intel.com>
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

features and cleanups from our internal tree.

Thanks,
Miri
---

Emmanuel Grumbach (14):
  wifi: iwlwifi: uefi: add support for PPAG table rev5
  wifi: iwlwifi: mvm: zero iwl_geo_tx_power_profiles_cmd before sending
  wifi: iwlwifi: uefi: support the new WRDS and EWRD tables
  wifi: iwlwifi: acpi: add support for WRDS rev 3 table
  wifi: iwlwifi: acpi: add support for EWRD rev 3 table
  wifi: iwlwifi: mld: support version 11 of REDUCE_TX_POWER_CMD
  wifi: iwlwifi: uefi: open code the parsing of the WGDS table
  wifi: iwlwifi: uefi: add support for WGDS rev4
  wifi: iwlwifi: acpi: validate the WGDS table
  wifi: iwlwifi: acpi: add support for WGDS revision 4
  wifi: iwlwifi: support PER_CHAIN_LIMIT_OFFSET_CMD v6
  wifi: iwlwifi: uefi: mode the comments valid kerneldoc comments
  wifi: iwlwifi: remove IWL_MAX_WD_TIMEOUT
  wifi: iwlwifi: mld: remove SCAN_TIMEOUT_MSEC

Johannes Berg (1):
  wifi: iwlwifi: restrict TOP reset to some devices

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 101 +++++++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |   7 +
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  29 ++-
 .../wireless/intel/iwlwifi/fw/regulatory.h    |   4 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 210 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  | 133 +++++++----
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   1 -
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  10 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  18 ++
 .../net/wireless/intel/iwlwifi/mld/power.c    |   5 +-
 .../wireless/intel/iwlwifi/mld/regulatory.c   |  64 +++++-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   4 +-
 .../intel/iwlwifi/pcie/gen1_2/trans.c         |   2 +-
 15 files changed, 468 insertions(+), 124 deletions(-)

-- 
2.34.1


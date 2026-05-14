Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1A03B6344
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778787909; cv=none; b=GBMimVVV7wPeyipWQtpAce5PSKm85A6CBis7ywK6SprutT4CfYCRUxaQ2+qZFtHeexEjhpL7I1nWVhTzJPHemJOEptIUC3i17QZGeiunOsErCAiADCBPPiv6LUH5HQ+rWMjJl/j9bWy1CTdEj/F79nbrVVHe2wEjhz3JnQg//uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778787909; c=relaxed/simple;
	bh=75ROxb1uiyCqVutGTVVrEAXNZA5DckGYg5JONs791BI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2cSUYYOaPb3Mqw+LpAC4Mn8IiyFdAy9/KwPHenCKZDcL5+1+emPDPEs9er6GGClYi+7J9/bi1Vt8pe8wqtB6IsoYhGxTLGajxzaQDMrpMT1Nuv1GcLJWFVY1KDJVES2gxsE3+nD0fWtEX2l7v6i8qAlpmKncxcmR+lI98q+DMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxE4bsor; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxE4bsor"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778787908; x=1810323908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=75ROxb1uiyCqVutGTVVrEAXNZA5DckGYg5JONs791BI=;
  b=MxE4bsorbaNOJkIfY0k+UBUt8lV8SDX70FKTXpqrozWJvCqMh1aeK70y
   TsZUeWncIb95mLuOy/KXxuDOOrZoXmvrTwRFaTroScgJb6YvgvL3CeVDn
   s3je5nGvJit3JpiVcmTnxVmXZH19c0NhF4ZfMatwi9LbUjEuABnb/mODr
   KgF8048JDfaGB4p08LXDYUAmn4tu3RYkgn6f+5BttdQSh0OW8Ij3w+L3r
   HE+AAaxHXuqRiBH5DKNtcS33D7c8Vw5auZdKT1Ps/KmGkvZEtCXdx8jJF
   PllfkeEC9cIOzQ2ZqCqXzXNZb3SCt0hlw123PXC0PqqJBdrmMPZK1+mzG
   g==;
X-CSE-ConnectionGUID: 7/KXVpNCRoyrwQ6AWlb2ew==
X-CSE-MsgGUID: DU5+KUNvSkuR63awdrRkZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="83352615"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="83352615"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:45:08 -0700
X-CSE-ConnectionGUID: QEy4PCMkRSCAPM+Y2pKXXg==
X-CSE-MsgGUID: HT+hlzksS2y+J8qIEJZAjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="237616370"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:45:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: pcie: add two LNL PCI IDs
Date: Thu, 14 May 2026 22:44:32 +0300
Message-Id: <20260514224230.d2e3c380227a.I791eef3dedc11a8b246ce3130a34018886e63d3f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
References: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add two PCI IDs for two WiFi-7 BE1735x Killer devices (these
are CRFs) so they work when put into the LNL platform.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fdafbad506a7..b0c59181907e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -537,6 +537,8 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA840, 0x4314, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1775, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1776, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1735, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1736, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x4D40, PCI_ANY_ID, iwl_bz_mac_cfg)},
 
-- 
2.34.1


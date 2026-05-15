Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EE0478E53
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847022; cv=none; b=p9Zfuee/Vaa2dQWvMuOyBwIQZ7eR0KxkSbc3tWuPkNZu9jNKuBu8P7XQeFzMeWx61a4nlTTbRMDd6M5CDPLopacsITYBt0DiL3rZzP/VDK87if4jo5uHAd95X8utjPXTyiIcspQn/0pDG2GRT0EUeIYE0634PzK932Z2tP4/19c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847022; c=relaxed/simple;
	bh=75ROxb1uiyCqVutGTVVrEAXNZA5DckGYg5JONs791BI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bVfUD5f0nrWmfAnreYQlUP3yCiIjbhiDeVh9uknRbJCpvr2jpTfDGqhM4LgMX+UlUd/gJ3z7I6ZfPOL7/Ql3hviGU4/wsmwGNt3Yk80yjow51WNKIFfPF/Rh6Ni9cbVn/GBsa85FVY7rOE3AEq6Kbw4yOVXCIeeKLPA4zFQuaqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0wOojsL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0wOojsL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778847021; x=1810383021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=75ROxb1uiyCqVutGTVVrEAXNZA5DckGYg5JONs791BI=;
  b=O0wOojsLx3TJb5w+zOfk5txXQiPHSKzHaEtjd6rGpgmAhXNDVDDGf2/i
   RTGRF3MalM5Yt5gqiiZ9jVRLmJdQ0X/ofRksqRT5tK9r0YO3hZAwdcS+2
   fxdNvXKqCZT8d7YDnMOfAJpq80883weP6bNSE8K1jDRNlJJfQNUAHP6LH
   OLDG9LxjuwE+Gj+G5YSVoFpq9h17Vs4FYiRgq0eE3wvYjvTQS9nPy/b18
   O8Xpq+6xkBqHBO19++7r5ApHxOJfg1AkGwFtPiEO/GR/VbUVRf1nSOYX8
   xmd9r6ovbBXvwTv9Jr0fIFuHWVRskERXTMwuDFmssOuuGC66XtS9cUiX5
   A==;
X-CSE-ConnectionGUID: SercRauiRDOFY+hIFhBoyA==
X-CSE-MsgGUID: pGOiTNE9Rz2RDb3lDFJt8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="91185689"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="91185689"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:20 -0700
X-CSE-ConnectionGUID: SoJY9H7HSWqqWPDWt9tg/w==
X-CSE-MsgGUID: N+NIpK6VSYWrp6z+JZLUGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="243650063"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:19 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 13/15] wifi: iwlwifi: pcie: add two LNL PCI IDs
Date: Fri, 15 May 2026 15:09:46 +0300
Message-Id: <20260515150751.d2e3c380227a.I791eef3dedc11a8b246ce3130a34018886e63d3f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
References: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
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


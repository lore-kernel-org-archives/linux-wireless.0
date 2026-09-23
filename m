Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8665172C2
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168590; cv=none; b=bIz/aOSATg0Kvj1IVHWkC/0gv8PEURIYjmnQ3UDYOMocIPwaG1OwlqAILpNrqe8D1Y2K/LM/QGsvN9IAmxmDsOQCfVVVRkg0WayaIqH4LhLz6RROt3i9J5qSrnM/J+u7qJHK3Rvlai2E9QPNX7v8uNe2MVn0zy+IstMm/+yHL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168590; c=relaxed/simple;
	bh=dsmJFNmOq1WAZyxAUUQ0/HZboJo0ERElDm+J0fteFXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QwHLQMIYpK1O3KPbead3F1mTCZK6RgZBWFiybglpWDFH0Lb21/7TMk9yhWmJ5xbUsjSCr7yDBWDAJEmKEcrvIQZjMB3UxLuqyQZ+vk97CIeYrguMZ2vgCHeNSy9HyNfp7sZb1LgcmewyXdVCQDDUpWf+q6qrrKdx2frfsP/xfYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TIPmlQKv; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TIPmlQKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168589; x=1821704589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsmJFNmOq1WAZyxAUUQ0/HZboJo0ERElDm+J0fteFXI=;
  b=TIPmlQKvlUvrrrpuoxFjeraXMy1GteUyXixJiyQLTEAXxYKcACgmWNs9
   deRyjoUO/6aynSDxZkPhSlF0OmATFFcOuGn/szgyuikbo+z8ArA2YlBgV
   DLwhqhR348uKJQcdTUXAERPAQedHnEfAIDXQLb1aa0ZmPuKvNEXaSUSwR
   0K0P7NqcFwHTaXgqsTn7yCfsjnyVjQIKW4R2qQy6neRY7aLW8JYa6pUi2
   HTaN0F6r1i6z362TUIfTTB7vC8MUeC9Jcye+gcKDqfzi/b6ti/KN3cuIQ
   XQHGwh4OY8v+luYukvgbviHpElXVUvLj8Bg9Nw35jVuNGmAPwvBSdlqJs
   w==;
X-CSE-ConnectionGUID: swsOd4bYRIGVX5OLcnW8PA==
X-CSE-MsgGUID: mQ1eJ56FSw6Ddpikgx40fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781322"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781322"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
X-CSE-ConnectionGUID: KtK0FWiCSWC1Q2wi0fQ8EQ==
X-CSE-MsgGUID: wFG6KEx7RYWSMMpnM+sgRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697021"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: mvm: fix LARI_CONFIG_EXTENSION version check
Date: Wed, 23 Sep 2026 16:04:46 +0300
Message-Id: <20260923160318.27693f88a8d7.Id6a4b91938cd7758c2be3b98379f1057e574cdad@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

The version guard used `< 1` instead of `!= 1`. With `< 1` the
command would be sent for any firmware version >= 1, including
future versions that may have a different structure, which could
trigger a firmware assert due to a size/format mismatch.

Fix the check to `!= 1` so the command is only sent when the
firmware supports exactly version 1.

Fixes: ebc246e1d5a3 ("wifi: iwlwifi: mvm: add LARI_CONFIG_EXTENSION command")
Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 43a7230f1ab4..06f3b065914b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1526,7 +1526,7 @@ static void iwl_mvm_send_lari_cfg_extension(struct iwl_mvm *mvm)
 	u32 value;
 	int ret;
 
-	if (iwl_fw_lookup_cmd_ver(mvm->fw, cmd_id, 0) < 1)
+	if (iwl_fw_lookup_cmd_ver(mvm->fw, cmd_id, 0) != 1)
 		return;
 
 	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_REGULATORY_CONFIG, &value);
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BBB47253A
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246384; cv=none; b=hPhjeAlcENYPS6hO/4radI4IKgbsgEdGv5/SbHpe58s4TsB4zFHMBBcJpWJKvLAyAf6DTNBBkcrvn8oXYVI5pE9Kg8GVlLD1uB9b4Ibs9nOlwHX/O/eZoBKuhkT9lsl76gbIQJ0858irrcm0hKRRnza7wUGnzF80CwlAjIe6Mk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246384; c=relaxed/simple;
	bh=BrnqEO9b38AKvi13ptohhwS6WVgh+u6ygqWczdWtJ1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fprOrpRBoOHod/s4uu0+zW7DpjOPCtxfn0EI/y/JvNt7qvG38GGZ5dcoRhWz0JQpQ/Y8i7NGJtnkuO2b98G5jKg8wR+4Sb2xjvEL7Fl1ocBSYhOEeLux+qxXPEXDPNyMnwYTyUm9RjCDuDH5Hg9qJcHR5iZhIqd9quuoa3rFPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F2ixI8yT; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F2ixI8yT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246383; x=1821782383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BrnqEO9b38AKvi13ptohhwS6WVgh+u6ygqWczdWtJ1g=;
  b=F2ixI8yTFjh1e3/HHTasNhWHG0fjOo2xMmt8wB6UWxeUfQnMN9GTB7Pc
   sp/DR9aTjniRL/iTnUjZyDC5eHEJ7Bq5d3ggRzxM005u2yxiLH76sazKN
   dGz4Tu6fnCIDYivUoZnxeEg/hkHMpNiv8hF3F9wGDOICSv0YFpx3HiE9Y
   qp9ByXGIXtRjlTGR0e9845obT/bxKZ0jkhpeR+YupkJHScrT/mqkMotAX
   61CpUTY1adtC8SAJLoTcVPGY3NbXxX9hPX/0XFuvigPUCScKSScImVZKS
   WamGHyhhgCPKxmTtjYkjWHmOT2scShhujJDsISGMnFmDVvqft/kc9D9F8
   w==;
X-CSE-ConnectionGUID: u5LICmDCSK2M3EsVLJY+fg==
X-CSE-MsgGUID: KGUeFODmSL+b0X51QWbtzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134880"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134880"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:43 -0700
X-CSE-ConnectionGUID: 0WvF3pAiTFaPBqtu4CoakA==
X-CSE-MsgGUID: tO/+EL+TR4+xU/4qS2HPUQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: fw: add Samsung to TAS and PPAG allow lists
Date: Thu, 24 Sep 2026 13:41:21 +0300
Message-Id: <20260924133942.208e0c2f85be.I18a7292b5a8bd878d074b114b45ce99e1309897e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Allow platforms reporting the exact manufacturer string
"Samsung" to use TAS and PPAG, while retaining the existing
Samsung Electronics entry.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 27a5804dbd73..c7de45323935 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -49,11 +49,16 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 		},
 	},
-	{ .ident = "SAMSUNG",
+	{ .ident = "SAMSUNG_ELECTRONICS",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD"),
 		},
 	},
+	{ .ident = "SAMSUNG",
+	  .matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Samsung"),
+		},
+	},
 	{ .ident = "MSFT",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
@@ -126,10 +131,15 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 		},
 	},
-	{ .ident = "SAMSUNG",
+	{ .ident = "SAMSUNG_ELECTRONICS",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD"),
 		},
+	},
+	{ .ident = "SAMSUNG",
+	  .matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Samsung"),
+		},
 	},
 		{ .ident = "LENOVO",
 	  .matches = {
-- 
2.34.1


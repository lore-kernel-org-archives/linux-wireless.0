Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC90E28DB55
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442948; cv=none; b=irqrqSBd5MnmG5PYWdOaOZBSkDT90GCARNGzoojgQdRR5ZMU0+NcoSPd8XF2WRraafcok1NE5qGIhngJwQPuI6tiUE/fT0HCqYsusnLytQsPBrGACnvAnDLtmDhl+62WWxMX1RIyvXXi1Enwvc7u5Gbs+MOpfSlffFGhO7PRt6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442948; c=relaxed/simple;
	bh=BrnqEO9b38AKvi13ptohhwS6WVgh+u6ygqWczdWtJ1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YFEPXNlyZvfVJ01PfHNLUvt4obxACN5ntq0uTXBE1+fckc+4wwieuTWza/2JL+xlyn51Ga34CsBMFHsawAtFTxY8zrDIl6LjKMcpuVwQmbYGROGWjVRPIdlufoDWTwgeMRgeGdf+QzJQ85eSBGlTWY1k8+Sm1lGtBPlbOaJVFEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWXLTzQN; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWXLTzQN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442947; x=1821978947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BrnqEO9b38AKvi13ptohhwS6WVgh+u6ygqWczdWtJ1g=;
  b=PWXLTzQNx1YMx4VWBNrswT82c4/XFtSvYVnI1o3kZCBGXewKBc9cbrAR
   /4Sa8TGceZY3FoSOS74THRwnRvu+Nh9SXJrPPy66gGniHQ6hbYzXnmAaG
   7DPhUYM2C2QMtCGhEMZzO+daNM/KJUXmwTEbkmMwffnYtRg51c75+/lNq
   pxyD1AVeau+HumId8L1vmDUZUn7v3IK5jVapfwprJtkEPaBKgAb39ILwf
   Cq+0zNvZUOBmyK665hR+cuxSh7dh+sLGhUaqm6+93k17CvPCiW1MMCES1
   AWO/0895Bi4m9Fn6boAVqa40YCsSeVWXbavFs/8ThTaDKh+3iz2BQ3A02
   g==;
X-CSE-ConnectionGUID: TFnhW42FRXOS4ROmsv6oPQ==
X-CSE-MsgGUID: aCCqVUSYSjCliHOJscpa8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533284"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533284"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:47 -0700
X-CSE-ConnectionGUID: Gj7J6iecRgud0EqNI5o1Ng==
X-CSE-MsgGUID: vqiCxZVAQ/uGwjOqeSw6Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196978"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH v2 iwlwifi-next 07/15] wifi: iwlwifi: fw: add Samsung to TAS and PPAG allow lists
Date: Sat, 26 Sep 2026 20:17:26 +0300
Message-Id: <20260926201527.e2e2e1f720af.I18a7292b5a8bd878d074b114b45ce99e1309897e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
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


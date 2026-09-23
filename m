Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA451FCA9
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168596; cv=none; b=XnkbvJgMb2kQkl+oDKbxMtum9ndvGj3kHYtFYxxuTUlJT3ytUvSgpolLMkA7iuSI4xV4rggh3ADzQ+HV4PetzZfMm+JA5D9avqRzWKJhTXNCSv8W9jwEB6dT20G7MPC7kYvttH/CZ59UAdX1Yav9IkW/0eHlJ5Nf5EqA+4wAbwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168596; c=relaxed/simple;
	bh=JKyN80kYeo4ezmjywk1O8YvwtEaQrg9oBaxKBmT3yJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fy245FKNXGGNirb2dU0EAJcdfxtbvjbZ8cO2PfXwz/d49S3D1KrOev8/5CdtlJeEi3kV55IkCNo30OK52Q9jcToIXCg6Yxqq4isAE7x9qr5/RUCApikBSvEjDC+XlD0fQrzbbZgKHwv72QrQ8z0X89TvAfeJuIaeCQDeS+D3M2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVnIHDhi; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVnIHDhi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168594; x=1821704594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JKyN80kYeo4ezmjywk1O8YvwtEaQrg9oBaxKBmT3yJ8=;
  b=FVnIHDhicP2QuDrd8es6i+nk6OQUYJMoeEeYk+pRo6ueNXqShAHbn7hS
   xUIwb803aPNfXcfdiLGw43R7irHxtatyls3HdfkjghFyqmPl6KuTCjIOZ
   y/kS+QTALLwOX8ojvKAHzdGPfYRMjvBXr4rSk2U3d+g+ic1INXLlsI6KE
   8BnHrmrzB4H9lO2d8/ZcOanMBcZVBH47A/BGTLabQywIrf4SzFDBtlzyS
   uY0+sVxmNwaeX0mSK8XnBJ40Q05haRWcuBT9SDW01OI4P5l5YHRIySEV1
   WFiMOFU1ARbK3AOncIKZEFJzdhiDWnQoTteJtleyFbrcYz00wzNLdvVeE
   A==;
X-CSE-ConnectionGUID: My7dPb20QOOn2pkMDDgUew==
X-CSE-MsgGUID: hk2+qJpvSDWxs31pW9dbTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781334"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781334"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:11 -0700
X-CSE-ConnectionGUID: hg1dOcmLTgOn2+tftm5mwg==
X-CSE-MsgGUID: 1ONr3XrYT+6QHQBNYbHYBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697066"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:11 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 108
Date: Wed, 23 Sep 2026 16:04:51 +0300
Message-Id: <20260923160318.61c292103e38.I0e2918e21f8a20d200d371c1861ed2c5deac829d@changeid>
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

Start supporting Core 108 FW on these devices.

The BZ/FM combination is frozen on Core107 (while each of BZ, FM is not
yet frozen and is still supported in other combinations).
Indicate this in the relevant FW file mames, for modinfo.
While at it, remove names that are no longer needed.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c    | 8 +-------
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c    | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c | 4 ++++
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c    | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 1099d8cfe6aa..3cc3ffd0aa1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -10,14 +10,11 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_BZ_UCODE_CORE_MAX	107
+#define IWL_BZ_UCODE_CORE_MAX	108
 
 /* Lowest firmware core release supported */
 #define IWL_BZ_UCODE_CORE_MIN	102
 
-#define IWL_BZ_A_FM_B_FW_PRE		"iwlwifi-bz-a0-fm-b0"
-#define IWL_BZ_A_FM_C_FW_PRE		"iwlwifi-bz-a0-fm-c0"
-#define IWL_BZ_A_FM4_B_FW_PRE		"iwlwifi-bz-a0-fm4-b0"
 #define IWL_GL_B_FM_B_FW_PRE		"iwlwifi-gl-b0-fm-b0"
 #define IWL_GL_C_FM_C_FW_PRE		"iwlwifi-gl-c0-fm-c0"
 
@@ -92,8 +89,5 @@ const struct iwl_mac_cfg iwl_gl_mac_cfg = {
 	.low_latency_xtal = true,
 };
 
-IWL_CORE_FW(IWL_BZ_A_FM_B_FW_PRE, IWL_BZ_UCODE_CORE_MAX);
-IWL_CORE_FW(IWL_BZ_A_FM_C_FW_PRE, IWL_BZ_UCODE_CORE_MAX);
-IWL_CORE_FW(IWL_BZ_A_FM4_B_FW_PRE, IWL_BZ_UCODE_CORE_MAX);
 IWL_CORE_FW(IWL_GL_B_FM_B_FW_PRE, IWL_BZ_UCODE_CORE_MAX);
 IWL_CORE_FW(IWL_GL_C_FM_C_FW_PRE, IWL_BZ_UCODE_CORE_MAX);
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
index a89a2c75687f..f6dd1f9733fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
@@ -9,7 +9,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_DR_UCODE_CORE_MAX	107
+#define IWL_DR_UCODE_CORE_MAX	108
 
 /* Lowest firmware core release supported */
 #define IWL_DR_UCODE_CORE_MIN	102
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
index 35b1618f3474..a7770cd61213 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
@@ -5,6 +5,8 @@
  */
 #include "iwl-config.h"
 
+#define IWL_BZ_A_FM_C_FW_PRE		"iwlwifi-bz-a0-fm-c0"
+
 #define IWL_DEVICE_FM							\
 	.ht_params = {							\
 		.stbc = true,						\
@@ -48,3 +50,5 @@ const char iwl_be201_name[] = "Intel(R) Wi-Fi 7 BE201 320MHz";
 const char iwl_be200_name[] = "Intel(R) Wi-Fi 7 BE200 320MHz";
 const char iwl_be202_name[] = "Intel(R) Wi-Fi 7 BE202 160MHz";
 const char iwl_be401_name[] = "Intel(R) Wi-Fi 7 BE401 320MHz";
+
+IWL_CORE_FW(IWL_BZ_A_FM_C_FW_PRE, 107);
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index 16abf0147fe4..467888c8d2cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_SC_UCODE_CORE_MAX	107
+#define IWL_SC_UCODE_CORE_MAX	108
 
 /* Lowest firmware core release supported */
 #define IWL_SC_UCODE_CORE_MIN	102
-- 
2.34.1


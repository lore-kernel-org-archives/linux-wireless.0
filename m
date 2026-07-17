Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E343B813D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298705; cv=none; b=qQ/Fj8U1vMtYkAcRwVJnBsxYBuUduqnu+oOGZxV1ZqaDydN+Odu5AL1Px0bgJxAyJhKgUkOYS4t8Ke3R0aThLy5CqpRIjdTFI+SVksfqC0YC2ooCkJpFWGa+hDkfgiZd4LYcA0tG/sb9KyS5MJc2Io8U8XZWTHqnSg8ipOCmoTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298705; c=relaxed/simple;
	bh=7/zN3H+wSLwAjgfoVRwp5I9WChlCaHtetgr/xnNX+VY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=biTMPHBrHjC/9dEizEWxK7reNCpf+8KEawM1yGweF69T0iqoL4xGYlFXBWBS2io8m13Mo3Zh8Mm62ufzgsrv3LCN/jpIjzearlM0D1CNQwfGZg2NwNdfgzFR4tuedX4pn2eOFiinODWPlxYaYSgX+jxWg3KSVxtLlk5Nimbbazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L48jxRds; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L48jxRds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298703; x=1815834703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7/zN3H+wSLwAjgfoVRwp5I9WChlCaHtetgr/xnNX+VY=;
  b=L48jxRdsb5PlshwMbrw5chOTHSdjEHamw5gcRYNI7z8N8130nvAGuQ+l
   Hp5AdePvX7YUR8nymuoFjjcc/wWMtBNy4npatMsm304bJIGDRimZRj5Ty
   +K7kQrKkbBHn/KnV67i2OiMr4dekf9WiTVMPqPcsYQMS2LI1WccmW2cdK
   VGT10R6zAQf+yAS9PanhMD1U3CnnpK8SoJeJWzi/S/8iNos1fzg2DtN/f
   wo38yT3ZffUvOoahO2bMyzIO8Be9tcipQcQWBvZF/4DFrlLvj/qGddBTB
   HJ1lf7pKntrOUlKu59Jl0BFAwa3IkTKbgMMmzd4W7gRznpI2pwVNOiJRh
   w==;
X-CSE-ConnectionGUID: Lph8qS89Tqy/6huyV4FcWg==
X-CSE-MsgGUID: IuWUjMfFRDalYmDeQqnlUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925994"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925994"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:43 -0700
X-CSE-ConnectionGUID: QZRNuuk1Sjqyn6/K6ioa9g==
X-CSE-MsgGUID: nQ7za11WSFyNE+PZ6g+L+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885740"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avinash Bhatt <avinash.bhatt@intel.com>
Subject: [PATCH iwlwifi-next 5/8] wifi: iwlwifi: fw: move SAR defines from acpi.h to regulatory.h
Date: Fri, 17 Jul 2026 17:31:09 +0300
Message-Id: <20260717172958.32e5dcde4b90.I420c58b05ab6ab011c4c771ca9e4eb62740de549@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avinash Bhatt <avinash.bhatt@intel.com>

IWL_SAR_ENABLE_MSK and IWL_REDUCE_POWER_FLAGS_POS describe the layout
of the shared WRDS/SAR table format. They are not ACPI-specific: the
same bit positions are used regardless of whether the data originates
from ACPI, UEFI, or another BIOS source.

IWL_SAR_ENABLE_MSK was already duplicated in regulatory.h; remove it
from acpi.h to eliminate the duplication.

Move IWL_REDUCE_POWER_FLAGS_POS to regulatory.h alongside
IWL_SAR_ENABLE_MSK so that both SAR field descriptors live in the
shared regulatory header, accessible to all BIOS configuration sources.

No functional change.

Signed-off-by: Avinash Bhatt <avinash.bhatt@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       | 5 +----
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h | 3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 51a57e57de7a..45eb35ffb637 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2023, 2025 Intel Corporation
+ * Copyright (C) 2018-2023, 2025-2026 Intel Corporation
  */
 #ifndef __iwl_fw_acpi__
 #define __iwl_fw_acpi__
@@ -111,9 +111,6 @@
 #define ACPI_PPAG_WIFI_DATA_SIZE_V3	((ACPI_PPAG_NUM_CHAINS * \
 					  ACPI_PPAG_NUM_BANDS_V3) + 2)
 
-#define IWL_SAR_ENABLE_MSK		BIT(0)
-#define IWL_REDUCE_POWER_FLAGS_POS	1
-
 /* The Inidcator whether UEFI WIFI GUID tables are locked is read from ACPI */
 #define UEFI_WIFI_GUID_UNLOCKED		0
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index 6fffc032efd3..22c97c75b83c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2023-2025 Intel Corporation
+ * Copyright (C) 2023-2026 Intel Corporation
  */
 
 #ifndef __fw_regulatory_h__
@@ -30,6 +30,7 @@
 #define BIOS_GEO_MIN_PROFILE_NUM	3
 
 #define IWL_SAR_ENABLE_MSK		BIT(0)
+#define IWL_REDUCE_POWER_FLAGS_POS	1
 
 /* PPAG gain value bounds in 1/8 dBm */
 #define IWL_PPAG_MIN_LB	-16
-- 
2.34.1


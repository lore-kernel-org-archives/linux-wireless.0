Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E00328B4B
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168602; cv=none; b=WEEHExRPg23FQMgsVS5h7zJFmFqL2c6Rc78f46O6B/M2QG01mRm+5PYuXG+j+wfhuVcmdoodeGcg/QCo9WOndRMU3VDvhIGGMRcQfC+1veRZftVyhi+rgkvWlV7Jlgk4L4iqcS+cctJ3SYAWPAoDZJJhnAAK+FuhJ4bDqr94lts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168602; c=relaxed/simple;
	bh=09KpxvaUDTq1eFjCQ2CR2Uj1h95icSeEQRUfdXCdgsw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cU186+s4Qar1nmTiuRaP/O94GMA2bvmoCj/OaRnuu2O0Owo7IedAKCUWYairxHPnBc6z3SZdnQ7JbZSzy6dBuu9FYzSxVzoNI2aw2Dumchlxk9vrU+bretCVuHl69VrCHcgHu6OwgNiRDwKBPINCW92KzWvT8s/z1nPvuhZcQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mbdMRO5i; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mbdMRO5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168601; x=1821704601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=09KpxvaUDTq1eFjCQ2CR2Uj1h95icSeEQRUfdXCdgsw=;
  b=mbdMRO5iNEE1QmfC98ERm9UeMvB0ezzYhM3up3Xv8Rx9bK6/ORIzOSDW
   xXokK5+H5EcJqhg+rwo/+r+wEaJz5DLXSOkK/5o0oBIF+/2C+dBib3f0U
   6t4obebhWys1lcxLW3ExSUJh9Dk7e0iKsXwiZOYLyxnfJcURHivRCKpHs
   JonuM8geJxnybgeYZM2qYUyvVxYWOyjyjB8tfJDtzdr2eIBNUSwJYDjVy
   vjdFZq4GDQD0JUeMynYsPqB3K0nnq1xQpdA3X+4DBI9fU2krRpMAvVnYR
   smXYI7oNCjcAzR4tP9Lrz2YHXwis2dZcdHkESbeqidYrKpZAj3uEc3LuU
   Q==;
X-CSE-ConnectionGUID: Kw4fD7DhTK+WUGb8/qcI6w==
X-CSE-MsgGUID: 7wvSdPP4QZq2mvKEskwB/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781354"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781354"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:17 -0700
X-CSE-ConnectionGUID: ikUwzLRnRv6OL535HOtIkw==
X-CSE-MsgGUID: FoD9qNnJQ5u8FZdnBBsktw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697100"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:16 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: regulatory: use GLUI as root-of-trust for connectivity variables
Date: Wed, 23 Sep 2026 16:04:55 +0300
Message-Id: <20260923160318.c6a2252dafb9.I46f8c4d55bd22d98a7200cce8f528c5e182f443c@changeid>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The BIOS tables can be sourced from either UEFI or ACPI. The UEFI
copies are writable, so they may be trusted only when the platform
attests they are locked. Resolve this trust from a single source,
preferring the UEFI GUID Lock Indicator (GLUI) and consulting the ACPI
GLAI whenever GLUI does not attest the tables as locked or in test mode.

Add iwl_bios_get_guid_lock_status() as that entry point and have the
mvm and mld op-modes use it instead of the ACPI-only helper, so trust is
resolved consistently regardless of whether a platform ships GLUI or
GLAI.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4-8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  1 -
 .../wireless/intel/iwlwifi/fw/regulatory.c    | 24 +++++++++++++++++++
 .../wireless/intel/iwlwifi/fw/regulatory.h    |  1 +
 .../wireless/intel/iwlwifi/mld/regulatory.c   |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  2 +-
 5 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index f53cb531cf88..21470b8ae8e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1166,7 +1166,6 @@ void iwl_acpi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
 out_free:
 	kfree(data);
 }
-IWL_EXPORT_SYMBOL(iwl_acpi_get_guid_lock_status);
 
 int iwl_acpi_get_wbem(struct iwl_fw_runtime *fwrt, u32 *value)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index c62f7f53323a..5dbb3cdb9916 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -451,3 +451,27 @@ bool iwl_rfi_is_enabled_in_bios(struct iwl_fw_runtime *fwrt)
 	return false;
 }
 IWL_EXPORT_SYMBOL(iwl_rfi_is_enabled_in_bios);
+
+/**
+ * iwl_bios_get_guid_lock_status - resolve connectivity variables lock status
+ * @fwrt: the firmware runtime context
+ *
+ * Determine the root-of-trust for the connectivity UEFI variables. The UEFI
+ * GUID Lock Indicator (GLUI) is preferred: if it attests the tables as locked
+ * or in test mode, that result is used. Otherwise (GLUI is missing, invalid or
+ * reports unlocked) the ACPI GUID Lock Indicator is consulted and can override
+ * the GLUI result.
+ *
+ * This only caches the result in &fwrt->uefi_tables_lock_status
+ * (see &enum iwl_uefi_cnv_guid_status).
+ */
+void iwl_bios_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
+{
+	iwl_uefi_get_guid_lock_status(fwrt);
+	if (fwrt->uefi_tables_lock_status == UEFI_CNV_GUID_LOCKED ||
+	    fwrt->uefi_tables_lock_status == UEFI_CNV_GUID_TEST_MODE)
+		return;
+
+	iwl_acpi_get_guid_lock_status(fwrt);
+}
+IWL_EXPORT_SYMBOL(iwl_bios_get_guid_lock_status);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index cd6218e3a740..f7bd09195ab4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -258,6 +258,7 @@ bool iwl_puncturing_is_allowed_in_bios(u32 puncturing, u16 mcc);
 
 int iwl_bios_get_dsbr(struct iwl_fw_runtime *fwrt, u32 *value);
 int iwl_bios_get_phy_filters(struct iwl_fw_runtime *fwrt);
+void iwl_bios_get_guid_lock_status(struct iwl_fw_runtime *fwrt);
 
 static inline void iwl_bios_setup_step(struct iwl_trans *trans,
 				       struct iwl_fw_runtime *fwrt)
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index 533870cf443f..94dd7cc97ad4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -6,7 +6,6 @@
 #include <linux/dmi.h>
 
 #include "fw/regulatory.h"
-#include "fw/acpi.h"
 #include "fw/uefi.h"
 
 #include "regulatory.h"
@@ -37,7 +36,7 @@ void iwl_mld_get_bios_tables(struct iwl_mld *mld)
 {
 	int ret;
 
-	iwl_acpi_get_guid_lock_status(&mld->fwrt);
+	iwl_bios_get_guid_lock_status(&mld->fwrt);
 
 	ret = iwl_bios_get_ppag_table(&mld->fwrt);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 06f3b065914b..0b5b41223a8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1576,7 +1576,7 @@ void iwl_mvm_get_bios_tables(struct iwl_mvm *mvm)
 {
 	int ret;
 
-	iwl_acpi_get_guid_lock_status(&mvm->fwrt);
+	iwl_bios_get_guid_lock_status(&mvm->fwrt);
 
 	/* read PPAG table */
 	ret = iwl_bios_get_ppag_table(&mvm->fwrt);
-- 
2.34.1


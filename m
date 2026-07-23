Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE49246DFE8
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 11:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805842; cv=none; b=rXW3hlzTeo+L1rsXxJxnSIzbXzzV63L4n+8Q1dTAEQD+AwYHQbtjAOlyJiAA08pf2ekg/S9h3grTtRr/XLD1tRlMgGzLivS/JUdTBzxZEMFTmAa1fXtUvTdARx+6bSo8j8eDoTswK6WshdeIEuHbSCcDk5hw4pTplG7qy04qmUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805842; c=relaxed/simple;
	bh=cHU60vsc/DeRSG1VFTLZRrK3VsQPI10uw9X7oYW555M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gCbxMTlYylHF7DxXWYlKu3C9bAA4FJaSpUzgh14kaFdz3Fq2AUR5Jw8EMYo28X8vsZjzHis0tYKqym0AmE+9qm5f0PG8Vj+HVqw5bKxof6RJT3xx/wEFmmmB2Y1PEKYXWf5zNfXG/8zekE+yRp9YMrv0kraMDknSh9Soz3/rzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cUE+9JY/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cUE+9JY/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784805841; x=1816341841;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cHU60vsc/DeRSG1VFTLZRrK3VsQPI10uw9X7oYW555M=;
  b=cUE+9JY/RA963FomIyZtf6mQ4m3vrYqkh7Txsgrf6pGIYEfkvF3O3vvR
   aRXciHhLqJYbwmP8aS2wPvDqL+gljHr7pIF/Ygen83smPpnp0fGEjA/ch
   NpV81gHOe7pgEa1aqWwjxVID3HPPAy4A2NhCsCpD8w+E6R00gPQYz4A71
   YB/kg8kCvsRIYI41tZZK5gAvHhYki0h9O+FkyPWp+dKysQa4zcBYyec7S
   3uW3FrmAML+RT/taCxn57q5qiDv4/4Ds99WDXnTE+/SpUphoeCDYZGTg4
   mwLmxEnXBjL4ccl9LPnKSViT59HhvxxJET69HYuce74AO3TOcGGOSpvyK
   g==;
X-CSE-ConnectionGUID: ZQHhKFPbQ4aBpsorMuqrkg==
X-CSE-MsgGUID: r+eUU6NITwO5Sc4FMkcGOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87999887"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87999887"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 04:24:00 -0700
X-CSE-ConnectionGUID: 9Ah82vpYR1WkmyW5TxlwFQ==
X-CSE-MsgGUID: JhduqTGaROyeGLmFRugaIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="256581997"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 04:23:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 1/2] wifi: iwlwifi: regulatory: add LARI v15 DSM support bitmap
Date: Thu, 23 Jul 2026 14:23:36 +0300
Message-Id: <20260723142324.c576a8c7560b.I5cc1277d0ef31409f6a3364342a3f35cd9318ceb@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Firmware API v15 extends LARI config with the DSM function-0 support
bitmap, and host must provide this information for regulatory handling.
Without this, FW cannot use BIOS-reported DSM capability bits.

Add oem_supported_dsm_bitmap to the host LARI config command
definition and wire it into regulatory command construction.
Populate it from DSM query data and keep backward compatibility by
using the pre-v15 command size for command version 14.

Behavior change:
When DSM function-0 data is available, host includes it in the LARI
config command sent to FW; older command versions remain compatible.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c      |  3 ++-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  5 +++++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c      |  2 +-
 .../net/wireless/intel/iwlwifi/mld/regulatory.c   | 15 +++++++++++++--
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 9f2f4a6af1ca..0b1e478fb7b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -181,6 +181,7 @@ static int iwl_acpi_load_dsm_values(struct iwl_fw_runtime *fwrt)
 
 	fwrt->dsm_revision = ACPI_DSM_REV;
 	fwrt->dsm_source = BIOS_SOURCE_ACPI;
+	fwrt->dsm_values[DSM_FUNC_QUERY] = (u32)query_func_val;
 
 	IWL_DEBUG_RADIO(fwrt, "ACPI DSM validity bitmap 0x%x\n",
 			(u32)query_func_val);
@@ -246,7 +247,7 @@ int iwl_acpi_get_dsm(struct iwl_fw_runtime *fwrt,
 	BUILD_BUG_ON(ARRAY_SIZE(fwrt->dsm_values) != DSM_FUNC_NUM_FUNCS);
 	BUILD_BUG_ON(BITS_PER_TYPE(fwrt->dsm_funcs_valid) < DSM_FUNC_NUM_FUNCS);
 
-	if (WARN_ON(func >= ARRAY_SIZE(fwrt->dsm_values) || !func))
+	if (WARN_ON(func >= ARRAY_SIZE(fwrt->dsm_values)))
 		return -EINVAL;
 
 	if (!(fwrt->dsm_funcs_valid & BIT(func))) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 9fbdb45e88db..5f48e3b306eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -697,6 +697,8 @@ struct iwl_lari_config_change_cmd_v8 {
  * @wcpe_bitmap: bitmap of puncturing enablement per MCC
  * @bios_wbem_hdr: 320 MHz per-MCC WBEM config header
  * @reserved: reserved
+ * @oem_supported_dsm_bitmap: DSM function 0 bitmap describing supported
+ *	DSM function indices
  */
 struct iwl_lari_config_change_cmd {
 	__le32 config_bitmap;
@@ -720,10 +722,13 @@ struct iwl_lari_config_change_cmd {
 	__le32 wcpe_bitmap;
 	struct iwl_bios_config_hdr bios_wbem_hdr;
 	__le32 reserved[10];
+	/* since version 15 */
+	__le32 oem_supported_dsm_bitmap;
 } __packed;
 /* LARI_CHANGE_CONF_CMD_S_VER_12
  * LARI_CHANGE_CONF_CMD_S_VER_13
  * LARI_CHANGE_CONF_CMD_S_VER_14
+ * LARI_CHANGE_CONF_CMD_S_VER_15
  */
 
 /* Activate UNII-1 (5.2GHz) for World Wide */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 01e495e24ebc..f9187989c988 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -927,7 +927,7 @@ static int iwl_uefi_load_dsm_values(struct iwl_fw_runtime *fwrt)
 	 */
 	fwrt->dsm_funcs_valid |= BIT(DSM_FUNC_QUERY);
 
-	for (int func = 1; func < ARRAY_SIZE(fwrt->dsm_values); func++) {
+	for (int func = 0; func < ARRAY_SIZE(fwrt->dsm_values); func++) {
 		if (!(fwrt->dsm_funcs_valid & BIT(func))) {
 			IWL_DEBUG_RADIO(fwrt, "DSM func %d not in 0x%x\n",
 					func, fwrt->dsm_funcs_valid);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index ad899ce5c64a..533870cf443f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -16,8 +16,11 @@
 static ssize_t iwl_mld_get_lari_config_cmd_size(u8 cmd_ver)
 {
 	switch (cmd_ver) {
-	case 14:
+	case 15:
 		return sizeof(struct iwl_lari_config_change_cmd);
+	case 14:
+		return offsetof(struct iwl_lari_config_change_cmd,
+				oem_supported_dsm_bitmap);
 	case 13:
 		return offsetof(struct iwl_lari_config_change_cmd,
 				oem_uhb_allow_extension_bitmap);
@@ -425,6 +428,10 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 	if (!ret)
 		cmd.oem_uhb_allow_extension_bitmap = cpu_to_le32(value);
 
+	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_QUERY, &value);
+	if (!ret)
+		cmd.oem_supported_dsm_bitmap = cpu_to_le32(value);
+
 	cmd.bios_wcpe_hdr.table_source = fwrt->puncturing_source;
 	cmd.bios_wcpe_hdr.table_revision = fwrt->puncturing_revision;
 	cmd.wcpe_bitmap = cpu_to_le32(fwrt->bios_puncturing);
@@ -441,7 +448,8 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 	    !cmd.oem_11be_allow_bitmap &&
 	    !cmd.oem_11bn_allow_bitmap &&
 	    !cmd.oem_unii9_enable &&
-	    !cmd.wcpe_bitmap)
+	    !cmd.wcpe_bitmap &&
+	    !cmd.oem_supported_dsm_bitmap)
 		return;
 
 	cmd.bios_hdr.table_source = fwrt->dsm_source;
@@ -478,6 +486,9 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 	IWL_DEBUG_RADIO(mld,
 			"sending LARI_CONFIG_CHANGE, wcpe_bitmap=0x%x\n",
 			le32_to_cpu(cmd.wcpe_bitmap));
+	IWL_DEBUG_RADIO(mld,
+			"sending LARI_CONFIG_CHANGE, oem_supported_dsm_bitmap=0x%x\n",
+			le32_to_cpu(cmd.oem_supported_dsm_bitmap));
 
 	ret = iwl_mld_send_cmd_pdu(mld,
 				   WIDE_ID(REGULATORY_AND_NVM_GROUP,
-- 
2.34.1


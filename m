Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B241F5FD
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142336; cv=none; b=TfV0aBNQeWLYm9Od6vGpQN/Cigo5G/t6HdVAjGcx8jsu5EVpmg3V4Q4+zlpk/mFq8brEnBk1crUGHXH2SBUu8XQeOleTYFs1t2u8mb5duhiO4ul09rzZU/xXrHqunP+01GXP2eeWWlmaPYOBUCOgiJpRvkT9yXptmrtUH1FWGag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142336; c=relaxed/simple;
	bh=Uk53ZR4IkZdt2ymn1uUcqo4XaAUXY6wx/ZbD03q8IVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RKTA6h6lZdyssxa8Cc6++s8wbH5wsQXYW2R4UHt/myVHzGS+L2vl/RrPHhuOBTdAlR1f8Bd96KOuQV2iHt2UWPZj2m9/YBHLUqKtjFkJJRWHI5o+MA4DgRonBpM6uzi24q8HTRBz38duY+r57DpqngOuSYsQC+pCjwOa6Tdr9Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPhAcvOr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPhAcvOr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142324; x=1815678324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uk53ZR4IkZdt2ymn1uUcqo4XaAUXY6wx/ZbD03q8IVw=;
  b=KPhAcvOrZe/s0kt0Dj5YJnI2HBbBXXgZnm1X3CJq2QvBnZTvhXWz3Ekk
   B/+UW4aOBs7vn7nR82gBJWoNXRJDwy7EsjeB057QZGDHTt5RdRXGFFNtB
   Ch3KOeyLpKzaWR4bbJRBVbqJsQKWDAeIVK9aFSJ448i0iebGTRumlhCDp
   5n5FZvmyF8NHNraE/iwm7hXv4K74aGkmelMbQ/2lCREfCy2YeUkibDE7j
   Jtk9rc2dtnGBqgybzstv+SrCgykarsq+sbPfIakiPIqB7HI3aTbqrNwn+
   Pt32UvMA+l6jcp/KnCLYdV7tShnbUAWzEqJyBUaRMuOYw0+QryZbcg1Cu
   w==;
X-CSE-ConnectionGUID: B8G/svSfQCGanZfT7u5BJg==
X-CSE-MsgGUID: YYtzp6lCS3e0w4sBona7zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340726"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340726"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:04 -0700
X-CSE-ConnectionGUID: 05NBcVjHSCCzF0p2fIHj3A==
X-CSE-MsgGUID: cdr4wFOlToihgaBeVGse/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851988"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: mvm: add LARI_CONFIG_EXTENSION command
Date: Wed, 15 Jul 2026 22:04:24 +0300
Message-Id: <20260715220243.551f40ee2de3.I3e32a5d5c9aa13cbb0e599bef630cdb8e3b031c4@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

There is a new UHB extension bitmap that is part of the LARI
configuration, which needs to be sent to the FW - also frozen ones.
But in frozen FWs we cannot increase the version of an API, since the
driver assumes a specific version, depending on the core number.
In case of a (new) FW that expects the new version and a (old) driver
that doesn't support that new version, the driver will send a default
old version, causing a fw assert about its bad size.

To mitigate this, there is a special command which will be supported
only on those frozen FWs. Old drivers will simply not support/send it,
and new driver will send it if supported by fw.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 26 ++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 36 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 3 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index d8ec9934a9b6..360b626a9572 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -46,6 +46,11 @@ enum iwl_regulatory_and_nvm_subcmd_ids {
 	 */
 	MCC_ALLOWED_AP_TYPE_CMD = 0x5,
 
+	/**
+	 * @LARI_CONFIG_EXTENSION: &struct iwl_lari_config_extension_cmd
+	 */
+	LARI_CONFIG_EXTENSION = 0x8,
+
 	/**
 	 * @PNVM_INIT_COMPLETE_NTFY: &struct iwl_pnvm_init_complete_ntfy
 	 */
@@ -514,6 +519,27 @@ struct iwl_bios_config_hdr {
 	u8 reserved[2];
 } __packed; /* BIOS_CONFIG_HDR_API_S_VER_1 */
 
+/**
+ * struct iwl_lari_config_extension_cmd - extend LARI configuration
+ *
+ * LARI_CONFIG_CHANGE's version must remain stable for frozen firmware.
+ * Because the driver might not know this version but still load that
+ * frozen FW and then send some default old version of LARI, causing the FW to
+ * assert about the bad size of it. To handle this, we do the following:
+ * 1. For newer firmware: increase the LARI_CONFIG_CHANGE version to support the
+ *	new firmware API with extra UHB bits.
+ * 2. For frozen firmware: add a special alternative API that doesn't require
+ *	modifying the frozen LARI_CONFIG_CHANGE's version.
+ * @dsm_table_hdr: BIOS DSM table source and revision
+ * @oem_uhb_allow_extension_bitmap: extension bitmap for OEM UHB config
+ * @reserved: reserved
+ */
+struct iwl_lari_config_extension_cmd {
+	struct iwl_bios_config_hdr dsm_table_hdr;
+	__le32 oem_uhb_allow_extension_bitmap;
+	__le32 reserved[10];
+} __packed; /* LARI_CONFIG_EXTENSION_CMD_API_S_VER_1 */
+
 /**
  * struct bios_value_u32 - BIOS configuration.
  * @hdr: bios config header
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6e507d6dcdd2..187f39aa6249 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1507,12 +1507,48 @@ static int iwl_mvm_fill_lari_config(struct iwl_fw_runtime *fwrt,
 	return 0;
 }
 
+static void iwl_mvm_send_lari_cfg_extension(struct iwl_mvm *mvm)
+{
+	struct iwl_fw_runtime *fwrt = &mvm->fwrt;
+	struct iwl_lari_config_extension_cmd cmd = {};
+	u32 cmd_id = WIDE_ID(REGULATORY_AND_NVM_GROUP,
+			     LARI_CONFIG_EXTENSION);
+	u32 value;
+	int ret;
+
+	if (iwl_fw_lookup_cmd_ver(mvm->fw, cmd_id, 0) < 1)
+		return;
+
+	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_REGULATORY_CONFIG, &value);
+	if (ret)
+		return;
+
+	cmd.dsm_table_hdr.table_source = fwrt->dsm_source;
+	cmd.dsm_table_hdr.table_revision = fwrt->dsm_revision;
+	cmd.oem_uhb_allow_extension_bitmap = cpu_to_le32(value);
+
+	IWL_DEBUG_RADIO(mvm,
+			"sending LARI_CONFIG_EXTENSION, oem_uhb_allow_extension_bitmap=0x%x\n",
+			le32_to_cpu(cmd.oem_uhb_allow_extension_bitmap));
+	ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cmd), &cmd);
+	if (ret < 0)
+		IWL_DEBUG_RADIO(mvm,
+				"Failed to send LARI_CONFIG_EXTENSION (%d)\n",
+				ret);
+}
+
 static void iwl_mvm_lari_cfg(struct iwl_mvm *mvm)
 {
 	struct iwl_lari_config_change_cmd cmd;
 	size_t cmd_size;
 	int ret;
 
+	/*
+	 * LARI_CONFIG_CHANGE triggers a profile update, so send
+	 * LARI_CONFIG_EXTENSION first to make sure its data is applied
+	 * in the same update.
+	 */
+	iwl_mvm_send_lari_cfg_extension(mvm);
 	ret = iwl_mvm_fill_lari_config(&mvm->fwrt, &cmd, &cmd_size);
 	if (!ret) {
 		ret = iwl_mvm_send_cmd_pdu(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index da4c67a91113..1dd27292af9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -707,6 +707,7 @@ static const struct iwl_hcmd_names iwl_mvm_regulatory_and_nvm_names[] = {
 	HCMD_NAME(NVM_ACCESS_COMPLETE),
 	HCMD_NAME(NVM_GET_INFO),
 	HCMD_NAME(TAS_CONFIG),
+	HCMD_NAME(LARI_CONFIG_EXTENSION),
 };
 
 /* Please keep this array *SORTED* by hex value.
-- 
2.34.1


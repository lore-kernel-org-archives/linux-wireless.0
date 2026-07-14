Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48766367B7B
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028801; cv=none; b=tXk4DgzU9Z4KV2L3m/c7erdZIHPrISCiuOsH1x00sgyRhp6CKgpTIa3XwvmKQlX5RB9acLHzpsrW05DLlZjhiv8Y/0FFBldEx/UgtilvfzDgbt2BtG2ZYqAg0JEuqEsCqkoY0KZMkZ8E/xSzd0UvSJzWZ0Z72ZkmmZaGrqPXU0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028801; c=relaxed/simple;
	bh=PRo/kvv+9pQX55NDqj7VShwqpZDABAHCq7UyjgjbFRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Njm3FdNZd2yGD4BMeg5fcWHbR3vao8br+x/MfTzDvN2mhu4yLd7CpoBQahs/Ts1JG75htyl+txPxJl8v/ryJy4pGrsoBaaDdPStqDq7TeKfRSUb+dU01xsRuPwlsC/9oG1O47/aQiiP1d4CNPslcpCwD8BuWmBJ5/5gpCf67Y6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B+C7VmKS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B+C7VmKS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028800; x=1815564800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PRo/kvv+9pQX55NDqj7VShwqpZDABAHCq7UyjgjbFRU=;
  b=B+C7VmKSNC1zCZbOTS5oFjxnlgBUlLKZB66Gh5hTpTvxRn3lcKegUPrc
   pd5JmMJE+5jXb6iiWBdhNcUAcWEJy6T8WLNjGP6Pt9GJU09ER2Kn063pg
   VOH3KnY2ktquXaZsi3K7cysCMocqUyXTTUsLuDckVAQBRcC2qZNNDov2i
   yvKdX9RLczG0PpJzZYsVrBCzZ/5sm0YyvAwzhHa/yDLfxM7UVhcjcLIFu
   TIjB6BpzHiPK1+oBIus0P9gHP6irzyq8VctU9TwCcC4hdL4h+O19bTFIG
   asoI6erq5ddAf8d7fNFAWZ6GePWph4wbyIGjBDzUta74F42WPqMRttIz2
   g==;
X-CSE-ConnectionGUID: Xwk+LwveRlq7r0r2vwDHtA==
X-CSE-MsgGUID: wDrnsP1XQ/qgQdvkVj3KJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469604"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469604"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:20 -0700
X-CSE-ConnectionGUID: SSGRBrSjSWShF0YaUN8qIg==
X-CSE-MsgGUID: /G5cWbxjSwSqFXD4xFZBNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882965"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Avinash Bhatt <avinash.bhatt@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: ignore raw-DSM TLV for LARI cmd version 13 and above
Date: Tue, 14 Jul 2026 14:32:37 +0300
Message-Id: <20260714143119.12c8b407e115.I6809041f1eb52b7fafe9172ca3e47323d43cc30a@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

LARI_CONFIG_CHANGE command version 13 and above accepts raw DSM
values by default in firmware, so FW_ACCEPTS_RAW_DSM_TABLE should
not gate DSM bitmap handling for these versions.

Set has_raw_dsm_capa based on command version (version 13 and above
is true) with TLV fallback for older command versions. Also update TLV
kernel-doc to mark this capability obsolete for LARI command
version 13 and above.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Avinash Bhatt <avinash.bhatt@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h     |  5 +++--
 .../net/wireless/intel/iwlwifi/mld/regulatory.c  | 16 +++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index a26ed82a8106..664ac25754e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -448,8 +448,9 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_EXT_FSEQ_IMAGE_SUPPORT: external FSEQ image support
  * @IWL_UCODE_TLV_CAPA_RESET_DURING_ASSERT: FW reset handshake is needed
  *	during assert handling even if the dump isn't split
- * @IWL_UCODE_TLV_CAPA_FW_ACCEPTS_RAW_DSM_TABLE: Firmware has capability of
- *	handling raw DSM table data.
+ * @IWL_UCODE_TLV_CAPA_FW_ACCEPTS_RAW_DSM_TABLE: Firmware can handle raw DSM
+ *	table data. For LARI_CONFIG_CHANGE command version 13 and above, this
+ *	capability is obsolete since raw DSM values are accepted by default.
  * @IWL_UCODE_TLV_CAPA_NAN_SYNC_SUPPORT: Supports NAN synchronization
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index 659243ada86c..858635607f5d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -325,8 +325,16 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 	struct iwl_lari_config_change_cmd cmd = {
 		.config_bitmap = iwl_mld_get_lari_config_bitmap(fwrt),
 	};
-	bool has_raw_dsm_capa = fw_has_capa(&fwrt->fw->ucode_capa,
-					    IWL_UCODE_TLV_CAPA_FW_ACCEPTS_RAW_DSM_TABLE);
+	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw,
+					   WIDE_ID(REGULATORY_AND_NVM_GROUP,
+						   LARI_CONFIG_CHANGE), 12);
+	/*
+	 * For LARI_CONFIG_CHANGE command version 13 and above, firmware accepts
+	 * raw DSM values by default and this TLV is no longer needed.
+	 */
+	bool has_raw_dsm_capa = cmd_ver >= 13 ||
+		fw_has_capa(&fwrt->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_FW_ACCEPTS_RAW_DSM_TABLE);
 	int ret;
 	u32 value;
 
@@ -428,9 +436,7 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 			"sending LARI_CONFIG_CHANGE, oem_unii9_enable=0x%x\n",
 			le32_to_cpu(cmd.oem_unii9_enable));
 
-	if (iwl_fw_lookup_cmd_ver(mld->fw,
-				  WIDE_ID(REGULATORY_AND_NVM_GROUP,
-					  LARI_CONFIG_CHANGE), 12) == 12) {
+	if (cmd_ver == 12) {
 		int cmd_size = offsetof(typeof(cmd), oem_11bn_allow_bitmap);
 
 		ret = iwl_mld_send_cmd_pdu(mld,
-- 
2.34.1


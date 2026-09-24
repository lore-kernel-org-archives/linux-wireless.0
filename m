Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEA472547
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246381; cv=none; b=Xjt/fJIuSI5/ARhDl1Ou1kKa55cR5WmFzHS8KfjAKshBLD0ZRsV3U8uiqcMg5nhfB7uP3uvsixpU16u9M0aCRX02uvJyOehLQEWIYj72WzWKFOfp3sw2oEuV4U+xlMfrGw8QG2XC6/j66aPBWzGciVEQ/t9DobolcOJOWxgi5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246381; c=relaxed/simple;
	bh=PxMIeu4hzdo37hidGVKu0O8kVUCrA1q49L4uFUyj2x0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iIjkS7ptzoQoohwoS8W9iZfaYz5tJ4cXUtVbL6fECQbkFAjpLq+sS9cCzlEIn2FTvTDSFFjqEpS3lTnxkYpAw8WnXXya+l7Zscmr491QOGPbd5sqj7pm5rZN75klUvVIuEmjUUpy3bITjC8IAJwZCX6kevubFcQDIr71IjwVzqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2CUgd+c; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2CUgd+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246378; x=1821782378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PxMIeu4hzdo37hidGVKu0O8kVUCrA1q49L4uFUyj2x0=;
  b=I2CUgd+co84X9va7WQP5z3rqeP/n7cQNdtMcdEyS6g59Yq/nOKQ5Xa1e
   IsIyFfcTHA5VGUv8bdpCMW9nLE3Gvd7YVlqzimVo5mvql6QfnQXoyvRQI
   4Sbfa2amAOOeEUp+lKjskcPr0bg2PLW+WuUxKVwXeYFgCN1tScKF+DtDN
   dCDWoza4/qhBpQBTml4J+rjFkf0udBUusNGAABkDPeDkS4xdGAv9reLjl
   7EpPB/ER8lHS/sbj/ItfeUoMslXouS0YnQ1euooRdpELdzPKg1LUKxdEJ
   MtpvOW1hQ5RufG67yRvWk0D0oXWrmBMs/gGKvFBDOw+VbiaSXR+T1r7Md
   w==;
X-CSE-ConnectionGUID: wgce/LWuTrylgJgkLyyC6w==
X-CSE-MsgGUID: CTJptajXS9u6GNVOvEA3/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134872"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134872"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:38 -0700
X-CSE-ConnectionGUID: diEYHW3lS2aHMu/tLm0blw==
X-CSE-MsgGUID: gaj6b0O+TceGgshqvI62Tw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: send standalone SAR to firmware
Date: Thu, 24 Sep 2026 13:41:18 +0300
Message-Id: <20260924133942.c199a92b439c.Ic02190e91e795dcfe660710721b47de71f2b2c86@changeid>
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

Plumb the standalone WRSS/EWSS SAR data and
send the standalone profile to firmware.

Add REDUCE_TX_POWER_CMD version 12 support with the
IWL_TX_POWER_MODE_SET_STANDALONE_CHAINS set_mode, and rename
iwl_dev_tx_power_cmd_v11 to iwl_dev_tx_power_cmd_v12 to match the
updated command layout.

This enables higher transmit power limits for standalone firmware
operation while preserving the existing concurrent SAR handling.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 14 ++--
 .../wireless/intel/iwlwifi/fw/regulatory.c    | 26 ++++--
 .../wireless/intel/iwlwifi/fw/regulatory.h    |  4 +-
 .../net/wireless/intel/iwlwifi/mld/power.c    |  2 +-
 .../wireless/intel/iwlwifi/mld/regulatory.c   | 80 +++++++++++++++++--
 .../wireless/intel/iwlwifi/mld/regulatory.h   |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  3 +-
 7 files changed, 107 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 115e65ba19f8..4d54a95b98ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -300,7 +300,8 @@ enum iwl_dev_tx_power_cmd_mode {
 	IWL_TX_POWER_MODE_SET_ACK = 3,
 	IWL_TX_POWER_MODE_SET_SAR_TIMER = 4,
 	IWL_TX_POWER_MODE_SET_SAR_TIMER_DEFAULT_TABLE = 5,
-}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_5 */;
+	IWL_TX_POWER_MODE_SET_STANDALONE_CHAINS = 8, /* cmd ver 12+ */
+}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_2 */;
 
 #define IWL_NUM_CHAIN_TABLES	1
 #define IWL_NUM_CHAIN_TABLES_V2	2
@@ -464,31 +465,34 @@ struct iwl_dev_tx_power_cmd_v10 {
 	__le32 flags;
 } __packed; /* TX_REDUCED_POWER_API_S_VER_10 */
 
-struct iwl_dev_tx_power_cmd_v11 {
+struct iwl_dev_tx_power_cmd_v12 {
 	__le16 per_chain[IWL_NUM_CHAIN_TABLES_V2][IWL_NUM_CHAIN_LIMITS][IWL_NUM_SUB_BANDS_V3];
 	u8 per_chain_restriction_changed;
 	u8 reserved;
 	__le32 timer_period;
 	__le32 flags;
-} __packed; /* TX_REDUCED_POWER_API_S_VER_11 */
+} __packed; /* TX_REDUCED_POWER_API_S_VER_11
+	     * TX_REDUCED_POWER_API_S_VER_12
+	     */
 
 /*
  * struct iwl_dev_tx_power_cmd - TX power reduction command (multiversion)
  * @common: common part of the command
  * @v9: version 9 part of the command
  * @v10: version 10 part of the command
- * @v11: version 11 part of the command
+ * @v12: version 12 part of the command (also covers v11)
  */
 struct iwl_dev_tx_power_cmd {
 	struct iwl_dev_tx_power_common common;
 	union {
 		struct iwl_dev_tx_power_cmd_v9 v9;
 		struct iwl_dev_tx_power_cmd_v10 v10;
-		struct iwl_dev_tx_power_cmd_v11 v11;
+		struct iwl_dev_tx_power_cmd_v12 v12;
 	};
 } __packed; /* TX_REDUCED_POWER_API_S_VER_9
 	     * TX_REDUCED_POWER_API_S_VER_10
 	     * TX_REDUCED_POWER_API_S_VER_11
+	     * TX_REDUCED_POWER_API_S_VER_12
 	     */
 
 #define IWL_NUM_GEO_PROFILES		3
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 137303e4a29b..27a5804dbd73 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -247,17 +247,22 @@ IWL_EXPORT_SYMBOL(iwl_sar_geo_fill_table);
 
 static int iwl_sar_fill_table(struct iwl_fw_runtime *fwrt,
 			      __le16 *per_chain, u32 n_subbands,
-			      int prof_a, int prof_b)
+			      int prof_a, int prof_b,
+			      const struct iwl_sar_profile *profiles,
+			      bool is_standalone)
 {
 	int profs[BIOS_SAR_NUM_CHAINS] = { prof_a, prof_b };
 	int i, j;
 
+	BUILD_BUG_ON(ARRAY_SIZE(fwrt->sar_standalone_profiles[0].chains[0].subbands) !=
+		     ARRAY_SIZE(fwrt->sar_profiles[0].chains[0].subbands));
+
 	if (WARN_ON_ONCE(n_subbands >
 			 ARRAY_SIZE(fwrt->sar_profiles[0].chains[0].subbands)))
 		return -EINVAL;
 
 	for (i = 0; i < BIOS_SAR_NUM_CHAINS; i++) {
-		struct iwl_sar_profile *prof;
+		const struct iwl_sar_profile *prof;
 
 		/* don't allow SAR to be disabled (profile 0 means disable) */
 		if (profs[i] == 0)
@@ -268,11 +273,13 @@ static int iwl_sar_fill_table(struct iwl_fw_runtime *fwrt,
 			return -EINVAL;
 
 		/* profiles go from 1 to 4, so decrement to access the array */
-		prof = &fwrt->sar_profiles[profs[i] - 1];
+		prof = &profiles[profs[i] - 1];
 
 		/* if the profile is disabled, do nothing */
 		if (!prof->enabled) {
-			IWL_DEBUG_RADIO(fwrt, "SAR profile %d is disabled.\n",
+			IWL_DEBUG_RADIO(fwrt,
+					"SAR %sprofile %d is disabled.\n",
+					is_standalone ? "standalone " : "",
 					profs[i]);
 			/*
 			 * if one of the profiles is disabled, we
@@ -282,8 +289,8 @@ static int iwl_sar_fill_table(struct iwl_fw_runtime *fwrt,
 			return 1;
 		}
 
-		IWL_DEBUG_INFO(fwrt,
-			       "SAR EWRD: chain %d profile index %d\n",
+		IWL_DEBUG_INFO(fwrt, "SAR %s: chain %d profile index %d\n",
+			       is_standalone ? "standalone" : "EWRD",
 			       i, profs[i]);
 		IWL_DEBUG_RADIO(fwrt, "  Chain[%d]:\n", i);
 		for (j = 0; j < n_subbands; j++) {
@@ -299,14 +306,17 @@ static int iwl_sar_fill_table(struct iwl_fw_runtime *fwrt,
 
 int iwl_sar_fill_profile(struct iwl_fw_runtime *fwrt,
 			 __le16 *per_chain, u32 n_tables, u32 n_subbands,
-			 int prof_a, int prof_b)
+			 int prof_a, int prof_b,
+			 const struct iwl_sar_profile *profiles,
+			 bool is_standalone)
 {
 	int i, ret = 0;
 
 	for (i = 0; i < n_tables; i++) {
 		ret = iwl_sar_fill_table(fwrt,
 			&per_chain[i * n_subbands * BIOS_SAR_NUM_CHAINS],
-			n_subbands, prof_a, prof_b);
+			n_subbands, prof_a, prof_b, profiles,
+			is_standalone);
 		if (ret)
 			break;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index bd7ea0ff3d19..e32e107812b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -210,7 +210,9 @@ int iwl_sar_geo_fill_table(struct iwl_fw_runtime *fwrt,
 
 int iwl_sar_fill_profile(struct iwl_fw_runtime *fwrt,
 			 __le16 *per_chain, u32 n_tables, u32 n_subbands,
-			 int prof_a, int prof_b);
+			 int prof_a, int prof_b,
+			 const struct iwl_sar_profile *profiles,
+			 bool is_standalone);
 
 bool iwl_is_ppag_approved(struct iwl_fw_runtime *fwrt);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/power.c b/drivers/net/wireless/intel/iwlwifi/mld/power.c
index 2387f3da5185..6fcbb1a2e8a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/power.c
@@ -525,7 +525,7 @@ int iwl_mld_set_tx_power(struct iwl_mld *mld,
 		.common.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_LINK),
 		.common.pwr_restriction = cpu_to_le16(u_tx_power),
 	};
-	int len = sizeof(cmd.common) + sizeof(cmd.v11);
+	int len = sizeof(cmd.common) + sizeof(cmd.v12);
 
 	if (iwl_fw_lookup_cmd_ver(mld->fw, cmd_id, 10) == 10)
 		len = sizeof(cmd.common) + sizeof(cmd.v10);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index 94dd7cc97ad4..76998e3e3e49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -74,6 +74,21 @@ void iwl_mld_get_bios_tables(struct iwl_mld *mld)
 					"EWRD SAR BIOS table invalid or unavailable. (%d)\n",
 					ret);
 
+		ret = iwl_bios_get_wsss_table(&mld->fwrt);
+		if (ret < 0)
+			IWL_DEBUG_RADIO(mld,
+					"WSSS (WRDS Standalone) SAR BIOS table invalid or unavailable. (%d)\n",
+					ret);
+
+		if (!ret) {
+			/* EWSS only extends the standalone SAR profiles from WSSS. */
+			ret = iwl_bios_get_ewss_table(&mld->fwrt);
+			if (ret < 0)
+				IWL_DEBUG_RADIO(mld,
+						"EWSS (EWRD Standalone) SAR BIOS table invalid or unavailable. (%d)\n",
+						ret);
+		}
+
 		ret = iwl_bios_get_wgds_table(&mld->fwrt);
 		if (ret < 0)
 			IWL_DEBUG_RADIO(mld,
@@ -135,7 +150,9 @@ static int iwl_mld_geo_sar_init(struct iwl_mld *mld)
 	return iwl_mld_send_cmd_pdu(mld, cmd_id, &cmd, cmd_size);
 }
 
-int iwl_mld_config_sar_profile(struct iwl_mld *mld, int prof_a, int prof_b)
+static int
+iwl_mld_config_sar_concurrent_profile(struct iwl_mld *mld, int prof_a,
+				      int prof_b)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
 		.common.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
@@ -152,8 +169,9 @@ int iwl_mld_config_sar_profile(struct iwl_mld *mld, int prof_a, int prof_b)
 		num_subbands = IWL_NUM_SUB_BANDS_V2;
 		break;
 	case 11:
-		cmd.v11.flags = cpu_to_le32(mld->fwrt.reduced_power_flags);
-		cmd_size = sizeof(cmd.common) + sizeof(cmd.v11);
+	case 12:
+		cmd.v12.flags = cpu_to_le32(mld->fwrt.reduced_power_flags);
+		cmd_size = sizeof(cmd.common) + sizeof(cmd.v12);
 		num_subbands = IWL_NUM_SUB_BANDS_V3;
 		break;
 	default:
@@ -163,12 +181,13 @@ int iwl_mld_config_sar_profile(struct iwl_mld *mld, int prof_a, int prof_b)
 	}
 
 	/* TODO: CDB - support IWL_NUM_CHAIN_TABLES_V2 */
-	/* v10 and v11 have the same position for per_chain */
-	BUILD_BUG_ON(offsetof(typeof(cmd), v11.per_chain) !=
+	/* v10 and v12 have the same position for per_chain */
+	BUILD_BUG_ON(offsetof(typeof(cmd), v12.per_chain) !=
 		     offsetof(typeof(cmd), v10.per_chain));
-	ret = iwl_sar_fill_profile(&mld->fwrt, &cmd.v11.per_chain[0][0][0],
+	ret = iwl_sar_fill_profile(&mld->fwrt, &cmd.v12.per_chain[0][0][0],
 				   IWL_NUM_CHAIN_TABLES, num_subbands,
-				   prof_a, prof_b);
+				   prof_a, prof_b,
+				   mld->fwrt.sar_profiles, false);
 	/* return on error or if the profile is disabled (positive number) */
 	if (ret)
 		return ret;
@@ -176,6 +195,51 @@ int iwl_mld_config_sar_profile(struct iwl_mld *mld, int prof_a, int prof_b)
 	return iwl_mld_send_cmd_pdu(mld, REDUCE_TX_POWER_CMD, &cmd, cmd_size);
 }
 
+static int iwl_mld_config_sar_standalone_profile(struct iwl_mld *mld,
+						 int prof_a, int prof_b)
+{
+	struct iwl_dev_tx_power_cmd cmd = {
+		.common.set_mode =
+			cpu_to_le32(IWL_TX_POWER_MODE_SET_STANDALONE_CHAINS),
+	};
+	int ret;
+
+	/* standalone per-chain SAR limits require cmd version 12 */
+	if (iwl_fw_lookup_cmd_ver(mld->fw, REDUCE_TX_POWER_CMD, 10) != 12)
+		return 0;
+
+	ret = iwl_sar_fill_profile(&mld->fwrt,
+				   &cmd.v12.per_chain[0][0][0],
+				   IWL_NUM_CHAIN_TABLES,
+				   IWL_NUM_SUB_BANDS_V3,
+				   prof_a, prof_b,
+				   mld->fwrt.sar_standalone_profiles,
+				   true);
+	/* return on error or if the standalone profile is disabled */
+	if (ret)
+		return ret;
+
+	return iwl_mld_send_cmd_pdu(mld, REDUCE_TX_POWER_CMD, &cmd,
+				    sizeof(cmd.common) + sizeof(cmd.v12));
+}
+
+int iwl_mld_config_sar_profiles(struct iwl_mld *mld, int prof_a, int prof_b)
+{
+	int ret;
+
+	ret = iwl_mld_config_sar_concurrent_profile(mld, prof_a, prof_b);
+	/* return on error or if the profile is disabled (positive number) */
+	if (ret)
+		return ret;
+
+	ret = iwl_mld_config_sar_standalone_profile(mld, prof_a, prof_b);
+	/* standalone profile is optional and may be disabled (positive number) */
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 int iwl_mld_init_sar(struct iwl_mld *mld)
 {
 	int chain_a_prof = 1;
@@ -190,7 +254,7 @@ int iwl_mld_init_sar(struct iwl_mld *mld)
 		chain_b_prof = mld->fwrt.sar_chain_b_profile;
 	}
 
-	ret = iwl_mld_config_sar_profile(mld, chain_a_prof, chain_b_prof);
+	ret = iwl_mld_config_sar_profiles(mld, chain_a_prof, chain_b_prof);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.h b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.h
index 5498c19789f4..0877b951f2e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #ifndef __iwl_mld_regulatory_h__
 #define __iwl_mld_regulatory_h__
@@ -18,6 +18,6 @@ int iwl_mld_init_sgom(struct iwl_mld *mld);
 
 int iwl_mld_init_sar(struct iwl_mld *mld);
 
-int iwl_mld_config_sar_profile(struct iwl_mld *mld, int prof_a, int prof_b);
+int iwl_mld_config_sar_profiles(struct iwl_mld *mld, int prof_a, int prof_b);
 
 #endif /* __iwl_mld_regulatory_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0b5b41223a8a..c3402f5e47a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -911,7 +911,8 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 
 	ret = iwl_sar_fill_profile(&mvm->fwrt, per_chain,
 				   IWL_NUM_CHAIN_TABLES,
-				   n_subbands, prof_a, prof_b);
+				   n_subbands, prof_a, prof_b,
+				   mvm->fwrt.sar_profiles, false);
 
 	/* return on error or if the profile is disabled (positive number) */
 	if (ret)
-- 
2.34.1


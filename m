Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703A7439918
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142333; cv=none; b=LgGOi4NTtLE93sC0okPnsJCwYklv0E0yTL/2l3aHtGoCbQREeUcJ9M57gYFjTBMPurZB5Lsc0z8L21A856I9WDI4hj0r5GHZtFR8AcJ9eslbBb8YOhYh0ZWn53H01CtCrQJpTOR8JQv0dfO/ty0ZZ0g93h6CQ75vbgJCWO0Zpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142333; c=relaxed/simple;
	bh=pH1lFCRIGKHV2in1v5ZyU1HFY1QfiDCELSusSokwAQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rqi3/YrhYUE2teBS2bSrIiyvHMKIbcDpY25s+nk0HtFY6iT/txwCWgS7NeUpOewoLc/0l2zXPOwCKnleZ+HYf1BTm2E/nYiuCIUDq+Rfx56/zeFEl0rsTbjUgefTaFPqcoyp0D2/+T3UmJ7145D9tDUqmMkTnFFswGi3JZVbovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bvagC4EK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bvagC4EK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142322; x=1815678322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pH1lFCRIGKHV2in1v5ZyU1HFY1QfiDCELSusSokwAQQ=;
  b=bvagC4EKeeskjNxdk2kfQsz/XJFuYC5nGBvCAy0NtnacqB1XfZ6YBaxM
   zxuvvXHRCA43yMwCdhyrCfXygxldDfkMG0C/xVLyH8inkw9VYxaWIxA1N
   urNUwOvcJ45/9j3DEXbTM7NJD115tVm1HqRwhzcHNxasvfKKr1eyL8jJz
   3c/mMIC3wvmA1KU20hiy/emFzZoTdHfedHBl67T3VPQRdYbfchx0vfequ
   vOVkbaGiY0LcF40lDKnPRu3BW34KVvaOblrmp4/9NDV1olNypASpqQL53
   KQUphV6RvQ+DvLappA5OxBOtgmS1569xEh05wSNbxdnhG5H1nzEVDgdJS
   w==;
X-CSE-ConnectionGUID: 2yz+etgBSDyq3t3c1COWig==
X-CSE-MsgGUID: FV/ZLYgmQWaVpho1taqi9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340721"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340721"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:03 -0700
X-CSE-ConnectionGUID: a6Ai1JaPTw2jLLQxnIRPJg==
X-CSE-MsgGUID: NnsI5CCqQdK9nJ3X95EXBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851978"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:02 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: mld: honor FW puncturing capability in MCC response
Date: Wed, 15 Jul 2026 22:04:23 +0300
Message-Id: <20260715220243.47d1389fa134.I5c7921d6e3c065e3962c5927991498c2d277fd8f@changeid>
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

New MCC response versions expose puncturing support directly in the
regulatory capability flags. Propagate that information from NVM MCC
parsing to MLD MCC handling and fall back to legacy FM/WH MCC-specific
policy when puncturing status is unknown.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 30 ++++++++++++++++++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.h    | 22 ++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c  | 24 ++++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 4 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 761424812609..2f38eea42963 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -230,6 +230,18 @@ enum iwl_reg_capa_flags_v5 {
 	REG_CAPA_V5_11BN_DISABLED		= BIT(17),
 }; /* GEO_CHANNEL_CAPABILITIES_API_S_VER_4, 5 */
 
+/**
+ * enum iwl_reg_capa_flags_v6 - global capability flags,
+ *	applicable from MCC response version 10 onwards.
+ * Response v6 includes all members of iwl_reg_capa_flags_v5; only v6-specific
+ * additions are listed here.
+ * @REG_CAPA_V6_EHT_PUNCTURING_ENABLED: EHT puncturing is enabled for this
+ *	regulatory domain.
+ */
+enum iwl_reg_capa_flags_v6 {
+	REG_CAPA_V6_EHT_PUNCTURING_ENABLED	= BIT(18),
+}; /* GEO_CHANNEL_CAPABILITIES_API_S_VER_6 */
+
 /*
 * API v2 for reg_capa_flags is relevant from version 6 and onwards of the
 * MCC update command response.
@@ -241,6 +253,11 @@ enum iwl_reg_capa_flags_v5 {
  */
 #define REG_CAPA_V4_RESP_VER	8
 
+/* API v6 for reg_capa_flags is relevant from version 10 and onwards of the
+ * MCC update command response.
+ */
+#define REG_CAPA_V6_RESP_VER	10
+
 static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
 					       int chan, u32 flags)
 {
@@ -1686,6 +1703,13 @@ static struct iwl_reg_capa iwl_get_reg_capa(u32 flags, u8 resp_ver)
 {
 	struct iwl_reg_capa reg_capa = {};
 
+	if (resp_ver >= REG_CAPA_V6_RESP_VER) {
+		if (flags & REG_CAPA_V6_EHT_PUNCTURING_ENABLED)
+			reg_capa.puncturing_status = IWL_PUNCTURING_STATUS_ENABLED;
+		else
+			reg_capa.puncturing_status = IWL_PUNCTURING_STATUS_DISABLED;
+	}
+
 	if (resp_ver >= REG_CAPA_V4_RESP_VER) {
 		reg_capa.allow_40mhz = true;
 		reg_capa.allow_80mhz = flags & REG_CAPA_V5_80MHZ_ALLOWED;
@@ -1712,7 +1736,8 @@ static struct iwl_reg_capa iwl_get_reg_capa(u32 flags, u8 resp_ver)
 struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct iwl_trans *trans,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc,
-		       u16 geo_info, u32 cap, u8 resp_ver)
+		       u16 geo_info, u32 cap, u8 resp_ver,
+		       enum iwl_puncturing_status *puncturing_status)
 {
 	const struct iwl_rf_cfg *cfg = trans->cfg;
 	struct device *dev = trans->dev;
@@ -1772,6 +1797,9 @@ iwl_parse_nvm_mcc_info(struct iwl_trans *trans,
 	/* parse regulatory capability flags */
 	reg_capa = iwl_get_reg_capa(cap, resp_ver);
 
+	if (puncturing_status)
+		*puncturing_status = reg_capa.puncturing_status;
+
 	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
 		enum nl80211_band band =
 			iwl_nl80211_band_from_channel_idx(ch_idx);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index e676d7c2d6cc..9ebb72d3726a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2015, 2018-2025 Intel Corporation
+ * Copyright (C) 2005-2015, 2018-2026 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #ifndef __iwl_nvm_parse_h__
@@ -21,6 +21,19 @@ enum iwl_nvm_sbands_flags {
 	IWL_NVM_SBANDS_FLAGS_NO_WIDE_IN_5GHZ	= BIT(1),
 };
 
+/**
+ * enum iwl_puncturing_status - EHT puncturing status from MCC capabilities
+ * @IWL_PUNCTURING_STATUS_UNKNOWN: puncturing status is not provided by FW
+ *	or is not initialized yet
+ * @IWL_PUNCTURING_STATUS_ENABLED: puncturing is enabled for the current MCC
+ * @IWL_PUNCTURING_STATUS_DISABLED: puncturing is disabled for the current MCC
+ */
+enum iwl_puncturing_status {
+	IWL_PUNCTURING_STATUS_UNKNOWN,
+	IWL_PUNCTURING_STATUS_ENABLED,
+	IWL_PUNCTURING_STATUS_DISABLED,
+};
+
 /**
  * struct iwl_reg_capa - struct for global regulatory capabilities, Used for
  * handling the different APIs of reg_capa_flags.
@@ -36,6 +49,8 @@ enum iwl_nvm_sbands_flags {
  * @disable_11ax: 11ax is forbidden for this regulatory domain.
  * @disable_11be: 11be is forbidden for this regulatory domain.
  * @disable_11bn: UHR/11bn is not allowed for this regulatory domain
+ * @puncturing_status: EHT puncturing status for the current MCC.
+ *	See &enum iwl_puncturing_status.
  */
 struct iwl_reg_capa {
 	bool allow_40mhz;
@@ -45,6 +60,7 @@ struct iwl_reg_capa {
 	bool disable_11ax;
 	bool disable_11be;
 	bool disable_11bn;
+	enum iwl_puncturing_status puncturing_status;
 };
 
 /**
@@ -131,11 +147,13 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
  * @geo_info: geo info value
  * @cap: capability
  * @resp_ver: FW response version
+ * @puncturing_status: FW puncturing status for current MCC, when available
  */
 struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct iwl_trans *trans,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc,
-		       u16 geo_info, u32 cap, u8 resp_ver);
+		       u16 geo_info, u32 cap, u8 resp_ver,
+		       enum iwl_puncturing_status *puncturing_status);
 
 /**
  * struct iwl_nvm_section - describes an NVM section in memory.
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
index 7649ae794dfd..e3d1fa370616 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
@@ -89,6 +89,8 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 	struct iwl_mcc_update_resp_v8 *resp;
 	u8 resp_ver = iwl_fw_lookup_notif_ver(mld->fw, IWL_ALWAYS_LONG_GROUP,
 					      MCC_UPDATE_CMD, 0);
+	enum iwl_puncturing_status puncturing_status;
+	u16 mcc;
 
 	IWL_DEBUG_LAR(mld, "Getting regdomain data for %s from FW\n", alpha2);
 
@@ -110,12 +112,13 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 	}
 	IWL_DEBUG_LAR(mld, "MCC update response version: %d\n", resp_ver);
 
+	mcc = le16_to_cpu(resp->mcc);
 	regd = iwl_parse_nvm_mcc_info(mld->trans,
 				      __le32_to_cpu(resp->n_channels),
-				      resp->channels,
-				      __le16_to_cpu(resp->mcc),
+				      resp->channels, mcc,
 				      __le16_to_cpu(resp->geo_info),
-				      le32_to_cpu(resp->cap), resp_ver);
+				      le32_to_cpu(resp->cap), resp_ver,
+				      &puncturing_status);
 
 	if (IS_ERR(regd)) {
 		IWL_DEBUG_LAR(mld, "Could not get parse update from FW %ld\n",
@@ -129,18 +132,25 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 
 	mld->mcc_src = resp->source_id;
 
+	if (puncturing_status == IWL_PUNCTURING_STATUS_ENABLED)
+		__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
+			    mld->hw->flags);
+	else if (puncturing_status == IWL_PUNCTURING_STATUS_DISABLED)
+		ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
+
+	if (resp_ver >= 10)
+		goto out;
+
 	/* FM follows BIOS/MCC policy, WH disallows puncturing only in US/CA. */
 	if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) == IWL_CFG_RF_TYPE_FM) {
 		if (!iwl_puncturing_is_allowed_in_bios(mld->fwrt.bios_puncturing,
-						       le16_to_cpu(resp->mcc)))
+						       mcc))
 			ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
 		else
 			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
 				    mld->hw->flags);
 	} else if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) ==
-			IWL_CFG_RF_TYPE_WH) {
-		u16 mcc = le16_to_cpu(resp->mcc);
-
+		   IWL_CFG_RF_TYPE_WH) {
 		if (mcc == IWL_MCC_US || mcc == IWL_MCC_CANADA)
 			ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
 		else
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 14aec0bfd173..37e2e2c6b716 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -152,7 +152,7 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 				      resp->channels,
 				      __le16_to_cpu(resp->mcc),
 				      __le16_to_cpu(resp->geo_info),
-				      le32_to_cpu(resp->cap), resp_ver);
+				      le32_to_cpu(resp->cap), resp_ver, NULL);
 	/* Store the return source id */
 	src_id = resp->source_id;
 	if (IS_ERR_OR_NULL(regd)) {
-- 
2.34.1


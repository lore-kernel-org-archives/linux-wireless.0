Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920D43B19D0
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779912337; cv=none; b=CWBWIYpJL4BqZG5rrLt2YBIo6clhG87+K6XIVxEu1Mcf17YwbavLxtdB4upRFX62Su+7fVJV022Czy3CYLpDKlT//hu4eKPNe+Im92woYtYIecFKRBDN73FkFTxVbFvOFYCS8HDTlOqCETTamuIBPu6FweTuV5Lmn75KxljtcOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779912337; c=relaxed/simple;
	bh=KVtv0bRF9ZTblQUo4gaxw51w3/m7bTYMLtR5iG9IxnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GBl2waWtGqXWPMr+gBx2SJFk7qe6FFnvhm2M2baOld0poFYs1eyzN9QUD4UdzA3GtOgw2rjbjdAXBHzSuTrbotGMQuWF+MC/DcGWqKKehwtrcKySzGttq4v+h74YrMQ+Zfa2XJ3WLekrt3NAMY2HO56Y1AU49A6DxYahQxgCxEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDLB5Q+G; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDLB5Q+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779912336; x=1811448336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVtv0bRF9ZTblQUo4gaxw51w3/m7bTYMLtR5iG9IxnU=;
  b=WDLB5Q+G8ZXOZwP31QJxBPq2PJmK4Zw2Syhoyfl2IylgHOmV9+jSHNnf
   NzPvD69UtaUZY4pghPP99R5XLJyFMOu35MapnSarrlYhqy1BI5RamtIDy
   ljBkp5AjmiHL620yt/nsbPndgbUDFbBOEokwfUmdqF73phWZPhDkA1AjM
   dPeaRsbBYiLbirK4tOG3RCTzTs428SEEJ1J3L9zXmjGFpotNW87hqiCog
   QL3h5XrBuH+Zt/4OnR861TNL3kGZ4RGU5AcCn7J2z933Wdn3wFUHna6jL
   0ojIG3+AX06Ksz7I3aA4OEkRRAsCHPB4bVR4FsuANIWvAb7PWMnWU/2rR
   Q==;
X-CSE-ConnectionGUID: +CI4JGmuTGiKrxFnvI4Nfw==
X-CSE-MsgGUID: 7XC4CAekRmCNF85d4Vugzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80940865"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80940865"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:36 -0700
X-CSE-ConnectionGUID: iKrkhaEUSIa7U8OrsI+N1Q==
X-CSE-MsgGUID: gaDoopzoRIy1KLgwoCNz7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247286960"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: mvm: rename iwl_mvm_mac80211_idx_to_hwrate()
Date: Wed, 27 May 2026 23:05:03 +0300
Message-Id: <20260527230313.a60c8aea5b6c.I6af48d5d9748e184eed9d3437d312291cab61d7f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
References: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Given that we now use v3 rates with FW index throughout,
_to_hwrate() is confusing, since the hardware still uses
the PLCP value, the driver just doesn't see that now (as
it talks to firmware, not hardware.)

Rename this to iwl_mvm_rate_idx_to_fw_idx() to more
clearly indicate what it's doing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 8ffa72aca3cf..3e5084d10a60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -935,7 +935,7 @@ u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 			  : IWL_MAC_BEACON_CCK_V1;
 
 	if (iwl_fw_lookup_cmd_ver(fw, TX_CMD, 0) > 8)
-		flags |= iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
+		flags |= iwl_mvm_rate_idx_to_fw_idx(fw, rate_idx);
 	else
 		flags |= iwl_fw_rate_idx_to_plcp(rate_idx);
 
@@ -998,7 +998,7 @@ static void iwl_mvm_mac_ctxt_set_tx(struct iwl_mvm *mvm,
 	else
 		rate_n_flags |= RATE_MCS_MOD_TYPE_LEGACY_OFDM;
 
-	rate_n_flags |= iwl_mvm_mac80211_idx_to_hwrate(mvm->fw, rate);
+	rate_n_flags |= iwl_mvm_rate_idx_to_fw_idx(mvm->fw, rate);
 
 	tx_params->rate_n_flags = iwl_mvm_v3_rate_to_fw(rate_n_flags,
 							mvm->fw_rates_ver);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index be89b84204fb..393acf5c5f55 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1653,7 +1653,7 @@ int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
 void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 			       enum nl80211_band band,
 			       struct ieee80211_tx_rate *r);
-u8 iwl_mvm_mac80211_idx_to_hwrate(const struct iwl_fw *fw, int rate_idx);
+u8 iwl_mvm_rate_idx_to_fw_idx(const struct iwl_fw *fw, int rate_idx);
 u8 iwl_mvm_mac80211_ac_to_ucode_ac(enum ieee80211_ac_numbers ac);
 bool iwl_mvm_is_nic_ack_enabled(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bca13417e82c..dc69c71faa76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -268,7 +268,6 @@ static u32 iwl_mvm_convert_rate_idx(struct iwl_mvm *mvm,
 				    int rate_idx)
 {
 	u32 rate_flags = 0;
-	u8 rate_plcp;
 	bool is_cck;
 
 	/* if the rate isn't a well known legacy rate, take the lowest one */
@@ -277,8 +276,9 @@ static u32 iwl_mvm_convert_rate_idx(struct iwl_mvm *mvm,
 							    info,
 							    info->control.vif);
 
-	/* Get PLCP rate for tx_cmd->rate_n_flags */
-	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(mvm->fw, rate_idx);
+	/* Get FW rate for tx_cmd->rate_n_flags */
+	rate_flags |= iwl_mvm_rate_idx_to_fw_idx(mvm->fw, rate_idx);
+
 	is_cck = (rate_idx >= IWL_FIRST_CCK_RATE) &&
 		 (rate_idx <= IWL_LAST_CCK_RATE);
 
@@ -288,7 +288,7 @@ static u32 iwl_mvm_convert_rate_idx(struct iwl_mvm *mvm,
 	else
 		rate_flags |= RATE_MCS_MOD_TYPE_CCK;
 
-	return (u32)rate_plcp | rate_flags;
+	return rate_flags;
 }
 
 static u32 iwl_mvm_get_inject_tx_rate(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index f052537e9567..8aba9768afcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -157,7 +157,7 @@ int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
 	return -1;
 }
 
-u8 iwl_mvm_mac80211_idx_to_hwrate(const struct iwl_fw *fw, int rate_idx)
+u8 iwl_mvm_rate_idx_to_fw_idx(const struct iwl_fw *fw, int rate_idx)
 {
 	return rate_idx >= IWL_FIRST_OFDM_RATE ?
 		rate_idx - IWL_FIRST_OFDM_RATE :
-- 
2.34.1


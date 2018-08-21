Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726560AbeHUJ4R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:56:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:52 +0300
Message-Id: <20180821063657.30071-11-luca@coelho.fi> (sfid-20180821_083733_443326_472913C9)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 10/15] iwlwifi: mvm: support Coex Schema 2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erel Geron <erelx.geron@intel.com>

The new coex schema requires moving to SISO only when BT AG is 4.
Adjust the SISO criteria according to the coex schema version reported
by firmware.

Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/fw/file.h     | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c    | 9 +++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
index 87c1ddea75ae..68060085010f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -203,6 +205,7 @@ enum iwl_bt_activity_grading {
 	BT_ON_NO_CONNECTION	= 1,
 	BT_LOW_TRAFFIC		= 2,
 	BT_HIGH_TRAFFIC		= 3,
+	BT_VERY_HIGH_TRAFFIC	= 4,
 
 	BT_MAX_AG,
 }; /* BT_COEX_BT_ACTIVITY_GRADING_API_E_VER_1 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index fce52ee4caec..7638d0bb1e11 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -331,6 +331,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_STA_PM_NOTIF: firmware will send STA PM notification
  * @IWL_UCODE_TLV_CAPA_TLC_OFFLOAD: firmware implements rate scaling algorithm
  * @IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA: firmware implements quota related
+ * @IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2: firmware implements Coex Schema 2
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
@@ -388,6 +389,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_END_FIRST		= (__force iwl_ucode_tlv_capa_t)41,
 	IWL_UCODE_TLV_CAPA_TLC_OFFLOAD                  = (__force iwl_ucode_tlv_capa_t)43,
 	IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA                = (__force iwl_ucode_tlv_capa_t)44,
+	IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2		= (__force iwl_ucode_tlv_capa_t)45,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 016e03a5034f..9707f455086b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -331,7 +331,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	/* default smps_mode is AUTOMATIC - only used for client modes */
 	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_AUTOMATIC;
-	u32 bt_activity_grading;
+	u32 bt_activity_grading, min_ag_for_static_smps;
 	int ave_rssi;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -363,8 +363,13 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		return;
 	}
 
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2))
+		min_ag_for_static_smps = BT_VERY_HIGH_TRAFFIC;
+	else
+		min_ag_for_static_smps = BT_HIGH_TRAFFIC;
+
 	bt_activity_grading = le32_to_cpu(data->notif->bt_activity_grading);
-	if (bt_activity_grading >= BT_HIGH_TRAFFIC)
+	if (bt_activity_grading >= min_ag_for_static_smps)
 		smps_mode = IEEE80211_SMPS_STATIC;
 	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
 		smps_mode = IEEE80211_SMPS_DYNAMIC;
-- 
2.18.0

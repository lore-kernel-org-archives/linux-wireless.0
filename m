Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50724 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752040AbdDKMkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:40:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:30 +0300
Message-Id: <20170411123742.12214-14-luca@coelho.fi> (sfid-20170411_145543_905596_EBD2A3F0)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: support new ADD_MODIFY_STA_KEY command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The command was changed to support PN offload and TKIP offload.
The FW will do TKIP calculations in D0 only for a000 devices,
but API is aligned anyway.
However, for all devices we can stop sending the wowlan tkip
command.
Firmware will fetch the keys from the station key command.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  4 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    | 34 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 96 +++++++++++++++-------
 4 files changed, 102 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 9f639fdf0f6e..287e83eb30d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -241,6 +241,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	iteration complete notification, and the timestamp reported for RX
  *	received during scan, are reported in TSF of the mac specified in the
  *	scan request.
+ * @IWL_UCODE_TLV_API_TKIP_MIC_KEYS: This ucode supports version 2 of
+ *	ADD_MODIFY_STA_KEY_API_S_VER_2.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -250,6 +252,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_SCAN_TSF_REPORT	= (__force iwl_ucode_tlv_api_t)28,
+	IWL_UCODE_TLV_API_TKIP_MIC_KEYS		= (__force iwl_ucode_tlv_api_t)29,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b7465857b4b6..d65acfa3b89b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -998,7 +998,9 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 			goto out;
 	}
 
-	if (key_data.use_tkip) {
+	if (key_data.use_tkip &&
+	    !fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_TKIP_MIC_KEYS)) {
 		ret = iwl_mvm_send_cmd_pdu(mvm,
 					   WOWLAN_TKIP_PARAM,
 					   cmd_flags, sizeof(tkip_cmd),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 3b5150e9975d..cd5fdf83d040 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -389,28 +389,50 @@ struct iwl_mvm_add_sta_cmd {
 } __packed; /* ADD_STA_CMD_API_S_VER_8 */
 
 /**
- * struct iwl_mvm_add_sta_key_cmd - add/modify sta key
+ * struct iwl_mvm_add_sta_key_common - add/modify sta key common part
  * ( REPLY_ADD_STA_KEY = 0x17 )
  * @sta_id: index of station in uCode's station table
  * @key_offset: key offset in key storage
  * @key_flags: type %iwl_sta_key_flag
  * @key: key material data
  * @rx_secur_seq_cnt: RX security sequence counter for the key
- * @tkip_rx_tsc_byte2: TSC[2] for key mix ph1 detection
- * @tkip_rx_ttak: 10-byte unicast TKIP TTAK for Rx
  */
-struct iwl_mvm_add_sta_key_cmd {
+struct iwl_mvm_add_sta_key_common {
 	u8 sta_id;
 	u8 key_offset;
 	__le16 key_flags;
 	u8 key[32];
 	u8 rx_secur_seq_cnt[16];
+} __packed;
+
+/**
+ * struct iwl_mvm_add_sta_key_cmd_v1 - add/modify sta key
+ * @common: see &struct iwl_mvm_add_sta_key_common
+ * @tkip_rx_tsc_byte2: TSC[2] for key mix ph1 detection
+ * @tkip_rx_ttak: 10-byte unicast TKIP TTAK for Rx
+ */
+struct iwl_mvm_add_sta_key_cmd_v1 {
+	struct iwl_mvm_add_sta_key_common common;
 	u8 tkip_rx_tsc_byte2;
 	u8 reserved;
 	__le16 tkip_rx_ttak[5];
 } __packed; /* ADD_MODIFY_STA_KEY_API_S_VER_1 */
 
 /**
+ * struct iwl_mvm_add_sta_key_cmd - add/modify sta key
+ * @common: see &struct iwl_mvm_add_sta_key_common
+ * @rx_mic_key: TKIP RX unicast or multicast key
+ * @tx_mic_key: TKIP TX key
+ * @transmit_seq_cnt: TSC, transmit packet number
+ */
+struct iwl_mvm_add_sta_key_cmd {
+	struct iwl_mvm_add_sta_key_common common;
+	__le64 rx_mic_key;
+	__le64 tx_mic_key;
+	__le64 transmit_seq_cnt;
+} __packed; /* ADD_MODIFY_STA_KEY_API_S_VER_2 */
+
+/**
  * enum iwl_mvm_add_sta_rsp_status - status in the response to ADD_STA command
  * @ADD_STA_SUCCESS: operation was executed successfully
  * @ADD_STA_STATIONS_OVERLOAD: no room left in the fw's station table
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 41fd3ba574c0..26155e2efa84 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2738,68 +2738,97 @@ static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
 
 static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 				struct iwl_mvm_sta *mvm_sta,
-				struct ieee80211_key_conf *keyconf, bool mcast,
+				struct ieee80211_key_conf *key, bool mcast,
 				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
 				u8 key_offset)
 {
-	struct iwl_mvm_add_sta_key_cmd cmd = {};
+	union {
+		struct iwl_mvm_add_sta_key_cmd_v1 cmd_v1;
+		struct iwl_mvm_add_sta_key_cmd cmd;
+	} u = {};
 	__le16 key_flags;
 	int ret;
 	u32 status;
 	u16 keyidx;
-	int i;
-	u8 sta_id = mvm_sta->sta_id;
+	u64 pn = 0;
+	int i, size;
+	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_API_TKIP_MIC_KEYS);
 
-	keyidx = (keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
+	keyidx = (key->keyidx << STA_KEY_FLG_KEYID_POS) &
 		 STA_KEY_FLG_KEYID_MSK;
 	key_flags = cpu_to_le16(keyidx);
 	key_flags |= cpu_to_le16(STA_KEY_FLG_WEP_KEY_MAP);
 
-	switch (keyconf->cipher) {
+	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_TKIP);
-		cmd.tkip_rx_tsc_byte2 = tkip_iv32;
-		for (i = 0; i < 5; i++)
-			cmd.tkip_rx_ttak[i] = cpu_to_le16(tkip_p1k[i]);
-		memcpy(cmd.key, keyconf->key, keyconf->keylen);
+		if (new_api) {
+			memcpy((void *)&u.cmd.tx_mic_key,
+			       &key->key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
+			       IWL_MIC_KEY_SIZE);
+
+			memcpy((void *)&u.cmd.rx_mic_key,
+			       &key->key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
+			       IWL_MIC_KEY_SIZE);
+			pn = atomic64_read(&key->tx_pn);
+
+		} else {
+			u.cmd_v1.tkip_rx_tsc_byte2 = tkip_iv32;
+			for (i = 0; i < 5; i++)
+				u.cmd_v1.tkip_rx_ttak[i] =
+					cpu_to_le16(tkip_p1k[i]);
+		}
+		memcpy(u.cmd.common.key, key->key, key->keylen);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_CCM);
-		memcpy(cmd.key, keyconf->key, keyconf->keylen);
+		memcpy(u.cmd.common.key, key->key, key->keylen);
+		if (new_api)
+			pn = atomic64_read(&key->tx_pn);
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP_13BYTES);
 		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP);
-		memcpy(cmd.key + 3, keyconf->key, keyconf->keylen);
+		memcpy(u.cmd.common.key + 3, key->key, key->keylen);
 		break;
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_KEY_32BYTES);
 		/* fall through */
 	case WLAN_CIPHER_SUITE_GCMP:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_GCMP);
-		memcpy(cmd.key, keyconf->key, keyconf->keylen);
+		memcpy(u.cmd.common.key, key->key, key->keylen);
+		if (new_api)
+			pn = atomic64_read(&key->tx_pn);
 		break;
 	default:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_EXT);
-		memcpy(cmd.key, keyconf->key, keyconf->keylen);
+		memcpy(u.cmd.common.key, key->key, key->keylen);
 	}
 
 	if (mcast)
 		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
 
-	cmd.key_offset = key_offset;
-	cmd.key_flags = key_flags;
-	cmd.sta_id = sta_id;
+	u.cmd.common.key_offset = key_offset;
+	u.cmd.common.key_flags = key_flags;
+	u.cmd.common.sta_id = mvm_sta->sta_id;
+
+	if (new_api) {
+		u.cmd.transmit_seq_cnt = cpu_to_le64(pn);
+		size = sizeof(u.cmd);
+	} else {
+		size = sizeof(u.cmd_v1);
+	}
 
 	status = ADD_STA_SUCCESS;
 	if (cmd_flags & CMD_ASYNC)
-		ret =  iwl_mvm_send_cmd_pdu(mvm, ADD_STA_KEY, CMD_ASYNC,
-					    sizeof(cmd), &cmd);
+		ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA_KEY, CMD_ASYNC, size,
+					   &u.cmd);
 	else
-		ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
-						  &cmd, &status);
+		ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, size,
+						  &u.cmd, &status);
 
 	switch (status) {
 	case ADD_STA_SUCCESS:
@@ -2952,9 +2981,14 @@ static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
 				    struct ieee80211_key_conf *keyconf,
 				    bool mcast)
 {
-	struct iwl_mvm_add_sta_key_cmd cmd = {};
+	union {
+		struct iwl_mvm_add_sta_key_cmd_v1 cmd_v1;
+		struct iwl_mvm_add_sta_key_cmd cmd;
+	} u = {};
+	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_API_TKIP_MIC_KEYS);
 	__le16 key_flags;
-	int ret;
+	int ret, size;
 	u32 status;
 
 	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
@@ -2965,13 +2999,19 @@ static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
 	if (mcast)
 		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
 
-	cmd.key_flags = key_flags;
-	cmd.key_offset = keyconf->hw_key_idx;
-	cmd.sta_id = sta_id;
+	/*
+	 * The fields assigned here are in the same location at the start
+	 * of the command, so we can do this union trick.
+	 */
+	u.cmd.common.key_flags = key_flags;
+	u.cmd.common.key_offset = keyconf->hw_key_idx;
+	u.cmd.common.sta_id = sta_id;
+
+	size = new_api ? sizeof(u.cmd) : sizeof(u.cmd_v1);
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
-					  &cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, size, &u.cmd,
+					  &status);
 
 	switch (status) {
 	case ADD_STA_SUCCESS:
-- 
2.11.0

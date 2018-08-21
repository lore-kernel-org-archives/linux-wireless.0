Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42646 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726657AbeHUI2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:43 +0300
Message-Id: <20180821050952.31603-9-luca@coelho.fi> (sfid-20180821_071013_145606_2C3E2497)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 08/17] iwlwifi: mvm: support new WoWLAN status FW API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

A new FW API has been added for WOWLAN_GET_STATUSES to support
multiple GTK keys and IGTK keys.  Check the respective TLV and use the
new API when it is set.

Let most of the code use the new version (v7) and convert the old
version (v6) to the new one when needed.

Also refactor some functions a bit so that they can be reused more
easily.  Particularly the part that calls WOWLAN_GET_STATUSES which is
reused in D3 and D0i3.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |  89 +++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 154 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  17 +-
 5 files changed, 208 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index 57f4bc242023..6fae02fa4cad 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -374,7 +376,7 @@ enum iwl_wowlan_wakeup_reason {
 
 }; /* WOWLAN_WAKE_UP_REASON_API_E_VER_2 */
 
-struct iwl_wowlan_gtk_status {
+struct iwl_wowlan_gtk_status_v1 {
 	u8 key_index;
 	u8 reserved[3];
 	u8 decrypt_key[16];
@@ -382,9 +384,84 @@ struct iwl_wowlan_gtk_status {
 	struct iwl_wowlan_rsc_tsc_params_cmd rsc;
 } __packed; /* WOWLAN_GTK_MATERIAL_VER_1 */
 
+#define WOWLAN_KEY_MAX_SIZE	32
+#define WOWLAN_GTK_KEYS_NUM     2
+#define WOWLAN_IGTK_KEYS_NUM	2
+
+/**
+ * struct iwl_wowlan_gtk_status - GTK status
+ * @key: GTK material
+ * @key_len: GTK legth, if set to 0, the key is not available
+ * @key_flags: information about the key:
+ *	bits[0:1]:  key index assigned by the AP
+ *	bits[2:6]:  GTK index of the key in the internal DB
+ *	bit[7]:     Set iff this is the currently used GTK
+ * @reserved: padding
+ * @tkip_mic_key: TKIP RX MIC key
+ * @rsc: TSC RSC counters
+ */
+struct iwl_wowlan_gtk_status {
+	u8 key[WOWLAN_KEY_MAX_SIZE];
+	u8 key_len;
+	u8 key_flags;
+	u8 reserved[2];
+	u8 tkip_mic_key[8];
+	struct iwl_wowlan_rsc_tsc_params_cmd rsc;
+} __packed; /* WOWLAN_GTK_MATERIAL_VER_2 */
+
+#define IWL_WOWLAN_GTK_IDX_MASK		(BIT(0) | BIT(1))
+
+/**
+ * struct iwl_wowlan_igtk_status - IGTK status
+ * @key: IGTK material
+ * @ipn: the IGTK packet number (replay counter)
+ * @key_len: IGTK length, if set to 0, the key is not available
+ * @key_flags: information about the key:
+ *	bits[0]:    key index assigned by the AP (0: index 4, 1: index 5)
+ *	bits[1:5]:  IGTK index of the key in the internal DB
+ *	bit[6]:     Set iff this is the currently used IGTK
+ */
+struct iwl_wowlan_igtk_status {
+	u8 key[WOWLAN_KEY_MAX_SIZE];
+	u8 ipn[6];
+	u8 key_len;
+	u8 key_flags;
+} __packed; /* WOWLAN_IGTK_MATERIAL_VER_1 */
+
+/**
+ * struct iwl_wowlan_status_v6 - WoWLAN status
+ * @gtk: GTK data
+ * @replay_ctr: GTK rekey replay counter
+ * @pattern_number: number of the matched pattern
+ * @non_qos_seq_ctr: non-QoS sequence counter to use next
+ * @qos_seq_ctr: QoS sequence counters to use next
+ * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
+ * @num_of_gtk_rekeys: number of GTK rekeys
+ * @transmitted_ndps: number of transmitted neighbor discovery packets
+ * @received_beacons: number of received beacons
+ * @wake_packet_length: wakeup packet length
+ * @wake_packet_bufsize: wakeup packet buffer size
+ * @wake_packet: wakeup packet
+ */
+struct iwl_wowlan_status_v6 {
+	struct iwl_wowlan_gtk_status_v1 gtk;
+	__le64 replay_ctr;
+	__le16 pattern_number;
+	__le16 non_qos_seq_ctr;
+	__le16 qos_seq_ctr[8];
+	__le32 wakeup_reasons;
+	__le32 num_of_gtk_rekeys;
+	__le32 transmitted_ndps;
+	__le32 received_beacons;
+	__le32 wake_packet_length;
+	__le32 wake_packet_bufsize;
+	u8 wake_packet[]; /* can be truncated from _length to _bufsize */
+} __packed; /* WOWLAN_STATUSES_API_S_VER_6 */
+
 /**
  * struct iwl_wowlan_status - WoWLAN status
  * @gtk: GTK data
+ * @igtk: IGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched pattern
  * @non_qos_seq_ctr: non-QoS sequence counter to use next
@@ -398,7 +475,8 @@ struct iwl_wowlan_gtk_status {
  * @wake_packet: wakeup packet
  */
 struct iwl_wowlan_status {
-	struct iwl_wowlan_gtk_status gtk;
+	struct iwl_wowlan_gtk_status gtk[WOWLAN_GTK_KEYS_NUM];
+	struct iwl_wowlan_igtk_status igtk[WOWLAN_IGTK_KEYS_NUM];
 	__le64 replay_ctr;
 	__le16 pattern_number;
 	__le16 non_qos_seq_ctr;
@@ -410,7 +488,12 @@ struct iwl_wowlan_status {
 	__le32 wake_packet_length;
 	__le32 wake_packet_bufsize;
 	u8 wake_packet[]; /* can be truncated from _length to _bufsize */
-} __packed; /* WOWLAN_STATUSES_API_S_VER_6 */
+} __packed; /* WOWLAN_STATUSES_API_S_VER_7 */
+
+static inline u8 iwlmvm_wowlan_gtk_idx(struct iwl_wowlan_gtk_status *gtk)
+{
+	return gtk->key_flags & IWL_WOWLAN_GTK_IDX_MASK;
+}
 
 #define IWL_WOWLAN_TCP_MAX_PACKET_LEN		64
 #define IWL_WOWLAN_REMOTE_WAKE_MAX_PACKET_LEN	128
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 257ef70f8a1e..c116dc3fbffe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -276,6 +276,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_OCE			= (__force iwl_ucode_tlv_api_t)33,
 	IWL_UCODE_TLV_API_NEW_BEACON_TEMPLATE	= (__force iwl_ucode_tlv_api_t)34,
 	IWL_UCODE_TLV_API_NEW_RX_STATS		= (__force iwl_ucode_tlv_api_t)35,
+	IWL_UCODE_TLV_API_WOWLAN_KEY_MATERIAL	= (__force iwl_ucode_tlv_api_t)36,
 	IWL_UCODE_TLV_API_QUOTA_LOW_LATENCY	= (__force iwl_ucode_tlv_api_t)38,
 	IWL_UCODE_TLV_API_DEPRECATE_TTAK	= (__force iwl_ucode_tlv_api_t)41,
 	IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2	= (__force iwl_ucode_tlv_api_t)42,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 799ee015ef84..58531dd40c45 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1362,7 +1362,7 @@ static void iwl_mvm_set_key_rx_seq(struct iwl_mvm *mvm,
 				   struct ieee80211_key_conf *key,
 				   struct iwl_wowlan_status *status)
 {
-	union iwl_all_tsc_rsc *rsc = &status->gtk.rsc.all_tsc_rsc;
+	union iwl_all_tsc_rsc *rsc = &status->gtk[0].rsc.all_tsc_rsc;
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
@@ -1419,7 +1419,8 @@ static void iwl_mvm_d3_update_keys(struct ieee80211_hw *hw,
 	 */
 	if (sta) {
 		struct ieee80211_key_seq seq = {};
-		union iwl_all_tsc_rsc *sc = &data->status->gtk.rsc.all_tsc_rsc;
+		union iwl_all_tsc_rsc *sc =
+			&data->status->gtk[0].rsc.all_tsc_rsc;
 
 		if (data->find_phase)
 			return;
@@ -1501,23 +1502,24 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 			u8 key[32];
 		} conf = {
 			.conf.cipher = gtkdata.cipher,
-			.conf.keyidx = status->gtk.key_index,
+			.conf.keyidx =
+				iwlmvm_wowlan_gtk_idx(&status->gtk[0]),
 		};
 		__be64 replay_ctr;
 
 		switch (gtkdata.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 			conf.conf.keylen = WLAN_KEY_LEN_CCMP;
-			memcpy(conf.conf.key, status->gtk.decrypt_key,
+			memcpy(conf.conf.key, status->gtk[0].key,
 			       WLAN_KEY_LEN_CCMP);
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
 			conf.conf.keylen = WLAN_KEY_LEN_TKIP;
-			memcpy(conf.conf.key, status->gtk.decrypt_key, 16);
+			memcpy(conf.conf.key, status->gtk[0].key, 16);
 			/* leave TX MIC key zeroed, we don't use it anyway */
 			memcpy(conf.conf.key +
 			       NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY,
-			       status->gtk.tkip_mic_key, 8);
+			       status->gtk[0].tkip_mic_key, 8);
 			break;
 		}
 
@@ -1526,7 +1528,8 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 			return false;
 		iwl_mvm_set_key_rx_seq(mvm, key, status);
 
-		replay_ctr = cpu_to_be64(le64_to_cpu(status->replay_ctr));
+		replay_ctr =
+			cpu_to_be64(le64_to_cpu(status->replay_ctr));
 
 		ieee80211_gtk_rekey_notify(vif, vif->bss_conf.bssid,
 					   (void *)&replay_ctr, GFP_KERNEL);
@@ -1540,6 +1543,107 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 	return true;
 }
 
+struct iwl_wowlan_status *iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm)
+{
+	struct iwl_wowlan_status *v7, *status;
+	struct iwl_host_cmd cmd = {
+		.id = WOWLAN_GET_STATUSES,
+		.flags = CMD_WANT_SKB,
+	};
+	int ret, len, status_size;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret) {
+		IWL_ERR(mvm, "failed to query wakeup status (%d)\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_WOWLAN_KEY_MATERIAL)) {
+		struct iwl_wowlan_status_v6 *v6 = (void *)cmd.resp_pkt->data;
+		int data_size;
+
+		status_size = sizeof(*v6);
+		len = iwl_rx_packet_payload_len(cmd.resp_pkt);
+
+		if (len < status_size) {
+			IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+			status = ERR_PTR(-EIO);
+			goto out_free_resp;
+		}
+
+		data_size = ALIGN(le32_to_cpu(v6->wake_packet_bufsize), 4);
+
+		if (len != (status_size + data_size)) {
+			IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+			status = ERR_PTR(-EIO);
+			goto out_free_resp;
+		}
+
+		status = kzalloc(sizeof(*status) + data_size, GFP_KERNEL);
+		if (!status)
+			goto out_free_resp;
+
+		BUILD_BUG_ON(sizeof(v6->gtk.decrypt_key) >
+			     sizeof(status->gtk[0].key));
+		BUILD_BUG_ON(sizeof(v6->gtk.tkip_mic_key) >
+			     sizeof(status->gtk[0].tkip_mic_key));
+
+		/* copy GTK info to the right place */
+		memcpy(status->gtk[0].key, v6->gtk.decrypt_key,
+		       sizeof(v6->gtk.decrypt_key));
+		memcpy(status->gtk[0].tkip_mic_key, v6->gtk.tkip_mic_key,
+		       sizeof(v6->gtk.tkip_mic_key));
+		memcpy(&status->gtk[0].rsc, &v6->gtk.rsc,
+		       sizeof(status->gtk[0].rsc));
+
+		/* hardcode the key length to 16 since v6 only supports 16 */
+		status->gtk[0].key_len = 16;
+
+		/*
+		 * The key index only uses 2 bits (values 0 to 3) and
+		 * we always set bit 7 which means this is the
+		 * currently used key.
+		 */
+		status->gtk[0].key_flags = v6->gtk.key_index | BIT(7);
+
+		status->replay_ctr = v6->replay_ctr;
+
+		/* everything starting from pattern_number is identical */
+		memcpy(&status->pattern_number, &v6->pattern_number,
+		       offsetof(struct iwl_wowlan_status, wake_packet) -
+		       offsetof(struct iwl_wowlan_status, pattern_number) +
+		       data_size);
+
+		goto out_free_resp;
+	}
+
+	v7 = (void *)cmd.resp_pkt->data;
+	status_size = sizeof(*v7);
+	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
+
+	if (len < status_size) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		status = ERR_PTR(-EIO);
+		goto out_free_resp;
+	}
+
+	if (len != (status_size +
+		    ALIGN(le32_to_cpu(v7->wake_packet_bufsize), 4))) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		status = ERR_PTR(-EIO);
+		goto out_free_resp;
+	}
+
+	status = kmemdup(v7, len, GFP_KERNEL);
+
+out_free_resp:
+	iwl_free_resp(&cmd);
+	return status;
+}
+
 static struct iwl_wowlan_status *
 iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -1549,12 +1653,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		u32 valid;
 		u32 error_id;
 	} err_info;
-	struct iwl_host_cmd cmd = {
-		.id = WOWLAN_GET_STATUSES,
-		.flags = CMD_WANT_SKB,
-	};
-	struct iwl_wowlan_status *status, *fw_status;
-	int ret, len, status_size;
+	int ret;
 
 	iwl_trans_read_mem_bytes(mvm->trans, base,
 				 &err_info, sizeof(err_info));
@@ -1577,34 +1676,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (ret)
 		IWL_ERR(mvm, "failed to query offload statistics (%d)\n", ret);
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-	if (ret) {
-		IWL_ERR(mvm, "failed to query status (%d)\n", ret);
-		return ERR_PTR(ret);
-	}
-
-	status_size = sizeof(*fw_status);
-
-	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
-	if (len < status_size) {
-		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		fw_status = ERR_PTR(-EIO);
-		goto out_free_resp;
-	}
-
-	status = (void *)cmd.resp_pkt->data;
-	if (len != (status_size +
-		    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4))) {
-		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		fw_status = ERR_PTR(-EIO);
-		goto out_free_resp;
-	}
-
-	fw_status = kmemdup(status, len, GFP_KERNEL);
-
-out_free_resp:
-	iwl_free_resp(&cmd);
-	return fw_status;
+	return iwl_mvm_send_wowlan_get_status(mvm);
 }
 
 /* releases the MVM mutex */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b3987a0a7018..760d515a78b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1733,6 +1733,7 @@ void iwl_mvm_ipv6_addr_change(struct ieee80211_hw *hw,
 void iwl_mvm_set_default_unicast_key(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, int idx);
 extern const struct file_operations iwl_dbgfs_d3_test_ops;
+struct iwl_wowlan_status *iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm);
 #ifdef CONFIG_PM
 int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 				     struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 421509c63f23..d275832dbb14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1605,25 +1605,23 @@ void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
 static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, d0i3_exit_work);
-	struct iwl_host_cmd get_status_cmd = {
-		.id = WOWLAN_GET_STATUSES,
-		.flags = CMD_HIGH_PRIO | CMD_WANT_SKB,
-	};
 	struct iwl_mvm_d0i3_exit_work_iter_data iter_data = {
 		.mvm = mvm,
 	};
 
 	struct iwl_wowlan_status *status;
-	int ret;
 	u32 wakeup_reasons = 0;
 	__le16 *qos_seq = NULL;
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_send_cmd(mvm, &get_status_cmd);
-	if (ret)
+
+	status = iwl_mvm_send_wowlan_get_status(mvm);
+	if (IS_ERR_OR_NULL(status)) {
+		/* set to NULL so we don't need to check before kfree'ing */
+		status = NULL;
 		goto out;
+	}
 
-	status = (void *)get_status_cmd.resp_pkt->data;
 	wakeup_reasons = le32_to_cpu(status->wakeup_reasons);
 	qos_seq = status->qos_seq_ctr;
 
@@ -1642,8 +1640,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 		       wakeup_reasons);
 
 	/* qos_seq might point inside resp_pkt, so free it only now */
-	if (get_status_cmd.resp_pkt)
-		iwl_free_resp(&get_status_cmd);
+	kfree(status);
 
 	/* the FW might have updated the regdomain */
 	iwl_mvm_update_changed_regdom(mvm);
-- 
2.18.0

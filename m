Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42128 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbeHRLez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:34:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:42 +0300
Message-Id: <20180818082750.28717-9-luca@coelho.fi> (sfid-20180818_102816_118681_E7A554AC)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: mvm: add NOA and CSA to a probe response
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

A probe response built by a P2P GO should contain:
1. CSA/eCSA IE when relevant
2. If the corresponding probe request had P2P IE, then
need to add P2P IE with NOA attributes.

However, the NOA attributes and the updated channel switch
counter are known only to the FW. The solution is that FW
will send a notification with the relevant probe response
data and the driver will save it and update the probe
response accordingly.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 49 ++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 61 +++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  9 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 18 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 67 +++++++++++++++++++
 5 files changed, 204 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 17c7ef1662a9..ca49db786ed6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -71,12 +73,59 @@ enum iwl_mac_conf_subcmd_ids {
 	 * @LOW_LATENCY_CMD: &struct iwl_mac_low_latency_cmd
 	 */
 	LOW_LATENCY_CMD = 0x3,
+	/**
+	 * @PROBE_RESPONSE_DATA_NOTIF: &struct iwl_probe_resp_data_notif
+	 */
+	PROBE_RESPONSE_DATA_NOTIF = 0xFC,
+
 	/**
 	 * @CHANNEL_SWITCH_NOA_NOTIF: &struct iwl_channel_switch_noa_notif
 	 */
 	CHANNEL_SWITCH_NOA_NOTIF = 0xFF,
 };
 
+#define IWL_P2P_NOA_DESC_COUNT	(2)
+
+/**
+ * struct iwl_p2p_noa_attr - NOA attr contained in probe resp FW notification
+ *
+ * @id: attribute id
+ * @len_low: length low half
+ * @len_high: length high half
+ * @idx: instance of NoA timing
+ * @ctwin: GO's ct window and pwer save capability
+ * @desc: NoA descriptor
+ * @reserved: reserved for alignment purposes
+ */
+struct iwl_p2p_noa_attr {
+	u8 id;
+	u8 len_low;
+	u8 len_high;
+	u8 idx;
+	u8 ctwin;
+	struct ieee80211_p2p_noa_desc desc[IWL_P2P_NOA_DESC_COUNT];
+	u8 reserved;
+} __packed;
+
+#define IWL_PROBE_RESP_DATA_NO_CSA (0xff)
+
+/**
+ * struct iwl_probe_resp_data_notif - notification with NOA and CSA counter
+ *
+ * @mac_id: the mac which should send the probe response
+ * @noa_active: notifies if the noa attribute should be handled
+ * @noa_attr: P2P NOA attribute
+ * @csa_counter: current csa counter
+ * @reserved: reserved for alignment purposes
+ */
+struct iwl_probe_resp_data_notif {
+	__le32 mac_id;
+	__le32 noa_active;
+	struct iwl_p2p_noa_attr noa_attr;
+	u8 csa_counter;
+	u8 reserved[3];
+} __packed; /* PROBE_RESPONSE_DATA_NTFY_API_S_VER_1 */
+
 /**
  * struct iwl_channel_switch_noa_notif - Channel switch NOA notification
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b3fd20502abb..6a38a3ee4db0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +36,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1568,6 +1570,65 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	ieee80211_rx_napi(mvm->hw, NULL, skb, NULL);
 }
 
+static void iwl_mvm_probe_resp_data_iter(void *_data, u8 *mac,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_probe_resp_data_notif *notif = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_probe_resp_data *old_data, *new_data;
+
+	if (mvmvif->id != (u16)le32_to_cpu(notif->mac_id))
+		return;
+
+	new_data = kzalloc(sizeof(*new_data), GFP_KERNEL);
+	if (!new_data)
+		return;
+
+	memcpy(&new_data->notif, notif, sizeof(new_data->notif));
+
+	/* noa_attr contains 1 reserved byte, need to substruct it */
+	new_data->noa_len = sizeof(struct ieee80211_vendor_ie) +
+			    sizeof(new_data->notif.noa_attr) - 1;
+
+	/*
+	 * If it's a one time NoA, only one descriptor is needed,
+	 * adjust the length according to len_low.
+	 */
+	if (new_data->notif.noa_attr.len_low ==
+	    sizeof(struct ieee80211_p2p_noa_desc) + 2)
+		new_data->noa_len -= sizeof(struct ieee80211_p2p_noa_desc);
+
+	old_data = rcu_dereference_protected(mvmvif->probe_resp_data,
+					lockdep_is_held(&mvmvif->mvm->mutex));
+	rcu_assign_pointer(mvmvif->probe_resp_data, new_data);
+
+	if (old_data)
+		kfree_rcu(old_data, rcu_head);
+
+	if (notif->csa_counter != IWL_PROBE_RESP_DATA_NO_CSA &&
+	    notif->csa_counter >= 1)
+		ieee80211_csa_set_counter(vif, notif->csa_counter);
+}
+
+void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_probe_resp_data_notif *notif = (void *)pkt->data;
+	int len = iwl_rx_packet_payload_len(pkt);
+
+	if (WARN_ON_ONCE(len < sizeof(*notif)))
+		return;
+
+	IWL_DEBUG_INFO(mvm, "Probe response data notif: noa %d, csa %d\n",
+		       notif->noa_active, notif->csa_counter);
+
+	ieee80211_iterate_active_interfaces(mvm->hw,
+					    IEEE80211_IFACE_ITER_ACTIVE,
+					    iwl_mvm_probe_resp_data_iter,
+					    notif);
+}
+
 void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 				      struct iwl_rx_cmd_buffer *rxb)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b15b0d84bb7e..66a4ca090412 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1035,6 +1035,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 
 	mvmvif->phy_ctxt = NULL;
 	memset(&mvmvif->bf_data, 0, sizeof(mvmvif->bf_data));
+	memset(&mvmvif->probe_resp_data, 0, sizeof(mvmvif->probe_resp_data));
 }
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
@@ -1333,6 +1334,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	int ret;
 
 	mvmvif->mvm = mvm;
+	RCU_INIT_POINTER(mvmvif->probe_resp_data, NULL);
 
 	/*
 	 * make sure D0i3 exit is completed, otherwise a target access
@@ -1497,6 +1499,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_probe_resp_data *probe_data;
 
 	iwl_mvm_prepare_mac_removal(mvm, vif);
 
@@ -1506,6 +1509,12 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	probe_data = rcu_dereference_protected(mvmvif->probe_resp_data,
+					       lockdep_is_held(&mvm->mutex));
+	RCU_INIT_POINTER(mvmvif->probe_resp_data, NULL);
+	if (probe_data)
+		kfree_rcu(probe_data, rcu_head);
+
 	if (mvm->bf_allowed_vif == mvmvif) {
 		mvm->bf_allowed_vif = NULL;
 		vif->driver_flags &= ~(IEEE80211_VIF_BEACON_FILTER |
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 760d515a78b5..09d94aaa7d1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -335,6 +335,18 @@ struct iwl_mvm_vif_bf_data {
 	int last_bt_coex_event;
 };
 
+/**
+ * struct iwl_probe_resp_data - data for NoA/CSA updates
+ * @rcu_head: used for freeing the data on update
+ * @notif: notification data
+ * @noa_len: length of NoA attribute, calculated from the notification
+ */
+struct iwl_probe_resp_data {
+	struct rcu_head rcu_head;
+	struct iwl_probe_resp_data_notif notif;
+	int noa_len;
+};
+
 /**
  * struct iwl_mvm_vif - data per Virtual Interface, it is a MAC context
  * @id: between 0 and 3
@@ -365,6 +377,8 @@ struct iwl_mvm_vif_bf_data {
  *	average signal of beacons retrieved from the firmware
  * @csa_failed: CSA failed to schedule time event, report an error later
  * @features: hw features active for this vif
+ * @probe_resp_data: data from FW notification to store NOA and CSA related
+ *	data to be inserted into probe response.
  */
 struct iwl_mvm_vif {
 	struct iwl_mvm *mvm;
@@ -460,6 +474,8 @@ struct iwl_mvm_vif {
 
 	/* TCP Checksum Offload */
 	netdev_features_t features;
+
+	struct iwl_probe_resp_data __rcu *probe_resp_data;
 };
 
 static inline struct iwl_mvm_vif *
@@ -1602,6 +1618,8 @@ void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *exclude_vif);
+void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 				      struct iwl_rx_cmd_buffer *rxb);
 /* Bindings */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 83f3e74337db..796f010204d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -626,6 +626,66 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 	}
 }
 
+static void iwl_mvm_probe_resp_set_noa(struct iwl_mvm *mvm,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct iwl_mvm_vif *mvmvif =
+		iwl_mvm_vif_from_mac80211(info->control.vif);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	int base_len = (u8 *)mgmt->u.probe_resp.variable - (u8 *)mgmt;
+	struct iwl_probe_resp_data *resp_data;
+	u8 *ie, *pos;
+	u8 match[] = {
+		(WLAN_OUI_WFA >> 16) & 0xff,
+		(WLAN_OUI_WFA >> 8) & 0xff,
+		WLAN_OUI_WFA & 0xff,
+		WLAN_OUI_TYPE_WFA_P2P,
+	};
+
+	rcu_read_lock();
+
+	resp_data = rcu_dereference(mvmvif->probe_resp_data);
+	if (!resp_data)
+		goto out;
+
+	if (!resp_data->notif.noa_active)
+		goto out;
+
+	ie = (u8 *)cfg80211_find_ie_match(WLAN_EID_VENDOR_SPECIFIC,
+					  mgmt->u.probe_resp.variable,
+					  skb->len - base_len,
+					  match, 4, 2);
+	if (!ie) {
+		IWL_DEBUG_TX(mvm, "probe resp doesn't have P2P IE\n");
+		goto out;
+	}
+
+	if (skb_tailroom(skb) < resp_data->noa_len) {
+		if (pskb_expand_head(skb, 0, resp_data->noa_len, GFP_ATOMIC)) {
+			IWL_ERR(mvm,
+				"Failed to reallocate probe resp\n");
+			goto out;
+		}
+	}
+
+	pos = skb_put(skb, resp_data->noa_len);
+
+	*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+	/* Set length of IE body (not including ID and length itself) */
+	*pos++ = resp_data->noa_len - 2;
+	*pos++ = (WLAN_OUI_WFA >> 16) & 0xff;
+	*pos++ = (WLAN_OUI_WFA >> 8) & 0xff;
+	*pos++ = WLAN_OUI_WFA & 0xff;
+	*pos++ = WLAN_OUI_TYPE_WFA_P2P;
+
+	memcpy(pos, &resp_data->notif.noa_attr,
+	       resp_data->noa_len - sizeof(struct ieee80211_vendor_ie));
+
+out:
+	rcu_read_unlock();
+}
+
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -634,6 +694,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	struct iwl_device_cmd *dev_cmd;
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	int queue;
 
 	/* IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets that can be used
@@ -695,6 +756,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		}
 	}
 
+	if (unlikely(ieee80211_is_probe_resp(fc)))
+		iwl_mvm_probe_resp_set_noa(mvm, skb);
+
 	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, queue);
 
 	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, &info, hdrlen, NULL, sta_id);
@@ -1016,6 +1080,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
+	if (unlikely(ieee80211_is_probe_resp(fc)))
+		iwl_mvm_probe_resp_set_noa(mvm, skb);
+
 	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, info, hdrlen,
 					sta, mvmsta->sta_id);
 	if (!dev_cmd)
-- 
2.18.0

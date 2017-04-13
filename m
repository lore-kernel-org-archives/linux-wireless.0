Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51410 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754728AbdDMP0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:26:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:51 +0300
Message-Id: <20170413152507.9648-11-luca@coelho.fi> (sfid-20170413_172646_707143_9C376555)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 10/26] iwlwifi: mvm: support new TX API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support the new TX command API for a000 devices.
Command is a very slim version of current TX command.
Generalize iwl_mvm_tx_mpdu to get rid of TX command dependencies.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 42 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 66 ++++++++++++++++------
 2 files changed, 91 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 85744fa3bd4d..f83ee6e760d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -124,6 +125,20 @@ enum iwl_tx_flags {
 }; /* TX_FLAGS_BITS_API_S_VER_1 */
 
 /**
+ * enum iwl_tx_cmd_flags - bitmasks for tx_flags in TX command for a000
+ * @IWL_TX_FLAGS_CMD_RATE: use rate from the TX command
+ * @IWL_TX_FLAGS_ENCRYPT_DIS: frame should not be encrypted, even if it belongs
+ *	to a secured STA
+ * @IWL_TX_FLAGS_HIGH_PRI: high priority frame (like EAPOL) - can affect rate
+ *	selection, retry limits and BT kill
+ */
+enum iwl_tx_cmd_flags {
+	IWL_TX_FLAGS_CMD_RATE		= BIT(0),
+	IWL_TX_FLAGS_ENCRYPT_DIS	= BIT(1),
+	IWL_TX_FLAGS_HIGH_PRI		= BIT(2),
+}; /* TX_FLAGS_BITS_API_S_VER_3 */
+
+/**
  * enum iwl_tx_pm_timeouts - pm timeout values in TX command
  * @PM_FRAME_NONE: no need to suspend sleep mode
  * @PM_FRAME_MGMT: fw suspend sleep mode for 100TU
@@ -301,6 +316,31 @@ struct iwl_tx_cmd {
 	struct ieee80211_hdr hdr[0];
 } __packed; /* TX_CMD_API_S_VER_6 */
 
+struct iwl_dram_sec_info {
+	__le32 pn_low;
+	__le16 pn_high;
+	__le16 aux_info;
+} __packed; /* DRAM_SEC_INFO_API_S_VER_1 */
+
+/**
+ * struct iwl_tx_cmd_gen2 - TX command struct to FW for a000 devices
+ * ( TX_CMD = 0x1c )
+ * @len: in bytes of the payload, see below for details
+ * @offload_assist: TX offload configuration
+ * @tx_flags: combination of &iwl_tx_cmd_flags
+ * @dram_info: FW internal DRAM storage
+ * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
+ *	cleared. Combination of RATE_MCS_*
+ */
+struct iwl_tx_cmd_gen2 {
+	__le16 len;
+	__le16 offload_assist;
+	__le32 flags;
+	struct iwl_dram_sec_info dram_info;
+	__le32 rate_n_flags;
+	struct ieee80211_hdr hdr[0];
+} __packed; /* TX_CMD_API_S_VER_7 */
+
 /*
  * TX response related data
  */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d76cc422b040..279f56bf175f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -475,6 +475,39 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
 	dev_cmd->hdr.cmd = TX_CMD;
+
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		struct iwl_tx_cmd_gen2 *cmd = (void *)dev_cmd->payload;
+		u16 offload_assist = iwl_mvm_tx_csum(mvm, skb, hdr, info);
+
+		/* padding is inserted later in transport */
+		/* FIXME - check for AMSDU may need to be removed */
+		if (ieee80211_hdrlen(hdr->frame_control) % 4 &&
+		    !(offload_assist & BIT(TX_CMD_OFFLD_AMSDU)))
+			offload_assist |= BIT(TX_CMD_OFFLD_PAD);
+
+		cmd->offload_assist |= cpu_to_le16(offload_assist);
+
+		/* Total # bytes to be transmitted */
+		cmd->len = cpu_to_le16((u16)skb->len);
+
+		/* Copy MAC header from skb into command buffer */
+		memcpy(cmd->hdr, hdr, hdrlen);
+
+		if (!info->control.hw_key)
+			cmd->flags |= cpu_to_le32(IWL_TX_FLAGS_ENCRYPT_DIS);
+
+		/* For data packets rate info comes from the fw */
+		if (ieee80211_is_data(hdr->frame_control) && sta)
+			goto out;
+
+		cmd->flags |= cpu_to_le32(IWL_TX_FLAGS_CMD_RATE);
+		cmd->rate_n_flags =
+			cpu_to_le32(iwl_mvm_get_tx_rate(mvm, info, sta));
+
+		goto out;
+	}
+
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	if (info->control.hw_key)
@@ -484,6 +517,10 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	iwl_mvm_set_tx_cmd_rate(mvm, tx_cmd, info, sta, hdr->frame_control);
 
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
+
+out:
 	return dev_cmd;
 }
 
@@ -539,7 +576,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_info info;
 	struct iwl_device_cmd *dev_cmd;
-	struct iwl_tx_cmd *tx_cmd;
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	int queue;
@@ -613,11 +649,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	/* From now on, we cannot access info->control */
 	iwl_mvm_skb_prepare_status(skb, dev_cmd);
 
-	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
-
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdrlen);
-
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, queue)) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 		return -1;
@@ -878,7 +909,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_mvm_sta *mvmsta;
 	struct iwl_device_cmd *dev_cmd;
-	struct iwl_tx_cmd *tx_cmd;
 	__le16 fc;
 	u16 seq_number = 0;
 	u8 tid = IWL_MAX_TID_COUNT;
@@ -901,8 +931,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (!dev_cmd)
 		goto drop;
 
-	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
-
 	/*
 	 * we handle that entirely ourselves -- for uAPSD the firmware
 	 * will always send a notification, and for PS-Poll responses
@@ -923,18 +951,27 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 			goto drop_unlock_sta;
 
-		seq_number = mvmsta->tid_data[tid].seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
 		if (WARN_ON_ONCE(is_ampdu &&
 				 mvmsta->tid_data[tid].state != IWL_AGG_ON))
 			goto drop_unlock_sta;
+
+		seq_number = mvmsta->tid_data[tid].seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+
+		if (!iwl_mvm_has_new_tx_api(mvm)) {
+			struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
+
+			hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+			hdr->seq_ctrl |= cpu_to_le16(seq_number);
+			/* update the tx_cmd hdr as it was already copied */
+			tx_cmd->hdr->seq_ctrl = hdr->seq_ctrl;
+		}
 	}
 
 	if (iwl_mvm_is_dqa_supported(mvm) || is_ampdu)
 		txq_id = mvmsta->tid_data[tid].txq_id;
+
 	if (sta->tdls && !iwl_mvm_is_dqa_supported(mvm)) {
 		/* default to TID 0 for non-QoS packets */
 		u8 tdls_tid = tid == IWL_MAX_TID_COUNT ? 0 : tid;
@@ -942,9 +979,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		txq_id = mvmsta->hw_queue[tid_to_mac80211_ac[tdls_tid]];
 	}
 
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdrlen);
-
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
 	/* Check if TXQ needs to be allocated or re-activated */
-- 
2.11.0

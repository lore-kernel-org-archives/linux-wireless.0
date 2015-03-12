Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbbCLNEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/49] iwlwifi: mvm: add MCC update FW API
Date: Thu, 12 Mar 2015 15:03:48 +0200
Message-Id: <1426165474-25586-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140450_243301_0840A89C)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The new API sets an MCC (mobile country code) to FW and receives a
channel structure to be used as a basis for an updated regulatory domain.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h  |  2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 48 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  9 ++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c    | 84 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  1 +
 5 files changed, 144 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 6842545..9bb36d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -157,6 +157,7 @@ do {                                            			\
 /* 0x0000F000 - 0x00001000 */
 #define IWL_DL_ASSOC		0x00001000
 #define IWL_DL_DROP		0x00002000
+#define IWL_DL_LAR		0x00004000
 #define IWL_DL_COEX		0x00008000
 /* 0x000F0000 - 0x00010000 */
 #define IWL_DL_FW		0x00010000
@@ -219,5 +220,6 @@ do {                                            			\
 #define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
 #define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
 #define IWL_DEBUG_RPM(p, f, a...)	IWL_DEBUG(p, IWL_DL_RPM, f, ## a)
+#define IWL_DEBUG_LAR(p, f, a...)	IWL_DEBUG(p, IWL_DL_LAR, f, ## a)
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index d95b472..85afede 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -212,6 +212,9 @@ enum {
 	REPLY_RX_MPDU_CMD = 0xc1,
 	BA_NOTIF = 0xc5,
 
+	/* Location Aware Regulatory */
+	MCC_UPDATE_CMD = 0xc8,
+
 	MARKER_CMD = 0xcb,
 
 	/* BT Coex */
@@ -1674,4 +1677,49 @@ struct iwl_shared_mem_cfg {
 	__le32 page_buff_size;
 } __packed; /* SHARED_MEM_ALLOC_API_S_VER_1 */
 
+/***********************************
+ * Location Aware Regulatory (LAR) API - MCC updates
+ ***********************************/
+
+/**
+ * struct iwl_mcc_update_cmd - Request the device to update geographic
+ * regulatory profile according to the given MCC (Mobile Country Code).
+ * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
+ * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
+ * MCC in the cmd response will be the relevant MCC in the NVM.
+ * @mcc: given mobile country code
+ * @reserved: reserved for alignment
+ */
+struct iwl_mcc_update_cmd {
+	__le16 mcc;
+	__le16 reserved;
+} __packed; /* LAR_UPDATE_MCC_CMD_API_S */
+
+/**
+ * iwl_mcc_update_resp - response to MCC_UPDATE_CMD.
+ * Contains the new channel control profile map, if changed, and the new MCC
+ * (mobile country code).
+ * The new MCC may be different than what was requested in MCC_UPDATE_CMD.
+ * @status: 0 for success, 1 no change in channel profile, 2 invalid input.
+ * @mcc: the new applied MCC
+ * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
+ *		channels, depending on platform)
+ * @channels: channel control data map, DWORD for each channel. Only the first
+ *	16bits are used.
+ */
+struct iwl_mcc_update_resp {
+	__le32 status;
+	__le16 mcc;
+	__le16 reserved;
+	__le32 n_channels;
+	__le32 channels[0];
+} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S */
+
+enum iwl_mcc_update_status {
+	MCC_RESP_NEW_CHAN_PROFILE,
+	MCC_RESP_SAME_CHAN_PROFILE,
+	MCC_RESP_INVALID,
+	MCC_RESP_NVM_DISABLED,
+};
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e10172d..a0aa3b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -910,6 +910,11 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
+static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
+{
+	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+}
+
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
 	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SCD_CFG;
@@ -1389,6 +1394,10 @@ void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_get_temp(struct iwl_mvm *mvm);
 
+/* Location Aware Regulatory */
+struct iwl_mcc_update_resp *
+iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2);
+
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      bool added_vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 5383429..96107b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -570,3 +570,87 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 
 	return 0;
 }
+
+struct iwl_mcc_update_resp *
+iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2)
+{
+	struct iwl_mcc_update_cmd mcc_update_cmd = {
+		.mcc = cpu_to_le16(alpha2[0] << 8 | alpha2[1]),
+	};
+	struct iwl_mcc_update_resp *mcc_resp, *resp_cp = NULL;
+	struct iwl_rx_packet *pkt;
+	struct iwl_host_cmd cmd = {
+		.id = MCC_UPDATE_CMD,
+		.flags = CMD_WANT_SKB,
+		.data = { &mcc_update_cmd },
+	};
+
+	int ret;
+	u32 status;
+	int resp_len, n_channels;
+	u16 mcc;
+
+	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	cmd.len[0] = sizeof(struct iwl_mcc_update_cmd);
+
+	IWL_DEBUG_LAR(mvm, "send MCC update to FW with '%c%c'\n",
+		      alpha2[0], alpha2[1]);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret)
+		return ERR_PTR(ret);
+
+	pkt = cmd.resp_pkt;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERR(mvm, "Bad return from MCC_UPDATE_COMMAND (0x%08X)\n",
+			pkt->hdr.flags);
+		ret = -EIO;
+		goto exit;
+	}
+
+	/* Extract MCC response */
+	mcc_resp = (void *)pkt->data;
+	status = le32_to_cpu(mcc_resp->status);
+
+	if (status == MCC_RESP_INVALID) {
+		IWL_ERR(mvm,
+			"FW ERROR: MCC update with invalid parameter '%c%c'\n",
+			alpha2[0], alpha2[1]);
+		ret = -EINVAL;
+		goto exit;
+	} else if (status == MCC_RESP_NVM_DISABLED) {
+		ret = 0;
+		/* resp_cp will be NULL */
+		goto exit;
+	}
+
+	mcc = le16_to_cpu(mcc_resp->mcc);
+
+	/* W/A for a FW/NVM issue - returns 0x00 for the world domain */
+	if (mcc == 0) {
+		mcc = 0x3030;  /* "00" - world */
+		mcc_resp->mcc = cpu_to_le16(mcc);
+	}
+
+	n_channels =  __le32_to_cpu(mcc_resp->n_channels);
+	IWL_DEBUG_LAR(mvm,
+		      "MCC response status: 0x%x. new MCC: 0x%x ('%c%c') change: %d n_chans: %d\n",
+		      status, mcc, mcc >> 8, mcc & 0xff,
+		      !!(status == MCC_RESP_SAME_CHAN_PROFILE), n_channels);
+
+	resp_len = sizeof(*mcc_resp) + n_channels * sizeof(__le32);
+	resp_cp = kmemdup(mcc_resp, resp_len, GFP_KERNEL);
+	if (!resp_cp) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	ret = 0;
+exit:
+	iwl_free_resp(&cmd);
+	if (ret)
+		return ERR_PTR(ret);
+	return resp_cp;
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index fe40922..72b8e19 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -358,6 +358,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(TDLS_CHANNEL_SWITCH_CMD),
 	CMD(TDLS_CHANNEL_SWITCH_NOTIFICATION),
 	CMD(TDLS_CONFIG_CMD),
+	CMD(MCC_UPDATE_CMD),
 };
 #undef CMD
 
-- 
1.9.1


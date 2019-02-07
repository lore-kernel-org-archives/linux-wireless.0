Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C753C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AF182173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfBGWhK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:37:10 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56704 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbfBGWhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:37:10 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHo-0002II-Bo; Fri, 08 Feb 2019 00:36:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:19 +0200
Message-Id: <20190207223622.9642-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/17] iwlwifi: add FW recovery flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

Add new API and TLV for the ability to send commands in the beginning
and end of reset flow.

The full flow of recovery is:

1. While loading FW, get address (from the TLV) of target buffer
   to read in case of reset
2. If an error/assert happens read the address data from step 1.
3. Reset the HW and load the FW.
4. Send the data read in step 2.
5. Add station keys
6. Send notification to FW that reset flow is done.

The main use of the recovery flow is for support in PN/SN recovery
when offloaded

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/alive.h | 20 +++++++
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  5 ++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 14 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 54 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 18 +++++++
 9 files changed, 118 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
index 0026e259fd87..df1bd0d2450e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
@@ -197,4 +197,24 @@ struct iwl_card_state_notif {
 	__le32 flags;
 } __packed; /* CARD_STATE_NTFY_API_S_VER_1 */
 
+/**
+ * enum iwl_error_recovery_flags - flags for error recovery cmd
+ * @ERROR_RECOVERY_UPDATE_DB: update db from blob sent
+ * @ERROR_RECOVERY_END_OF_RECOVERY: end of recovery
+ */
+enum iwl_error_recovery_flags {
+	ERROR_RECOVERY_UPDATE_DB = BIT(0),
+	ERROR_RECOVERY_END_OF_RECOVERY = BIT(1),
+};
+
+/**
+ * struct iwl_fw_error_recovery_cmd - recovery cmd sent upon assert
+ * @flags: &enum iwl_error_recovery_flags
+ * @buf_size: db buffer size in bytes
+ */
+struct iwl_fw_error_recovery_cmd {
+	__le32 flags;
+	__le32 buf_size;
+} __packed; /* ERROR_RECOVERY_CMD_HDR_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_alive_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 0290b333d860..4d2274bcc0b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -643,6 +643,11 @@ enum iwl_system_subcmd_ids {
 	 * @INIT_EXTENDED_CFG_CMD: &struct iwl_init_extended_cfg_cmd
 	 */
 	INIT_EXTENDED_CFG_CMD = 0x03,
+
+	/**
+	 * @FW_ERROR_RECOVERY_CMD: &struct iwl_fw_error_recovery_cmd
+	 */
+	FW_ERROR_RECOVERY_CMD = 0x7,
 };
 
 #endif /* __iwl_fw_api_commands_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 886a620e03cf..3f61dc50c2d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -145,6 +145,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_IML		= 52,
 	IWL_UCODE_TLV_UMAC_DEBUG_ADDRS	= 54,
 	IWL_UCODE_TLV_LMAC_DEBUG_ADDRS	= 55,
+	IWL_UCODE_TLV_FW_RECOVERY_INFO	= 57,
 	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP | 0x1,
 	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP | 0x2,
 	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP | 0x3,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 6ffa2e39a25c..f4c5a4d73206 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -105,6 +105,8 @@ struct iwl_ucode_capabilities {
 	u32 n_scan_channels;
 	u32 standard_phy_calibration_size;
 	u32 flags;
+	u32 error_log_addr;
+	u32 error_log_size;
 	unsigned long _api[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_API)];
 	unsigned long _capa[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_CAPA)];
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 784e07b648e6..91ec90e5eb67 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1088,6 +1088,20 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				return -ENOMEM;
 			break;
 			}
+		case IWL_UCODE_TLV_FW_RECOVERY_INFO: {
+			struct {
+				__le32 buf_addr;
+				__le32 buf_size;
+			} *recov_info = (void *)tlv_data;
+
+			if (tlv_len != sizeof(*recov_info))
+				goto invalid_tlv_len;
+			capa->error_log_addr =
+				le32_to_cpu(recov_info->buf_addr);
+			capa->error_log_size =
+				le32_to_cpu(recov_info->buf_size);
+			}
+			break;
 		case IWL_UCODE_TLV_UMAC_DEBUG_ADDRS: {
 			struct iwl_umac_debug_addrs *dbg_ptrs =
 				(void *)tlv_data;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index cf7f8c340ffe..28ef204c9cf7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -976,6 +976,57 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 }
 #endif /* CONFIG_ACPI */
 
+void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
+{
+	u32 error_log_size = mvm->fw->ucode_capa.error_log_size;
+	int ret;
+	u32 resp;
+
+	struct iwl_fw_error_recovery_cmd recovery_cmd = {
+		.flags = cpu_to_le32(flags),
+		.buf_size = 0,
+	};
+	struct iwl_host_cmd host_cmd = {
+		.id = WIDE_ID(SYSTEM_GROUP, FW_ERROR_RECOVERY_CMD),
+		.flags = CMD_WANT_SKB,
+		.data = {&recovery_cmd, },
+		.len = {sizeof(recovery_cmd), },
+	};
+
+	/* no error log was defined in TLV */
+	if (!error_log_size)
+		return;
+
+	if (flags & ERROR_RECOVERY_UPDATE_DB) {
+		/* no buf was allocated while HW reset */
+		if (!mvm->error_recovery_buf)
+			return;
+
+		host_cmd.data[1] = mvm->error_recovery_buf;
+		host_cmd.len[1] =  error_log_size;
+		host_cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
+		recovery_cmd.buf_size = cpu_to_le32(error_log_size);
+	}
+
+	ret = iwl_mvm_send_cmd(mvm, &host_cmd);
+	kfree(mvm->error_recovery_buf);
+	mvm->error_recovery_buf = NULL;
+
+	if (ret) {
+		IWL_ERR(mvm, "Failed to send recovery cmd %d\n", ret);
+		return;
+	}
+
+	/* skb respond is only relevant in ERROR_RECOVERY_UPDATE_DB */
+	if (flags & ERROR_RECOVERY_UPDATE_DB) {
+		resp = le32_to_cpu(*(__le32 *)host_cmd.resp_pkt->data);
+		if (resp)
+			IWL_ERR(mvm,
+				"Failed to send recovery cmd blob was invalid %d\n",
+				resp);
+	}
+}
+
 static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 {
 	int ret;
@@ -1212,6 +1263,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		iwl_mvm_send_recovery_cmd(mvm, ERROR_RECOVERY_UPDATE_DB);
+
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0) {
 		ret = iwl_mvm_sar_geo_init(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9377fca39edf..c02559766712 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1326,6 +1326,8 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 	/* allow transport/FW low power modes */
 	iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+	iwl_mvm_send_recovery_cmd(mvm, ERROR_RECOVERY_END_OF_RECOVERY);
+
 	/*
 	 * If we have TDLS peers, remove them. We don't know the last seqno/PN
 	 * of packets the FW sent out, so we must reconnect.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0255157378db..c70fc90680af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1014,6 +1014,7 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 fw_restart;
+	u8 *error_recovery_buf;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
@@ -1657,6 +1658,7 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mfu_assert_dump_notif(struct iwl_mvm *mvm,
 				   struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags);
 void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 				   struct iwl_rx_cmd_buffer *rxb);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0c276124bf0f..f8a5a7074dc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -422,6 +422,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
 	HCMD_NAME(SHARED_MEM_CFG_CMD),
 	HCMD_NAME(INIT_EXTENDED_CFG_CMD),
+	HCMD_NAME(FW_ERROR_RECOVERY_CMD),
 };
 
 /* Please keep this array *SORTED* by hex value.
@@ -921,6 +922,9 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
+	kfree(mvm->error_recovery_buf);
+	mvm->error_recovery_buf = NULL;
+
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_IWLWIFI_DEBUGFS)
 	kfree(mvm->d3_resume_sram);
 #endif
@@ -1301,6 +1305,20 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 		/* don't let the transport/FW power down */
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+		if (mvm->fw->ucode_capa.error_log_size) {
+			u32 src_size = mvm->fw->ucode_capa.error_log_size;
+			u32 src_addr = mvm->fw->ucode_capa.error_log_addr;
+			u8 *recover_buf = kzalloc(src_size, GFP_ATOMIC);
+
+			if (recover_buf) {
+				mvm->error_recovery_buf = recover_buf;
+				iwl_trans_read_mem_bytes(mvm->trans,
+							 src_addr,
+							 recover_buf,
+							 src_size);
+			}
+		}
+
 		if (fw_error && mvm->fw_restart > 0)
 			mvm->fw_restart--;
 		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
-- 
2.20.1


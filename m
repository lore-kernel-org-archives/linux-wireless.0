Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3AWQta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 11:49:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] iwlwifi: query and report WoWLAN wakeup reason
Date: Wed, 23 Jan 2013 17:49:53 +0100
Message-Id: <1358959793-18051-1-git-send-email-johannes@sipsolutions.net> (sfid-20130123_174934_343150_D61452D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement proper WoWLAN wakeup and query the wakeup
reasons, then report them to userspace.

Note that this is tricky: a firmware bug (that has
been fixed in later versions) means that the status
command response isn't properly closed in hardware
and thus won't arrive at the host. Sending another
command after it closes the status response but the
next command gets stuck, etc. We reset the device
after querying though, so this is not a big issue,
just makes for strange code.

Change-Id: Ief6f3e5748ff04ec158c11f1699c6b33bbf8fd22
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h |  18 +++
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 163 ++++++++++++++++++++++------
 2 files changed, 150 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 8bce4b0..02c9ebb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -3897,6 +3897,24 @@ struct iwlagn_wowlan_kek_kck_material_cmd {
 	__le64	replay_ctr;
 } __packed;
 
+#define RF_KILL_INDICATOR_FOR_WOWLAN	0x87
+
+/*
+ * REPLY_WOWLAN_GET_STATUS = 0xe5
+ */
+struct iwlagn_wowlan_status {
+	__le64 replay_ctr;
+	__le32 rekey_status;
+	__le32 wakeup_reason;
+	u8 pattern_number;
+	u8 reserved1;
+	__le16 qos_seq_ctr[8];
+	__le16 non_qos_seq_ctr;
+	__le16 reserved2;
+	union iwlagn_all_tsc_rsc tsc_rsc;
+	__le16 reserved3;
+} __packed;
+
 /*
  * REPLY_WIPAN_PARAMS = 0xb2 (Commands and Notification)
  */
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 39dfa99..276b58a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -450,54 +450,154 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	return ret;
 }
 
+struct iwl_resume_data {
+	struct iwl_priv *priv;
+	struct iwlagn_wowlan_status *cmd;
+	bool valid;
+};
+
+static bool iwl_resume_status_fn(struct iwl_notif_wait_data *notif_wait,
+				 struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_resume_data *resume_data = data;
+	struct iwl_priv *priv = resume_data->priv;
+	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+
+	if (len - 4 != sizeof(*resume_data->cmd)) {
+		IWL_ERR(priv, "rx wrong size data\n");
+		return true;
+	}
+	memcpy(resume_data->cmd, pkt->data, sizeof(*resume_data->cmd));
+	resume_data->valid = true;
+
+	return true;
+}
+
 static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct ieee80211_vif *vif;
-	unsigned long flags;
-	u32 base, status = 0xffffffff;
-	int ret = -EIO;
+	u32 base;
+	int ret;
+	enum iwl_d3_status d3_status;
+	struct error_table_start {
+		/* cf. struct iwl_error_event_table */
+		u32 valid;
+		u32 error_id;
+	} err_info;
+	struct iwl_notification_wait status_wait;
+	static const u8 status_cmd[] = {
+		REPLY_WOWLAN_GET_STATUS,
+	};
+	struct iwlagn_wowlan_status status_data = {};
+	struct iwl_resume_data resume_data = {
+		.priv = priv,
+		.cmd = &status_data,
+		.valid = false,
+	};
+	struct cfg80211_wowlan_wakeup wakeup = {
+		.pattern_idx = -1,
+	};
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	const struct fw_img *img;
+#endif
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
 
-	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
-			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
+	vif = ctx->vif;
+
+	ret = iwl_trans_d3_resume(priv->trans, &d3_status);
+	if (ret)
+		goto out_unlock;
+
+	if (d3_status != IWL_D3_STATUS_ALIVE) {
+		IWL_INFO(priv, "Device was reset during suspend\n");
+		goto out_unlock;
+	}
 
 	base = priv->device_pointers.error_event_table;
-	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		if (iwl_trans_grab_nic_access(priv->trans, true)) {
-			iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, base);
-			status = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-			iwl_trans_release_nic_access(priv->trans);
-			ret = 0;
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_WARN(priv, "Invalid error table during resume!\n");
+		goto out_unlock;
+	}
+
+	iwl_trans_read_mem_bytes(priv->trans, base,
+				 &err_info, sizeof(err_info));
+
+	if (err_info.valid) {
+		IWL_INFO(priv, "error table is valid (%d, 0x%x)\n",
+			 err_info.valid, err_info.error_id);
+		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
+			wakeup.rfkill_release = true;
+			ieee80211_report_wowlan_wakeup(vif, &wakeup,
+						       GFP_KERNEL);
 		}
-		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
+		goto out_unlock;
+	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-		if (ret == 0) {
-			const struct fw_img *img;
-
-			img = &(priv->fw->img[IWL_UCODE_WOWLAN]);
-			if (!priv->wowlan_sram) {
-				priv->wowlan_sram =
-				   kzalloc(img->sec[IWL_UCODE_SECTION_DATA].len,
-						GFP_KERNEL);
-			}
+	img = &priv->fw->img[IWL_UCODE_WOWLAN];
+	if (!priv->wowlan_sram)
+		priv->wowlan_sram =
+			kzalloc(img->sec[IWL_UCODE_SECTION_DATA].len,
+				GFP_KERNEL);
+
+	if (priv->wowlan_sram)
+		iwl_trans_read_mem(priv->trans, 0x800000,
+				   priv->wowlan_sram,
+				   img->sec[IWL_UCODE_SECTION_DATA].len / 4);
+#endif
 
-			if (priv->wowlan_sram)
-				iwl_trans_read_mem(
-				      priv->trans, 0x800000,
-				      priv->wowlan_sram,
-				      img->sec[IWL_UCODE_SECTION_DATA].len / 4);
+	/*
+	 * This is very strange. The GET_STATUS command is sent but the device
+	 * doesn't reply properly, it seems it doesn't close the RBD so one is
+	 * always left open ... As a result, we need to send another command
+	 * and have to reset the driver afterwards. As we need to switch to
+	 * runtime firmware again that'll happen.
+	 */
+
+	iwl_init_notification_wait(&priv->notif_wait, &status_wait, status_cmd,
+				   ARRAY_SIZE(status_cmd), iwl_resume_status_fn,
+				   &resume_data);
+
+	iwl_dvm_send_cmd_pdu(priv, REPLY_WOWLAN_GET_STATUS, CMD_ASYNC, 0, NULL);
+	iwl_dvm_send_cmd_pdu(priv, REPLY_ECHO, CMD_ASYNC, 0, NULL);
+	/* an RBD is left open in the firmware now! */
+
+	ret = iwl_wait_notification(&priv->notif_wait, &status_wait, HZ/5);
+	if (ret)
+		goto out_unlock;
+
+	if (resume_data.valid && priv->contexts[IWL_RXON_CTX_BSS].vif) {
+		u32 reasons = le32_to_cpu(status_data.wakeup_reason);
+		struct cfg80211_wowlan_wakeup *wakeup_report;
+
+		IWL_INFO(priv, "WoWLAN wakeup reason(s): 0x%.8x\n", reasons);
+
+		if (reasons) {
+			if (reasons & IWLAGN_WOWLAN_WAKEUP_MAGIC_PACKET)
+				wakeup.magic_pkt = true;
+			if (reasons & IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH)
+				wakeup.pattern_idx = status_data.pattern_number;
+			if (reasons & (IWLAGN_WOWLAN_WAKEUP_BEACON_MISS |
+				       IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE))
+				wakeup.disconnect = true;
+			if (reasons & IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL)
+				wakeup.gtk_rekey_failure = true;
+			if (reasons & IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ)
+				wakeup.eap_identity_req = true;
+			if (reasons & IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE)
+				wakeup.four_way_handshake = true;
+			wakeup_report = &wakeup;
+		} else {
+			wakeup_report = NULL;
 		}
-#endif
-	}
 
-	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
-	vif = ctx->vif;
+		ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
+	}
 
 	priv->wowlan = false;
 
@@ -507,6 +607,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwl_connection_init_rx_config(priv, ctx);
 	iwlagn_set_rxon_chain(priv, ctx);
 
+ out_unlock:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-- 
1.8.0


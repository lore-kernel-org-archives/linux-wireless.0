Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:64562 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaAMUWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:22 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so3551013eaj.32
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/18] iwlwifi: add inline helper for packet lengths
Date: Mon, 13 Jan 2014 22:21:54 +0200
Message-Id: <1389644517-22807-15-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_360175_7AEB4B45)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add an inline helper function for getting an RX packet's
length or payload length and use it throughout the code
(most of which I did using an spatch.)

While at it, adjust some code, and remove a bogus comment
from the dvm calibration code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |    3 +--
 drivers/net/wireless/iwlwifi/dvm/rx.c         |    7 ++-----
 drivers/net/wireless/iwlwifi/dvm/ucode.c      |    7 +------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/d3.c         |   15 ++++++---------
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/utils.c      |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/rx.c        |    2 +-
 8 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 8a3286a..e2ba4a7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -407,9 +407,8 @@ static bool iwl_resume_status_fn(struct iwl_notif_wait_data *notif_wait,
 {
 	struct iwl_resume_data *resume_data = data;
 	struct iwl_priv *priv = resume_data->priv;
-	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 
-	if (len - 4 != sizeof(*resume_data->cmd)) {
+	if (iwl_rx_packet_payload_len(pkt) != sizeof(*resume_data->cmd)) {
 		IWL_ERR(priv, "rx wrong size data\n");
 		return true;
 	}
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index b68bb2f..7a1bc1c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -205,8 +205,7 @@ static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 __maybe_unused len =
-		le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	u32 __maybe_unused len = iwl_rx_packet_len(pkt);
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for PM_DEBUG_STATISTIC_NOTIFIC:\n", len);
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->data, len);
@@ -457,7 +456,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	const int reg_recalib_period = 60;
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	u32 len = iwl_rx_packet_payload_len(pkt);
 	__le32 *flag;
 	struct statistics_general_common *common;
 	struct statistics_rx_non_phy *rx_non_phy;
@@ -467,8 +466,6 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	struct statistics_tx *tx;
 	struct statistics_bt_activity *bt_activity;
 
-	len -= sizeof(struct iwl_cmd_header); /* skip header */
-
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d bytes).\n",
 		     len);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 4da6d90..9980635 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -389,7 +389,6 @@ static bool iwlagn_wait_calib(struct iwl_notif_wait_data *notif_wait,
 {
 	struct iwl_priv *priv = data;
 	struct iwl_calib_hdr *hdr;
-	int len;
 
 	if (pkt->hdr.cmd != CALIBRATION_RES_NOTIFICATION) {
 		WARN_ON(pkt->hdr.cmd != CALIBRATION_COMPLETE_NOTIFICATION);
@@ -397,12 +396,8 @@ static bool iwlagn_wait_calib(struct iwl_notif_wait_data *notif_wait,
 	}
 
 	hdr = (struct iwl_calib_hdr *)pkt->data;
-	len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 
-	/* reduce the size by the length field itself */
-	len -= sizeof(__le32);
-
-	if (iwl_calib_set(priv, hdr, len))
+	if (iwl_calib_set(priv, hdr, iwl_rx_packet_payload_len(pkt)))
 		IWL_ERR(priv, "Failed to record calibration data %d\n",
 			hdr->op_code);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8d1b5ed..1f065cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -176,6 +176,16 @@ struct iwl_rx_packet {
 	u8 data[];
 } __packed;
 
+static inline u32 iwl_rx_packet_len(const struct iwl_rx_packet *pkt)
+{
+	return le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+}
+
+static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
+{
+	return iwl_rx_packet_len(pkt) - sizeof(pkt->hdr);
+}
+
 /**
  * enum CMD_MODE - how to send the host commands ?
  *
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index f04d2f4..f36a7ee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -886,8 +886,7 @@ static int iwl_mvm_get_last_nonqos_seq(struct iwl_mvm *mvm,
 	if (err)
 		return err;
 
-	size = le32_to_cpu(cmd.resp_pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	size -= sizeof(cmd.resp_pkt->hdr);
+	size = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (size < sizeof(__le16)) {
 		err = -EINVAL;
 	} else {
@@ -1211,9 +1210,8 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	len = le32_to_cpu(d3_cfg_cmd.resp_pkt->len_n_flags) &
-		FH_RSCSR_FRAME_SIZE_MSK;
-	if (len >= sizeof(u32) * 2) {
+	len = iwl_rx_packet_payload_len(d3_cfg_cmd.resp_pkt);
+	if (len >= sizeof(u32)) {
 		mvm->d3_test_pme_ptr =
 			le32_to_cpup((__le32 *)d3_cfg_cmd.resp_pkt->data);
 	}
@@ -1668,8 +1666,8 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	else
 		status_size = sizeof(struct iwl_wowlan_status_v4);
 
-	len = le32_to_cpu(cmd.resp_pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	if (len - sizeof(struct iwl_cmd_header) < status_size) {
+	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
+	if (len < status_size) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
 		goto out_free_resp;
 	}
@@ -1704,8 +1702,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		status.wake_packet = status_v4->wake_packet;
 	}
 
-	if (len - sizeof(struct iwl_cmd_header) !=
-	    status_size + ALIGN(status.wake_packet_bufsize, 4)) {
+	if (len != status_size + ALIGN(status.wake_packet_bufsize, 4)) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
 		goto out_free_resp;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 50f3d7f..b4c2aba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -249,12 +249,12 @@ static bool iwl_mvm_time_event_response(struct iwl_notif_wait_data *notif_wait,
 		container_of(notif_wait, struct iwl_mvm, notif_wait);
 	struct iwl_mvm_time_event_data *te_data = data;
 	struct iwl_time_event_resp *resp;
-	int resp_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	int resp_len = iwl_rx_packet_payload_len(pkt);
 
 	if (WARN_ON(pkt->hdr.cmd != TIME_EVENT_CMD))
 		return true;
 
-	if (WARN_ON_ONCE(resp_len != sizeof(pkt->hdr) + sizeof(*resp))) {
+	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
 		IWL_ERR(mvm, "Invalid TIME_EVENT_CMD response\n");
 		return true;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 487d61b..a4a5e25 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -168,8 +168,8 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 		goto out_free_resp;
 	}
 
-	resp_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	if (WARN_ON_ONCE(resp_len != sizeof(pkt->hdr) + sizeof(*resp))) {
+	resp_len = iwl_rx_packet_payload_len(pkt);
+	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
 		ret = -EIO;
 		goto out_free_resp;
 	}
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 1890ea2..08c23d4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -615,7 +615,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			rxcb._offset, get_cmd_string(trans_pcie, pkt->hdr.cmd),
 			pkt->hdr.cmd);
 
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len = iwl_rx_packet_len(pkt);
 		len += sizeof(u32); /* account for status word */
 		trace_iwlwifi_dev_rx(trans->dev, trans, pkt, len);
 		trace_iwlwifi_dev_rx_data(trans->dev, trans, pkt, len);
-- 
1.7.9.5


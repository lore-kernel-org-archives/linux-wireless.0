Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbbHDU7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/37] iwlwifi: remove command header flags field
Date: Tue,  4 Aug 2015 23:43:07 +0300
Message-Id: <1438721007-23283-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230006_265363_120610A4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The 'flags' field really has been reserved in the firmware API for a
very long time, probably since 4965. As a consequence, the field is
always 0 and checking for a IWL_CMD_FAILED_MSK flag makes no sense.

Rename the field to 'reserved', get rid of IWL_CMD_FAILED_MSK and
all the code for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c   | 44 ++++++++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-trans.h |  6 +----
 drivers/net/wireless/iwlwifi/mvm/fw.c    |  7 -----
 drivers/net/wireless/iwlwifi/mvm/nvm.c   | 12 ---------
 drivers/net/wireless/iwlwifi/mvm/tdls.c  |  9 +------
 drivers/net/wireless/iwlwifi/mvm/utils.c |  5 ----
 drivers/net/wireless/iwlwifi/pcie/tx.c   |  2 +-
 7 files changed, 19 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index c18aa3e..0fa67d3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -65,12 +65,6 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 {
 	struct iwl_add_sta_resp *add_sta_resp = (void *)pkt->data;
 
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			pkt->hdr.flags);
-		return;
-	}
-
 	IWL_DEBUG_INFO(priv, "Processing response for adding station\n");
 
 	spin_lock_bh(&priv->sta_lock);
@@ -136,8 +130,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	add_sta_resp = (void *)pkt->data;
 
 	/* debug messages are printed in the handler */
-	if (!(pkt->hdr.flags & IWL_CMD_FAILED_MSK) &&
-	    add_sta_resp->status == ADD_STA_SUCCESS_MSK) {
+	if (add_sta_resp->status == ADD_STA_SUCCESS_MSK) {
 		spin_lock_bh(&priv->sta_lock);
 		ret = iwl_sta_ucode_activate(priv, sta_id);
 		spin_unlock_bh(&priv->sta_lock);
@@ -431,6 +424,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt;
 	int ret;
 	struct iwl_rem_sta_cmd rm_sta_cmd;
+	struct iwl_rem_sta_resp *rem_sta_resp;
 
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_REMOVE_STA,
@@ -450,29 +444,23 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 		return ret;
 
 	pkt = cmd.resp_pkt;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
-			  pkt->hdr.flags);
-		ret = -EIO;
-	}
+	rem_sta_resp = (void *)pkt->data;
 
-	if (!ret) {
-		struct iwl_rem_sta_resp *rem_sta_resp = (void *)pkt->data;
-		switch (rem_sta_resp->status) {
-		case REM_STA_SUCCESS_MSK:
-			if (!temporary) {
-				spin_lock_bh(&priv->sta_lock);
-				iwl_sta_ucode_deactivate(priv, sta_id);
-				spin_unlock_bh(&priv->sta_lock);
-			}
-			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
-			break;
-		default:
-			ret = -EIO;
-			IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
-			break;
+	switch (rem_sta_resp->status) {
+	case REM_STA_SUCCESS_MSK:
+		if (!temporary) {
+			spin_lock_bh(&priv->sta_lock);
+			iwl_sta_ucode_deactivate(priv, sta_id);
+			spin_unlock_bh(&priv->sta_lock);
 		}
+		IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
+		break;
+	default:
+		ret = -EIO;
+		IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
+		break;
 	}
+
 	iwl_free_resp(&cmd);
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7b6f095..64769e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -130,7 +130,7 @@
  */
 struct iwl_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
-	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
+	u8 reserved;
 	/*
 	 * The driver sets up the sequence number to values of its choosing.
 	 * uCode does not use this value, but passes it back to the driver
@@ -154,10 +154,6 @@ struct iwl_cmd_header {
 	__le16 sequence;
 } __packed;
 
-/* iwl_cmd_header flags value */
-#define IWL_CMD_FAILED_MSK 0x40
-
-
 #define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
 #define FH_RSCSR_FRAME_INVALID		0x55550000
 #define FH_RSCSR_FRAME_ALIGN		0x40
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index a5dae098..e905c07 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -444,12 +444,6 @@ static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 		return;
 
 	pkt = cmd.resp_pkt;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(mvm, "Bad return from SHARED_MEM_CFG (0x%08X)\n",
-			pkt->hdr.flags);
-		goto exit;
-	}
-
 	mem_cfg = (void *)pkt->data;
 
 	mvm->shared_mem_cfg.shared_mem_addr =
@@ -473,7 +467,6 @@ static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 		le32_to_cpu(mem_cfg->page_buff_size);
 	IWL_DEBUG_INFO(mvm, "SHARED MEM CFG: got memory offsets/sizes\n");
 
-exit:
 	iwl_free_resp(&cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 6dcdee7..328187d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -139,12 +139,6 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 		return ret;
 
 	pkt = cmd.resp_pkt;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(mvm, "Bad return from NVM_ACCES_COMMAND (0x%08X)\n",
-			pkt->hdr.flags);
-		ret = -EIO;
-		goto exit;
-	}
 
 	/* Extract NVM response */
 	nvm_resp = (void *)pkt->data;
@@ -652,12 +646,6 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		return ERR_PTR(ret);
 
 	pkt = cmd.resp_pkt;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(mvm, "Bad return from MCC_UPDATE_COMMAND (0x%08X)\n",
-			pkt->hdr.flags);
-		ret = -EIO;
-		goto exit;
-	}
 
 	/* Extract MCC response */
 	mcc_resp = (void *)pkt->data;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index 71802e7..d44d02d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -169,18 +169,11 @@ static void iwl_mvm_tdls_config(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 
 	pkt = cmd.resp_pkt;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(mvm, "Bad return from TDLS_CONFIG_COMMAND (0x%08X)\n",
-			pkt->hdr.flags);
-		goto exit;
-	}
 
-	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(pkt) != sizeof(*resp)))
-		goto exit;
+	WARN_ON_ONCE(iwl_rx_packet_payload_len(pkt) != sizeof(*resp));
 
 	/* we don't really care about the response at this point */
 
-exit:
 	iwl_free_resp(&cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 3b016f9..f50ef82 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -166,11 +166,6 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 		goto out_free_resp;
 	}
 
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		ret = -EIO;
-		goto out_free_resp;
-	}
-
 	resp_len = iwl_rx_packet_payload_len(pkt);
 	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
 		ret = -EIO;
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 90d02d5..553ae13 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1420,7 +1420,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	/* set up the header */
 
 	out_cmd->hdr.cmd = cmd->id;
-	out_cmd->hdr.flags = 0;
+	out_cmd->hdr.reserved = 0;
 	out_cmd->hdr.sequence =
 		cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
 					 INDEX_TO_SEQ(q->write_ptr));
-- 
2.1.4


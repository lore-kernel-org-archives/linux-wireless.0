Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34222 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753765AbdFVVVO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:38 +0300
Message-Id: <20170622212101.16422-3-luca@coelho.fi> (sfid-20170622_232127_511235_BB32C1AD)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: remove resp_pkt NULL checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Contrary to what some of the comments say, if rfkill was
asserted the transport will return -ERFKILL instead of
success, if CMD_WANT_SKB was set, so it's not necessary
to check cmd.resp_pkt for being NULL if the return code
was success.

Validate that this is true in iwl_trans_send_cmd().

Most of the other code modifications were done with the
following spatch:
    @@
    struct iwl_host_cmd cmd;
    identifier pkt;
    @@
    <...
    (
    pkt = cmd.resp_pkt;
    ...
    -if (!pkt) { ... }
    |
    pkt = cmd.resp_pkt;
    ...
    -if (WARN_ON(!pkt)) { ... }
    |
    -if (!cmd.resp_pkt) { ... }
    )
    ...>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c    | 12 ------------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c   |  4 ----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c   |  3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c |  5 -----
 5 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index c0871f8f2c68..dcf596217d9e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -143,6 +143,9 @@ int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (!(cmd->flags & CMD_ASYNC))
 		lock_map_release(&trans->sync_cmd_lockdep_map);
 
+	if (WARN_ON((cmd->flags & CMD_WANT_SKB) && !ret && !cmd->resp_pkt))
+		return -EIO;
+
 	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_trans_send_cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 119a3bd92c50..0493a03ec3ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1795,12 +1795,6 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return ERR_PTR(ret);
 	}
 
-	/* RF-kill already asserted again... */
-	if (!cmd.resp_pkt) {
-		fw_status = ERR_PTR(-ERFKILL);
-		goto out_free_resp;
-	}
-
 	status_size = sizeof(*fw_status);
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
@@ -1925,12 +1919,6 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 		return ret;
 	}
 
-	/* RF-kill already asserted again... */
-	if (!cmd.resp_pkt) {
-		ret = -ERFKILL;
-		goto out_free_resp;
-	}
-
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (len < sizeof(*query)) {
 		IWL_ERR(mvm, "Invalid scan offload profiles query response!\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 87b9ebfc653e..beead0bc08c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -118,10 +118,6 @@ static int iwl_nvm_write_chunk(struct iwl_mvm *mvm, u16 section,
 		return ret;
 
 	pkt = cmd.resp_pkt;
-	if (!pkt) {
-		IWL_ERR(mvm, "Error in NVM_ACCESS response\n");
-		return -EINVAL;
-	}
 	/* Extract & check NVM write response */
 	nvm_resp = (void *)pkt->data;
 	if (le16_to_cpu(nvm_resp->status) != READ_NVM_CHUNK_SUCCEED) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1da55e4a1048..c9686e31b32e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1611,9 +1611,6 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	if (ret)
 		goto out;
 
-	if (!get_status_cmd.resp_pkt)
-		goto out;
-
 	status = (void *)get_status_cmd.resp_pkt->data;
 	wakeup_reasons = le32_to_cpu(status->wakeup_reasons);
 	qos_seq = status->qos_seq_ctr;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 8f4f176e204e..cc5a56818db8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -168,11 +168,6 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 	}
 
 	pkt = cmd->resp_pkt;
-	/* Can happen if RFKILL is asserted */
-	if (!pkt) {
-		ret = 0;
-		goto out_free_resp;
-	}
 
 	resp_len = iwl_rx_packet_payload_len(pkt);
 	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
-- 
2.11.0

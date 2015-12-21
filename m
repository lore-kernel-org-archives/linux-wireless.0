Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbLUUwf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/45] iwlwifi: mvm: infrastructure for frame-release message
Date: Mon, 21 Dec 2015 22:50:39 +0200
Message-Id: <1450731046-2796-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220059_135098_E7B2ACEB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Incoming hardware will send frame release notifications to
the reorder buffer in order to update with the BA session
status and up to date NSSN.
This patch enables the API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 6 ++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 0a8d162..fb6d341 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -316,6 +316,8 @@ enum iwl_rx_mpdu_sta_id_flags {
 	IWL_RX_MPDU_SIF_FILTER_STATUS_MASK	= 0xc0,
 };
 
+#define IWL_RX_REORDER_DATA_INVALID_BAID 0x7f
+
 enum iwl_rx_mpdu_reorder_data {
 	IWL_RX_MPDU_REORDER_NSSN_MASK		= 0x00000fff,
 	IWL_RX_MPDU_REORDER_SN_MASK		= 0x00fff000,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0088106..86409c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1138,6 +1138,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 void iwl_mvm_rx_phy_cmd_mq(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
+void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
+			      struct iwl_rx_cmd_buffer *rxb, int queue);
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0885b77..2debce3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -822,6 +822,8 @@ static void iwl_mvm_rx(struct iwl_op_mode *op_mode,
 
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
 		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
+	else if (pkt->hdr.cmd == FRAME_RELEASE)
+		iwl_mvm_rx_frame_release(mvm, rxb, 0);
 	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
 		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
 	else
@@ -1488,8 +1490,12 @@ static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
 			      unsigned int queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
-	iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, queue);
+	if (unlikely(pkt->hdr.cmd == FRAME_RELEASE))
+		iwl_mvm_rx_frame_release(mvm, rxb, queue);
+	else
+		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, queue);
 }
 
 static const struct iwl_op_mode_ops iwl_mvm_ops_mq = {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c67962e..e2a872d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -370,3 +370,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, hdr, len, ampdu_status,
 					crypt_len, rxb);
 }
+
+void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
+			      struct iwl_rx_cmd_buffer *rxb, int queue)
+{
+	/* TODO */
+}
-- 
2.5.0


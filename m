Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36699 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbFVOyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:54:07 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 5/8] ath10k: add 10.4 fw specific htt msg definitions
Date: Mon, 22 Jun 2015 20:22:24 +0530
Message-ID: <1434984747-24294-6-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_165411_384347_F3E027C1)
In-Reply-To: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New htt event table is added for 10.4 firmware. Following new htt
events are available only 10.4. adding this to generic htt event
table,
	HTT_T2H_MSG_TYPE_EN_STATS,
	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
	HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
	HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v2 changes:
 - updated htt msg ids based on stable 10.4 firmware.

 drivers/net/wireless/ath/ath10k/core.c   |  3 +++
 drivers/net/wireless/ath/ath10k/htt.c    | 41 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    | 36 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 ++++
 drivers/net/wireless/ath/ath10k/hw.h     |  2 ++
 5 files changed, 86 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 020ac9f..b43565d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1121,6 +1121,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
 		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
+		ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
@@ -1146,6 +1147,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
 			break;
 		case ATH10K_FW_WMI_OP_VERSION_10_4:
+			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_4;
+			break;
 		case ATH10K_FW_WMI_OP_VERSION_UNSET:
 		case ATH10K_FW_WMI_OP_VERSION_MAX:
 			WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 6da6ef2..6f71f94 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -102,6 +102,43 @@ static const enum htt_t2h_msg_type htt_tlv_t2h_msg_types[] = {
 	[HTT_TLV_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
 };
 
+static const enum htt_t2h_msg_type htt_10_4_t2h_msg_types[] = {
+	[HTT_10_4_T2H_MSG_TYPE_VERSION_CONF] = HTT_T2H_MSG_TYPE_VERSION_CONF,
+	[HTT_10_4_T2H_MSG_TYPE_RX_IND] = HTT_T2H_MSG_TYPE_RX_IND,
+	[HTT_10_4_T2H_MSG_TYPE_RX_FLUSH] = HTT_T2H_MSG_TYPE_RX_FLUSH,
+	[HTT_10_4_T2H_MSG_TYPE_PEER_MAP] = HTT_T2H_MSG_TYPE_PEER_MAP,
+	[HTT_10_4_T2H_MSG_TYPE_PEER_UNMAP] = HTT_T2H_MSG_TYPE_PEER_UNMAP,
+	[HTT_10_4_T2H_MSG_TYPE_RX_ADDBA] = HTT_T2H_MSG_TYPE_RX_ADDBA,
+	[HTT_10_4_T2H_MSG_TYPE_RX_DELBA] = HTT_T2H_MSG_TYPE_RX_DELBA,
+	[HTT_10_4_T2H_MSG_TYPE_TX_COMPL_IND] = HTT_T2H_MSG_TYPE_TX_COMPL_IND,
+	[HTT_10_4_T2H_MSG_TYPE_PKTLOG] = HTT_T2H_MSG_TYPE_PKTLOG,
+	[HTT_10_4_T2H_MSG_TYPE_STATS_CONF] = HTT_T2H_MSG_TYPE_STATS_CONF,
+	[HTT_10_4_T2H_MSG_TYPE_RX_FRAG_IND] = HTT_T2H_MSG_TYPE_RX_FRAG_IND,
+	[HTT_10_4_T2H_MSG_TYPE_SEC_IND] = HTT_T2H_MSG_TYPE_SEC_IND,
+	[HTT_10_4_T2H_MSG_TYPE_RC_UPDATE_IND] = HTT_T2H_MSG_TYPE_RC_UPDATE_IND,
+	[HTT_10_4_T2H_MSG_TYPE_TX_INSPECT_IND] =
+				HTT_T2H_MSG_TYPE_TX_INSPECT_IND,
+	[HTT_10_4_T2H_MSG_TYPE_MGMT_TX_COMPL_IND] =
+				HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION,
+	[HTT_10_4_T2H_MSG_TYPE_CHAN_CHANGE] = HTT_T2H_MSG_TYPE_CHAN_CHANGE,
+	[HTT_10_4_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND] =
+				HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND,
+	[HTT_10_4_T2H_MSG_TYPE_RX_PN_IND] = HTT_T2H_MSG_TYPE_RX_PN_IND,
+	[HTT_10_4_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND] =
+				HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND,
+	[HTT_10_4_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
+	[HTT_10_4_T2H_MSG_TYPE_EN_STATS] = HTT_T2H_MSG_TYPE_EN_STATS,
+	[HTT_10_4_T2H_MSG_TYPE_AGGR_CONF] = HTT_T2H_MSG_TYPE_AGGR_CONF,
+	[HTT_10_4_T2H_MSG_TYPE_TX_FETCH_IND] =
+				HTT_T2H_MSG_TYPE_TX_FETCH_IND,
+	[HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONF] =
+				HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
+	[HTT_10_4_T2H_MSG_TYPE_STATS_NOUPLOAD] =
+				HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
+	[HTT_10_4_T2H_MSG_TYPE_TX_LOW_LATENCY_IND] =
+				HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND,
+};
+
 int ath10k_htt_connect(struct ath10k_htt *htt)
 {
 	struct ath10k_htc_svc_conn_req conn_req;
@@ -147,6 +184,10 @@ int ath10k_htt_init(struct ath10k *ar)
 		2; /* ip4 dscp or ip6 priority */
 
 	switch (ar->htt.op_version) {
+	case ATH10K_FW_HTT_OP_VERSION_10_4:
+		ar->htt.t2h_msg_types = htt_10_4_t2h_msg_types;
+		ar->htt.t2h_msg_types_max = HTT_10_4_T2H_NUM_MSGS;
+		break;
 	case ATH10K_FW_HTT_OP_VERSION_10_1:
 		ar->htt.t2h_msg_types = htt_10x_t2h_msg_types;
 		ar->htt.t2h_msg_types_max = HTT_10X_T2H_NUM_MSGS;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 7e8a0d8..8e64ace 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -349,6 +349,38 @@ enum htt_tlv_t2h_msg_type {
 	HTT_TLV_T2H_NUM_MSGS
 };
 
+enum htt_10_4_t2h_msg_type {
+	HTT_10_4_T2H_MSG_TYPE_VERSION_CONF           = 0x0,
+	HTT_10_4_T2H_MSG_TYPE_RX_IND                 = 0x1,
+	HTT_10_4_T2H_MSG_TYPE_RX_FLUSH               = 0x2,
+	HTT_10_4_T2H_MSG_TYPE_PEER_MAP               = 0x3,
+	HTT_10_4_T2H_MSG_TYPE_PEER_UNMAP             = 0x4,
+	HTT_10_4_T2H_MSG_TYPE_RX_ADDBA               = 0x5,
+	HTT_10_4_T2H_MSG_TYPE_RX_DELBA               = 0x6,
+	HTT_10_4_T2H_MSG_TYPE_TX_COMPL_IND           = 0x7,
+	HTT_10_4_T2H_MSG_TYPE_PKTLOG                 = 0x8,
+	HTT_10_4_T2H_MSG_TYPE_STATS_CONF             = 0x9,
+	HTT_10_4_T2H_MSG_TYPE_RX_FRAG_IND            = 0xa,
+	HTT_10_4_T2H_MSG_TYPE_SEC_IND                = 0xb,
+	HTT_10_4_T2H_MSG_TYPE_RC_UPDATE_IND          = 0xc,
+	HTT_10_4_T2H_MSG_TYPE_TX_INSPECT_IND         = 0xd,
+	HTT_10_4_T2H_MSG_TYPE_MGMT_TX_COMPL_IND      = 0xe,
+	HTT_10_4_T2H_MSG_TYPE_CHAN_CHANGE            = 0xf,
+	HTT_10_4_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND   = 0x10,
+	HTT_10_4_T2H_MSG_TYPE_RX_PN_IND              = 0x11,
+	HTT_10_4_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND = 0x12,
+	HTT_10_4_T2H_MSG_TYPE_TEST                   = 0x13,
+	HTT_10_4_T2H_MSG_TYPE_EN_STATS               = 0x14,
+	HTT_10_4_T2H_MSG_TYPE_AGGR_CONF              = 0x15,
+	HTT_10_4_T2H_MSG_TYPE_TX_FETCH_IND           = 0x16,
+	HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONF          = 0x17,
+	HTT_10_4_T2H_MSG_TYPE_STATS_NOUPLOAD         = 0x18,
+	/* 0x19 to 0x2f are reserved */
+	HTT_10_4_T2H_MSG_TYPE_TX_LOW_LATENCY_IND     = 0x30,
+	/* keep this last */
+	HTT_10_4_T2H_NUM_MSGS
+};
+
 enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_VERSION_CONF,
 	HTT_T2H_MSG_TYPE_RX_IND,
@@ -375,6 +407,10 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_AGGR_CONF,
 	HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
 	HTT_T2H_MSG_TYPE_TEST,
+	HTT_T2H_MSG_TYPE_EN_STATS,
+	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
+	HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
+	HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND,
 	/* keep this last */
 	HTT_T2H_NUM_MSGS
 };
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7399e45..d7d1183 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2072,6 +2072,10 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case HTT_T2H_MSG_TYPE_CHAN_CHANGE:
 		break;
+	case HTT_T2H_MSG_TYPE_EN_STATS:
+	case HTT_T2H_MSG_TYPE_TX_FETCH_IND:
+	case HTT_T2H_MSG_TYPE_TX_FETCH_CONF:
+	case HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND:
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
 			    resp->hdr.msg_type);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 568c5ea5..9172285 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -153,6 +153,8 @@ enum ath10k_fw_htt_op_version {
 
 	ATH10K_FW_HTT_OP_VERSION_TLV = 3,
 
+	ATH10K_FW_HTT_OP_VERSION_10_4 = 4,
+
 	/* keep last */
 	ATH10K_FW_HTT_OP_VERSION_MAX,
 };
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

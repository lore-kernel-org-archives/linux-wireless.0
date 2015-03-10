Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22001 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbbCJRfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 13:35:08 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT] ath10k: fix htt t2h message conflicts among firmware revisions
Date: Tue, 10 Mar 2015 23:04:43 +0530
Message-ID: <1426008883-12556-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150310_183534_736455_FFA8F2E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Target to host message type are conflicting between 10.x and other
firmware revisions. Separate target to host HTT message tables are
maintained for each firmware revisions (main, 10x and tlv) similar
to WMI abstraction.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    | 100 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    | 129 ++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/htt_rx.c |  12 ++-
 3 files changed, 213 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 4f59ab9..c1d92e9 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -22,6 +22,86 @@
 #include "core.h"
 #include "debug.h"
 
+static const enum htt_t2h_msg_type htt_main_t2h_msg_types[] = {
+	[HTT_MAIN_T2H_MSG_TYPE_VERSION_CONF] = HTT_T2H_MSG_TYPE_VERSION_CONF,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_IND] = HTT_T2H_MSG_TYPE_RX_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_FLUSH] = HTT_T2H_MSG_TYPE_RX_FLUSH,
+	[HTT_MAIN_T2H_MSG_TYPE_PEER_MAP] = HTT_T2H_MSG_TYPE_PEER_MAP,
+	[HTT_MAIN_T2H_MSG_TYPE_PEER_UNMAP] = HTT_T2H_MSG_TYPE_PEER_UNMAP,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_ADDBA] = HTT_T2H_MSG_TYPE_RX_ADDBA,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_DELBA] = HTT_T2H_MSG_TYPE_RX_DELBA,
+	[HTT_MAIN_T2H_MSG_TYPE_TX_COMPL_IND] = HTT_T2H_MSG_TYPE_TX_COMPL_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_PKTLOG] = HTT_T2H_MSG_TYPE_PKTLOG,
+	[HTT_MAIN_T2H_MSG_TYPE_STATS_CONF] = HTT_T2H_MSG_TYPE_STATS_CONF,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_FRAG_IND] = HTT_T2H_MSG_TYPE_RX_FRAG_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_SEC_IND] = HTT_T2H_MSG_TYPE_SEC_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_TX_INSPECT_IND] =
+		HTT_T2H_MSG_TYPE_TX_INSPECT_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_MGMT_TX_COMPL_IND] =
+		HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION,
+	[HTT_MAIN_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND] =
+		HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_PN_IND] = HTT_T2H_MSG_TYPE_RX_PN_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND] =
+		HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND,
+	[HTT_MAIN_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
+};
+
+static const enum htt_t2h_msg_type htt_10x_t2h_msg_types[] = {
+	[HTT_10X_T2H_MSG_TYPE_VERSION_CONF] = HTT_T2H_MSG_TYPE_VERSION_CONF,
+	[HTT_10X_T2H_MSG_TYPE_RX_IND] = HTT_T2H_MSG_TYPE_RX_IND,
+	[HTT_10X_T2H_MSG_TYPE_RX_FLUSH] = HTT_T2H_MSG_TYPE_RX_FLUSH,
+	[HTT_10X_T2H_MSG_TYPE_PEER_MAP] = HTT_T2H_MSG_TYPE_PEER_MAP,
+	[HTT_10X_T2H_MSG_TYPE_PEER_UNMAP] = HTT_T2H_MSG_TYPE_PEER_UNMAP,
+	[HTT_10X_T2H_MSG_TYPE_RX_ADDBA] = HTT_T2H_MSG_TYPE_RX_ADDBA,
+	[HTT_10X_T2H_MSG_TYPE_RX_DELBA] = HTT_T2H_MSG_TYPE_RX_DELBA,
+	[HTT_10X_T2H_MSG_TYPE_TX_COMPL_IND] = HTT_T2H_MSG_TYPE_TX_COMPL_IND,
+	[HTT_10X_T2H_MSG_TYPE_PKTLOG] = HTT_T2H_MSG_TYPE_PKTLOG,
+	[HTT_10X_T2H_MSG_TYPE_STATS_CONF] = HTT_T2H_MSG_TYPE_STATS_CONF,
+	[HTT_10X_T2H_MSG_TYPE_RX_FRAG_IND] = HTT_T2H_MSG_TYPE_RX_FRAG_IND,
+	[HTT_10X_T2H_MSG_TYPE_SEC_IND] = HTT_T2H_MSG_TYPE_SEC_IND,
+	[HTT_10X_T2H_MSG_TYPE_RC_UPDATE_IND] = HTT_T2H_MSG_TYPE_RC_UPDATE_IND,
+	[HTT_10X_T2H_MSG_TYPE_TX_INSPECT_IND] = HTT_T2H_MSG_TYPE_TX_INSPECT_IND,
+	[HTT_10X_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
+	[HTT_10X_T2H_MSG_TYPE_CHAN_CHANGE] = HTT_T2H_MSG_TYPE_CHAN_CHANGE,
+	[HTT_10X_T2H_MSG_TYPE_AGGR_CONF] = HTT_T2H_MSG_TYPE_AGGR_CONF,
+	[HTT_10X_T2H_MSG_TYPE_STATS_NOUPLOAD] = HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
+	[HTT_10X_T2H_MSG_TYPE_MGMT_TX_COMPL_IND] =
+		HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION,
+};
+
+static const enum htt_t2h_msg_type htt_tlv_t2h_msg_types[] = {
+	[HTT_TLV_T2H_MSG_TYPE_VERSION_CONF] = HTT_T2H_MSG_TYPE_VERSION_CONF,
+	[HTT_TLV_T2H_MSG_TYPE_RX_IND] = HTT_T2H_MSG_TYPE_RX_IND,
+	[HTT_TLV_T2H_MSG_TYPE_RX_FLUSH] = HTT_T2H_MSG_TYPE_RX_FLUSH,
+	[HTT_TLV_T2H_MSG_TYPE_PEER_MAP] = HTT_T2H_MSG_TYPE_PEER_MAP,
+	[HTT_TLV_T2H_MSG_TYPE_PEER_UNMAP] = HTT_T2H_MSG_TYPE_PEER_UNMAP,
+	[HTT_TLV_T2H_MSG_TYPE_RX_ADDBA] = HTT_T2H_MSG_TYPE_RX_ADDBA,
+	[HTT_TLV_T2H_MSG_TYPE_RX_DELBA] = HTT_T2H_MSG_TYPE_RX_DELBA,
+	[HTT_TLV_T2H_MSG_TYPE_TX_COMPL_IND] = HTT_T2H_MSG_TYPE_TX_COMPL_IND,
+	[HTT_TLV_T2H_MSG_TYPE_PKTLOG] = HTT_T2H_MSG_TYPE_PKTLOG,
+	[HTT_TLV_T2H_MSG_TYPE_STATS_CONF] = HTT_T2H_MSG_TYPE_STATS_CONF,
+	[HTT_TLV_T2H_MSG_TYPE_RX_FRAG_IND] = HTT_T2H_MSG_TYPE_RX_FRAG_IND,
+	[HTT_TLV_T2H_MSG_TYPE_SEC_IND] = HTT_T2H_MSG_TYPE_SEC_IND,
+	[HTT_TLV_T2H_MSG_TYPE_RC_UPDATE_IND] = HTT_T2H_MSG_TYPE_RC_UPDATE_IND,
+	[HTT_TLV_T2H_MSG_TYPE_TX_INSPECT_IND] = HTT_T2H_MSG_TYPE_TX_INSPECT_IND,
+	[HTT_TLV_T2H_MSG_TYPE_MGMT_TX_COMPLETION] =
+		HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION,
+	[HTT_TLV_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND] =
+		HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND,
+	[HTT_TLV_T2H_MSG_TYPE_RX_PN_IND] = HTT_T2H_MSG_TYPE_RX_PN_IND,
+	[HTT_TLV_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND] =
+		HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND,
+	[HTT_TLV_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND] =
+		HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND,
+	[HTT_TLV_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE] =
+		HTT_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE,
+	[HTT_TLV_T2H_MSG_TYPE_CHAN_CHANGE] = HTT_T2H_MSG_TYPE_CHAN_CHANGE,
+	[HTT_TLV_T2H_MSG_TYPE_RX_OFLD_PKT_ERR] =
+		HTT_T2H_MSG_TYPE_RX_OFLD_PKT_ERR,
+	[HTT_TLV_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
+};
+
 int ath10k_htt_connect(struct ath10k_htt *htt)
 {
 	struct ath10k_htc_svc_conn_req conn_req;
@@ -66,6 +146,26 @@ int ath10k_htt_init(struct ath10k *ar)
 		8 + /* llc snap */
 		2; /* ip4 dscp or ip6 priority */
 
+	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_MAIN:
+		ar->htt.t2h_msg_types = htt_main_t2h_msg_types;
+		ar->htt.t2h_msg_types_max = HTT_MAIN_T2H_NUM_MSGS;
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
+	case ATH10K_FW_WMI_OP_VERSION_10_2:
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
+		ar->htt.t2h_msg_types = htt_10x_t2h_msg_types;
+		ar->htt.t2h_msg_types_max = HTT_10X_T2H_NUM_MSGS;
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_TLV:
+		ar->htt.t2h_msg_types = htt_tlv_t2h_msg_types;
+		ar->htt.t2h_msg_types_max = HTT_TLV_T2H_NUM_MSGS;
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_UNSET:
+	case ATH10K_FW_WMI_OP_VERSION_MAX:
+		WARN_ON(1);
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 874bf44..6a1b158 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -271,39 +271,111 @@ enum htt_mgmt_tx_status {
 
 /*=== target -> host messages ===============================================*/
 
-enum htt_t2h_msg_type {
-	HTT_T2H_MSG_TYPE_VERSION_CONF		= 0x0,
-	HTT_T2H_MSG_TYPE_RX_IND			= 0x1,
-	HTT_T2H_MSG_TYPE_RX_FLUSH		= 0x2,
-	HTT_T2H_MSG_TYPE_PEER_MAP		= 0x3,
-	HTT_T2H_MSG_TYPE_PEER_UNMAP		= 0x4,
-	HTT_T2H_MSG_TYPE_RX_ADDBA		= 0x5,
-	HTT_T2H_MSG_TYPE_RX_DELBA		= 0x6,
-	HTT_T2H_MSG_TYPE_TX_COMPL_IND		= 0x7,
-	HTT_T2H_MSG_TYPE_PKTLOG			= 0x8,
-	HTT_T2H_MSG_TYPE_STATS_CONF		= 0x9,
-	HTT_T2H_MSG_TYPE_RX_FRAG_IND		= 0xa,
-	HTT_T2H_MSG_TYPE_SEC_IND		= 0xb,
-	HTT_T2H_MSG_TYPE_RC_UPDATE_IND		= 0xc,
-	HTT_T2H_MSG_TYPE_TX_INSPECT_IND		= 0xd,
-	HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION	= 0xe,
-	HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND	= 0xf,
-	HTT_T2H_MSG_TYPE_RX_PN_IND		= 0x10,
-	HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND = 0x11,
-	HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND	= 0x12,
+enum htt_main_t2h_msg_type {
+	HTT_MAIN_T2H_MSG_TYPE_VERSION_CONF             = 0x0,
+	HTT_MAIN_T2H_MSG_TYPE_RX_IND                   = 0x1,
+	HTT_MAIN_T2H_MSG_TYPE_RX_FLUSH                 = 0x2,
+	HTT_MAIN_T2H_MSG_TYPE_PEER_MAP                 = 0x3,
+	HTT_MAIN_T2H_MSG_TYPE_PEER_UNMAP               = 0x4,
+	HTT_MAIN_T2H_MSG_TYPE_RX_ADDBA                 = 0x5,
+	HTT_MAIN_T2H_MSG_TYPE_RX_DELBA                 = 0x6,
+	HTT_MAIN_T2H_MSG_TYPE_TX_COMPL_IND             = 0x7,
+	HTT_MAIN_T2H_MSG_TYPE_PKTLOG                   = 0x8,
+	HTT_MAIN_T2H_MSG_TYPE_STATS_CONF               = 0x9,
+	HTT_MAIN_T2H_MSG_TYPE_RX_FRAG_IND              = 0xa,
+	HTT_MAIN_T2H_MSG_TYPE_SEC_IND                  = 0xb,
+	HTT_MAIN_T2H_MSG_TYPE_TX_INSPECT_IND           = 0xd,
+	HTT_MAIN_T2H_MSG_TYPE_MGMT_TX_COMPL_IND        = 0xe,
+	HTT_MAIN_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND     = 0xf,
+	HTT_MAIN_T2H_MSG_TYPE_RX_PN_IND                = 0x10,
+	HTT_MAIN_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND   = 0x11,
+	HTT_MAIN_T2H_MSG_TYPE_TEST,
+	/* keep this last */
+	HTT_MAIN_T2H_NUM_MSGS
+};
+
+enum htt_10x_t2h_msg_type {
+	HTT_10X_T2H_MSG_TYPE_VERSION_CONF              = 0x0,
+	HTT_10X_T2H_MSG_TYPE_RX_IND                    = 0x1,
+	HTT_10X_T2H_MSG_TYPE_RX_FLUSH                  = 0x2,
+	HTT_10X_T2H_MSG_TYPE_PEER_MAP                  = 0x3,
+	HTT_10X_T2H_MSG_TYPE_PEER_UNMAP                = 0x4,
+	HTT_10X_T2H_MSG_TYPE_RX_ADDBA                  = 0x5,
+	HTT_10X_T2H_MSG_TYPE_RX_DELBA                  = 0x6,
+	HTT_10X_T2H_MSG_TYPE_TX_COMPL_IND              = 0x7,
+	HTT_10X_T2H_MSG_TYPE_PKTLOG                    = 0x8,
+	HTT_10X_T2H_MSG_TYPE_STATS_CONF                = 0x9,
+	HTT_10X_T2H_MSG_TYPE_RX_FRAG_IND               = 0xa,
+	HTT_10X_T2H_MSG_TYPE_SEC_IND                   = 0xb,
+	HTT_10X_T2H_MSG_TYPE_RC_UPDATE_IND             = 0xc,
+	HTT_10X_T2H_MSG_TYPE_TX_INSPECT_IND            = 0xd,
+	HTT_10X_T2H_MSG_TYPE_TEST                      = 0xe,
+	HTT_10X_T2H_MSG_TYPE_CHAN_CHANGE               = 0xf,
+	HTT_10X_T2H_MSG_TYPE_AGGR_CONF                 = 0x11,
+	HTT_10X_T2H_MSG_TYPE_STATS_NOUPLOAD            = 0x12,
+	HTT_10X_T2H_MSG_TYPE_MGMT_TX_COMPL_IND         = 0x13,
+	/* keep this last */
+	HTT_10X_T2H_NUM_MSGS
+};
+
+enum htt_tlv_t2h_msg_type {
+	HTT_TLV_T2H_MSG_TYPE_VERSION_CONF              = 0x0,
+	HTT_TLV_T2H_MSG_TYPE_RX_IND                    = 0x1,
+	HTT_TLV_T2H_MSG_TYPE_RX_FLUSH                  = 0x2,
+	HTT_TLV_T2H_MSG_TYPE_PEER_MAP                  = 0x3,
+	HTT_TLV_T2H_MSG_TYPE_PEER_UNMAP                = 0x4,
+	HTT_TLV_T2H_MSG_TYPE_RX_ADDBA                  = 0x5,
+	HTT_TLV_T2H_MSG_TYPE_RX_DELBA                  = 0x6,
+	HTT_TLV_T2H_MSG_TYPE_TX_COMPL_IND              = 0x7,
+	HTT_TLV_T2H_MSG_TYPE_PKTLOG                    = 0x8,
+	HTT_TLV_T2H_MSG_TYPE_STATS_CONF                = 0x9,
+	HTT_TLV_T2H_MSG_TYPE_RX_FRAG_IND               = 0xa,
+	HTT_TLV_T2H_MSG_TYPE_SEC_IND                   = 0xb,
+	HTT_TLV_T2H_MSG_TYPE_RC_UPDATE_IND             = 0xc, /* deprecated */
+	HTT_TLV_T2H_MSG_TYPE_TX_INSPECT_IND            = 0xd,
+	HTT_TLV_T2H_MSG_TYPE_MGMT_TX_COMPLETION        = 0xe,
+	HTT_TLV_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND      = 0xf,
+	HTT_TLV_T2H_MSG_TYPE_RX_PN_IND                 = 0x10,
+	HTT_TLV_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND    = 0x11,
+	HTT_TLV_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND       = 0x12,
 	/* 0x13 reservd */
-	HTT_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE	= 0x14,
+	HTT_TLV_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE       = 0x14,
+	HTT_TLV_T2H_MSG_TYPE_CHAN_CHANGE               = 0x15,
+	HTT_TLV_T2H_MSG_TYPE_RX_OFLD_PKT_ERR           = 0x16,
+	HTT_TLV_T2H_MSG_TYPE_TEST,
+	/* keep this last */
+	HTT_TLV_T2H_NUM_MSGS
+};
 
-	/* FIXME: Do not depend on this event id. Numbering of this event id is
-	 * broken across different firmware revisions and HTT version fails to
-	 * indicate this.
-	 */
+enum htt_t2h_msg_type {
+	HTT_T2H_MSG_TYPE_VERSION_CONF,
+	HTT_T2H_MSG_TYPE_RX_IND,
+	HTT_T2H_MSG_TYPE_RX_FLUSH,
+	HTT_T2H_MSG_TYPE_PEER_MAP,
+	HTT_T2H_MSG_TYPE_PEER_UNMAP,
+	HTT_T2H_MSG_TYPE_RX_ADDBA,
+	HTT_T2H_MSG_TYPE_RX_DELBA,
+	HTT_T2H_MSG_TYPE_TX_COMPL_IND,
+	HTT_T2H_MSG_TYPE_PKTLOG,
+	HTT_T2H_MSG_TYPE_STATS_CONF,
+	HTT_T2H_MSG_TYPE_RX_FRAG_IND,
+	HTT_T2H_MSG_TYPE_SEC_IND,
+	HTT_T2H_MSG_TYPE_RC_UPDATE_IND,
+	HTT_T2H_MSG_TYPE_TX_INSPECT_IND,
+	HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION,
+	HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND,
+	HTT_T2H_MSG_TYPE_RX_PN_IND,
+	HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND,
+	HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND,
+	HTT_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE,
+	HTT_T2H_MSG_TYPE_CHAN_CHANGE,
+	HTT_T2H_MSG_TYPE_RX_OFLD_PKT_ERR,
+	HTT_T2H_MSG_TYPE_AGGR_CONF,
+	HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
 	HTT_T2H_MSG_TYPE_TEST,
-
 	/* keep this last */
 	HTT_T2H_NUM_MSGS
 };
-
 /*
  * htt_resp_hdr - header for target-to-host messages
  *
@@ -1249,6 +1321,9 @@ struct ath10k_htt {
 	u8 target_version_minor;
 	struct completion target_version_received;
 
+	const enum htt_t2h_msg_type *t2h_msg_types;
+	u32 t2h_msg_types_max;
+
 	struct {
 		/*
 		 * Ring of network buffer objects - This ring is
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 01a2b38..46c163b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1892,6 +1892,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
+	enum htt_t2h_msg_type type;
 
 	/* confirm alignment */
 	if (!IS_ALIGNED((unsigned long)skb->data, 4))
@@ -1899,7 +1900,16 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx, msg_type: 0x%0X\n",
 		   resp->hdr.msg_type);
-	switch (resp->hdr.msg_type) {
+
+	if (resp->hdr.msg_type >= ar->htt.t2h_msg_types_max) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx, unsupported msg_type: 0x%0X\n max: 0x%0X",
+			   resp->hdr.msg_type, ar->htt.t2h_msg_types_max);
+		dev_kfree_skb_any(skb);
+		return;
+	}
+	type = ar->htt.t2h_msg_types[resp->hdr.msg_type];
+
+	switch (type) {
 	case HTT_T2H_MSG_TYPE_VERSION_CONF: {
 		htt->target_version_major = resp->ver_resp.major;
 		htt->target_version_minor = resp->ver_resp.minor;
-- 
2.3.2


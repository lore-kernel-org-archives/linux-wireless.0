Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab0DPB21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 21:28:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/2] iwmc3200wifi: Fix sparse warnings
Date: Fri, 16 Apr 2010 09:28:43 +0800
Message-Id: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c    |    3 ++-
 drivers/net/wireless/iwmc3200wifi/trace.h |    4 ++--
 drivers/net/wireless/iwmc3200wifi/tx.c    |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index ad53987..e1184de 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -431,7 +431,8 @@ static int iwm_ntf_rx_ticket(struct iwm_priv *iwm, u8 *buf,
 				return PTR_ERR(ticket_node);
 
 			IWM_DBG_RX(iwm, DBG, "TICKET %s(%d)\n",
-				   ticket->action ==  IWM_RX_TICKET_RELEASE ?
+				   __le16_to_cpu(ticket->action) ==
+							IWM_RX_TICKET_RELEASE ?
 				   "RELEASE" : "DROP",
 				   ticket->id);
 			spin_lock(&iwm->ticket_lock);
diff --git a/drivers/net/wireless/iwmc3200wifi/trace.h b/drivers/net/wireless/iwmc3200wifi/trace.h
index 320e54f..abb4805 100644
--- a/drivers/net/wireless/iwmc3200wifi/trace.h
+++ b/drivers/net/wireless/iwmc3200wifi/trace.h
@@ -76,7 +76,7 @@ TRACE_EVENT(iwm_tx_wifi_cmd,
 		IWM_ASSIGN;
 		__entry->opcode = hdr->sw_hdr.cmd.cmd;
 		__entry->lmac = 0;
-		__entry->seq = hdr->sw_hdr.cmd.seq_num;
+		__entry->seq = __le16_to_cpu(hdr->sw_hdr.cmd.seq_num);
 		__entry->resp = GET_VAL8(hdr->sw_hdr.cmd.flags, UMAC_DEV_CMD_FLAGS_RESP_REQ);
 		__entry->color = GET_VAL32(hdr->sw_hdr.meta_data, UMAC_FW_CMD_TX_STA_COLOR);
 		__entry->eot = GET_VAL32(hdr->hw_hdr.cmd, UMAC_HDI_OUT_CMD_EOT);
@@ -123,7 +123,7 @@ TRACE_EVENT(iwm_tx_packets,
 		__entry->ra_tid = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_RATID);
 		__entry->credit_group = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_CREDIT_GRP);
 		__entry->color = GET_VAL32(hdr->sw_hdr.meta_data, UMAC_FW_CMD_TX_STA_COLOR);
-		__entry->seq = hdr->sw_hdr.cmd.seq_num;
+		__entry->seq = __le16_to_cpu(hdr->sw_hdr.cmd.seq_num);
 		__entry->npkt = 1;
 		__entry->bytes = len;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
index 9537cdb..3216621 100644
--- a/drivers/net/wireless/iwmc3200wifi/tx.c
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -302,8 +302,8 @@ void iwm_tx_credit_init_pools(struct iwm_priv *iwm,
 
 #define IWM_UDMA_HDR_LEN	sizeof(struct iwm_umac_wifi_out_hdr)
 
-static int iwm_tx_build_packet(struct iwm_priv *iwm, struct sk_buff *skb,
-			       int pool_id, u8 *buf)
+static __le16 iwm_tx_build_packet(struct iwm_priv *iwm, struct sk_buff *skb,
+				  int pool_id, u8 *buf)
 {
 	struct iwm_umac_wifi_out_hdr *hdr = (struct iwm_umac_wifi_out_hdr *)buf;
 	struct iwm_udma_wifi_cmd udma_cmd;
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZGPJdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/10] iwmc3200wifi: use correct debug level
Date: Thu, 16 Jul 2009 17:34:09 +0800
Message-Id: <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses TX and RX instead of NTF debug levels in some hot
paths.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 9fb498b..218933b 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -218,17 +218,17 @@ static int iwm_ntf_tx(struct iwm_priv *iwm, u8 *buf,
 		(buf + sizeof(struct iwm_umac_wifi_in_hdr));
 	hdr = (struct iwm_umac_wifi_in_hdr *)buf;
 
-	IWM_DBG_NTF(iwm, DBG, "REPLY_TX, buf size: %lu\n", buf_size);
-
-	IWM_DBG_NTF(iwm, DBG, "Seqnum: %d\n",
-		    le16_to_cpu(hdr->sw_hdr.cmd.seq_num));
-	IWM_DBG_NTF(iwm, DBG, "\tFrame cnt: %d\n", tx_resp->frame_cnt);
-	IWM_DBG_NTF(iwm, DBG, "\tRetry cnt: %d\n",
-		    le16_to_cpu(tx_resp->retry_cnt));
-	IWM_DBG_NTF(iwm, DBG, "\tSeq ctl: %d\n", le16_to_cpu(tx_resp->seq_ctl));
-	IWM_DBG_NTF(iwm, DBG, "\tByte cnt: %d\n",
-		    le16_to_cpu(tx_resp->byte_cnt));
-	IWM_DBG_NTF(iwm, DBG, "\tStatus: 0x%x\n", le32_to_cpu(tx_resp->status));
+	IWM_DBG_TX(iwm, DBG, "REPLY_TX, buf size: %lu\n", buf_size);
+
+	IWM_DBG_TX(iwm, DBG, "Seqnum: %d\n",
+		   le16_to_cpu(hdr->sw_hdr.cmd.seq_num));
+	IWM_DBG_TX(iwm, DBG, "\tFrame cnt: %d\n", tx_resp->frame_cnt);
+	IWM_DBG_TX(iwm, DBG, "\tRetry cnt: %d\n",
+		   le16_to_cpu(tx_resp->retry_cnt));
+	IWM_DBG_TX(iwm, DBG, "\tSeq ctl: %d\n", le16_to_cpu(tx_resp->seq_ctl));
+	IWM_DBG_TX(iwm, DBG, "\tByte cnt: %d\n",
+		   le16_to_cpu(tx_resp->byte_cnt));
+	IWM_DBG_TX(iwm, DBG, "\tStatus: 0x%x\n", le32_to_cpu(tx_resp->status));
 
 	return 0;
 }
@@ -418,8 +418,8 @@ static int iwm_ntf_rx_ticket(struct iwm_priv *iwm, u8 *buf,
 			if (IS_ERR(ticket_node))
 				return PTR_ERR(ticket_node);
 
-			IWM_DBG_NTF(iwm, DBG, "TICKET RELEASE(%d)\n",
-				    ticket->id);
+			IWM_DBG_RX(iwm, DBG, "TICKET RELEASE(%d)\n",
+				   ticket->id);
 			list_add_tail(&ticket_node->node, &iwm->rx_tickets);
 
 			/*
@@ -454,15 +454,15 @@ static int iwm_ntf_rx_packet(struct iwm_priv *iwm, u8 *buf,
 	u16 id, buf_offset;
 	u32 packet_size;
 
-	IWM_DBG_NTF(iwm, DBG, "\n");
+	IWM_DBG_RX(iwm, DBG, "\n");
 
 	wifi_hdr = (struct iwm_umac_wifi_in_hdr *)buf;
 	id = le16_to_cpu(wifi_hdr->sw_hdr.cmd.seq_num);
 	buf_offset = sizeof(struct iwm_umac_wifi_in_hdr);
 	packet_size = buf_size - sizeof(struct iwm_umac_wifi_in_hdr);
 
-	IWM_DBG_NTF(iwm, DBG, "CMD:0x%x, seqnum: %d, packet size: %d\n",
-		    wifi_hdr->sw_hdr.cmd.cmd, id, packet_size);
+	IWM_DBG_RX(iwm, DBG, "CMD:0x%x, seqnum: %d, packet size: %d\n",
+		   wifi_hdr->sw_hdr.cmd.cmd, id, packet_size);
 	IWM_DBG_RX(iwm, DBG, "Packet id: %d\n", id);
 	IWM_HEXDUMP(iwm, DBG, RX, "PACKET: ", buf + buf_offset, packet_size);
 
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34331 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753709AbdGJMpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:09 -0400
Received: by mail-pf0-f193.google.com with SMTP id c24so14378552pfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:08 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 06/17] rsi: Update aggregation parameters command frame
Date: Mon, 10 Jul 2017 18:10:37 +0530
Message-Id: <1499690448-9956-7-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144534_782945_C14E1B4C)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

AMPDU aggregation parameters frame configured to device is
modified to use common descriptor structure.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 41 ++++++++++++++-------------------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 14 +++++++++++
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index fd9bcd7..a1a60f7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -528,10 +528,11 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 				      u8 event)
 {
 	struct sk_buff *skb = NULL;
-	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_aggr_params *aggr_params;
 	u8 peer_id = 0;
+	u16 frame_len = sizeof(struct rsi_aggr_params);
 
-	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	skb = dev_alloc_skb(frame_len);
 
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -539,37 +540,29 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+	memset(skb->data, 0, frame_len);
+	aggr_params = (struct rsi_aggr_params *)skb->data;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending AMPDU indication frame\n", __func__);
 
-	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
-	mgmt_frame->desc_word[1] = cpu_to_le16(AMPDU_IND);
+	rsi_set_len_qno(&aggr_params->desc_dword0.len_qno, 0, RSI_WIFI_MGMT_Q);
+	aggr_params->desc_dword0.frame_type = AMPDU_IND;
 
+	aggr_params->aggr_params = tid & RSI_AGGR_PARAMS_TID_MASK;
+	aggr_params->peer_id = peer_id;
 	if (event == STA_TX_ADDBA_DONE) {
-		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
-		mgmt_frame->desc_word[5] = cpu_to_le16(buf_size);
-		mgmt_frame->desc_word[7] =
-		cpu_to_le16((tid | (START_AMPDU_AGGR << 4) | (peer_id << 8)));
+		aggr_params->seq_start = cpu_to_le16(ssn);
+		aggr_params->baw_size = cpu_to_le16(buf_size);
+		aggr_params->aggr_params |= RSI_AGGR_PARAMS_START;
 	} else if (event == STA_RX_ADDBA_DONE) {
-		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
-		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
-						       (START_AMPDU_AGGR << 4) |
-						       (RX_BA_INDICATION << 5) |
-						       (peer_id << 8));
-	} else if (event == STA_TX_DELBA) {
-		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
-						       (STOP_AMPDU_AGGR << 4) |
-						       (peer_id << 8));
+		aggr_params->seq_start = cpu_to_le16(ssn);
+		aggr_params->aggr_params |= (RSI_AGGR_PARAMS_START |
+					     RSI_AGGR_PARAMS_RX_AGGR);
 	} else if (event == STA_RX_DELBA) {
-		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
-						       (STOP_AMPDU_AGGR << 4) |
-						       (RX_BA_INDICATION << 5) |
-						       (peer_id << 8));
+		aggr_params->aggr_params |= RSI_AGGR_PARAMS_RX_AGGR;
 	}
 
-	skb_put(skb, FRAME_DESC_SZ);
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index d2fe9ee..68863c8 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -280,6 +280,20 @@ struct rsi_peer_notify {
 	__le32 sta_flags;
 } __packed;
 
+/* Aggregation params flags */
+#define RSI_AGGR_PARAMS_TID_MASK	0xf
+#define RSI_AGGR_PARAMS_START		BIT(4)
+#define RSI_AGGR_PARAMS_RX_AGGR		BIT(5)
+struct rsi_aggr_params {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword0 desc_dword1;
+	__le16 seq_start;
+	__le16 baw_size;
+	__le16 token;
+	u8 aggr_params;
+	u8 peer_id;
+} __packed;
+
 struct rsi_vap_caps {
 	__le16 desc_word[8];
 	u8 mac_addr[6];
-- 
2.7.4

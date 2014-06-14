Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63186 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaFNNyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:54:16 -0400
Received: by mail-pd0-f180.google.com with SMTP id ft15so2984839pdb.39
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:54:16 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id qv9sm9008110pbc.71.2014.06.14.06.54.14
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:54:15 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/16] rsi: Changed the logic of dequeuing packets from hal queues.
Date: Sat, 14 Jun 2014 19:24:07 +0530
Message-Id: <1402754047-14166-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155419_531347_EB2F6416)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of packets being dequeued from s/w queues was fixed -
changed it to a dynamic calculation based on txop. There are also
some fixes to the dequeuing algorithm.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |   80 +++++++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_main.h     |    3 +
 2 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index cf61d6e..264e8fa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -77,6 +77,50 @@ static bool rsi_recalculate_weights(struct rsi_common *common)
 }
 
 /**
+ * rsi_get_num_pkts_dequeue() - This function determines the number of
+ *		                packets to be dequeued based on the number
+ *			        of bytes calculated using txop.
+ *
+ * @common: Pointer to the driver private structure.
+ * @q_num: the queue from which pkts have to be dequeued
+ *
+ * Return: pkt_num: Number of pkts to be dequeued.
+ */
+static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct sk_buff *skb;
+	u32 pkt_cnt = 0;
+	s16 txop = common->tx_qinfo[q_num].txop * 32;
+	struct ieee80211_rate rate;
+
+	rate.bitrate = RSI_RATE_MCS0 * 5 * 10; /* Convert to Kbps */
+	if (q_num == VI_Q)
+		txop = ((txop << 5) / 80);
+
+	if (skb_queue_len(&common->tx_queue[q_num]))
+		skb = skb_peek(&common->tx_queue[q_num]);
+	else
+		return 0;
+
+	do {
+		txop -= ieee80211_generic_frame_duration(adapter->hw,
+							 adapter->vifs[0],
+							 common->band,
+							 skb->len, &rate);
+		pkt_cnt += 1;
+		/*checking if pkts are still there*/
+		if (skb_queue_len(&common->tx_queue[q_num]) - pkt_cnt)
+			skb = skb->next;
+		else
+			break;
+
+	} while (txop > 0);
+
+	return pkt_cnt;
+}
+
+/**
  * rsi_core_determine_hal_queue() - This function determines the queue from
  *				    which packet has to be dequeued.
  * @common: Pointer to the driver private structure.
@@ -88,7 +132,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	bool recontend_queue = false;
 	u32 q_len = 0;
 	u8 q_num = INVALID_QUEUE;
-	u8 ii = 0, min = 0;
+	u8 ii = 0;
 
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
@@ -96,6 +140,9 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 		return q_num;
 	}
 
+	if (common->hw_data_qs_blocked)
+		return q_num;
+
 	if (common->pkt_cnt != 0) {
 		--common->pkt_cnt;
 		return common->selected_qnum;
@@ -106,14 +153,15 @@ get_queue_num:
 
 	q_num = rsi_determine_min_weight_queue(common);
 
-	q_len = skb_queue_len(&common->tx_queue[ii]);
 	ii = q_num;
 
 	/* Selecting the queue with least back off */
 	for (; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
 		if (((common->tx_qinfo[ii].pkt_contended) &&
-		     (common->tx_qinfo[ii].weight < min)) && q_len) {
-			min = common->tx_qinfo[ii].weight;
+		     (common->tx_qinfo[ii].weight < common->min_weight)) &&
+		      q_len) {
+			common->min_weight = common->tx_qinfo[ii].weight;
 			q_num = ii;
 		}
 	}
@@ -140,26 +188,10 @@ get_queue_num:
 	common->selected_qnum = q_num;
 	q_len = skb_queue_len(&common->tx_queue[q_num]);
 
-	switch (common->selected_qnum) {
-	case VO_Q:
-		if (q_len > MAX_CONTINUOUS_VO_PKTS)
-			common->pkt_cnt = (MAX_CONTINUOUS_VO_PKTS - 1);
-		else
-			common->pkt_cnt = --q_len;
-		break;
-
-	case VI_Q:
-		if (q_len > MAX_CONTINUOUS_VI_PKTS)
-			common->pkt_cnt = (MAX_CONTINUOUS_VI_PKTS - 1);
-		else
-			common->pkt_cnt = --q_len;
-
-		break;
-
-	default:
-		common->pkt_cnt = 0;
-		break;
-	}
+	if (q_num == VO_Q || q_num == VI_Q) {
+		common->pkt_cnt = rsi_get_num_pkts_dequeue(common, q_num);
+		common->pkt_cnt -= 1;
+	};
 
 	return q_num;
 }
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 2cb73e7..8629131 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -115,6 +115,7 @@ struct wmm_qinfo {
 	s32 weight;
 	s32 wme_params;
 	s32 pkt_contended;
+	s32 txop;
 };
 
 struct transmit_q_stats {
@@ -192,6 +193,8 @@ struct rsi_common {
 	u8 selected_qnum;
 	u32 pkt_cnt;
 	u8 min_weight;
+
+	bool hw_data_qs_blocked;
 };
 
 struct rsi_hw {
-- 
1.7.1


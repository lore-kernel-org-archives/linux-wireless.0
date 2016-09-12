Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33409 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757479AbcILJna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:30 -0400
Received: by mail-pa0-f67.google.com with SMTP id h5so7563010pao.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:30 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 4/9] rsi: code clean up in file rsi_91x_main.c
Date: Mon, 12 Sep 2016 15:08:19 +0530
Message-Id: <bce2e61df900a69d6c43ef2594e5c2b3cff949d5.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114333_792958_4C85D398)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..f82e457 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -86,7 +86,7 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 
 	pkt_len -= extended_desc;
 	skb = dev_alloc_skb(pkt_len + FRAME_DESC_SZ);
-	if (skb == NULL)
+	if (!skb)
 		return NULL;
 
 	payload_offset = (extended_desc + FRAME_DESC_SZ);
@@ -111,11 +111,10 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 {
 	u8 *frame_desc = NULL, extended_desc = 0;
-	u32 index, length = 0, queueno = 0;
+	u32 index = 0, length = 0, queueno = 0;
 	u16 actual_length = 0, offset;
 	struct sk_buff *skb = NULL;
 
-	index = 0;
 	do {
 		frame_desc = &common->rx_data_pkt[index];
 		actual_length = *(u16 *)&frame_desc[0];
@@ -131,7 +130,7 @@ int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 					      (frame_desc + offset),
 					      length,
 					      extended_desc);
-			if (skb == NULL)
+			if (!skb)
 				goto fail;
 
 			rsi_indicate_pkt_to_os(common, skb);
@@ -198,15 +197,14 @@ struct rsi_hw *rsi_91x_init(void)
 		return NULL;
 
 	adapter->priv = kzalloc(sizeof(*common), GFP_KERNEL);
-	if (adapter->priv == NULL) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of memory\n",
+	if (!adapter->priv) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of common cb\n",
 			__func__);
 		kfree(adapter);
 		return NULL;
-	} else {
-		common = adapter->priv;
-		common->priv = adapter;
 	}
+	common = adapter->priv;
+	common->priv = adapter;
 
 	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
 		skb_queue_head_init(&common->tx_queue[ii]);
-- 
2.4.11

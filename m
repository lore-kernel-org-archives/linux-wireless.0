Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1HWIRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:17:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 7/7] ath6kl: Fix system freeze under heavy data load
Date: Tue, 23 Aug 2011 11:16:46 +0300
Message-ID: <1314087406-29188-8-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_101724_123949_4F33C482)
In-Reply-To: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Patch "ath6kl: Fix buffer alignment for scatter-gather write" does
memmove for a length (scat_req->scat_list[i].len) which is not the
actual length of data that is suppossed to be moved. The right
lengh is packet->act_len + HTC_HDR_LENGTH. Using wrong length
for data move during buffer alignment causes system freeze after
the following WARN_ON and sometimes target assert.

WARNING: at drivers/net/wireless/ath/ath6kl/main.c:771 ath6k_credit_distribute+0x196/0x1a0
 [<ffffffffa051cf5f>] ath6kl_htc_rxmsg_pending_handler+0x83f/0xe00 [ath6kl]
 [<ffffffff8104a743>] ? __wake_up+0x53/0x70
 [<ffffffffa0518b18>] ath6kldev_intr_bh_handler+0x188/0x650 [ath6kl]
 [<ffffffffa052d316>] ath6kl_sdio_irq_handler+0x36/0x80 [ath6kl]
 [<ffffffff81492b3c>] sdio_irq_thread+0xfc/0x360
 [<ffffffff81051c52>] ? default_wake_function+0x12/0x20
 [<ffffffff81492a40>] ? sdio_claim_irq+0x220/0x220
 [<ffffffff81080c36>] kthread+0x96/0xa0
 [<ffffffff815b9fb4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81080ba0>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff815b9fb0>] ? gs_change+0x13/0x13

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c  |   14 ++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |   15 ---------------
 drivers/net/wireless/ath/ath6kl/txrx.c |    6 ++++--
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 2001660..dc575a8 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -22,6 +22,17 @@
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
+static void ath6kl_htc_buf_align(u8 **buf, unsigned long len)
+{
+	u8 *align_addr;
+
+	if (!IS_ALIGNED((unsigned long) *buf, 4)) {
+		align_addr = PTR_ALIGN(*buf - 4, 4);
+		memmove(align_addr, *buf, len);
+		*buf = align_addr;
+	}
+}
+
 static void htc_prep_send_pkt(struct htc_packet *packet, u8 flags, int ctrl0,
 			      int ctrl1)
 {
@@ -391,6 +402,9 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 		htc_prep_send_pkt(packet,
 				packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE,
 				cred_pad, packet->info.tx.seqno);
+		/* Make sure the buffer is 4-byte aligned */
+		ath6kl_htc_buf_align(&packet->buf,
+				     packet->act_len + HTC_HDR_LENGTH);
 		scat_req->scat_list[i].buf = packet->buf;
 		scat_req->scat_list[i].len = len;
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 852a0cc..0cce801 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -128,17 +128,6 @@ static int ath6kl_sdio_func0_cmd52_wr_byte(struct mmc_card *card,
 	return mmc_wait_for_cmd(card->host, &io_cmd, 0);
 }
 
-static void ath6kl_sdio_buf_align(u8 **buf, unsigned long len)
-{
-	u8 *align_addr;
-
-	if (!IS_ALIGNED((unsigned long) *buf, 4)) {
-		align_addr = PTR_ALIGN(*buf - 4, 4);
-		memmove(align_addr, *buf, len);
-		*buf = align_addr;
-	}
-}
-
 static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 			  u8 *buf, u32 len)
 {
@@ -224,10 +213,6 @@ static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
 
 	/* assemble SG list */
 	for (i = 0; i < scat_req->scat_entries; i++, sg++) {
-		/* No header is added to rx buf, so it shoule be aligned */
-		if (data->flags == MMC_DATA_WRITE)
-			ath6kl_sdio_buf_align(&scat_req->scat_list[i].buf,
-					      scat_req->scat_list[i].len);
 		ath6kl_dbg(ATH6KL_DBG_SCATTER, "%d: addr:0x%p, len:%d\n",
 			   i, scat_req->scat_list[i].buf,
 			   scat_req->scat_list[i].len);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ba1350d..ba33370 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -689,7 +689,8 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 			break;
 
 		packet = (struct htc_packet *) skb->head;
-		skb->data = PTR_ALIGN(skb->data - 4, 4);
+		if (!IS_ALIGNED((unsigned long) skb->data, 4))
+			skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				ATH6KL_BUFFER_SIZE, endpoint);
 		list_add_tail(&packet->list, &queue);
@@ -710,7 +711,8 @@ void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
 			return;
 
 		packet = (struct htc_packet *) skb->head;
-		skb->data = PTR_ALIGN(skb->data - 4, 4);
+		if (!IS_ALIGNED((unsigned long) skb->data, 4))
+			skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_AMSDU_BUFFER_SIZE, 0);
 		spin_lock_bh(&ar->lock);
-- 
1.7.1


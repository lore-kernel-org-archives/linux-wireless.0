Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1HWIRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:17:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 5/7] ath6kl: Fix buffer alignment for scatter-gather I/O
Date: Tue, 23 Aug 2011 11:16:44 +0300
Message-ID: <1314087406-29188-6-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_101713_756226_B2E62EA5)
In-Reply-To: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

For non-scatter buffers, there is already a bounce buffer which
takes care of alignment. This patch is influenced by a rough patch of
Kalle.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 +++
 drivers/net/wireless/ath/ath6kl/init.c |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c |   25 +++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 ++
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 214d114..a1aa2ef 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -42,6 +42,9 @@
 #define ATH6KL_MAX_ENDPOINTS   4
 #define MAX_NODE_NUM           15
 
+/* Extra bytes for htc header alignment */
+#define ATH6KL_HTC_ALIGN_BYTES 3
+
 /* MAX_HI_COOKIE_NUM are reserved for high priority traffic */
 #define MAX_DEF_COOKIE_NUM                180
 #define MAX_HI_COOKIE_NUM                 18	/* 10% of MAX_COOKIE_NUM */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index df15bfa..75230ac 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -67,7 +67,7 @@ struct sk_buff *ath6kl_buf_alloc(int size)
 
 	/* Add chacheline space at front and back of buffer */
 	reserved = (2 * L1_CACHE_BYTES) + ATH6KL_DATA_OFFSET +
-		   sizeof(struct htc_packet);
+		   sizeof(struct htc_packet) + ATH6KL_HTC_ALIGN_BYTES;
 	skb = dev_alloc_skb(size + reserved);
 
 	if (skb)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f236aa8..868838b 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1347,7 +1347,7 @@ void init_netdev(struct net_device *dev)
 	dev->needed_headroom = ETH_HLEN;
 	dev->needed_headroom += sizeof(struct ath6kl_llc_snap_hdr) +
 				sizeof(struct wmi_data_hdr) + HTC_HDR_LENGTH
-				+ WMI_MAX_TX_META_SZ;
+				+ WMI_MAX_TX_META_SZ + ATH6KL_HTC_ALIGN_BYTES;
 
 	return;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 3417160..f393090 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -128,6 +128,17 @@ static int ath6kl_sdio_func0_cmd52_wr_byte(struct mmc_card *card,
 	return mmc_wait_for_cmd(card->host, &io_cmd, 0);
 }
 
+static void ath6kl_sdio_buf_align(u8 **buf, unsigned long len)
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
 static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 			  u8 *buf, u32 len)
 {
@@ -213,16 +224,10 @@ static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
 
 	/* assemble SG list */
 	for (i = 0; i < scat_req->scat_entries; i++, sg++) {
-		if ((unsigned long)scat_req->scat_list[i].buf & 0x3)
-			/*
-			 * Some scatter engines can handle unaligned
-			 * buffers, print this as informational only.
-			 */
-			ath6kl_dbg(ATH6KL_DBG_SCATTER,
-				   "(%s) scatter buffer is unaligned 0x%p\n",
-				   scat_req->req & HIF_WRITE ? "WR" : "RD",
-				   scat_req->scat_list[i].buf);
-
+		/* No header is added to rx buf, so it shoule be aligned */
+		if (data->flags == MMC_DATA_WRITE)
+			ath6kl_sdio_buf_align(&scat_req->scat_list[i].buf,
+					      scat_req->scat_list[i].len);
 		ath6kl_dbg(ATH6KL_DBG_SCATTER, "%d: addr:0x%p, len:%d\n",
 			   i, scat_req->scat_list[i].buf,
 			   scat_req->scat_list[i].len);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 44bf227..ba1350d 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -689,6 +689,7 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 			break;
 
 		packet = (struct htc_packet *) skb->head;
+		skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				ATH6KL_BUFFER_SIZE, endpoint);
 		list_add_tail(&packet->list, &queue);
@@ -709,6 +710,7 @@ void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
 			return;
 
 		packet = (struct htc_packet *) skb->head;
+		skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_AMSDU_BUFFER_SIZE, 0);
 		spin_lock_bh(&ar->lock);
-- 
1.7.1


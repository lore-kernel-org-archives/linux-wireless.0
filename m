Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309CBC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08AFC20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfBVOVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:42 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726978AbfBVOVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:39 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017387"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:34 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285593"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:33 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 20/21] wil6210: reset buff id in status message after completion
Date:   Fri, 22 Feb 2019 16:21:18 +0200
Message-Id: <1550845279-16103-21-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since DR bit and buffer id are written in different dwords of
the status message, the DR bit can already be set to 1 while the
buffer id is not updated yet.
Resetting the buffer id in the status message will allow the driver
to identify such cases and re-read the status message until the buffer
id is written by HW.
In case DR bit is set but buffer id is zero, need to read the status
message again, until a valid id is identified.

In addition to that, move the completed buffer id to the tail of the
free list to prevent its immediate reuse in the upcoming refill.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   |  2 ++
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 50 ++++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/txrx_edma.h |  6 ++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 78320ec..df2adff 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -207,6 +207,8 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 		seq_puts(s, "???\n");
 	}
 	seq_printf(s, "  desc_rdy_pol   = %d\n", sring->desc_rdy_pol);
+	seq_printf(s, "  invalid_buff_id_cnt   = %d\n",
+		   sring->invalid_buff_id_cnt);
 
 	if (sring->va && (sring->size <= (1 << WIL_RING_SIZE_ORDER_MAX))) {
 		uint i;
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 492f7bd..f6fce6f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -29,6 +29,7 @@
 #define WIL_EDMA_MAX_DATA_OFFSET (2)
 /* RX buffer size must be aligned to 4 bytes */
 #define WIL_EDMA_RX_BUF_LEN_DEFAULT (2048)
+#define MAX_INVALID_BUFF_ID_RETRY (3)
 
 static void wil_tx_desc_unmap_edma(struct device *dev,
 				   union wil_tx_desc *desc,
@@ -312,7 +313,8 @@ static int wil_init_rx_buff_arr(struct wil6210_priv *wil,
 	struct list_head *free = &wil->rx_buff_mgmt.free;
 	int i;
 
-	wil->rx_buff_mgmt.buff_arr = kcalloc(size, sizeof(struct wil_rx_buff),
+	wil->rx_buff_mgmt.buff_arr = kcalloc(size + 1,
+					     sizeof(struct wil_rx_buff),
 					     GFP_KERNEL);
 	if (!wil->rx_buff_mgmt.buff_arr)
 		return -ENOMEM;
@@ -321,14 +323,16 @@ static int wil_init_rx_buff_arr(struct wil6210_priv *wil,
 	INIT_LIST_HEAD(active);
 	INIT_LIST_HEAD(free);
 
-	/* Linkify the list */
+	/* Linkify the list.
+	 * buffer id 0 should not be used (marks invalid id).
+	 */
 	buff_arr = wil->rx_buff_mgmt.buff_arr;
-	for (i = 0; i < size; i++) {
+	for (i = 1; i <= size; i++) {
 		list_add(&buff_arr[i].list, free);
 		buff_arr[i].id = i;
 	}
 
-	wil->rx_buff_mgmt.size = size;
+	wil->rx_buff_mgmt.size = size + 1;
 
 	return 0;
 }
@@ -876,26 +880,50 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 
 	/* Extract the buffer ID from the status message */
 	buff_id = le16_to_cpu(wil_rx_status_get_buff_id(msg));
-	if (unlikely(!wil_val_in_range(buff_id, 0, wil->rx_buff_mgmt.size))) {
+
+	while (!buff_id) {
+		struct wil_rx_status_extended *s;
+		int invalid_buff_id_retry = 0;
+
+		wil_dbg_txrx(wil,
+			     "buff_id is not updated yet by HW, (swhead 0x%x)\n",
+			     sring->swhead);
+		if (++invalid_buff_id_retry > MAX_INVALID_BUFF_ID_RETRY)
+			break;
+
+		/* Read the status message again */
+		s = (struct wil_rx_status_extended *)
+			(sring->va + (sring->elem_size * sring->swhead));
+		*(struct wil_rx_status_extended *)msg = *s;
+		buff_id = le16_to_cpu(wil_rx_status_get_buff_id(msg));
+	}
+
+	if (unlikely(!wil_val_in_range(buff_id, 1, wil->rx_buff_mgmt.size))) {
 		wil_err(wil, "Corrupt buff_id=%d, sring->swhead=%d\n",
 			buff_id, sring->swhead);
+		wil_rx_status_reset_buff_id(sring);
 		wil_sring_advance_swhead(sring);
+		sring->invalid_buff_id_cnt++;
 		goto again;
 	}
 
-	wil_sring_advance_swhead(sring);
-
 	/* Extract the SKB from the rx_buff management array */
 	skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
 	wil->rx_buff_mgmt.buff_arr[buff_id].skb = NULL;
 	if (!skb) {
 		wil_err(wil, "No Rx skb at buff_id %d\n", buff_id);
+		wil_rx_status_reset_buff_id(sring);
 		/* Move the buffer from the active list to the free list */
-		list_move(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
-			  &wil->rx_buff_mgmt.free);
+		list_move_tail(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
+			       &wil->rx_buff_mgmt.free);
+		wil_sring_advance_swhead(sring);
+		sring->invalid_buff_id_cnt++;
 		goto again;
 	}
 
+	wil_rx_status_reset_buff_id(sring);
+	wil_sring_advance_swhead(sring);
+
 	memcpy(&pa, skb->cb, sizeof(pa));
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
 	dmalen = le16_to_cpu(wil_rx_status_get_length(msg));
@@ -910,8 +938,8 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 			  sizeof(struct wil_rx_status_extended), false);
 
 	/* Move the buffer from the active list to the free list */
-	list_move(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
-		  &wil->rx_buff_mgmt.free);
+	list_move_tail(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
+		       &wil->rx_buff_mgmt.free);
 
 	eop = wil_rx_status_get_eop(msg);
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.h b/drivers/net/wireless/ath/wil6210/txrx_edma.h
index 9cf9ecf..bb4ff28 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.h
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.h
@@ -427,6 +427,12 @@ static inline int wil_rx_status_get_eop(void *msg) /* EoP = End of Packet */
 			    30, 30);
 }
 
+static inline void wil_rx_status_reset_buff_id(struct wil_status_ring *s)
+{
+	((struct wil_rx_status_compressed *)
+		(s->va + (s->elem_size * s->swhead)))->buff_id = 0;
+}
+
 static inline __le16 wil_rx_status_get_buff_id(void *msg)
 {
 	return ((struct wil_rx_status_compressed *)msg)->buff_id;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f508d52..8724d99 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -568,6 +568,7 @@ struct wil_status_ring {
 	bool is_rx;
 	u8 desc_rdy_pol; /* Expected descriptor ready bit polarity */
 	struct wil_ring_rx_data rx_data;
+	u32 invalid_buff_id_cnt; /* relevant only for RX */
 };
 
 #define WIL_STA_TID_NUM (16)
-- 
1.9.1


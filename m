Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC70C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A033205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfDZPt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:49:58 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21641 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbfDZPt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:57 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2019 11:49:53 EDT
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367520"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:43 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889768"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:42 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 5/9] wil6210: enhancements for descriptor and status ring debugfs
Date:   Fri, 26 Apr 2019 18:43:33 +0300
Message-Id: <1556293417-27097-6-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

Add printing of hwhead as part of desc ring and status ring debugfs.
Validate wil->rx_buff_mgmt and ring->ctx arrays before accessing them.
Dump Tx descriptor content even when it indicates invalid buff_id.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 52 +++++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/wil6210.h |  5 +++
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index df2adff..42507f5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -63,7 +63,9 @@ static void wil_print_desc_edma(struct seq_file *s, struct wil6210_priv *wil,
 			&ring->va[idx].rx.enhanced;
 		u16 buff_id = le16_to_cpu(rx_d->mac.buff_id);
 
-		has_skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
+		if (wil->rx_buff_mgmt.buff_arr &&
+		    wil_val_in_range(buff_id, 0, wil->rx_buff_mgmt.size))
+			has_skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
 		seq_printf(s, "%c", (has_skb) ? _h : _s);
 	} else {
 		struct wil_tx_enhanced_desc *d =
@@ -71,9 +73,9 @@ static void wil_print_desc_edma(struct seq_file *s, struct wil6210_priv *wil,
 			&ring->va[idx].tx.enhanced;
 
 		num_of_descs = (u8)d->mac.d[2];
-		has_skb = ring->ctx[idx].skb;
+		has_skb = ring->ctx && ring->ctx[idx].skb;
 		if (num_of_descs >= 1)
-			seq_printf(s, "%c", ring->ctx[idx].skb ? _h : _s);
+			seq_printf(s, "%c", has_skb ? _h : _s);
 		else
 			/* num_of_descs == 0, it's a frag in a list of descs */
 			seq_printf(s, "%c", has_skb ? 'h' : _s);
@@ -84,7 +86,7 @@ static void wil_print_ring(struct seq_file *s, struct wil6210_priv *wil,
 			   const char *name, struct wil_ring *ring,
 			   char _s, char _h)
 {
-	void __iomem *x = wmi_addr(wil, ring->hwtail);
+	void __iomem *x;
 	u32 v;
 
 	seq_printf(s, "RING %s = {\n", name);
@@ -96,7 +98,21 @@ static void wil_print_ring(struct seq_file *s, struct wil6210_priv *wil,
 	else
 		seq_printf(s, "  swtail = %d\n", ring->swtail);
 	seq_printf(s, "  swhead = %d\n", ring->swhead);
+	if (wil->use_enhanced_dma_hw) {
+		int ring_id = ring->is_rx ?
+			WIL_RX_DESC_RING_ID : ring - wil->ring_tx;
+		/* SUBQ_CONS is a table of 32 entries, one for each Q pair.
+		 * lower 16bits are for even ring_id and upper 16bits are for
+		 * odd ring_id
+		 */
+		x = wmi_addr(wil, RGF_DMA_SCM_SUBQ_CONS + 4 * (ring_id / 2));
+		v = readl_relaxed(x);
+
+		v = (ring_id % 2 ? (v >> 16) : (v & 0xffff));
+		seq_printf(s, "  hwhead = %u\n", v);
+	}
 	seq_printf(s, "  hwtail = [0x%08x] -> ", ring->hwtail);
+	x = wmi_addr(wil, ring->hwtail);
 	if (x) {
 		v = readl(x);
 		seq_printf(s, "0x%08x = %d\n", v, v);
@@ -188,7 +204,7 @@ static int ring_show(struct seq_file *s, void *data)
 static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 			    struct wil_status_ring *sring)
 {
-	void __iomem *x = wmi_addr(wil, sring->hwtail);
+	void __iomem *x;
 	int sring_idx = sring - wil->srings;
 	u32 v;
 
@@ -199,7 +215,19 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_printf(s, "  size   = %d\n", sring->size);
 	seq_printf(s, "  elem_size   = %zu\n", sring->elem_size);
 	seq_printf(s, "  swhead = %d\n", sring->swhead);
+	if (wil->use_enhanced_dma_hw) {
+		/* COMPQ_PROD is a table of 32 entries, one for each Q pair.
+		 * lower 16bits are for even ring_id and upper 16bits are for
+		 * odd ring_id
+		 */
+		x = wmi_addr(wil, RGF_DMA_SCM_COMPQ_PROD + 4 * (sring_idx / 2));
+		v = readl_relaxed(x);
+
+		v = (sring_idx % 2 ? (v >> 16) : (v & 0xffff));
+		seq_printf(s, "  hwhead = %u\n", v);
+	}
 	seq_printf(s, "  hwtail = [0x%08x] -> ", sring->hwtail);
+	x = wmi_addr(wil, sring->hwtail);
 	if (x) {
 		v = readl_relaxed(x);
 		seq_printf(s, "0x%08x = %d\n", v, v);
@@ -1091,19 +1119,18 @@ static int txdesc_show(struct seq_file *s, void *data)
 
 	if (wil->use_enhanced_dma_hw) {
 		if (tx) {
-			skb = ring->ctx[txdesc_idx].skb;
-		} else {
+			skb = ring->ctx ? ring->ctx[txdesc_idx].skb : NULL;
+		} else if (wil->rx_buff_mgmt.buff_arr) {
 			struct wil_rx_enhanced_desc *rx_d =
 				(struct wil_rx_enhanced_desc *)
 				&ring->va[txdesc_idx].rx.enhanced;
 			u16 buff_id = le16_to_cpu(rx_d->mac.buff_id);
 
 			if (!wil_val_in_range(buff_id, 0,
-					      wil->rx_buff_mgmt.size)) {
+					      wil->rx_buff_mgmt.size))
 				seq_printf(s, "invalid buff_id %d\n", buff_id);
-				return 0;
-			}
-			skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
+			else
+				skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
 		}
 	} else {
 		skb = ring->ctx[txdesc_idx].skb;
@@ -1136,7 +1163,7 @@ static int status_msg_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int sring_idx = dbg_sring_index;
 	struct wil_status_ring *sring;
-	bool tx = sring_idx == wil->tx_sring_idx ? 1 : 0;
+	bool tx;
 	u32 status_msg_idx = dbg_status_msg_index;
 	u32 *u;
 
@@ -1146,6 +1173,7 @@ static int status_msg_show(struct seq_file *s, void *data)
 	}
 
 	sring = &wil->srings[sring_idx];
+	tx = !sring->is_rx;
 
 	if (!sring->va) {
 		seq_printf(s, "No %cX status ring\n", tx ? 'T' : 'R');
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index dc40002..1f0175d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -335,6 +335,11 @@ struct RGF_ICR {
 	#define BIT_BOOT_FROM_ROM		BIT(31)
 
 /* eDMA */
+#define RGF_SCM_PTRS_SUBQ_RD_PTR	(0x8b4000)
+#define RGF_SCM_PTRS_COMPQ_RD_PTR	(0x8b4100)
+#define RGF_DMA_SCM_SUBQ_CONS		(0x8b60ec)
+#define RGF_DMA_SCM_COMPQ_PROD		(0x8b616c)
+
 #define RGF_INT_COUNT_ON_SPECIAL_EVT	(0x8b62d8)
 
 #define RGF_INT_CTRL_INT_GEN_CFG_0	(0x8bc000)
-- 
1.9.1


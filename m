Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1630 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759498Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/24] brcm80211: smac: remove skb next pointer usage
 from the driver
Date: Tue, 22 Nov 2011 17:21:37 -0800
Message-ID: <1322011319-24863-3-git-send-email-frankyl@broadcom.com> (sfid-20111123_022258_263202_7F89013A)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In two places the next pointer was used to process a sk_buff chain
but it will always get a single sk_buff so this has been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c  |   62 +++++++++--------------
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 -
 2 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 0bb8c37..b55b1f6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1239,10 +1239,9 @@ bool dma_rxreset(struct dma_pub *pub)
  *   the error(toss frames) could be fatal and cause many subsequent hard
  *   to debug problems
  */
-int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
+int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 {
 	struct dma_info *di = (struct dma_info *)pub;
-	struct sk_buff *p, *next;
 	unsigned char *data;
 	uint len;
 	u16 txout;
@@ -1254,50 +1253,37 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 	txout = di->txout;
 
 	/*
-	 * Walk the chain of packet buffers
-	 * allocating and initializing transmit descriptor entries.
+	 * obtain and initialize transmit descriptor entry.
 	 */
-	for (p = p0; p; p = next) {
-		data = p->data;
-		len = p->len;
-		next = p->next;
-
-		/* return nonzero if out of tx descriptors */
-		if (nexttxd(di, txout) == di->txin)
-			goto outoftxd;
+	data = p->data;
+	len = p->len;
 
-		if (len == 0)
-			continue;
-
-		/* get physical address of buffer start */
-		pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
+	/* no use to transmit a zero length packet */
+	if (len == 0)
+		return 0;
 
-		flags = 0;
-		if (p == p0)
-			flags |= D64_CTRL1_SOF;
+	/* return nonzero if out of tx descriptors */
+	if (nexttxd(di, txout) == di->txin)
+		goto outoftxd;
 
-		/* With a DMA segment list, Descriptor table is filled
-		 * using the segment list instead of looping over
-		 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
-		 * is when end of segment list is reached.
-		 */
-		if (next == NULL)
-			flags |= (D64_CTRL1_IOC | D64_CTRL1_EOF);
-		if (txout == (di->ntxd - 1))
-			flags |= D64_CTRL1_EOT;
+	/* get physical address of buffer start */
+	pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
 
-		dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
+	/* With a DMA segment list, Descriptor table is filled
+	 * using the segment list instead of looping over
+	 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
+	 * is when end of segment list is reached.
+	 */
+	flags = D64_CTRL1_SOF | D64_CTRL1_IOC | D64_CTRL1_EOF;
+	if (txout == (di->ntxd - 1))
+		flags |= D64_CTRL1_EOT;
 
-		txout = nexttxd(di, txout);
-	}
+	dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
 
-	/* if last txd eof not set, fix it */
-	if (!(flags & D64_CTRL1_EOF))
-		di->txd64[prevtxd(di, txout)].ctrl1 =
-		     cpu_to_le32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF);
+	txout = nexttxd(di, txout);
 
 	/* save the packet */
-	di->txp[prevtxd(di, txout)] = p0;
+	di->txp[prevtxd(di, txout)] = p;
 
 	/* bump the tx descriptor index */
 	di->txout = txout;
@@ -1314,7 +1300,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 
  outoftxd:
 	DMA_ERROR("%s: out of txds !!!\n", di->name);
-	brcmu_pkt_buf_free_skb(p0);
+	brcmu_pkt_buf_free_skb(p);
 	di->dma.txavail = 0;
 	di->dma.txnobuf++;
 	return -1;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 36e3e06..897e252 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -955,8 +955,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	brcms_c_txfifo_complete(wlc, queue, 1);
 
 	if (lastframe) {
-		p->next = NULL;
-		p->prev = NULL;
 		/* remove PLCP & Broadcom tx descriptor header */
 		skb_pull(p, D11_PHY_HDR_LEN);
 		skb_pull(p, D11_TXH_LEN);
-- 
1.7.5.4



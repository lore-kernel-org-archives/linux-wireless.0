Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4375 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759246Ab3JONpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/12] brcmfmac: rework single packet transfers
Date: Tue, 15 Oct 2013 15:44:52 +0200
Message-ID: <1381844697-24881-8-git-send-email-arend@broadcom.com> (sfid-20131015_154536_208378_C6705EE7)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_sdio_sglist_rw() does a different code path
when packet queue length is 1. Move this to a separate function
reducing overhead in the calling context.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   81 +++++++++++-----------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 344b2d2..da02816 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -314,6 +314,34 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
+static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
+			     bool write, u32 addr, struct sk_buff *pkt)
+{
+	unsigned int req_sz;
+
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
+
+	/* Single skb use the standard mmc interface */
+	req_sz = pkt->len + 3;
+	req_sz &= (uint)~3;
+
+	if (write)
+		return sdio_memcpy_toio(sdiodev->func[fn], addr,
+					((u8 *)(pkt->data)),
+					req_sz);
+	else if (fn == 1)
+		return sdio_memcpy_fromio(sdiodev->func[fn],
+					  ((u8 *)(pkt->data)),
+					  addr, req_sz);
+	else
+		/* function 2 read is FIFO operation */
+		return sdio_readsb(sdiodev->func[fn],
+				   ((u8 *)(pkt->data)), addr,
+				   req_sz);
+}
+
 /**
  * brcmf_sdio_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
@@ -350,27 +378,6 @@ static int brcmf_sdio_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
-	/* Single skb use the standard mmc interface */
-	if (pktlist->qlen == 1) {
-		pkt_next = pktlist->next;
-		req_sz = pkt_next->len + 3;
-		req_sz &= (uint)~3;
-
-		if (write)
-			return sdio_memcpy_toio(sdiodev->func[fn], addr,
-						((u8 *)(pkt_next->data)),
-						req_sz);
-		else if (fn == 1)
-			return sdio_memcpy_fromio(sdiodev->func[fn],
-						  ((u8 *)(pkt_next->data)),
-						  addr, req_sz);
-		else
-			/* function 2 read is FIFO operation */
-			return sdio_readsb(sdiodev->func[fn],
-					   ((u8 *)(pkt_next->data)), addr,
-					   req_sz);
-	}
-
 	target_list = pktlist;
 	/* for host with broken sg support, prepare a page aligned list */
 	__skb_queue_head_init(&local_list);
@@ -543,7 +550,6 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 {
 	uint width;
 	int err = 0;
-	struct sk_buff_head pkt_list;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
@@ -553,10 +559,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (err)
 		goto done;
 
-	skb_queue_head_init(&pkt_list);
-	skb_queue_tail(&pkt_list, pkt);
-	err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, &pkt_list);
-	skb_dequeue_tail(&pkt_list);
+	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pkt);
 
 done:
 	return err;
@@ -589,7 +592,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	struct sk_buff_head pktq;
+	uint width;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -600,10 +603,11 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	}
 
 	memcpy(mypkt->data, buf, nbytes);
-	__skb_queue_head_init(&pktq);
-	__skb_queue_tail(&pktq, mypkt);
-	err = brcmf_sdcard_send_pkt(sdiodev, addr, fn, flags, &pktq);
-	__skb_dequeue_tail(&pktq);
+
+	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
+	brcmf_sdio_addrprep(sdiodev, width, &addr);
+
+	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 	return err;
@@ -615,7 +619,6 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff_head *pktq)
 {
 	uint width;
-	int err = 0;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pktq->qlen);
@@ -623,9 +626,9 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	brcmf_sdio_addrprep(sdiodev, width, &addr);
 
-	err = brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
-
-	return err;
+	if (pktq->qlen == 1)
+		return brcmf_sdio_buffrw(sdiodev, fn, true, addr, pktq->next);
+	return brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
 }
 
 int
@@ -636,7 +639,6 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
-	struct sk_buff_head pkt_list;
 
 	dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
 	pkt = dev_alloc_skb(dsize);
@@ -645,7 +647,6 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		return -EIO;
 	}
 	pkt->priority = 0;
-	skb_queue_head_init(&pkt_list);
 
 	/* Determine initial transfer parameters */
 	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
@@ -673,10 +674,8 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
-		skb_queue_tail(&pkt_list, pkt);
-		bcmerror = brcmf_sdio_sglist_rw(sdiodev, SDIO_FUNC_1, write,
-						sdaddr, &pkt_list);
-		skb_dequeue_tail(&pkt_list);
+		bcmerror = brcmf_sdio_buffrw(sdiodev, SDIO_FUNC_1, write,
+					     sdaddr, pkt);
 		if (bcmerror) {
 			brcmf_err("membytes transfer failed\n");
 			break;
-- 
1.7.10.4



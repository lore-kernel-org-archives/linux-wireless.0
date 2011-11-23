Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1629 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab1KWBWK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/24] brcm80211: fmac: remove alignment check from
 brcmf_sdioh_request_buffer()
Date: Tue, 22 Nov 2011 17:21:44 -0800
Message-ID: <1322011319-24863-10-git-send-email-frankyl@broadcom.com> (sfid-20111123_022245_495007_D7DA49B9)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The check for alignment is not valid anymore and can be removed. The
function is collapsed with brcmf_sdioh_request_packet() as a consequence
because it did not add much functionality any longer.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  100 ++++----------------
 1 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2263d3c..ccb32c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -229,44 +229,6 @@ brcmf_sdioh_request_data(struct brcmf_sdio_dev *sdiodev, uint write, bool fifo,
 	return err_ret;
 }
 
-static int
-brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
-			   uint write, uint func, uint addr,
-			   struct sk_buff *pkt)
-{
-	bool fifo = (fix_inc == SDIOH_DATA_FIX);
-	int err_ret = 0;
-	uint pkt_len = pkt->len;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_packet_wait);
-	if (brcmf_pm_resume_error(sdiodev))
-		return -EIO;
-
-	/* Claim host controller */
-	sdio_claim_host(sdiodev->func[func]);
-
-	pkt_len += 3;
-	pkt_len &= 0xFFFFFFFC;
-
-	err_ret = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
-					   addr, pkt, pkt_len);
-	if (err_ret) {
-		brcmf_dbg(ERROR, "%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
-			  write ? "TX" : "RX", pkt, addr, pkt_len, err_ret);
-	} else {
-		brcmf_dbg(TRACE, "%s xfr'd %p, addr=0x%05x, len=%d\n",
-			  write ? "TX" : "RX", pkt, addr, pkt_len);
-	}
-
-	/* Release host controller */
-	sdio_release_host(sdiodev->func[func]);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err_ret;
-}
-
 int
 brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 			  uint write, uint func, uint addr,
@@ -317,26 +279,15 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 }
 
 /*
- * This function takes a buffer or packet, and fixes everything up
- * so that in the end, a DMA-able packet is created.
- *
- * A buffer does not have an associated packet pointer,
- * and may or may not be aligned.
- * A packet may consist of a single packet, or a packet chain.
- * If it is a packet chain, then all the packets in the chain
- * must be properly aligned.
- *
- * If the packet data is not aligned, then there may only be
- * one packet, and in this case,  it is copied to a new
- * aligned packet.
- *
+ * This function takes a single DMA-able packet.
  */
 int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			       uint fix_inc, uint write, uint func, uint addr,
 			       struct sk_buff *pkt)
 {
 	int status;
-	struct sk_buff *mypkt = NULL;
+	uint pkt_len = pkt->len;
+	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -347,40 +298,25 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
-	if (((ulong) (pkt->data) & DMA_ALIGN_MASK) != 0) {
-		/*
-		 * Case 2: We have a packet, but it is unaligned.
-		 * In this case, we cannot have a chain (pkt->next == NULL)
-		 */
-		brcmf_dbg(DATA, "Creating aligned %s Packet, len=%d\n",
-			  write ? "TX" : "RX", pkt->len);
-		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
-		if (!mypkt) {
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
-				  pkt->len);
-			return -EIO;
-		}
-
-		/* For a write, copy the buffer data into the packet. */
-		if (write)
-			memcpy(mypkt->data, pkt->data, pkt->len);
-
-		status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
-						    func, addr, mypkt);
+	/* Claim host controller */
+	sdio_claim_host(sdiodev->func[func]);
 
-		/* For a read, copy the packet data back to the buffer. */
-		if (!write)
-			memcpy(pkt->data, mypkt->data, mypkt->len);
+	pkt_len += 3;
+	pkt_len &= (uint)~3;
 
-		brcmu_pkt_buf_free_skb(mypkt);
-	} else {		/* case 3: We have a packet and
-				 it is aligned. */
-		brcmf_dbg(DATA, "Aligned %s Packet, direct DMA\n",
-			  write ? "Tx" : "Rx");
-		status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
-						    func, addr, pkt);
+	status = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
+					   addr, pkt, pkt_len);
+	if (status) {
+		brcmf_dbg(ERROR, "%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+			  write ? "TX" : "RX", pkt, addr, pkt_len, status);
+	} else {
+		brcmf_dbg(TRACE, "%s xfr'd %p, addr=0x%05x, len=%d\n",
+			  write ? "TX" : "RX", pkt, addr, pkt_len);
 	}
 
+	/* Release host controller */
+	sdio_release_host(sdiodev->func[func]);
+
 	return status;
 }
 
-- 
1.7.5.4



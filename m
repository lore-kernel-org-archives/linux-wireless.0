Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1628 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391Ab1KWBWK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/24] brcm80211: fmac: simplify the
 brcmf_sdioh_request_buffer() function
Date: Tue, 22 Nov 2011 17:21:40 -0800
Message-ID: <1322011319-24863-6-git-send-email-frankyl@broadcom.com> (sfid-20111123_022216_105478_639D310E)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function is only called with sk_buff parameter being non-zero so
the prototype does not need to support passing a char buffer any longer.
When the function is called with a NULL sk_buff parameter it returns
-EINVAL now.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   31 ++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   37 +++++---------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e8d1c9e..668eb36 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -288,7 +288,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
 	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
-					 fn, addr, 0, NULL, pkt);
+					 fn, addr, pkt);
 
 	return err;
 }
@@ -369,18 +369,39 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
-					  addr, 0, NULL, pkt);
+					  addr, pkt);
 }
 
 int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 			u8 *buf, uint nbytes)
 {
+	struct sk_buff *mypkt;
+	bool write = rw ? SDIOH_WRITE : SDIOH_READ;
+	int err;
+
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC,
-		(rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
-		addr, nbytes, buf, NULL);
+	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+	if (!mypkt) {
+		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+			  nbytes);
+		return -EIO;
+	}
+
+	/* For a write, copy the buffer data into the packet. */
+	if (write)
+		memcpy(mypkt->data, buf, nbytes);
+
+	err = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC, write,
+					 SDIO_FUNC_1, addr, mypkt);
+
+	/* For a read, copy the packet data back to the buffer. */
+	if (!err && !write)
+		memcpy(buf, mypkt->data, nbytes);
+
+	brcmu_pkt_buf_free_skb(mypkt);
+	return err;
 }
 
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 271765c..2263d3c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -333,40 +333,21 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
  */
 int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			       uint fix_inc, uint write, uint func, uint addr,
-			       uint buflen_u, u8 *buffer, struct sk_buff *pkt)
+			       struct sk_buff *pkt)
 {
-	int Status;
+	int status;
 	struct sk_buff *mypkt = NULL;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
+	if (pkt == NULL)
+		return -EINVAL;
+
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
-	/* Case 1: we don't have a packet. */
-	if (pkt == NULL) {
-		brcmf_dbg(DATA, "Creating new %s Packet, len=%d\n",
-			  write ? "TX" : "RX", buflen_u);
-		mypkt = brcmu_pkt_buf_get_skb(buflen_u);
-		if (!mypkt) {
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
-				  buflen_u);
-			return -EIO;
-		}
 
-		/* For a write, copy the buffer data into the packet. */
-		if (write)
-			memcpy(mypkt->data, buffer, buflen_u);
-
-		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
-						    func, addr, mypkt);
-
-		/* For a read, copy the packet data back to the buffer. */
-		if (!write)
-			memcpy(buffer, mypkt->data, buflen_u);
-
-		brcmu_pkt_buf_free_skb(mypkt);
-	} else if (((ulong) (pkt->data) & DMA_ALIGN_MASK) != 0) {
+	if (((ulong) (pkt->data) & DMA_ALIGN_MASK) != 0) {
 		/*
 		 * Case 2: We have a packet, but it is unaligned.
 		 * In this case, we cannot have a chain (pkt->next == NULL)
@@ -384,7 +365,7 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 		if (write)
 			memcpy(mypkt->data, pkt->data, pkt->len);
 
-		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
+		status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
 						    func, addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
@@ -396,11 +377,11 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 				 it is aligned. */
 		brcmf_dbg(DATA, "Aligned %s Packet, direct DMA\n",
 			  write ? "Tx" : "Rx");
-		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
+		status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
 						    func, addr, pkt);
 	}
 
-	return Status;
+	return status;
 }
 
 /* Read client card reg */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 74beffc..1e4a0bb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -248,7 +248,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 extern int
 brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			   uint fix_inc, uint rw, uint fnc_num, u32 addr,
-			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
+			   struct sk_buff *pkt);
 extern int
 brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 			  uint write, uint func, uint addr,
-- 
1.7.5.4



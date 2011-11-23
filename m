Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1627 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759476Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/24] brcm80211: fmac: separate receiving skb chain
 from other receive path
Date: Tue, 22 Nov 2011 17:21:38 -0800
Message-ID: <1322011319-24863-4-git-send-email-frankyl@broadcom.com> (sfid-20111123_022252_889651_E40E5D76)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In the receive path the buffer used to store the receive data from the
device can be a chain of sk_buff. It has been separated to allow the
use of skb queues.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  116 ++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   97 ++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   47 +++-----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   18 +++-
 4 files changed, 201 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 89ff94d..9c27870 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -222,19 +222,12 @@ bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev)
 	return sdiodev->regfail;
 }
 
-int
-brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags,
-		      u8 *buf, uint nbytes, struct sk_buff *pkt)
+static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
+				     uint flags, uint width, u32 *addr)
 {
-	int status;
-	uint incr_fix;
-	uint width;
-	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
+	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n", fn, addr, nbytes);
-
 	/* Async not implemented yet */
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
@@ -247,29 +240,114 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		sdiodev->sbwad = bar0;
 	}
 
-	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
+
+	if (width == 4)
+		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
+	return 0;
+}
+
+int
+brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		      uint flags, u8 *buf, uint nbytes)
+{
+	struct sk_buff *mypkt;
+	int err;
+
+	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+	if (!mypkt) {
+		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+			  nbytes);
+		return -EIO;
+	}
+
+	err = brcmf_sdcard_recv_pkt(sdiodev, addr, fn, flags, mypkt);
+	if (!err)
+		memcpy(buf, mypkt->data, nbytes);
+
+	brcmu_pkt_buf_free_skb(mypkt);
+	return err;
+}
+
+int
+brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		      uint flags, struct sk_buff *pkt)
+{
+	uint incr_fix;
+	uint width;
+	int err = 0;
+
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+		  fn, addr, pkt->len);
+
+	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
+	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
+	if (err)
+		return err;
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
+	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
+					 fn, addr, width, 0, NULL, pkt);
+
+	return err;
+}
+
+int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			    uint flags, struct sk_buff_head *pktq)
+{
+	uint incr_fix;
+	uint width;
+	int err = 0;
+
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+		  fn, addr, pktq->qlen);
+
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	if (width == 4)
-		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
+	if (err)
+		return err;
 
-	status = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
-					    fn, addr, width, nbytes, buf, pkt);
+	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
+	err = brcmf_sdioh_request_chain(sdiodev, incr_fix, SDIOH_READ, fn, addr,
+					pktq);
 
-	return status;
+	return err;
 }
 
 int
 brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt)
+		      uint flags, u8 *buf, uint nbytes)
+{
+	struct sk_buff *mypkt;
+	int err;
+
+	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+	if (!mypkt) {
+		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+			  nbytes);
+		return -EIO;
+	}
+
+	memcpy(mypkt->data, buf, nbytes);
+	err = brcmf_sdcard_send_pkt(sdiodev, addr, fn, flags, mypkt);
+
+	brcmu_pkt_buf_free_skb(mypkt);
+	return err;
+
+}
+
+int
+brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		      uint flags, struct sk_buff *pkt)
 {
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n", fn, addr, nbytes);
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+		  fn, addr, pkt->len);
 
 	/* Async not implemented yet */
 	if (flags & SDIO_REQ_ASYNC)
@@ -291,7 +369,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
-					  addr, width, nbytes, buf, pkt);
+					  addr, width, 0, NULL, pkt);
 }
 
 int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index bbaeb2d..4e75c19 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -204,16 +204,79 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 	return err_ret;
 }
 
+/* precondition: host controller is claimed */
+static int
+brcmf_sdioh_request_data(struct brcmf_sdio_dev *sdiodev, uint write, bool fifo,
+			 uint func, uint addr, struct sk_buff *pkt, uint pktlen)
+{
+	int err_ret = 0;
+
+	if ((write) && (!fifo)) {
+		err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
+					   ((u8 *) (pkt->data)), pktlen);
+	} else if (write) {
+		err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
+					   ((u8 *) (pkt->data)), pktlen);
+	} else if (fifo) {
+		err_ret = sdio_readsb(sdiodev->func[func],
+				      ((u8 *) (pkt->data)), addr, pktlen);
+	} else {
+		err_ret = sdio_memcpy_fromio(sdiodev->func[func],
+					     ((u8 *) (pkt->data)),
+					     addr, pktlen);
+	}
+
+	return err_ret;
+}
+
 static int
 brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 			   uint write, uint func, uint addr,
 			   struct sk_buff *pkt)
 {
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
+	int err_ret = 0;
+	uint pkt_len = pkt->len;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_packet_wait);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
+
+	/* Claim host controller */
+	sdio_claim_host(sdiodev->func[func]);
+
+	pkt_len += 3;
+	pkt_len &= 0xFFFFFFFC;
+
+	err_ret = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
+					   addr, pkt, pkt_len);
+	if (err_ret) {
+		brcmf_dbg(ERROR, "%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+			  write ? "TX" : "RX", pkt, addr, pkt_len, err_ret);
+	} else {
+		brcmf_dbg(TRACE, "%s xfr'd %p, addr=0x%05x, len=%d\n",
+			  write ? "TX" : "RX", pkt, addr, pkt_len);
+	}
+
+	/* Release host controller */
+	sdio_release_host(sdiodev->func[func]);
+
+	brcmf_dbg(TRACE, "Exit\n");
+	return err_ret;
+}
+
+int
+brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
+			  uint write, uint func, uint addr,
+			  struct sk_buff_head *pktq)
+{
+	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 	u32 SGCount = 0;
 	int err_ret = 0;
 
-	struct sk_buff *pnext;
+	struct sk_buff *pkt;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -223,43 +286,27 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	/* Claim host controller */
 	sdio_claim_host(sdiodev->func[func]);
-	for (pnext = pkt; pnext; pnext = pnext->next) {
-		uint pkt_len = pnext->len;
+
+	skb_queue_walk(pktq, pkt) {
+		uint pkt_len = pkt->len;
 		pkt_len += 3;
 		pkt_len &= 0xFFFFFFFC;
 
-		if ((write) && (!fifo)) {
-			err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
-						   ((u8 *) (pnext->data)),
-						   pkt_len);
-		} else if (write) {
-			err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
-						   ((u8 *) (pnext->data)),
-						   pkt_len);
-		} else if (fifo) {
-			err_ret = sdio_readsb(sdiodev->func[func],
-					      ((u8 *) (pnext->data)),
-					      addr, pkt_len);
-		} else {
-			err_ret = sdio_memcpy_fromio(sdiodev->func[func],
-						     ((u8 *) (pnext->data)),
-						     addr, pkt_len);
-		}
-
+		err_ret = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
+						   addr, pkt, pkt_len);
 		if (err_ret) {
 			brcmf_dbg(ERROR, "%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
-				  write ? "TX" : "RX", pnext, SGCount, addr,
+				  write ? "TX" : "RX", pkt, SGCount, addr,
 				  pkt_len, err_ret);
 		} else {
 			brcmf_dbg(TRACE, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
-				  write ? "TX" : "RX", pnext, SGCount, addr,
+				  write ? "TX" : "RX", pkt, SGCount, addr,
 				  pkt_len);
 		}
-
 		if (!fifo)
 			addr += pkt_len;
-		SGCount++;
 
+		SGCount++;
 	}
 
 	/* Release host controller */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 10b9247..a9b8272 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1228,17 +1228,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		if (usechain) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
+			errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
 					bus->sdiodev->sbwad,
-					SDIO_FUNC_2,
-					F2SYNC, (u8 *) pfirst->data, dlen,
-					pfirst);
+					SDIO_FUNC_2, F2SYNC, &bus->glom);
 		} else if (bus->dataptr) {
 			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
 					bus->sdiodev->sbwad,
-					SDIO_FUNC_2,
-					F2SYNC, bus->dataptr, dlen,
-					NULL);
+					SDIO_FUNC_2, F2SYNC,
+					bus->dataptr, dlen);
 			sublen = (u16) brcmf_sdbrcm_glom_from_buf(bus, dlen);
 			if (sublen != dlen) {
 				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
@@ -1560,8 +1557,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 				bus->sdiodev->sbwad,
 				SDIO_FUNC_2,
-				F2SYNC, (bus->rxctl + BRCMF_FIRSTREAD), rdlen,
-				NULL);
+				F2SYNC, (bus->rxctl + BRCMF_FIRSTREAD), rdlen);
 	bus->f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -1617,9 +1613,8 @@ brcmf_alloc_pkt_and_read(struct brcmf_bus *bus, u16 rdlen,
 	pkt_align(*pkt, rdlen, BRCMF_SDALIGN);
 	*rxbuf = (u8 *) ((*pkt)->data);
 	/* Read the entire frame */
-	sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				      SDIO_FUNC_2, F2SYNC,
-				      *rxbuf, rdlen, *pkt);
+	sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+				      SDIO_FUNC_2, F2SYNC, *pkt);
 	bus->f2rxdata++;
 
 	if (sdret < 0) {
@@ -1847,7 +1842,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		/* Read frame header (hardware and software) */
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, bus->rxhdr,
-					      BRCMF_FIRSTREAD, NULL);
+					      BRCMF_FIRSTREAD);
 		bus->f2rxhdrs++;
 
 		if (sdret < 0) {
@@ -1996,9 +1991,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
-				rdlen, pkt);
+		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+					      SDIO_FUNC_2, F2SYNC, pkt);
 		bus->f2rxdata++;
 
 		if (sdret < 0) {
@@ -2085,14 +2079,6 @@ deliver:
 	return rxcount;
 }
 
-static int
-brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
-		    u8 *buf, uint nbytes, struct sk_buff *pkt)
-{
-	return brcmf_sdcard_send_buf
-		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt);
-}
-
 static void
 brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
 {
@@ -2202,9 +2188,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	if (len & (ALIGNMENT - 1))
 			len = roundup(len, ALIGNMENT);
 
-	ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, frame,
-				    len, pkt);
+	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+				    SDIO_FUNC_2, F2SYNC, pkt);
 	bus->f2txdata++;
 
 	if (ret < 0) {
@@ -2467,9 +2452,9 @@ clkwait:
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
-		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+		ret = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
-			(u32) bus->ctrl_frame_len, NULL);
+			(u32) bus->ctrl_frame_len);
 
 		if (ret < 0) {
 			/* On failure, abort the command and
@@ -2772,8 +2757,8 @@ static int brcmf_tx_frame(struct brcmf_bus *bus, u8 *frame, u16 len)
 	int ret;
 
 	bus->ctrl_frame_stat = false;
-	ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, frame, len, NULL);
+	ret = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				    SDIO_FUNC_2, F2SYNC, frame, len);
 
 	if (ret < 0) {
 		/* On failure, abort the command and terminate the frame */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 726fa89..85694ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -182,11 +182,21 @@ extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
  * NOTE: Async operation is not currently supported.
  */
 extern int
+brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		      uint flags, struct sk_buff *pkt);
+extern int
 brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt);
+		      uint flags, u8 *buf, uint nbytes);
+
+extern int
+brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		      uint flags, struct sk_buff *pkt);
 extern int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt);
+		      uint flags, u8 *buf, uint nbytes);
+extern int
+brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			uint flags, struct sk_buff_head *pktq);
 
 /* Flags bits */
 
@@ -240,6 +250,10 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			   uint fix_inc, uint rw, uint fnc_num,
 			   u32 addr, uint regwidth,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
+extern int
+brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
+			  uint write, uint func, uint addr,
+			  struct sk_buff_head *pktq);
 
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.5.4



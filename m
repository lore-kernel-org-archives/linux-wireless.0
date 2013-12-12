Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38819 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3LLK7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:16 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/18] brcmfmac: reduce function parameters in sdio send/receive calls
Date: Thu, 12 Dec 2013 11:58:59 +0100
Message-ID: <1386845946-9859-12-git-send-email-arend@broadcom.com> (sfid-20131212_122500_427710_F046D0A0)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO send and receive functions in bcmsdh.c are always called
with the same parameters. For the driver there is no use-case
to call them otherwise so remove those parameters from function
prototypes.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   73 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   20 ++----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   20 +++---
 3 files changed, 46 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 1249a60..5ff34e6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -679,9 +679,7 @@ exit:
 	return ret;
 }
 
-int
-brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		     uint flags, u8 *buf, uint nbytes)
+int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
 	int err;
@@ -693,7 +691,7 @@ brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		return -EIO;
 	}
 
-	err = brcmf_sdiod_recv_pkt(sdiodev, addr, fn, flags, mypkt);
+	err = brcmf_sdiod_recv_pkt(sdiodev, mypkt);
 	if (!err)
 		memcpy(buf, mypkt->data, nbytes);
 
@@ -701,50 +699,47 @@ brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	return err;
 }
 
-int
-brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		     uint flags, struct sk_buff *pkt)
+int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
-	uint width;
+	u32 addr = sdiodev->sbwad;
 	int err = 0;
 
-	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
-		  fn, addr, pkt->len);
+	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (err)
 		goto done;
 
-	err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, pkt);
+	err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr, pkt);
 
 done:
 	return err;
 }
 
-int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			   uint flags, struct sk_buff_head *pktq, uint totlen)
+int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
+			   struct sk_buff_head *pktq, uint totlen)
 {
 	struct sk_buff *glom_skb;
 	struct sk_buff *skb;
-	uint width;
+	u32 addr = sdiodev->sbwad;
 	int err = 0;
 
-	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
-		  fn, addr, pktq->qlen);
+	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
+		  addr, pktq->qlen);
 
-	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (err)
 		goto done;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, pktq->next);
+		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
+					 pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, glom_skb);
+		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
+					 glom_skb);
 		if (err)
 			goto done;
 
@@ -753,18 +748,17 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdiod_sglist_rw(sdiodev, fn, false, addr, pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, false, addr,
+					    pktq);
 
 done:
 	return err;
 }
 
-int
-brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		     uint flags, u8 *buf, uint nbytes)
+int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	uint width;
+	u32 addr = sdiodev->sbwad;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -776,41 +770,40 @@ brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 
 	if (!err)
-		err = brcmf_sdiod_buffrw(sdiodev, fn, true, addr, mypkt);
+		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
+					 mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 	return err;
 
 }
 
-int
-brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		     uint flags, struct sk_buff_head *pktq)
+int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
+			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
-	uint width;
+	u32 addr = sdiodev->sbwad;
 	int err;
 
-	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
-		  fn, addr, pktq->qlen);
+	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (err)
 		return err;
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buffrw(sdiodev, fn, true, addr, skb);
+			err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true,
+						 addr, skb);
 			if (err)
 				break;
 		}
 	else
-		err = brcmf_sdiod_sglist_rw(sdiodev, fn, true, addr, pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, true, addr,
+					    pktq);
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3d8a1a8..7fff4cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1419,8 +1419,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 */
 		sdio_claim_host(bus->sdiodev->func[1]);
 		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
-						 bus->sdiodev->sbwad,
-						 SDIO_FUNC_2, F2SYNC,
 						 &bus->glom, dlen);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
@@ -1615,8 +1613,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Read remain of frame body */
-	sdret = brcmf_sdiod_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				     SDIO_FUNC_2, F2SYNC, rbuf, rdlen);
+	sdret = brcmf_sdiod_recv_buf(bus->sdiodev, rbuf, rdlen);
 	bus->sdcnt.f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -1702,8 +1699,6 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		sdio_claim_host(bus->sdiodev->func[1]);
 		if (!rd->len) {
 			ret = brcmf_sdiod_recv_buf(bus->sdiodev,
-						   bus->sdiodev->sbwad,
-						   SDIO_FUNC_2, F2SYNC,
 						   bus->rxhdr, BRCMF_FIRSTREAD);
 			bus->sdcnt.f2rxhdrs++;
 			if (ret < 0) {
@@ -1760,8 +1755,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		skb_pull(pkt, head_read);
 		pkt_align(pkt, rd->len_left, bus->head_align);
 
-		ret = brcmf_sdiod_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-					   SDIO_FUNC_2, F2SYNC, pkt);
+		ret = brcmf_sdiod_recv_pkt(bus->sdiodev, pkt);
 		bus->sdcnt.f2rxdata++;
 		sdio_release_host(bus->sdiodev->func[1]);
 
@@ -2116,8 +2110,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		goto done;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
-	ret = brcmf_sdiod_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-				   SDIO_FUNC_2, F2SYNC, pktq);
+	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0) {
@@ -2481,9 +2474,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		int i;
 
 		sdio_claim_host(bus->sdiodev->func[1]);
-		err = brcmf_sdiod_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
-					   SDIO_FUNC_2, F2SYNC,
-					   bus->ctrl_frame_buf,
+		err = brcmf_sdiod_send_buf(bus->sdiodev, bus->ctrl_frame_buf,
 					   (u32)bus->ctrl_frame_len);
 
 		if (err < 0) {
@@ -2700,8 +2691,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 	int ret;
 
 	bus->ctrl_frame_stat = false;
-	ret = brcmf_sdiod_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				   SDIO_FUNC_2, F2SYNC, frame, len);
+	ret = brcmf_sdiod_send_buf(bus->sdiodev, frame, len);
 
 	if (ret < 0) {
 		/* On failure, abort the command and terminate the frame */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 4d71eb0..4c70cf2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -197,7 +197,6 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
- *   addr:     backplane address (i.e. >= regsva from attach)
  *   flags:    backplane width, address increment, sync/async
  *   buf:      pointer to memory data buffer
  *   nbytes:   number of bytes to transfer to/from buf
@@ -207,17 +206,14 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
  * Returns 0 or error code.
  * NOTE: Async operation is not currently supported.
  */
-int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			 uint flags, struct sk_buff_head *pktq);
-int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			 uint flags, u8 *buf, uint nbytes);
-
-int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			 uint flags, struct sk_buff *pkt);
-int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			 uint flags, u8 *buf, uint nbytes);
-int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			   uint flags, struct sk_buff_head *pktq, uint totlen);
+int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
+			 struct sk_buff_head *pktq);
+int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes);
+
+int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt);
+int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes);
+int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
+			   struct sk_buff_head *pktq, uint totlen);
 
 /* Flags bits */
 
-- 
1.7.10.4


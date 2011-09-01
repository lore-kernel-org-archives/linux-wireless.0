Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2944 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/30] staging: brcm80211: remove function wrapper of
 getting sb window address
Date: Thu, 1 Sep 2011 11:17:05 +0200
Message-ID: <1314868640-9425-16-git-send-email-rvossen@broadcom.com> (sfid-20110901_111808_104890_08D27737)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The address stored in sdiodev can be used directly instead of using
the wrapper function brcmf_sdcard_cur_sbwad.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |    5 ---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   36 +++++++++--------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    3 --
 3 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 3672776..e4c7852 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -476,11 +476,6 @@ int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	return 0;
 }
 
-u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev)
-{
-	return sdiodev->sbwad;
-}
-
 int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	u32 regs = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 72e5629..49914c6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1336,9 +1336,9 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 			len = roundup(len, ALIGNMENT);
 
 	do {
-		ret = brcmf_sdbrcm_send_buf(bus,
-			brcmf_sdcard_cur_sbwad(bus->sdiodev),
-			SDIO_FUNC_2, F2SYNC, frame, len, pkt);
+		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+					    SDIO_FUNC_2, F2SYNC, frame,
+					    len, pkt);
 		bus->f2txdata++;
 
 		if (ret < 0) {
@@ -1625,10 +1625,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 
 		do {
 			bus->ctrl_frame_stat = false;
-			ret = brcmf_sdbrcm_send_buf(bus,
-				brcmf_sdcard_cur_sbwad(bus->sdiodev),
-				SDIO_FUNC_2,
-				F2SYNC, frame, len, NULL);
+			ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+					SDIO_FUNC_2, F2SYNC, frame, len, NULL);
 
 			if (ret < 0) {
 				/* On failure, abort the command and
@@ -1976,11 +1974,9 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
-					   brcmf_sdcard_cur_sbwad(
-							bus->sdiodev)))
+	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, bus->sdiodev->sbwad))
 		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
-			  brcmf_sdcard_cur_sbwad(bus->sdiodev));
+			  bus->sdiodev->sbwad);
 
 	return bcmerror;
 }
@@ -3256,7 +3252,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Read remainder of frame body into the rxctl buffer */
 	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-				brcmf_sdcard_cur_sbwad(bus->sdiodev),
+				bus->sdiodev->sbwad,
 				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL);
@@ -3412,13 +3408,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		 */
 		if (usechain) {
 			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
-					brcmf_sdcard_cur_sbwad(bus->sdiodev),
+					bus->sdiodev->sbwad,
 					SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
 					pfirst);
 		} else if (bus->dataptr) {
 			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
-					brcmf_sdcard_cur_sbwad(bus->sdiodev),
+					bus->sdiodev->sbwad,
 					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL);
@@ -3756,8 +3752,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
 				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-						brcmf_sdcard_cur_sbwad(
-							bus->sdiodev),
+						bus->sdiodev->sbwad,
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
 						pkt);
@@ -3910,8 +3905,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		}
 
 		/* Read frame header (hardware and software) */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-				brcmf_sdcard_cur_sbwad(bus->sdiodev),
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL);
 		bus->f2rxhdrs++;
@@ -4061,8 +4055,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-				brcmf_sdcard_cur_sbwad(bus->sdiodev),
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
 				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
 				rdlen, pkt);
 		bus->f2rxdata++;
@@ -4388,8 +4381,7 @@ clkwait:
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
-		ret = brcmf_sdbrcm_send_buf(bus,
-			brcmf_sdcard_cur_sbwad(bus->sdiodev),
+		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len, NULL);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 9c55c4a..4565aef9 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -231,9 +231,6 @@ extern void brcmf_sdio_function_cleanup(void);
 extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 
-/* Function to return current window addr */
-extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
-
 extern int brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev,
 					  u32 address);
 
-- 
1.7.4.1



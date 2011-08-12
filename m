Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4842 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1HLNfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/14] staging: brcm80211: remove unused parameter from
 data interface in fullmac
Date: Fri, 12 Aug 2011 15:34:59 +0200
Message-ID: <1313156101-16817-13-git-send-email-arend@broadcom.com> (sfid-20110812_153534_371767_154B56D8)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove redundant complete function pointer in send/recv buffer interface.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   10 +------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   31 +++++++++--------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |   10 +------
 3 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 824208f..0c845c9 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -385,10 +385,7 @@ bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev)
 int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags,
-		      u8 *buf, uint nbytes, struct sk_buff *pkt,
-		      void (*complete)(void *handle, int status,
-				       bool sync_waiting),
-		      void *handle)
+		      u8 *buf, uint nbytes, struct sk_buff *pkt)
 {
 	int status;
 	uint incr_fix;
@@ -426,10 +423,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 int
 brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, void *pkt,
-		      void (*complete)(void *handle, int status,
-				       bool sync_waiting),
-		      void *handle)
+		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt)
 {
 	uint incr_fix;
 	uint width;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 1d487db..60e7a814 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -941,10 +941,7 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len);
 static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size);
 static int brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
-			       struct sk_buff *pkt,
-			       void (*complete)(void *handle, int status,
-						      bool sync_waiting),
-			       void *handle);
+			       struct sk_buff *pkt);
 
 static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card);
 static int  _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
@@ -1413,7 +1410,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	do {
 		ret = brcmf_sdbrcm_send_buf(bus,
 			brcmf_sdcard_cur_sbwad(bus->sdiodev),
-			SDIO_FUNC_2, F2SYNC, frame, len, pkt, NULL, NULL);
+			SDIO_FUNC_2, F2SYNC, frame, len, pkt);
 		bus->f2txdata++;
 
 		if (ret < 0) {
@@ -1731,7 +1728,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			ret = brcmf_sdbrcm_send_buf(bus,
 				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2,
-				F2SYNC, frame, len, NULL, NULL, NULL);
+				F2SYNC, frame, len, NULL);
 
 			if (ret < 0) {
 				/* On failure, abort the command and
@@ -3493,7 +3490,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
-				NULL, NULL, NULL);
+				NULL);
 	bus->f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -3657,13 +3654,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					brcmf_sdcard_cur_sbwad(bus->sdiodev),
 					SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
-					pfirst, NULL, NULL);
+					pfirst);
 		} else if (bus->dataptr) {
 			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
 					brcmf_sdcard_cur_sbwad(bus->sdiodev),
 					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
-					NULL, NULL, NULL);
+					NULL);
 			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
@@ -4032,7 +4029,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 							bus->sdiodev),
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
-						pkt, NULL, NULL);
+						pkt);
 				bus->f2rxdata++;
 
 				if (sdret < 0) {
@@ -4195,7 +4192,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
-				NULL, NULL, NULL);
+				NULL);
 		bus->f2rxhdrs++;
 
 		if (sdret < 0) {
@@ -4352,7 +4349,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
-				rdlen, pkt, NULL, NULL);
+				rdlen, pkt);
 		bus->f2rxdata++;
 
 		if (sdret < 0) {
@@ -4689,7 +4686,7 @@ clkwait:
 		ret = brcmf_sdbrcm_send_buf(bus,
 			brcmf_sdcard_cur_sbwad(bus->sdiodev),
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
-			(u32) bus->ctrl_frame_len, NULL, NULL, NULL);
+			(u32) bus->ctrl_frame_len, NULL);
 
 		if (ret < 0) {
 			/* On failure, abort the command and
@@ -5885,14 +5882,10 @@ err:
 
 static int
 brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
-		    u8 *buf, uint nbytes, struct sk_buff *pkt,
-		    void (*complete)(void *handle, int status,
-				     bool sync_waiting),
-		    void *handle)
+		    u8 *buf, uint nbytes, struct sk_buff *pkt)
 {
 	return brcmf_sdcard_send_buf
-		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt, complete,
-		 handle);
+		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt);
 }
 
 int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index dc588e7..03ae16a 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -188,16 +188,10 @@ extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
  */
 extern int
 brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, void *pkt,
-		      void (*complete)(void *handle, int status,
-				       bool sync_waiting),
-		      void *handle);
+		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt);
 extern int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
-		      void (*complete)(void *handle, int status,
-				       bool sync_waiting),
-		      void *handle);
+		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt);
 
 /* Flags bits */
 
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1764 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/9] brcmfmac: remove SDIO_REQ_ASYNC flag
Date: Wed, 26 Jun 2013 14:20:16 +0200
Message-ID: <1372249222-4858-4-git-send-email-arend@broadcom.com> (sfid-20130626_142043_779564_9A597A7B)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove SDIO_REQ_ASYNC from brcmfmac since it is not being used.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c    |   14 +++-----------
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h |    2 --
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3f8e69c..c9c5ad2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -453,15 +453,11 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 }
 
 static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
-				     uint flags, uint width, u32 *addr)
+				     uint width, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	/* Async not implemented yet */
-	if (flags & SDIO_REQ_ASYNC)
-		return -ENOTSUPP;
-
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
@@ -512,7 +508,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pkt->len);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
+	err = brcmf_sdcard_recv_prepare(sdiodev, fn, width, &addr);
 	if (err)
 		goto done;
 
@@ -536,7 +532,7 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
+	err = brcmf_sdcard_recv_prepare(sdiodev, fn, width, &addr);
 	if (err)
 		goto done;
 
@@ -581,10 +577,6 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
-	/* Async not implemented yet */
-	if (flags & SDIO_REQ_ASYNC)
-		return -ENOTSUPP;
-
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 793df66..69c03fe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -229,8 +229,6 @@ brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 #define SDIO_REQ_4BYTE	0x1
 /* Fixed address (FIFO) (vs. incrementing address) */
 #define SDIO_REQ_FIXED	0x2
-/* Async request (vs. sync request) */
-#define SDIO_REQ_ASYNC	0x4
 
 /* Read/write to memory block (F1, no FIFO) via CMD53 (sync only).
  *   rw:       read or write (0/1)
-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1762 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/9] brcmfmac: use unified dongle address preparation
 function
Date: Wed, 26 Jun 2013 14:20:17 +0200
Message-ID: <1372249222-4858-5-git-send-email-arend@broadcom.com> (sfid-20130626_142043_135652_31FA9D84)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Introduce a unified dongle backplane address preparation function
brcmf_sdio_addrprep to replace duplicate address prep code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   79 +++++++-------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    3 -
 2 files changed, 27 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index c9c5ad2..70cd0e9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -162,7 +162,7 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
-int
+static int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0, i;
@@ -193,12 +193,33 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	return err;
 }
 
+static int
+brcmf_sdio_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+{
+	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
+	int err = 0;
+
+	if (bar0 != sdiodev->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
+		if (err)
+			return err;
+
+		sdiodev->sbwad = bar0;
+	}
+
+	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
+
+	if (width == 4)
+		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
+	return 0;
+}
+
 int
 brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			void *data, bool write)
 {
 	u8 func_num, reg_size;
-	u32 bar;
 	s32 retry = 0;
 	int ret;
 
@@ -218,18 +239,7 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		func_num = SDIO_FUNC_1;
 		reg_size = 4;
 
-		/* Set the window for SB core register */
-		bar = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-		if (bar != sdiodev->sbwad) {
-			ret = brcmf_sdcard_set_sbaddr_window(sdiodev, bar);
-			if (ret != 0) {
-				memset(data, 0xFF, reg_size);
-				return ret;
-			}
-			sdiodev->sbwad = bar;
-		}
-		addr &= SBSDIO_SB_OFT_ADDR_MASK;
-		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+		brcmf_sdio_addrprep(sdiodev, reg_size, &addr);
 	}
 
 	do {
@@ -452,28 +462,6 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	return ret;
 }
 
-static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
-				     uint width, u32 *addr)
-{
-	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-	int err = 0;
-
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
-
-		sdiodev->sbwad = bar0;
-	}
-
-	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
-	if (width == 4)
-		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
-
-	return 0;
-}
-
 int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes)
@@ -508,7 +496,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pkt->len);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdcard_recv_prepare(sdiodev, fn, width, &addr);
+	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
 	if (err)
 		goto done;
 
@@ -532,7 +520,7 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdcard_recv_prepare(sdiodev, fn, width, &addr);
+	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
 	if (err)
 		goto done;
 
@@ -570,33 +558,20 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff *pkt)
 {
 	uint width;
-	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 	struct sk_buff_head pkt_list;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			goto done;
-
-		sdiodev->sbwad = bar0;
-	}
-
-	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	if (width == 4)
-		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	brcmf_sdio_addrprep(sdiodev, width, &addr);
 
 	skb_queue_head_init(&pkt_list);
 	skb_queue_tail(&pkt_list, pkt);
 	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, &pkt_list);
 	skb_dequeue_tail(&pkt_list);
 
-done:
 	return err;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 69c03fe..09786a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -249,9 +249,6 @@ extern int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 
-extern int brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev,
-					  u32 address);
-
 /* attach, return handler on success, NULL if failed.
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
-- 
1.7.10.4



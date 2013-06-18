Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1869 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3FRL3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: replace brcmf_sdioh_request_buffer with
 brcmf_sdio_buffrw
Date: Tue, 18 Jun 2013 13:29:28 +0200
Message-ID: <1371554970-23495-8-git-send-email-arend@broadcom.com> (sfid-20130618_132957_378944_52B32C17)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Introducing a new SDIO block data access interface function
brcmf_sdio_buffrw. It will act as a unified interface function for any block
data access to WiFi dongle through SDIO interface. This patch enables
the support for single skb transmission.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   58 ++++++++++++++++----
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   41 +-------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    8 +--
 3 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 4891e3d..32a205e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -303,6 +303,49 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
+/**
+ * brcmf_sdio_buffrw - SDIO interface function for block data access
+ * @sdiodev: brcmfmac sdio device
+ * @fn: SDIO function number
+ * @write: direction flag
+ * @addr: dongle memory address as source/destination
+ * @pkt: skb pointer
+ *
+ * This function takes the respbonsibility as the interface function to MMC
+ * stack for block data access. It assumes that the skb passed down by the
+ * caller has already been padded and aligned.
+ */
+static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
+			     bool write, u32 addr, struct sk_buff *pkt)
+{
+	uint len;
+
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
+
+	/* Single skb use the standard mmc interface */
+	if (!pkt->next) {
+		len = pkt->len + 3;
+		len &= (uint)~3;
+
+		if (write)
+			return sdio_memcpy_toio(sdiodev->func[fn], addr,
+						((u8 *)(pkt->data)), len);
+		else if (fn == 1)
+			return sdio_memcpy_fromio(sdiodev->func[fn],
+						  ((u8 *)(pkt->data)), addr,
+						  len);
+		else
+			/* function 2 read is FIFO operation */
+			return sdio_readsb(sdiodev->func[fn],
+					   ((u8 *)(pkt->data)), addr, len);
+	}
+
+	brcmf_err("skb chain is not supported yet.\n");
+	return -EOPNOTSUPP;
+}
+
 static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
 				     uint flags, uint width, u32 *addr)
 {
@@ -355,7 +398,6 @@ int
 brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff *pkt)
 {
-	uint incr_fix;
 	uint width;
 	int err = 0;
 
@@ -367,9 +409,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (err)
 		goto done;
 
-	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
-	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
-					 fn, addr, pkt);
+	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pkt);
 
 done:
 	return err;
@@ -424,7 +464,6 @@ int
 brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff *pkt)
 {
-	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -446,13 +485,11 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 
-	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
-					 addr, pkt);
+	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, pkt);
 
 done:
 	return err;
@@ -501,9 +538,8 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
-		bcmerror = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC,
-						      write, SDIO_FUNC_1,
-						      sdaddr, pkt);
+		bcmerror = brcmf_sdio_buffrw(sdiodev, SDIO_FUNC_1, write,
+					     sdaddr, pkt);
 		if (bcmerror) {
 			brcmf_err("membytes transfer failed\n");
 			break;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 11400b3..7a3c5bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -66,7 +66,7 @@ MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
 
 
-static bool
+bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 {
 	bool is_err = false;
@@ -76,7 +76,7 @@ brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 	return is_err;
 }
 
-static void
+void
 brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
 {
 #ifdef CONFIG_PM_SLEEP
@@ -283,43 +283,6 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 	return err_ret;
 }
 
-/*
- * This function takes a single DMA-able packet.
- */
-int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
-			       uint fix_inc, uint write, uint func, uint addr,
-			       struct sk_buff *pkt)
-{
-	int status;
-	uint pkt_len;
-	bool fifo = (fix_inc == SDIOH_DATA_FIX);
-
-	brcmf_dbg(SDIO, "Enter\n");
-
-	if (pkt == NULL)
-		return -EINVAL;
-	pkt_len = pkt->len;
-
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
-	if (brcmf_pm_resume_error(sdiodev))
-		return -EIO;
-
-	pkt_len += 3;
-	pkt_len &= (uint)~3;
-
-	status = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
-					   addr, pkt, pkt_len);
-	if (status) {
-		brcmf_err("%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
-			  write ? "TX" : "RX", pkt, addr, pkt_len, status);
-	} else {
-		brcmf_dbg(SDIO, "%s xfr'd %p, addr=0x%05x, len=%d\n",
-			  write ? "TX" : "RX", pkt, addr, pkt_len);
-	}
-
-	return status;
-}
-
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 7c1b633..991c1501 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -274,10 +274,6 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 
 /* read or write any buffer using cmd53 */
 extern int
-brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
-			   uint fix_inc, uint rw, uint fnc_num, u32 addr,
-			   struct sk_buff *pkt);
-extern int
 brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 			  uint write, uint func, uint addr,
 			  struct sk_buff_head *pktq);
@@ -291,4 +287,8 @@ extern void brcmf_sdbrcm_disconnect(void *ptr);
 extern void brcmf_sdbrcm_isr(void *arg);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
+
+extern void brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
+				 wait_queue_head_t *wq);
+extern bool brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4



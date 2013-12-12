Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:11789 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3LLK7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:22 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/18] brcmfmac: use consistent function names in bcmsdh.c
Date: Thu, 12 Dec 2013 11:58:58 +0100
Message-ID: <1386845946-9859-11-git-send-email-arend@broadcom.com> (sfid-20131212_122459_780711_EC039970)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Functions in bcmsdh.c that are called with struct brcmf_sdio_dev
instance are renamed consistently with brcmf_sdiod_ prefix. Also
removing brcmf_sdioh_attach/detach() functions and merge it with
brcmf_sdiod_probe/remove().

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  274 ++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  324 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  288 ++++++++---------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   44 +--
 4 files changed, 452 insertions(+), 478 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 2decb41..1249a60 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -57,7 +57,7 @@
 #define SDIO_WAIT_F2RDY	3000
 
 
-static irqreturn_t brcmf_sdio_oob_irqhandler(int irq, void *dev_id)
+static irqreturn_t brcmf_sdiod_oob_irqhandler(int irq, void *dev_id)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev_id);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -77,7 +77,7 @@ static irqreturn_t brcmf_sdio_oob_irqhandler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void brcmf_sdio_ib_irqhandler(struct sdio_func *func)
+static void brcmf_sdiod_ib_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(&func->dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -88,11 +88,11 @@ static void brcmf_sdio_ib_irqhandler(struct sdio_func *func)
 }
 
 /* dummy handler for SDIO function 2 interrupt */
-static void brcmf_sdio_dummy_irqhandler(struct sdio_func *func)
+static void brcmf_sdiod_dummy_irqhandler(struct sdio_func *func)
 {
 }
 
-static bool brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
+static bool brcmf_sdiod_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 {
 	bool is_err = false;
 #ifdef CONFIG_PM_SLEEP
@@ -101,8 +101,8 @@ static bool brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 	return is_err;
 }
 
-static void brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
-				 wait_queue_head_t *wq)
+static void brcmf_sdiod_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
+				       wait_queue_head_t *wq)
 {
 #ifdef CONFIG_PM_SLEEP
 	int retry = 0;
@@ -111,7 +111,7 @@ static void brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
 #endif
 }
 
-int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
+int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 	u8 data;
@@ -121,7 +121,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 		brcmf_dbg(SDIO, "Enter, register OOB IRQ %d\n",
 			  sdiodev->pdata->oob_irq_nr);
 		ret = request_irq(sdiodev->pdata->oob_irq_nr,
-				  brcmf_sdio_oob_irqhandler,
+				  brcmf_sdiod_oob_irqhandler,
 				  sdiodev->pdata->oob_irq_flags,
 				  "brcmf_oob_intr",
 				  &sdiodev->func[1]->dev);
@@ -145,36 +145,36 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 		sdio_claim_host(sdiodev->func[1]);
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
-		data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
+		data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
 		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
+		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
 		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
 		if (sdiodev->pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
 			data |= SDIO_SEPINT_ACT_HI;
-		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
+		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 
 		sdio_release_host(sdiodev->func[1]);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
 		sdio_claim_host(sdiodev->func[1]);
-		sdio_claim_irq(sdiodev->func[1], brcmf_sdio_ib_irqhandler);
-		sdio_claim_irq(sdiodev->func[2], brcmf_sdio_dummy_irqhandler);
+		sdio_claim_irq(sdiodev->func[1], brcmf_sdiod_ib_irqhandler);
+		sdio_claim_irq(sdiodev->func[2], brcmf_sdiod_dummy_irqhandler);
 		sdio_release_host(sdiodev->func[1]);
 	}
 
 	return 0;
 }
 
-int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
+int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(SDIO, "Entering\n");
 
 	if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
 		sdio_claim_host(sdiodev->func[1]);
-		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
-		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
+		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
+		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 		sdio_release_host(sdiodev->func[1]);
 
 		if (sdiodev->oob_irq_requested) {
@@ -197,7 +197,7 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
-static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
+static inline int brcmf_sdiod_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 					    uint regaddr, u8 *byte)
 {
 	struct sdio_func *sdfunc = sdiodev->func[0];
@@ -227,20 +227,20 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 	return err_ret;
 }
 
-static int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
+static int brcmf_sdiod_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
 				    uint func, uint regaddr, u8 *byte)
 {
 	int err_ret;
 
 	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
-	if (brcmf_pm_resume_error(sdiodev))
+	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
+	if (brcmf_sdiod_pm_resume_error(sdiodev))
 		return -EIO;
 
 	if (rw && func == 0) {
 		/* handle F0 separately */
-		err_ret = brcmf_sdioh_f0_write_byte(sdiodev, regaddr, byte);
+		err_ret = brcmf_sdiod_f0_write_byte(sdiodev, regaddr, byte);
 	} else {
 		if (rw) /* CMD52 Write */
 			sdio_writeb(sdiodev->func[func], *byte, regaddr,
@@ -272,7 +272,7 @@ static int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
 	return err_ret;
 }
 
-static int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
+static int brcmf_sdiod_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
 				    uint func, uint addr, u32 *word,
 				    uint nbytes)
 {
@@ -286,8 +286,8 @@ static int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
 	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		  rw, func, addr, nbytes);
 
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
-	if (brcmf_pm_resume_error(sdiodev))
+	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
+	if (brcmf_sdiod_pm_resume_error(sdiodev))
 		return -EIO;
 
 	if (rw) {		/* CMD52 Write */
@@ -317,7 +317,7 @@ static int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
 }
 
 static int
-brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
+brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0, i;
 	u8 addr[3];
@@ -332,7 +332,7 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 		do {
 			if (retry)
 				usleep_range(1000, 2000);
-			err = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE,
+			err = brcmf_sdiod_request_byte(sdiodev, SDIOH_WRITE,
 					SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW + i,
 					&addr[i]);
 		} while (err != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
@@ -348,13 +348,13 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 }
 
 static int
-brcmf_sdio_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
 	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
 		if (err)
 			return err;
 
@@ -369,8 +369,8 @@ brcmf_sdio_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 	return 0;
 }
 
-static int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				   void *data, bool write)
+static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				    void *data, bool write)
 {
 	u8 func_num, reg_size;
 	s32 retry = 0;
@@ -392,7 +392,7 @@ static int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		func_num = SDIO_FUNC_1;
 		reg_size = 4;
 
-		ret = brcmf_sdio_addrprep(sdiodev, reg_size, &addr);
+		ret = brcmf_sdiod_addrprep(sdiodev, reg_size, &addr);
 		if (ret)
 			goto done;
 	}
@@ -403,10 +403,10 @@ static int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			usleep_range(1000, 2000);
 		if (reg_size == 1)
-			ret = brcmf_sdioh_request_byte(sdiodev, write,
+			ret = brcmf_sdiod_request_byte(sdiodev, write,
 						       func_num, addr, data);
 		else
-			ret = brcmf_sdioh_request_word(sdiodev, write,
+			ret = brcmf_sdiod_request_word(sdiodev, write,
 						       func_num, addr, data, 4);
 	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
@@ -417,13 +417,13 @@ done:
 	return ret;
 }
 
-u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
+u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
 	u8 data;
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, false);
 	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -432,13 +432,13 @@ u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	return data;
 }
 
-u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
+u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
 	u32 data;
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, false);
 	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 	if (ret)
@@ -447,37 +447,37 @@ u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	return data;
 }
 
-void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
+void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		      u8 data, int *ret)
 {
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, true);
 
 	if (ret)
 		*ret = retval;
 }
 
-void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
+void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		      u32 data, int *ret)
 {
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, true);
 
 	if (ret)
 		*ret = retval;
 }
 
-static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
+static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			     bool write, u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
 
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
-	if (brcmf_pm_resume_error(sdiodev))
+	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
+	if (brcmf_sdiod_pm_resume_error(sdiodev))
 		return -EIO;
 
 	/* Single skb use the standard mmc interface */
@@ -500,7 +500,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 }
 
 /**
- * brcmf_sdio_sglist_rw - SDIO interface function for block data access
+ * brcmf_sdiod_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
  * @fn: SDIO function number
  * @write: direction flag
@@ -511,9 +511,9 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
  * stack for block data access. It assumes that the skb passed down by the
  * caller has already been padded and aligned.
  */
-static int brcmf_sdio_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
-				bool write, u32 addr,
-				struct sk_buff_head *pktlist)
+static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
+				 bool write, u32 addr,
+				 struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
 	unsigned int max_req_sz, orig_offset, dst_offset;
@@ -531,8 +531,8 @@ static int brcmf_sdio_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	if (!pktlist->qlen)
 		return -EINVAL;
 
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
-	if (brcmf_pm_resume_error(sdiodev))
+	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
+	if (brcmf_sdiod_pm_resume_error(sdiodev))
 		return -EIO;
 
 	target_list = pktlist;
@@ -680,8 +680,8 @@ exit:
 }
 
 int
-brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes)
+brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		     uint flags, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
 	int err;
@@ -693,7 +693,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		return -EIO;
 	}
 
-	err = brcmf_sdcard_recv_pkt(sdiodev, addr, fn, flags, mypkt);
+	err = brcmf_sdiod_recv_pkt(sdiodev, addr, fn, flags, mypkt);
 	if (!err)
 		memcpy(buf, mypkt->data, nbytes);
 
@@ -702,8 +702,8 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 }
 
 int
-brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, struct sk_buff *pkt)
+brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		     uint flags, struct sk_buff *pkt)
 {
 	uint width;
 	int err = 0;
@@ -712,18 +712,18 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pkt->len);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
 	if (err)
 		goto done;
 
-	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pkt);
+	err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, pkt);
 
 done:
 	return err;
 }
 
-int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			    uint flags, struct sk_buff_head *pktq, uint totlen)
+int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			   uint flags, struct sk_buff_head *pktq, uint totlen)
 {
 	struct sk_buff *glom_skb;
 	struct sk_buff *skb;
@@ -734,17 +734,17 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
 	if (err)
 		goto done;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pktq->next);
+		err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, glom_skb);
+		err = brcmf_sdiod_buffrw(sdiodev, fn, false, addr, glom_skb);
 		if (err)
 			goto done;
 
@@ -753,15 +753,15 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, fn, false, addr, pktq);
 
 done:
 	return err;
 }
 
 int
-brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, u8 *buf, uint nbytes)
+brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		     uint flags, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
 	uint width;
@@ -777,10 +777,10 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	memcpy(mypkt->data, buf, nbytes);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
 
 	if (!err)
-		err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, mypkt);
+		err = brcmf_sdiod_buffrw(sdiodev, fn, true, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 	return err;
@@ -788,8 +788,8 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 }
 
 int
-brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, struct sk_buff_head *pktq)
+brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+		     uint flags, struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
 	uint width;
@@ -799,25 +799,25 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
-	err = brcmf_sdio_addrprep(sdiodev, width, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, width, &addr);
 	if (err)
 		return err;
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, skb);
+			err = brcmf_sdiod_buffrw(sdiodev, fn, true, addr, skb);
 			if (err)
 				break;
 		}
 	else
-		err = brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, fn, true, addr, pktq);
 
 	return err;
 }
 
 int
-brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
-		 u8 *data, uint size)
+brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
+		  u8 *data, uint size)
 {
 	int bcmerror = 0;
 	struct sk_buff *pkt;
@@ -844,7 +844,7 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		bcmerror = brcmf_sdcard_set_sbaddr_window(sdiodev, address);
+		bcmerror = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
 		if (bcmerror)
 			break;
 
@@ -858,8 +858,8 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
-		bcmerror = brcmf_sdio_buffrw(sdiodev, SDIO_FUNC_1, write,
-					     sdaddr, pkt);
+		bcmerror = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
+					      sdaddr, pkt);
 		if (bcmerror) {
 			brcmf_err("membytes transfer failed\n");
 			break;
@@ -881,7 +881,7 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	dev_kfree_skb(pkt);
 
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(sdiodev, sdiodev->sbwad))
+	if (brcmf_sdiod_set_sbaddr_window(sdiodev, sdiodev->sbwad))
 		brcmf_err("FAILED to set window back to 0x%x\n",
 			  sdiodev->sbwad);
 
@@ -890,41 +890,64 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	return bcmerror;
 }
 
-int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
 	char t_func = (char)fn;
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
-	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
+	brcmf_sdiod_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
 				 SDIO_CCCR_ABORT, &t_func);
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
 }
 
-static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
+static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
+{
+	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+
+	if (sdiodev->bus) {
+		brcmf_sdbrcm_disconnect(sdiodev->bus);
+		sdiodev->bus = NULL;
+	}
+
+	/* Disable Function 2 */
+	sdio_claim_host(sdiodev->func[2]);
+	sdio_disable_func(sdiodev->func[2]);
+	sdio_release_host(sdiodev->func[2]);
+
+	/* Disable Function 1 */
+	sdio_claim_host(sdiodev->func[1]);
+	sdio_disable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
+
+	sdiodev->sbwad = 0;
+
+	return 0;
+}
+
+static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
-	int err_ret = 0;
-	struct mmc_host *host;
 	struct sdio_func *func;
+	struct mmc_host *host;
 	uint max_blocks;
-
-	brcmf_dbg(SDIO, "\n");
+	int ret = 0;
 
 	sdiodev->num_funcs = 2;
 
 	sdio_claim_host(sdiodev->func[1]);
 
-	err_ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
-	if (err_ret) {
+	ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
+	if (ret) {
 		brcmf_err("Failed to set F1 blocksize\n");
+		sdio_release_host(sdiodev->func[1]);
 		goto out;
 	}
-
-	err_ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
-	if (err_ret) {
+	ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
+	if (ret) {
 		brcmf_err("Failed to set F2 blocksize\n");
+		sdio_release_host(sdiodev->func[1]);
 		goto out;
 	}
 
@@ -932,14 +955,15 @@ static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->func[2]->enable_timeout = SDIO_WAIT_F2RDY;
 
 	/* Enable Function 1 */
-	err_ret = sdio_enable_func(sdiodev->func[1]);
-	if (err_ret) {
-		brcmf_err("Failed to enable F1 Err: 0x%08x\n", err_ret);
+	ret = sdio_enable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
+	if (ret) {
+		brcmf_err("Failed to enable F1: err=%d\n", ret);
 		goto out;
 	}
 
 	/*
-	 * determine host related variables after brcmf_sdio_probe()
+	 * determine host related variables after brcmf_sdiod_probe()
 	 * as func->cur_blksize is properly set and F2 init has been
 	 * completed successfully.
 	 */
@@ -952,63 +976,17 @@ static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->max_segment_count = min_t(uint, host->max_segs,
 					   SG_MAX_SINGLE_ALLOC);
 	sdiodev->max_segment_size = host->max_seg_size;
-out:
-	sdio_release_host(sdiodev->func[1]);
-	brcmf_dbg(SDIO, "Done\n");
-	return err_ret;
-}
-
-static void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
-{
-	brcmf_dbg(SDIO, "\n");
-
-	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func[2]);
-	sdio_disable_func(sdiodev->func[2]);
-	sdio_release_host(sdiodev->func[2]);
-
-	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func[1]);
-	sdio_disable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
-
-}
-
-static int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
-{
-	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-
-	if (sdiodev->bus) {
-		brcmf_sdbrcm_disconnect(sdiodev->bus);
-		sdiodev->bus = NULL;
-	}
-
-	brcmf_sdioh_detach(sdiodev);
-
-	sdiodev->sbwad = 0;
-
-	return 0;
-}
-
-static int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
-{
-	int ret = 0;
-
-	ret = brcmf_sdioh_attach(sdiodev);
-	if (ret)
-		goto out;
 
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdbrcm_probe(sdiodev);
 	if (!sdiodev->bus) {
-		brcmf_err("device attach failed\n");
 		ret = -ENODEV;
 		goto out;
 	}
 
 out:
 	if (ret)
-		brcmf_sdio_remove(sdiodev);
+		brcmf_sdiod_remove(sdiodev);
 
 	return ret;
 }
@@ -1075,8 +1053,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	init_waitqueue_head(&sdiodev->request_word_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
 
-	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdio_probe...\n");
-	err = brcmf_sdio_probe(sdiodev);
+	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
+	err = brcmf_sdiod_probe(sdiodev);
 	if (err) {
 		brcmf_err("F2 error, probe failed %d...\n", err);
 		goto fail;
@@ -1109,7 +1087,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	bus_if = dev_get_drvdata(&func->dev);
 	if (bus_if) {
 		sdiodev = bus_if->bus_priv.sdio;
-		brcmf_sdio_remove(sdiodev);
+		brcmf_sdiod_remove(sdiodev);
 
 		dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
 		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
@@ -1122,7 +1100,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int brcmf_sdio_suspend(struct device *dev)
+static int brcmf_ops_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -1150,7 +1128,7 @@ static int brcmf_sdio_suspend(struct device *dev)
 	return ret;
 }
 
-static int brcmf_sdio_resume(struct device *dev)
+static int brcmf_ops_sdio_resume(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -1161,8 +1139,8 @@ static int brcmf_sdio_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops brcmf_sdio_pm_ops = {
-	.suspend	= brcmf_sdio_suspend,
-	.resume		= brcmf_sdio_resume,
+	.suspend	= brcmf_ops_sdio_suspend,
+	.resume		= brcmf_ops_sdio_resume,
 };
 #endif	/* CONFIG_PM_SLEEP */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c42d5a0..3d8a1a8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -621,8 +621,8 @@ r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	int ret;
 
-	*regvar = brcmf_sdio_regrl(bus->sdiodev,
-				   bus->ci->c_inf[idx].base + offset, &ret);
+	*regvar = brcmf_sdiod_regrl(bus->sdiodev,
+				    bus->ci->c_inf[idx].base + offset, &ret);
 
 	return ret;
 }
@@ -633,9 +633,9 @@ w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	int ret;
 
-	brcmf_sdio_regwl(bus->sdiodev,
-			 bus->ci->c_inf[idx].base + reg_offset,
-			 regval, &ret);
+	brcmf_sdiod_regwl(bus->sdiodev,
+			  bus->ci->c_inf[idx].base + reg_offset,
+			  regval, &ret);
 
 	return ret;
 }
@@ -651,8 +651,8 @@ brcmf_sdbrcm_kso_control(struct brcmf_sdio *bus, bool on)
 
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-			 wr_val, &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+			  wr_val, &err);
 	if (err) {
 		brcmf_err("SDIO_AOS KSO write error: %d\n", err);
 		return err;
@@ -682,15 +682,15 @@ brcmf_sdbrcm_kso_control(struct brcmf_sdio *bus, bool on)
 		 * just one write attempt may fail,
 		 * read it back until it matches written value
 		 */
-		rd_val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-					  &err);
+		rd_val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+					   &err);
 		if (((rd_val & bmask) == cmp_val) && !err)
 			break;
 		brcmf_dbg(SDIO, "KSO wr/rd retry:%d (max: %d) ERR:%x\n",
 			  try_cnt, MAX_KSO_ATTEMPTS, err);
 		udelay(KSO_WAIT_US);
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-				 wr_val, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+				  wr_val, &err);
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
 
 	return err;
@@ -721,16 +721,16 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 clkreq, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  clkreq, &err);
 		if (err) {
 			brcmf_err("HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdio_regrb(bus->sdiodev,
-					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_err("HT Avail read error: %d\n", err);
 			return -EBADE;
@@ -739,8 +739,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdio_regrb(bus->sdiodev,
-						  SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				brcmf_err("Devctl error setting CA: %d\n",
 					  err);
@@ -748,28 +748,28 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					  devctl, &err);
 			brcmf_dbg(SDIO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdio_regrb(bus->sdiodev,
-						  SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					  devctl, &err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdio_regrb(bus->sdiodev,
-						  SBSDIO_FUNC1_CHIPCLKCSR,
-						  &err);
+			clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_FUNC1_CHIPCLKCSR,
+						   &err);
 			if (time_after(jiffies, timeout))
 				break;
 			else
@@ -802,16 +802,16 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdio_regrb(bus->sdiodev,
-						  SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					  devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 clkreq, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  clkreq, &err);
 		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
 			brcmf_err("Failed access turning clock off: %d\n",
@@ -1037,18 +1037,18 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		  rtx ? ", send NAK" : "");
 
 	if (abort)
-		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
 
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-			 SFC_RF_TERM, &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+			  SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdio_regrb(bus->sdiodev,
-				      SBSDIO_FUNC1_RFRAMEBCHI, &err);
-		lo = brcmf_sdio_regrb(bus->sdiodev,
-				      SBSDIO_FUNC1_RFRAMEBCLO, &err);
+		hi = brcmf_sdiod_regrb(bus->sdiodev,
+				       SBSDIO_FUNC1_RFRAMEBCHI, &err);
+		lo = brcmf_sdiod_regrb(bus->sdiodev,
+				       SBSDIO_FUNC1_RFRAMEBCLO, &err);
 		bus->sdcnt.f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -1418,9 +1418,10 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		sdio_claim_host(bus->sdiodev->func[1]);
-		errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
-				bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, &bus->glom, dlen);
+		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
+						 bus->sdiodev->sbwad,
+						 SDIO_FUNC_2, F2SYNC,
+						 &bus->glom, dlen);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
 
@@ -1614,10 +1615,8 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Read remain of frame body */
-	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-				bus->sdiodev->sbwad,
-				SDIO_FUNC_2,
-				F2SYNC, rbuf, rdlen);
+	sdret = brcmf_sdiod_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				     SDIO_FUNC_2, F2SYNC, rbuf, rdlen);
 	bus->sdcnt.f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -1702,11 +1701,10 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		/* read header first for unknow frame length */
 		sdio_claim_host(bus->sdiodev->func[1]);
 		if (!rd->len) {
-			ret = brcmf_sdcard_recv_buf(bus->sdiodev,
-						      bus->sdiodev->sbwad,
-						      SDIO_FUNC_2, F2SYNC,
-						      bus->rxhdr,
-						      BRCMF_FIRSTREAD);
+			ret = brcmf_sdiod_recv_buf(bus->sdiodev,
+						   bus->sdiodev->sbwad,
+						   SDIO_FUNC_2, F2SYNC,
+						   bus->rxhdr, BRCMF_FIRSTREAD);
 			bus->sdcnt.f2rxhdrs++;
 			if (ret < 0) {
 				brcmf_err("RXHEADER FAILED: %d\n",
@@ -1762,8 +1760,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		skb_pull(pkt, head_read);
 		pkt_align(pkt, rd->len_left, bus->head_align);
 
-		ret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-					      SDIO_FUNC_2, F2SYNC, pkt);
+		ret = brcmf_sdiod_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+					   SDIO_FUNC_2, F2SYNC, pkt);
 		bus->sdcnt.f2rxdata++;
 		sdio_release_host(bus->sdiodev->func[1]);
 
@@ -2118,8 +2116,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		goto done;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
-	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, pktq);
+	ret = brcmf_sdiod_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+				   SDIO_FUNC_2, F2SYNC, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0) {
@@ -2128,17 +2126,17 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 			  ret);
 		bus->sdcnt.tx_sderrs++;
 
-		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-				 SFC_WF_TERM, NULL);
+		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+				  SFC_WF_TERM, NULL);
 		bus->sdcnt.f1regdata++;
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
-			hi = brcmf_sdio_regrb(bus->sdiodev,
-					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-			lo = brcmf_sdio_regrb(bus->sdiodev,
-					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
+			hi = brcmf_sdiod_regrb(bus->sdiodev,
+					       SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+			lo = brcmf_sdiod_regrb(bus->sdiodev,
+					       SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 			bus->sdcnt.f1regdata += 2;
 			if ((hi == 0) && (lo == 0))
 				break;
@@ -2251,11 +2249,11 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdio_regrb(bus->sdiodev,
-				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcmf_sdiod_regrb(bus->sdiodev,
+				    SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err)
 		brcmf_err("Failed to force clock for F2: err %d\n", err);
@@ -2316,7 +2314,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	addr = bus->ci->c_inf[idx].base +
 	       offsetof(struct sdpcmd_regs, intstatus);
 
-	val = brcmf_sdio_regrl(bus->sdiodev, addr, &ret);
+	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
 		val = 0;
@@ -2326,7 +2324,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 	/* Clear interrupts */
 	if (val) {
-		brcmf_sdio_regwl(bus->sdiodev, addr, val, &ret);
+		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
 	}
 
@@ -2359,8 +2357,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 #ifdef DEBUG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdio_regrb(bus->sdiodev,
-					  SBSDIO_DEVICE_CTL, &err);
+		devctl = brcmf_sdiod_regrb(bus->sdiodev,
+					   SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			brcmf_err("error reading DEVCTL: %d\n", err);
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
@@ -2368,8 +2366,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdio_regrb(bus->sdiodev,
-					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_err("error reading CSR: %d\n",
 				  err);
@@ -2380,16 +2378,16 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdio_regrb(bus->sdiodev,
-						  SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				brcmf_err("error reading DEVCTL: %d\n",
 					  err);
 				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					  devctl, &err);
 			if (err) {
 				brcmf_err("error writing DEVCTL: %d\n",
 					  err);
@@ -2483,9 +2481,10 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		int i;
 
 		sdio_claim_host(bus->sdiodev->func[1]);
-		err = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
-			SDIO_FUNC_2, F2SYNC, bus->ctrl_frame_buf,
-			(u32) bus->ctrl_frame_len);
+		err = brcmf_sdiod_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
+					   SDIO_FUNC_2, F2SYNC,
+					   bus->ctrl_frame_buf,
+					   (u32)bus->ctrl_frame_len);
 
 		if (err < 0) {
 			/* On failure, abort the command and
@@ -2494,20 +2493,20 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 				  err);
 			bus->sdcnt.tx_sderrs++;
 
-			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+			brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
 
-			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-					 SFC_WF_TERM, &err);
+			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+					  SFC_WF_TERM, &err);
 			bus->sdcnt.f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdio_regrb(bus->sdiodev,
-						      SBSDIO_FUNC1_WFRAMEBCHI,
-						      &err);
-				lo = brcmf_sdio_regrb(bus->sdiodev,
-						      SBSDIO_FUNC1_WFRAMEBCLO,
-						      &err);
+				hi = brcmf_sdiod_regrb(bus->sdiodev,
+						       SBSDIO_FUNC1_WFRAMEBCHI,
+						       &err);
+				lo = brcmf_sdiod_regrb(bus->sdiodev,
+						       SBSDIO_FUNC1_WFRAMEBCLO,
+						       &err);
 				bus->sdcnt.f1regdata += 2;
 				if ((hi == 0) && (lo == 0))
 					break;
@@ -2631,8 +2630,8 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
 
 	/* Read console log struct */
 	addr = bus->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, (u8 *)&c->log_le,
-			      sizeof(c->log_le));
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&c->log_le,
+			       sizeof(c->log_le));
 	if (rv < 0)
 		return rv;
 
@@ -2657,7 +2656,7 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
 
 	/* Read the console buffer */
 	addr = le32_to_cpu(c->log_le.buf);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, c->buf, c->bufsize);
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, c->buf, c->bufsize);
 	if (rv < 0)
 		return rv;
 
@@ -2701,8 +2700,8 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 	int ret;
 
 	bus->ctrl_frame_stat = false;
-	ret = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, frame, len);
+	ret = brcmf_sdiod_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				   SDIO_FUNC_2, F2SYNC, frame, len);
 
 	if (ret < 0) {
 		/* On failure, abort the command and terminate the frame */
@@ -2710,18 +2709,18 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 			  ret);
 		bus->sdcnt.tx_sderrs++;
 
-		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
 
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-				 SFC_WF_TERM, NULL);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+				  SFC_WF_TERM, NULL);
 		bus->sdcnt.f1regdata++;
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
-			hi = brcmf_sdio_regrb(bus->sdiodev,
-					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-			lo = brcmf_sdio_regrb(bus->sdiodev,
-					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
+			hi = brcmf_sdiod_regrb(bus->sdiodev,
+					       SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+			lo = brcmf_sdiod_regrb(bus->sdiodev,
+					       SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 			bus->sdcnt.f1regdata += 2;
 			if (hi == 0 && lo == 0)
 				break;
@@ -2868,7 +2867,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 */
 	sdio_claim_host(bus->sdiodev->func[1]);
 	brcmf_sdbrcm_bus_sleep(bus, false, false);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
 	sdio_release_host(bus->sdiodev->func[1]);
 	if (rv < 0)
 		return rv;
@@ -2888,8 +2887,8 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	}
 
 	/* Read hndrte_shared structure */
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
-			      sizeof(struct sdpcm_shared_le));
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
+			       sizeof(struct sdpcm_shared_le));
 	if (rv < 0)
 		return rv;
 
@@ -2925,22 +2924,22 @@ static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
 
 	/* obtain console information from device memory */
 	addr = sh->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
-			      (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
+			       (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_ptr = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.buf_size);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
-			      (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
+			       (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_size = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.idx);
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
-			      (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
+			       (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_index = le32_to_cpu(sh_val);
@@ -2954,8 +2953,8 @@ static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
 
 	/* obtain the console data from device */
 	conbuf[console_size] = '\0';
-	rv = brcmf_sdio_ramrw(bus->sdiodev, false, console_ptr, (u8 *)conbuf,
-			      console_size);
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, console_ptr, (u8 *)conbuf,
+			       console_size);
 	if (rv < 0)
 		goto done;
 
@@ -2992,8 +2991,8 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 		return 0;
 	}
 
-	error = brcmf_sdio_ramrw(bus->sdiodev, false, sh->trap_addr, (u8 *)&tr,
-				 sizeof(struct brcmf_trap_info));
+	error = brcmf_sdiod_ramrw(bus->sdiodev, false, sh->trap_addr, (u8 *)&tr,
+				  sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
@@ -3036,14 +3035,14 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 	if (sh->assert_file_addr != 0) {
-		error = brcmf_sdio_ramrw(bus->sdiodev, false,
-					 sh->assert_file_addr, (u8 *)file, 80);
+		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
+					  sh->assert_file_addr, (u8 *)file, 80);
 		if (error < 0)
 			return error;
 	}
 	if (sh->assert_exp_addr != 0) {
-		error = brcmf_sdio_ramrw(bus->sdiodev, false,
-					 sh->assert_exp_addr, (u8 *)expr, 80);
+		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
+					  sh->assert_exp_addr, (u8 *)expr, 80);
 		if (error < 0)
 			return error;
 	}
@@ -3248,8 +3247,8 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 	while (offset < fw->size) {
 		len = ((offset + MEMBLOCK) < fw->size) ? MEMBLOCK :
 		      fw->size - offset;
-		err = brcmf_sdio_ramrw(bus->sdiodev, true, address,
-				       (u8 *)&fw->data[offset], len);
+		err = brcmf_sdiod_ramrw(bus->sdiodev, true, address,
+					(u8 *)&fw->data[offset], len);
 		if (err) {
 			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
 				  err, len, address);
@@ -3399,9 +3398,9 @@ static bool brcmf_sdbrcm_sr_capable(struct brcmf_sdio *bus)
 
 	/* read PMU chipcontrol register 3*/
 	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_addr);
-	brcmf_sdio_regwl(bus->sdiodev, addr, 3, NULL);
+	brcmf_sdiod_regwl(bus->sdiodev, addr, 3, NULL);
 	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_data);
-	reg = brcmf_sdio_regrl(bus->sdiodev, addr, NULL);
+	reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
 
 	return (bool)reg;
 }
@@ -3413,33 +3412,31 @@ static void brcmf_sdbrcm_sr_init(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL,
-			       &err);
+	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL,
-			 val, &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	/* Add CMD14 Support */
-	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
-			 (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
-			  SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
-			 &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
+			  (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
+			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
+			  &err);
 	if (err) {
 		brcmf_err("error writing SDIO_CCCR_BRCM_CARDCAP\n");
 		return;
 	}
 
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			 SBSDIO_FORCE_HT, &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			  SBSDIO_FORCE_HT, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
@@ -3462,8 +3459,7 @@ static int brcmf_sdbrcm_kso_init(struct brcmf_sdio *bus)
 	if (bus->ci->c_inf[1].rev < 12)
 		return 0;
 
-	val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-			       &err);
+	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
 		return err;
@@ -3472,8 +3468,8 @@ static int brcmf_sdbrcm_kso_init(struct brcmf_sdio *bus)
 	if (!(val & SBSDIO_FUNC1_SLEEPCSR_KSO_MASK)) {
 		val |= (SBSDIO_FUNC1_SLEEPCSR_KSO_EN <<
 			SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-				 val, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+				  val, &err);
 		if (err) {
 			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
 			return err;
@@ -3592,11 +3588,11 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		goto exit;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdio_regrb(bus->sdiodev,
-				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcmf_sdiod_regrb(bus->sdiodev,
+				    SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
 		brcmf_err("Failed to force clock for F2: err %d\n", err);
@@ -3618,7 +3614,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		w_sdreg32(bus, bus->hostintmask,
 			  offsetof(struct sdpcmd_regs, hostintmask));
 
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
@@ -3629,12 +3625,12 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		brcmf_sdbrcm_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 saveclk, &err);
+		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  saveclk, &err);
 	}
 
 	if (ret == 0) {
-		ret = brcmf_sdio_intr_register(bus->sdiodev);
+		ret = brcmf_sdiod_intr_register(bus->sdiodev);
 		if (ret != 0)
 			brcmf_err("intr register failed:%d\n", ret);
 	}
@@ -3704,9 +3700,9 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				u8 devpend;
 
 				sdio_claim_host(bus->sdiodev->func[1]);
-				devpend = brcmf_sdio_regrb(bus->sdiodev,
-							   SDIO_CCCR_INTx,
-							   NULL);
+				devpend = brcmf_sdiod_regrb(bus->sdiodev,
+							    SDIO_CCCR_INTx,
+							    NULL);
 				sdio_release_host(bus->sdiodev->func[1]);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
@@ -3814,18 +3810,18 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
-		 brcmf_sdio_regrl(bus->sdiodev, SI_ENUM_BASE, NULL));
+		 brcmf_sdiod_regrl(bus->sdiodev, SI_ENUM_BASE, NULL));
 
 	/*
 	 * Force PLL off until brcmf_sdio_chip_attach()
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			 BRCMF_INIT_CLKCTL1, &err);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			  BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
-		clkctl = brcmf_sdio_regrb(bus->sdiodev,
-					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
 		brcmf_err("ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
@@ -3857,33 +3853,33 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus)
 	}
 
 	/* Set card control so an SDIO card reset does a WLAN backplane reset */
-	reg_val = brcmf_sdio_regrb(bus->sdiodev,
-				   SDIO_CCCR_BRCM_CARDCTRL, &err);
+	reg_val = brcmf_sdiod_regrb(bus->sdiodev,
+				    SDIO_CCCR_BRCM_CARDCTRL, &err);
 	if (err)
 		goto fail;
 
 	reg_val |= SDIO_CCCR_BRCM_CARDCTRL_WLANRESET;
 
-	brcmf_sdio_regwb(bus->sdiodev,
-			 SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
+	brcmf_sdiod_regwb(bus->sdiodev,
+			  SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
 	if (err)
 		goto fail;
 
 	/* set PMUControl so a backplane reset does PMU state reload */
 	reg_addr = CORE_CC_REG(bus->ci->c_inf[0].base,
 			       pmucontrol);
-	reg_val = brcmf_sdio_regrl(bus->sdiodev,
-				   reg_addr,
-				   &err);
+	reg_val = brcmf_sdiod_regrl(bus->sdiodev,
+				    reg_addr,
+				    &err);
 	if (err)
 		goto fail;
 
 	reg_val |= (BCMA_CC_PMU_CTL_RES_RELOAD << BCMA_CC_PMU_CTL_RES_SHIFT);
 
-	brcmf_sdio_regwl(bus->sdiodev,
-			 reg_addr,
-			 reg_val,
-			 &err);
+	brcmf_sdiod_regwl(bus->sdiodev,
+			  reg_addr,
+			  reg_val,
+			  &err);
 	if (err)
 		goto fail;
 
@@ -3926,7 +3922,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	sdio_release_host(bus->sdiodev->func[1]);
 
@@ -4005,7 +4001,7 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 
 	if (bus) {
 		/* De-register interrupt handler */
-		brcmf_sdio_intr_unregister(bus->sdiodev);
+		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
 		cancel_work_sync(&bus->datawork);
 		if (bus->brcmf_wq)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index b612808d..5f39f28 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -112,9 +112,9 @@ brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbidhigh),
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbidhigh),
+				    NULL);
 	return SBCOREREV(regdata);
 }
 
@@ -140,9 +140,9 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	if (idx == BRCMF_MAX_CORENUM)
 		return false;
 
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				    NULL);
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
 	return (SSB_TMSLOW_CLOCK == regdata);
@@ -160,13 +160,13 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	if (idx == BRCMF_MAX_CORENUM)
 		return false;
 
-	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				    NULL);
 	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
 
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				    NULL);
 	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
 
 	return ret;
@@ -182,79 +182,79 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 	base = ci->c_inf[idx].base;
 
-	regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
 	if (regdata & SSB_TMSLOW_RESET)
 		return;
 
-	regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
 	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
-					   NULL);
-		brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-				 regdata | SSB_TMSLOW_REJECT, NULL);
+		regdata = brcmf_sdiod_regrl(sdiodev,
+					    CORE_SB(base, sbtmstatelow), NULL);
+		brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+				  regdata | SSB_TMSLOW_REJECT, NULL);
 
-		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
-					   NULL);
+		regdata = brcmf_sdiod_regrl(sdiodev,
+					    CORE_SB(base, sbtmstatelow), NULL);
 		udelay(1);
-		SPINWAIT((brcmf_sdio_regrl(sdiodev,
-					   CORE_SB(base, sbtmstatehigh),
-					   NULL) &
-			SSB_TMSHIGH_BUSY), 100000);
-
-		regdata = brcmf_sdio_regrl(sdiodev,
-					   CORE_SB(base, sbtmstatehigh),
-					   NULL);
+		SPINWAIT((brcmf_sdiod_regrl(sdiodev,
+					    CORE_SB(base, sbtmstatehigh),
+					    NULL) &
+			  SSB_TMSHIGH_BUSY), 100000);
+
+		regdata = brcmf_sdiod_regrl(sdiodev,
+					    CORE_SB(base, sbtmstatehigh),
+					    NULL);
 		if (regdata & SSB_TMSHIGH_BUSY)
 			brcmf_err("core state still busy\n");
 
-		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbidlow),
-					   NULL);
+		regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbidlow),
+					    NULL);
 		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdio_regrl(sdiodev,
-						   CORE_SB(base, sbimstate),
-						   NULL);
+			regdata = brcmf_sdiod_regrl(sdiodev,
+						    CORE_SB(base, sbimstate),
+						    NULL);
 			regdata |= SSB_IMSTATE_REJECT;
-			brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbimstate),
-					 regdata, NULL);
-			regdata = brcmf_sdio_regrl(sdiodev,
-						   CORE_SB(base, sbimstate),
-						   NULL);
+			brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbimstate),
+					  regdata, NULL);
+			regdata = brcmf_sdiod_regrl(sdiodev,
+						    CORE_SB(base, sbimstate),
+						    NULL);
 			udelay(1);
-			SPINWAIT((brcmf_sdio_regrl(sdiodev,
-						   CORE_SB(base, sbimstate),
-						   NULL) &
-				SSB_IMSTATE_BUSY), 100000);
+			SPINWAIT((brcmf_sdiod_regrl(sdiodev,
+						    CORE_SB(base, sbimstate),
+						    NULL) &
+				  SSB_IMSTATE_BUSY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
 		regdata = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			  SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
-		brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-				 regdata, NULL);
-		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
-					   NULL);
+		brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+				  regdata, NULL);
+		regdata = brcmf_sdiod_regrl(sdiodev,
+					    CORE_SB(base, sbtmstatelow), NULL);
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbidlow),
-					   NULL);
+		regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbidlow),
+					    NULL);
 		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdio_regrl(sdiodev,
-						   CORE_SB(base, sbimstate),
-						   NULL);
+			regdata = brcmf_sdiod_regrl(sdiodev,
+						    CORE_SB(base, sbimstate),
+						    NULL);
 			regdata &= ~SSB_IMSTATE_REJECT;
-			brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbimstate),
-					 regdata, NULL);
+			brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbimstate),
+					  regdata, NULL);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-			 (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET), NULL);
+	brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+			  (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET), NULL);
 	udelay(1);
 }
 
@@ -270,9 +270,9 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 		return;
 
 	/* if core is already in reset, just return */
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				    NULL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
@@ -281,24 +281,24 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	 * extra 10ms is taken into account for firmware load stage
 	 * after 10300us carry on disabling the core anyway
 	 */
-	SPINWAIT(brcmf_sdio_regrl(sdiodev,
-				  ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
-				  NULL), 10300);
-	regdata = brcmf_sdio_regrl(sdiodev,
+	SPINWAIT(brcmf_sdiod_regrl(sdiodev,
 				   ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
-				   NULL);
+				   NULL), 10300);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
+				    NULL);
 	if (regdata)
 		brcmf_err("disabling core 0x%x with reset status %x\n",
 			  coreid, regdata);
 
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			 BCMA_RESET_CTL_RESET, NULL);
+	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			  BCMA_RESET_CTL_RESET, NULL);
 	udelay(1);
 
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			 core_bits, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			  core_bits, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				    NULL);
 	usleep_range(10, 20);
 
 }
@@ -325,47 +325,47 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdio_regwl(sdiodev,
-			 CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET,
-			 NULL);
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev,
+			  CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			  SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET,
+			  NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				    NULL);
 	udelay(1);
 
 	/* clear any serror */
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
+				    NULL);
 	if (regdata & SSB_TMSHIGH_SERR)
-		brcmf_sdio_regwl(sdiodev,
-				 CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
-				 0, NULL);
+		brcmf_sdiod_regwl(sdiodev,
+				  CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
+				  0, NULL);
 
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbimstate),
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbimstate),
+				    NULL);
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
-		brcmf_sdio_regwl(sdiodev,
-				 CORE_SB(ci->c_inf[idx].base, sbimstate),
-				 regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO),
-				 NULL);
+		brcmf_sdiod_regwl(sdiodev,
+				  CORE_SB(ci->c_inf[idx].base, sbimstate),
+				  regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO),
+				  NULL);
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdio_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			  SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				    NULL);
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdio_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			 SSB_TMSLOW_CLOCK, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			  SSB_TMSLOW_CLOCK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				    NULL);
 	udelay(1);
 }
 
@@ -384,21 +384,21 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, core_bits);
 
 	/* now do initialization sequence */
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			 core_bits | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				   NULL);
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			 0, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			  core_bits | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				    NULL);
+	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			  0, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				    NULL);
 	udelay(1);
 
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			 core_bits | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				   NULL);
+	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			  core_bits | BCMA_IOCTL_CLK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				    NULL);
 	udelay(1);
 }
 
@@ -450,9 +450,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	 */
 	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
 	ci->c_inf[0].base = SI_ENUM_BASE;
-	regdata = brcmf_sdio_regrl(sdiodev,
-				   CORE_CC_REG(ci->c_inf[0].base, chipid),
-				   NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev,
+				    CORE_CC_REG(ci->c_inf[0].base, chipid),
+				    NULL);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
@@ -607,7 +607,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
 		brcmf_err("error writing for HT off\n");
 		return err;
@@ -615,8 +615,8 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdio_regrb(sdiodev,
-				  SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+	clkval = brcmf_sdiod_regrb(sdiodev,
+				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
 		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
@@ -624,8 +624,8 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 		return -EACCES;
 	}
 
-	SPINWAIT(((clkval = brcmf_sdio_regrb(sdiodev,
-					     SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
+	SPINWAIT(((clkval = brcmf_sdiod_regrb(sdiodev,
+					      SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
 	if (!SBSDIO_ALPAV(clkval)) {
@@ -635,11 +635,11 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
-	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	udelay(65);
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
 	return 0;
 }
@@ -654,16 +654,16 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
 
 	/* get chipcommon capabilites */
-	ci->c_inf[0].caps = brcmf_sdio_regrl(sdiodev,
-					     CORE_CC_REG(base, capabilities),
-					     NULL);
+	ci->c_inf[0].caps = brcmf_sdiod_regrl(sdiodev,
+					      CORE_CC_REG(base, capabilities),
+					      NULL);
 
 	/* get pmu caps & rev */
 	if (ci->c_inf[0].caps & CC_CAP_PMU) {
 		ci->pmucaps =
-			brcmf_sdio_regrl(sdiodev,
-					 CORE_CC_REG(base, pmucapabilities),
-					 NULL);
+			brcmf_sdiod_regrl(sdiodev,
+					  CORE_CC_REG(base, pmucapabilities),
+					  NULL);
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
@@ -703,10 +703,10 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
-	brcmf_sdio_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopullup),
-			 0, NULL);
-	brcmf_sdio_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopulldown),
-			 0, NULL);
+	brcmf_sdiod_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopullup),
+			  0, NULL);
+	brcmf_sdiod_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopulldown),
+			  0, NULL);
 
 	*ci_ptr = ci;
 	return 0;
@@ -784,12 +784,12 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			}
 		}
 		addr = CORE_CC_REG(base, chipcontrol_addr);
-		brcmf_sdio_regwl(sdiodev, addr, 1, NULL);
-		cc_data_temp = brcmf_sdio_regrl(sdiodev, addr, NULL);
+		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
+		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdio_regwl(sdiodev, addr, cc_data_temp, NULL);
+		brcmf_sdiod_regwl(sdiodev, addr, cc_data_temp, NULL);
 
 		brcmf_dbg(INFO, "SDIO: %d mA (req=%d mA) drive strength selected, set to 0x%08x\n",
 			  str_tab[i].strength, drivestrength, cc_data_temp);
@@ -816,8 +816,8 @@ brcmf_sdio_chip_verifynvram(struct brcmf_sdio_dev *sdiodev, u32 nvram_addr,
 	memset(nvram_ularray, 0xaa, nvram_sz);
 
 	/* Read the vars list to temp buffer for comparison */
-	err = brcmf_sdio_ramrw(sdiodev, false, nvram_addr, nvram_ularray,
-			       nvram_sz);
+	err = brcmf_sdiod_ramrw(sdiodev, false, nvram_addr, nvram_ularray,
+				nvram_sz);
 	if (err) {
 		brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
 			  err, nvram_sz, nvram_addr);
@@ -850,7 +850,7 @@ static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
 	nvram_addr = (ci->ramsize - 4) - nvram_sz + ci->rambase;
 
 	/* Write the vars list */
-	err = brcmf_sdio_ramrw(sdiodev, true, nvram_addr, nvram_dat, nvram_sz);
+	err = brcmf_sdiod_ramrw(sdiodev, true, nvram_addr, nvram_dat, nvram_sz);
 	if (err) {
 		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
 			  err, nvram_sz, nvram_addr);
@@ -874,8 +874,8 @@ static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
 		  nvram_addr, nvram_sz, token);
 
 	/* Write the length token to the last word */
-	if (brcmf_sdio_ramrw(sdiodev, true, (ci->ramsize - 4 + ci->rambase),
-			     (u8 *)&token_le, 4))
+	if (brcmf_sdiod_ramrw(sdiodev, true, (ci->ramsize - 4 + ci->rambase),
+			      (u8 *)&token_le, 4))
 		return false;
 
 	return true;
@@ -891,7 +891,7 @@ brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0);
 
 	/* clear length token */
-	brcmf_sdio_ramrw(sdiodev, true, ci->ramsize - 4, (u8 *)&zeros, 4);
+	brcmf_sdiod_ramrw(sdiodev, true, ci->ramsize - 4, (u8 *)&zeros, 4);
 }
 
 static bool
@@ -913,7 +913,7 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = ci->c_inf[core_idx].base;
 	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
-	brcmf_sdio_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
 	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
 
@@ -942,11 +942,11 @@ brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = ci->c_inf[core_idx].base;
 	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
-	brcmf_sdio_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
 	/* Write reset vector to address 0 */
-	brcmf_sdio_ramrw(sdiodev, true, 0, (void *)&ci->rst_vec,
-			 sizeof(ci->rst_vec));
+	brcmf_sdiod_ramrw(sdiodev, true, 0, (void *)&ci->rst_vec,
+			  sizeof(ci->rst_vec));
 
 	/* restore ARM */
 	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, 0);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 414aa16..4d71eb0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -184,16 +184,16 @@ struct brcmf_sdio_dev {
 };
 
 /* Register/deregister interrupt handler. */
-int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev);
-int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
+int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev);
+int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
 /* sdio device register access interface */
-u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr, u8 data,
-		      int *ret);
-void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
-		      int *ret);
+u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
+u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
+void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr, u8 data,
+		       int *ret);
+void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
+		       int *ret);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
@@ -207,17 +207,17 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
  * Returns 0 or error code.
  * NOTE: Async operation is not currently supported.
  */
-int brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			  uint flags, struct sk_buff_head *pktq);
-int brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			  uint flags, u8 *buf, uint nbytes);
-
-int brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			  uint flags, struct sk_buff *pkt);
-int brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			  uint flags, u8 *buf, uint nbytes);
-int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			    uint flags, struct sk_buff_head *pktq, uint totlen);
+int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			 uint flags, struct sk_buff_head *pktq);
+int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			 uint flags, u8 *buf, uint nbytes);
+
+int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			 uint flags, struct sk_buff *pkt);
+int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			 uint flags, u8 *buf, uint nbytes);
+int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
+			   uint flags, struct sk_buff_head *pktq, uint totlen);
 
 /* Flags bits */
 
@@ -233,11 +233,11 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
  *   nbytes:   number of bytes to transfer to/from buf
  * Returns 0 or error code.
  */
-int brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
-		     u8 *data, uint size);
+int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
+		      u8 *data, uint size);
 
 /* Issue an abort to the specified function */
-int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
 struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdbrcm_disconnect(struct brcmf_sdio *bus);
-- 
1.7.10.4


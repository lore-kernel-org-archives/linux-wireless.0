Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59602 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751911AbdGSTNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:13:20 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 32/34] brcmfmac: Replace function index with function pointer
Date: Wed, 19 Jul 2017 20:08:20 +0100
Message-Id: <20170719190822.10857-33-ian@mnementh.co.uk> (sfid-20170719_211325_805701_BEF212AD)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for removing the function array, remove all code that
refers to function by index and replace with pointers to the function
itself.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 69 +++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 14 ++---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    | 14 ++---
 3 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 89cf71d98cee..43a9c28738b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -148,7 +148,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
 		data = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
-		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
+		data |= SDIO_CCCR_IEN_FUNC1 | SDIO_CCCR_IEN_FUNC2 | SDIO_CCCR_IEN_BIT0;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
@@ -290,7 +290,8 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
+static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev,
+				struct sdio_func *func,
 				u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
@@ -300,13 +301,12 @@ static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	if (fn == 1)
-		err = sdio_memcpy_fromio(sdiodev->func[fn],
-				((u8 *)(pkt->data)), addr, req_sz);
+	if (func->num == 1)
+		err = sdio_memcpy_fromio(func, ((u8 *)(pkt->data)), addr,
+						req_sz);
 	else
 		/* function 2 read is FIFO operation */
-		err = sdio_readsb(sdiodev->func[fn],
-				((u8 *)(pkt->data)), addr, req_sz);
+		err = sdio_readsb(func, ((u8 *)(pkt->data)), addr, req_sz);
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
@@ -314,7 +314,8 @@ static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
 	return err;
 }
 
-static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
+static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev,
+				struct sdio_func *func,
 				u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
@@ -324,8 +325,7 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	err = sdio_memcpy_toio(sdiodev->func[fn], addr,
-			       ((u8 *)(pkt->data)), req_sz);
+	err = sdio_memcpy_toio(func, addr, ((u8 *)(pkt->data)), req_sz);
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
@@ -336,7 +336,7 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
 /**
  * brcmf_sdiod_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
- * @fn: SDIO function number
+ * @func: SDIO function
  * @write: direction flag
  * @addr: dongle memory address as source/destination
  * @pkt: skb pointer
@@ -345,9 +345,10 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
  * stack for block data access. It assumes that the skb passed down by the
  * caller has already been padded and aligned.
  */
-static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
-				 bool write, u32 addr,
-				 struct sk_buff_head *pktlist)
+static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
+					struct sdio_func *func,
+					bool write, u32 addr,
+					struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
 	unsigned int max_req_sz, orig_offset, dst_offset;
@@ -371,7 +372,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		req_sz = 0;
 		skb_queue_walk(pktlist, pkt_next)
 			req_sz += pkt_next->len;
-		req_sz = ALIGN(req_sz, sdiodev->func[fn]->cur_blksize);
+		req_sz = ALIGN(req_sz, func->cur_blksize);
 		while (req_sz > PAGE_SIZE) {
 			pkt_next = brcmu_pkt_buf_get_skb(PAGE_SIZE);
 			if (pkt_next == NULL) {
@@ -390,7 +391,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		target_list = &local_list;
 	}
 
-	func_blk_sz = sdiodev->func[fn]->cur_blksize;
+	func_blk_sz = func->cur_blksize;
 	max_req_sz = sdiodev->max_request_size;
 	max_seg_cnt = min_t(unsigned short, sdiodev->max_segment_count,
 			    target_list->qlen);
@@ -407,10 +408,10 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
 	mmc_cmd.opcode = SD_IO_RW_EXTENDED;
 	mmc_cmd.arg = write ? 1<<31 : 0;	/* write flag  */
-	mmc_cmd.arg |= (fn & 0x7) << 28;	/* SDIO func num */
+	mmc_cmd.arg |= (func->num & 0x7) << 28;	/* SDIO func num */
 	mmc_cmd.arg |= 1<<27;			/* block mode */
 	/* for function 1 the addr will be incremented */
-	mmc_cmd.arg |= (fn == 1) ? 1<<26 : 0;
+	mmc_cmd.arg |= (func->num == 1) ? 1<<26 : 0;
 	mmc_cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
 	mmc_req.cmd = &mmc_cmd;
 	mmc_req.data = &mmc_dat;
@@ -456,11 +457,11 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		mmc_cmd.arg |= (addr & 0x1FFFF) << 9;	/* address */
 		mmc_cmd.arg |= mmc_dat.blocks & 0x1FF;	/* block count */
 		/* incrementing addr for function 1 */
-		if (fn == 1)
+		if (func->num == 1)
 			addr += req_sz;
 
-		mmc_set_data_timeout(&mmc_dat, sdiodev->func[fn]->card);
-		mmc_wait_for_req(sdiodev->func[fn]->card->host, &mmc_req);
+		mmc_set_data_timeout(&mmc_dat, func->card);
+		mmc_wait_for_req(func->card->host, &mmc_req);
 
 		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
 		if (ret == -ENOMEDIUM) {
@@ -540,7 +541,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr, pkt);
 
 done:
 	return err;
@@ -565,13 +566,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
+		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr,
 					 pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
+		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr,
 					 glom_skb);
 		if (err)
 			goto done;
@@ -581,7 +582,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, false, addr,
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], false, addr,
 					    pktq);
 
 done:
@@ -613,7 +614,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
-		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2], addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 
@@ -639,13 +640,13 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2],
 						 addr, skb);
 			if (err)
 				break;
 		}
 	else
-		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, true, addr,
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], true, addr,
 					    pktq);
 
 	return err;
@@ -695,11 +696,11 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 		if (write) {
 			memcpy(pkt->data, data, dsize);
-			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_1,
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[1],
 						      sdaddr, pkt);
 		}
 		else {
-			err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_1,
+			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[1],
 						      sdaddr, pkt);
 		}
 
@@ -728,12 +729,12 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	return err;
 }
 
-int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, struct sdio_func *func)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Issue abort cmd52 command through F0 */
-	brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_ABORT, fn, NULL);
+	brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_ABORT, func->num, NULL);
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
@@ -1104,7 +1105,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 
 	func = container_of(dev, struct sdio_func, dev);
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
-	if (func->num != SDIO_FUNC_1)
+	if (func->num != 1)
 		return 0;
 
 
@@ -1133,7 +1134,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct sdio_func *func = container_of(dev, struct sdio_func, dev);
 
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
-	if (func->num != SDIO_FUNC_2)
+	if (func->num != 2)
 		return 0;
 
 	brcmf_sdiod_freezer_off(sdiodev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 9b8bd870c1fc..c94625b6549f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1144,7 +1144,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		  rtx ? ", send NAK" : "");
 
 	if (abort)
-		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdiod_abort(bus->sdiodev, bus->sdiodev->func[2]);
 
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
@@ -1193,7 +1193,7 @@ static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 	brcmf_err("sdio error, abort command and terminate frame\n");
 	bus->sdcnt.tx_sderrs++;
 
-	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
+	brcmf_sdiod_abort(sdiodev, sdiodev->func[2]);
 	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
@@ -2055,7 +2055,7 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 	int ntail, ret;
 
 	sdiodev = bus->sdiodev;
-	blksize = sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+	blksize = sdiodev->func[2]->cur_blksize;
 	/* sg entry alignment should be a divisor of block size */
 	WARN_ON(blksize % bus->sgentry_align);
 
@@ -2423,7 +2423,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 
 		/* Turn off the bus (F2), free any pending packets */
 		brcmf_dbg(INTR, "disable SDIO interrupts\n");
-		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
+		sdio_disable_func(sdiodev->func[2]);
 
 		/* Clear any pending interrupts now that F2 is disabled */
 		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus),
@@ -4024,7 +4024,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailboxdata),
 				SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT, NULL);
 
-	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
+	err = sdio_enable_func(sdiodev->func[2]);
 
 
 	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
@@ -4040,7 +4040,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
-		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
+		sdio_disable_func(sdiodev->func[2]);
 		goto release;
 	}
 
@@ -4183,7 +4183,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
+	sdio_disable_func(bus->sdiodev->func[2]);
 
 	bus->rxflow = false;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index cae21d14042d..bc9e9bcf40e2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -24,9 +24,6 @@
 /* Maximum number of I/O funcs */
 #define NUM_SDIO_FUNCS	3
 
-#define SDIO_FUNC_1		1
-#define SDIO_FUNC_2		2
-
 #define SDIOD_FBR_SIZE		0x100
 
 /* io_en */
@@ -45,11 +42,13 @@
 #define REG_F0_REG_MASK		0x7FF
 #define REG_F1_MISC_MASK	0x1FFFF
 
-/* as of sdiod rev 0, supports 3 functions */
-#define SBSDIO_NUM_FUNCTION		3
-
 /* function 0 vendor specific CCCR registers */
 
+/* Interrupt enable bits for func 1 and 2 */
+#define SDIO_CCCR_IEN_BIT0		(1 << 0)
+#define SDIO_CCCR_IEN_FUNC1		(1 << 1)
+#define SDIO_CCCR_IEN_FUNC2		(1 << 2)
+
 #define SDIO_CCCR_BRCM_CARDCAP		0xf0
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
@@ -349,7 +348,8 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		      u8 *data, uint size);
 
 /* Issue an abort to the specified function */
-int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn);
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, struct sdio_func *func);
+
 void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 			      enum brcmf_sdiod_state state);
-- 
2.11.0

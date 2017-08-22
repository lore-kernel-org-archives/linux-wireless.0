Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60224 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932550AbdHVLpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:38 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 27/30] brcmfmac: Replace function index with function pointer
Date: Tue, 22 Aug 2017 12:25:47 +0100
Message-Id: <20170822112550.60311-28-ian@mnementh.co.uk> (sfid-20170822_134550_159268_B2E9E3C9)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for removing the function array, remove all code that
refers to function by index and replace with pointers to the function
itself.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 83 ++++++++++++----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 15 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  6 +-
 3 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 69a6699126fd..0cd081d732f9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -289,8 +289,9 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
-				 u32 addr, struct sk_buff *pkt)
+static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev,
+				 struct sdio_func *func, u32 addr,
+				 struct sk_buff *pkt)
 {
 	unsigned int req_sz;
 	int err;
@@ -299,13 +300,17 @@ static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	if (fn == 1)
-		err = sdio_memcpy_fromio(sdiodev->func[fn],
-					 ((u8 *)(pkt->data)), addr, req_sz);
-	else
-		/* function 2 read is FIFO operation */
-		err = sdio_readsb(sdiodev->func[fn],
-				  ((u8 *)(pkt->data)), addr, req_sz);
+	switch (func->num) {
+	case 1:
+		err = sdio_memcpy_fromio(func, ((u8 *)(pkt->data)), addr,
+					 req_sz);
+		break;
+	case 2:
+		err = sdio_readsb(func, ((u8 *)(pkt->data)), addr, req_sz);
+		break;
+	default:
+		BUG();
+	};
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
@@ -313,8 +318,9 @@ static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
 	return err;
 }
 
-static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
-				  u32 addr, struct sk_buff *pkt)
+static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev,
+				  struct sdio_func *func, u32 addr,
+				  struct sk_buff *pkt)
 {
 	unsigned int req_sz;
 	int err;
@@ -323,8 +329,7 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	err = sdio_memcpy_toio(sdiodev->func[fn], addr,
-			       ((u8 *)(pkt->data)), req_sz);
+	err = sdio_memcpy_toio(func, addr, ((u8 *)(pkt->data)), req_sz);
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
@@ -335,7 +340,7 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
 /**
  * brcmf_sdiod_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
- * @fn: SDIO function number
+ * @func: SDIO function
  * @write: direction flag
  * @addr: dongle memory address as source/destination
  * @pkt: skb pointer
@@ -344,7 +349,8 @@ static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
  * stack for block data access. It assumes that the skb passed down by the
  * caller has already been padded and aligned.
  */
-static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
+static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
+				 struct sdio_func *func,
 				 bool write, u32 addr,
 				 struct sk_buff_head *pktlist)
 {
@@ -370,7 +376,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		req_sz = 0;
 		skb_queue_walk(pktlist, pkt_next)
 			req_sz += pkt_next->len;
-		req_sz = ALIGN(req_sz, sdiodev->func[fn]->cur_blksize);
+		req_sz = ALIGN(req_sz, func->cur_blksize);
 		while (req_sz > PAGE_SIZE) {
 			pkt_next = brcmu_pkt_buf_get_skb(PAGE_SIZE);
 			if (pkt_next == NULL) {
@@ -389,7 +395,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		target_list = &local_list;
 	}
 
-	func_blk_sz = sdiodev->func[fn]->cur_blksize;
+	func_blk_sz = func->cur_blksize;
 	max_req_sz = sdiodev->max_request_size;
 	max_seg_cnt = min_t(unsigned short, sdiodev->max_segment_count,
 			    target_list->qlen);
@@ -406,10 +412,10 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
 	mmc_cmd.opcode = SD_IO_RW_EXTENDED;
 	mmc_cmd.arg = write ? 1<<31 : 0;	/* write flag  */
-	mmc_cmd.arg |= (fn & 0x7) << 28;	/* SDIO func num */
-	mmc_cmd.arg |= 1<<27;			/* block mode */
+	mmc_cmd.arg |= (func->num & 0x7) << 28;	/* SDIO func num */
+	mmc_cmd.arg |= 1 << 27;			/* block mode */
 	/* for function 1 the addr will be incremented */
-	mmc_cmd.arg |= (fn == 1) ? 1<<26 : 0;
+	mmc_cmd.arg |= (func->num == 1) ? 1 << 26 : 0;
 	mmc_cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
 	mmc_req.cmd = &mmc_cmd;
 	mmc_req.data = &mmc_dat;
@@ -455,11 +461,11 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
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
@@ -539,7 +545,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr, pkt);
 
 done:
 	return err;
@@ -564,13 +570,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
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
@@ -580,8 +586,8 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, false, addr,
-					    pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], false,
+					    addr, pktq);
 
 done:
 	brcmu_pkt_buf_free_skb(glom_skb);
@@ -612,7 +618,8 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
-		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2], addr,
+					     mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 
@@ -637,14 +644,14 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support) {
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2],
 						     addr, skb);
 			if (err)
 				break;
 		}
 	} else {
-		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, true, addr,
-					    pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], true,
+					    addr, pktq);
 	}
 
 	return err;
@@ -694,10 +701,10 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 		if (write) {
 			memcpy(pkt->data, data, dsize);
-			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_1,
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[1],
 						     sdaddr, pkt);
 		} else {
-			err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_1,
+			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[1],
 						    sdaddr, pkt);
 		}
 
@@ -726,12 +733,12 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
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
@@ -1102,7 +1109,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 
 	func = container_of(dev, struct sdio_func, dev);
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
-	if (func->num != SDIO_FUNC_1)
+	if (func->num != 1)
 		return 0;
 
 
@@ -1131,7 +1138,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct sdio_func *func = container_of(dev, struct sdio_func, dev);
 
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
-	if (func->num != SDIO_FUNC_2)
+	if (func->num != 2)
 		return 0;
 
 	brcmf_sdiod_freezer_off(sdiodev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8a730133db77..c95d9efe8672 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1148,7 +1148,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		  rtx ? ", send NAK" : "");
 
 	if (abort)
-		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdiod_abort(bus->sdiodev, bus->sdiodev->func[2]);
 
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM,
 			   &err);
@@ -1198,7 +1198,7 @@ static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 	brcmf_err("sdio error, abort command and terminate frame\n");
 	bus->sdcnt.tx_sderrs++;
 
-	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
+	brcmf_sdiod_abort(sdiodev, sdiodev->func[2]);
 	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
@@ -2061,7 +2061,7 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 	int ntail, ret;
 
 	sdiodev = bus->sdiodev;
-	blksize = sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+	blksize = sdiodev->func[2]->cur_blksize;
 	/* sg entry alignment should be a divisor of block size */
 	WARN_ON(blksize % bus->sgentry_align);
 
@@ -2431,7 +2431,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 
 		/* Turn off the bus (F2), free any pending packets */
 		brcmf_dbg(INTR, "disable SDIO interrupts\n");
-		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
+		sdio_disable_func(sdiodev->func[2]);
 
 		/* Clear any pending interrupts now that F2 is disabled */
 		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus),
@@ -4043,8 +4043,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailboxdata),
 			   SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT, NULL);
 
-	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
-
+	err = sdio_enable_func(sdiodev->func[2]);
 
 	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
 
@@ -4059,7 +4058,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
-		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
+		sdio_disable_func(sdiodev->func[2]);
 		goto release;
 	}
 
@@ -4197,7 +4196,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
+	sdio_disable_func(bus->sdiodev->func[2]);
 
 	bus->rxflow = false;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 6e2fc065b8a7..54a03036fccb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -45,9 +45,6 @@
 #define REG_F0_REG_MASK		0x7FF
 #define REG_F1_MISC_MASK	0x1FFFF
 
-/* as of sdiod rev 0, supports 3 functions */
-#define SBSDIO_NUM_FUNCTION		3
-
 /* function 0 vendor specific CCCR registers */
 
 #define SDIO_CCCR_BRCM_CARDCAP			0xf0
@@ -350,7 +347,8 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
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

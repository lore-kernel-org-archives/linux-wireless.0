Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1869 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3FRL3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 8/8] brcmfmac: add sdio sg list support
Date: Tue, 18 Jun 2013 13:29:29 +0200
Message-ID: <1371554970-23495-9-git-send-email-arend@broadcom.com> (sfid-20130618_133007_954541_53A30C16)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Add scatter gather list support for better rx glom performance.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  149 +++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   73 ----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   82 +----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    7 -
 4 files changed, 137 insertions(+), 174 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 32a205e..3f8e69c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -22,9 +22,11 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/scatterlist.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
 
 #include <defs.h>
@@ -316,34 +318,138 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
  * caller has already been padded and aligned.
  */
 static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
-			     bool write, u32 addr, struct sk_buff *pkt)
+			     bool write, u32 addr, struct sk_buff_head *pktlist)
 {
-	uint len;
+	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
+	unsigned int max_blks, max_req_sz;
+	unsigned short max_seg_sz, seg_sz;
+	unsigned char *pkt_data;
+	struct sk_buff *pkt_next = NULL;
+	struct mmc_request mmc_req;
+	struct mmc_command mmc_cmd;
+	struct mmc_data mmc_dat;
+	struct sg_table st;
+	struct scatterlist *sgl;
+	struct mmc_host *host;
+	int ret = 0;
+
+	if (!pktlist->qlen)
+		return -EINVAL;
 
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
 	/* Single skb use the standard mmc interface */
-	if (!pkt->next) {
-		len = pkt->len + 3;
-		len &= (uint)~3;
+	if (pktlist->qlen == 1) {
+		pkt_next = pktlist->next;
+		req_sz = pkt_next->len + 3;
+		req_sz &= (uint)~3;
 
 		if (write)
 			return sdio_memcpy_toio(sdiodev->func[fn], addr,
-						((u8 *)(pkt->data)), len);
+						((u8 *)(pkt_next->data)),
+						req_sz);
 		else if (fn == 1)
 			return sdio_memcpy_fromio(sdiodev->func[fn],
-						  ((u8 *)(pkt->data)), addr,
-						  len);
+						  ((u8 *)(pkt_next->data)),
+						  addr, req_sz);
 		else
 			/* function 2 read is FIFO operation */
 			return sdio_readsb(sdiodev->func[fn],
-					   ((u8 *)(pkt->data)), addr, len);
+					   ((u8 *)(pkt_next->data)), addr,
+					   req_sz);
 	}
 
-	brcmf_err("skb chain is not supported yet.\n");
-	return -EOPNOTSUPP;
+	host = sdiodev->func[fn]->card->host;
+	func_blk_sz = sdiodev->func[fn]->cur_blksize;
+	/* Blocks per command is limited by host count, host transfer
+	 * size and the maximum for IO_RW_EXTENDED of 511 blocks.
+	 */
+	max_blks = min_t(unsigned int, host->max_blk_count, 511u);
+	max_req_sz = min_t(unsigned int, host->max_req_size,
+			   max_blks * func_blk_sz);
+	max_seg_sz = min_t(unsigned short, host->max_segs, SG_MAX_SINGLE_ALLOC);
+	max_seg_sz = min_t(unsigned short, max_seg_sz, pktlist->qlen);
+	seg_sz = pktlist->qlen;
+	pkt_offset = 0;
+	pkt_next = pktlist->next;
+
+	if (sg_alloc_table(&st, max_seg_sz, GFP_KERNEL))
+		return -ENOMEM;
+
+	while (seg_sz) {
+		req_sz = 0;
+		sg_cnt = 0;
+		memset(&mmc_req, 0, sizeof(struct mmc_request));
+		memset(&mmc_cmd, 0, sizeof(struct mmc_command));
+		memset(&mmc_dat, 0, sizeof(struct mmc_data));
+		sgl = st.sgl;
+		/* prep sg table */
+		while (pkt_next != (struct sk_buff *)pktlist) {
+			pkt_data = pkt_next->data + pkt_offset;
+			sg_data_sz = pkt_next->len - pkt_offset;
+			if (sg_data_sz > host->max_seg_size)
+				sg_data_sz = host->max_seg_size;
+			if (sg_data_sz > max_req_sz - req_sz)
+				sg_data_sz = max_req_sz - req_sz;
+
+			sg_set_buf(sgl, pkt_data, sg_data_sz);
+
+			sg_cnt++;
+			sgl = sg_next(sgl);
+			req_sz += sg_data_sz;
+			pkt_offset += sg_data_sz;
+			if (pkt_offset == pkt_next->len) {
+				pkt_offset = 0;
+				pkt_next = pkt_next->next;
+			}
+
+			if (req_sz >= max_req_sz || sg_cnt >= max_seg_sz)
+				break;
+		}
+		seg_sz -= sg_cnt;
+
+		if (req_sz % func_blk_sz != 0) {
+			brcmf_err("sg request length %u is not %u aligned\n",
+				  req_sz, func_blk_sz);
+			sg_free_table(&st);
+			return -ENOTBLK;
+		}
+		mmc_dat.sg = st.sgl;
+		mmc_dat.sg_len = sg_cnt;
+		mmc_dat.blksz = func_blk_sz;
+		mmc_dat.blocks = req_sz / func_blk_sz;
+		mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+		mmc_cmd.opcode = SD_IO_RW_EXTENDED;
+		mmc_cmd.arg = write ? 1<<31 : 0;	/* write flag  */
+		mmc_cmd.arg |= (fn & 0x7) << 28;	/* SDIO func num */
+		mmc_cmd.arg |= 1<<27;			/* block mode */
+		/* incrementing addr for function 1 */
+		mmc_cmd.arg |= (fn == 1) ? 1<<26 : 0;
+		mmc_cmd.arg |= (addr & 0x1FFFF) << 9;	/* address */
+		mmc_cmd.arg |= mmc_dat.blocks & 0x1FF;	/* block count */
+		mmc_cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
+		mmc_req.cmd = &mmc_cmd;
+		mmc_req.data = &mmc_dat;
+		if (fn == 1)
+			addr += req_sz;
+
+		mmc_set_data_timeout(&mmc_dat, sdiodev->func[fn]->card);
+		mmc_wait_for_req(host, &mmc_req);
+
+		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
+		if (ret != 0) {
+			brcmf_err("CMD53 sg block %s failed %d\n",
+				  write ? "write" : "read", ret);
+			ret = -EIO;
+			break;
+		}
+	}
+
+	sg_free_table(&st);
+
+	return ret;
 }
 
 static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
@@ -400,6 +506,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 {
 	uint width;
 	int err = 0;
+	struct sk_buff_head pkt_list;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
@@ -409,7 +516,10 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (err)
 		goto done;
 
-	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pkt);
+	skb_queue_head_init(&pkt_list);
+	skb_queue_tail(&pkt_list, pkt);
+	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, &pkt_list);
+	skb_dequeue_tail(&pkt_list);
 
 done:
 	return err;
@@ -431,8 +541,7 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		goto done;
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
-	err = brcmf_sdioh_request_chain(sdiodev, incr_fix, SDIOH_READ, fn, addr,
-					pktq);
+	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pktq);
 
 done:
 	return err;
@@ -467,6 +576,7 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
+	struct sk_buff_head pkt_list;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
@@ -489,7 +599,10 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, pkt);
+	skb_queue_head_init(&pkt_list);
+	skb_queue_tail(&pkt_list, pkt);
+	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, &pkt_list);
+	skb_dequeue_tail(&pkt_list);
 
 done:
 	return err;
@@ -503,6 +616,7 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
+	struct sk_buff_head pkt_list;
 
 	dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
 	pkt = dev_alloc_skb(dsize);
@@ -511,6 +625,7 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		return -EIO;
 	}
 	pkt->priority = 0;
+	skb_queue_head_init(&pkt_list);
 
 	/* Determine initial transfer parameters */
 	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
@@ -538,8 +653,10 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
+		skb_queue_tail(&pkt_list, pkt);
 		bcmerror = brcmf_sdio_buffrw(sdiodev, SDIO_FUNC_1, write,
-					     sdaddr, pkt);
+					     sdaddr, &pkt_list);
+		skb_dequeue_tail(&pkt_list);
 		if (bcmerror) {
 			brcmf_err("membytes transfer failed\n");
 			break;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7a3c5bf..289e386 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -211,78 +211,6 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 	return err_ret;
 }
 
-/* precondition: host controller is claimed */
-static int
-brcmf_sdioh_request_data(struct brcmf_sdio_dev *sdiodev, uint write, bool fifo,
-			 uint func, uint addr, struct sk_buff *pkt, uint pktlen)
-{
-	int err_ret = 0;
-
-	if ((write) && (!fifo)) {
-		err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
-					   ((u8 *) (pkt->data)), pktlen);
-	} else if (write) {
-		err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
-					   ((u8 *) (pkt->data)), pktlen);
-	} else if (fifo) {
-		err_ret = sdio_readsb(sdiodev->func[func],
-				      ((u8 *) (pkt->data)), addr, pktlen);
-	} else {
-		err_ret = sdio_memcpy_fromio(sdiodev->func[func],
-					     ((u8 *) (pkt->data)),
-					     addr, pktlen);
-	}
-
-	return err_ret;
-}
-
-/*
- * This function takes a queue of packets. The packets on the queue
- * are assumed to be properly aligned by the caller.
- */
-int
-brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
-			  uint write, uint func, uint addr,
-			  struct sk_buff_head *pktq)
-{
-	bool fifo = (fix_inc == SDIOH_DATA_FIX);
-	u32 SGCount = 0;
-	int err_ret = 0;
-
-	struct sk_buff *pkt;
-
-	brcmf_dbg(SDIO, "Enter\n");
-
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_chain_wait);
-	if (brcmf_pm_resume_error(sdiodev))
-		return -EIO;
-
-	skb_queue_walk(pktq, pkt) {
-		uint pkt_len = pkt->len;
-		pkt_len += 3;
-		pkt_len &= 0xFFFFFFFC;
-
-		err_ret = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
-						   addr, pkt, pkt_len);
-		if (err_ret) {
-			brcmf_err("%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
-				  write ? "TX" : "RX", pkt, SGCount, addr,
-				  pkt_len, err_ret);
-		} else {
-			brcmf_dbg(SDIO, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
-				  write ? "TX" : "RX", pkt, SGCount, addr,
-				  pkt_len);
-		}
-		if (!fifo)
-			addr += pkt_len;
-
-		SGCount++;
-	}
-
-	brcmf_dbg(SDIO, "Exit\n");
-	return err_ret;
-}
-
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
@@ -431,7 +359,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	atomic_set(&sdiodev->suspend, false);
 	init_waitqueue_head(&sdiodev->request_byte_wait);
 	init_waitqueue_head(&sdiodev->request_word_wait);
-	init_waitqueue_head(&sdiodev->request_chain_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdio_probe...\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index cb22f2f..2641119 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -448,8 +448,6 @@ struct brcmf_sdio {
 	uint rxblen;		/* Allocated length of rxbuf */
 	u8 *rxctl;		/* Aligned pointer into rxbuf */
 	u8 *rxctl_orig;		/* pointer for freeing rxctl */
-	u8 *databuf;		/* Buffer for receiving big glom packet */
-	u8 *dataptr;		/* Aligned pointer into databuf */
 	uint rxlen;		/* Length of valid data in buffer */
 	spinlock_t rxctl_lock;	/* protection lock for ctrl frame resources */
 
@@ -473,8 +471,6 @@ struct brcmf_sdio {
 	s32 idletime;		/* Control for activity timeout */
 	s32 idlecount;	/* Activity timeout counter */
 	s32 idleclock;	/* How to set bus driver when idle */
-	s32 sd_rxchain;
-	bool use_rxchain;	/* If brcmf should use PKT chains */
 	bool rxflow_mode;	/* Rx flow control mode */
 	bool rxflow;		/* Is rx flow control on */
 	bool alp_only;		/* Don't use HT clock (ALP only) */
@@ -1025,29 +1021,6 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 }
 
-/* copy a buffer into a pkt buffer chain */
-static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_sdio *bus, uint len)
-{
-	uint n, ret = 0;
-	struct sk_buff *p;
-	u8 *buf;
-
-	buf = bus->dataptr;
-
-	/* copy the data */
-	skb_queue_walk(&bus->glom, p) {
-		n = min_t(uint, p->len, len);
-		memcpy(p->data, buf, n);
-		buf += n;
-		len -= n;
-		ret += n;
-		if (!len)
-			break;
-	}
-
-	return ret;
-}
-
 /* return total length of buffer chain */
 static uint brcmf_sdbrcm_glom_len(struct brcmf_sdio *bus)
 {
@@ -1201,8 +1174,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	int errcode;
 	u8 doff, sfdoff;
 
-	bool usechain = bus->use_rxchain;
-
 	struct brcmf_sdio_read rd_new;
 
 	/* If packets, issue read(s) and send up packet chain */
@@ -1237,7 +1208,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			if (sublen % BRCMF_SDALIGN) {
 				brcmf_err("sublen %d not multiple of %d\n",
 					  sublen, BRCMF_SDALIGN);
-				usechain = false;
 			}
 			totlen += sublen;
 
@@ -1304,27 +1274,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		sdio_claim_host(bus->sdiodev->func[1]);
-		if (usechain) {
-			errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
-					bus->sdiodev->sbwad,
-					SDIO_FUNC_2, F2SYNC, &bus->glom);
-		} else if (bus->dataptr) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
-					bus->sdiodev->sbwad,
-					SDIO_FUNC_2, F2SYNC,
-					bus->dataptr, dlen);
-			sublen = (u16) brcmf_sdbrcm_glom_from_buf(bus, dlen);
-			if (sublen != dlen) {
-				brcmf_err("FAILED TO COPY, dlen %d sublen %d\n",
-					  dlen, sublen);
-				errcode = -1;
-			}
-			pnext = NULL;
-		} else {
-			brcmf_err("COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
-				  dlen);
-			errcode = -1;
-		}
+		errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
+				bus->sdiodev->sbwad,
+				SDIO_FUNC_2, F2SYNC, &bus->glom);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
 
@@ -3527,9 +3479,6 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
 	kfree(bus->rxbuf);
 	bus->rxctl = bus->rxbuf = NULL;
 	bus->rxlen = 0;
-
-	kfree(bus->databuf);
-	bus->databuf = NULL;
 }
 
 static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
@@ -3542,29 +3491,10 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf))
-			goto fail;
-	}
-
-	/* Allocate buffer to receive glomed packet */
-	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
-	if (!(bus->databuf)) {
-		/* release rxbuf which was already located as above */
-		if (!bus->rxblen)
-			kfree(bus->rxbuf);
-		goto fail;
+			return false;
 	}
 
-	/* Align the buffer */
-	if ((unsigned long)bus->databuf % BRCMF_SDALIGN)
-		bus->dataptr = bus->databuf + (BRCMF_SDALIGN -
-			       ((unsigned long)bus->databuf % BRCMF_SDALIGN));
-	else
-		bus->dataptr = bus->databuf;
-
 	return true;
-
-fail:
-	return false;
 }
 
 static bool
@@ -3703,10 +3633,6 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
-	/* bus module does not support packet chaining */
-	bus->use_rxchain = false;
-	bus->sd_rxchain = false;
-
 	/* SR state */
 	bus->sleeping = false;
 	bus->sr_enabled = false;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 991c1501..793df66 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -170,7 +170,6 @@ struct brcmf_sdio_dev {
 	atomic_t suspend;		/* suspend flag */
 	wait_queue_head_t request_byte_wait;
 	wait_queue_head_t request_word_wait;
-	wait_queue_head_t request_chain_wait;
 	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
@@ -272,12 +271,6 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			 uint rw, uint fnc, uint addr,
 			 u32 *word, uint nbyte);
 
-/* read or write any buffer using cmd53 */
-extern int
-brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
-			  uint write, uint func, uint addr,
-			  struct sk_buff_head *pktq);
-
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
-- 
1.7.10.4



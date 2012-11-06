Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1678 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/24] brcmfmac: protect consecutive SDIO access with
 sdio_claim_host
Date: Mon, 5 Nov 2012 16:22:24 -0800
Message-ID: <1352161352-30405-17-git-send-email-frankyl@broadcom.com> (sfid-20121106_012311_515725_B1403CEE)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Semaphore sdsem is used to protect consecutive memory access
through SDIO bus. Same functionality is provided by sdio_claim_host/
sdio_release_host interface as well. Replace sdsem with
sdio_claim_host.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   28 +----
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  118 ++++++++++++--------
 3 files changed, 82 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3b2c4c2..1aec434 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -84,6 +84,8 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 		return ret;
 	sdiodev->irq_wake = true;
 
+	sdio_claim_host(sdiodev->func[1]);
+
 	/* must configure SDIO_CCCR_IENx to enable irq */
 	data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
 	data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
@@ -95,6 +97,8 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 		data |= SDIO_SEPINT_ACT_HI;
 	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 
+	sdio_release_host(sdiodev->func[1]);
+
 	return 0;
 }
 
@@ -102,8 +106,10 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
+	sdio_claim_host(sdiodev->func[1]);
 	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
+	sdio_release_host(sdiodev->func[1]);
 
 	if (sdiodev->irq_wake) {
 		disable_irq_wake(sdiodev->irq);
@@ -249,9 +255,7 @@ u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
-	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
-	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(INFO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -266,9 +270,7 @@ u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
-	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
-	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(INFO, "data:0x%08x\n", data);
 
 	if (ret)
@@ -283,9 +285,7 @@ void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
-	sdio_release_host(sdiodev->func[1]);
 
 	if (ret)
 		*ret = retval;
@@ -297,9 +297,7 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
-	sdio_release_host(sdiodev->func[1]);
 
 	if (ret)
 		*ret = retval;
@@ -364,8 +362,6 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
-	sdio_claim_host(sdiodev->func[1]);
-
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
 	if (err)
@@ -376,8 +372,6 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 					 fn, addr, pkt);
 
 done:
-	sdio_release_host(sdiodev->func[1]);
-
 	return err;
 }
 
@@ -391,8 +385,6 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pktq->qlen);
 
-	sdio_claim_host(sdiodev->func[1]);
-
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
 	if (err)
@@ -403,8 +395,6 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 					pktq);
 
 done:
-	sdio_release_host(sdiodev->func[1]);
-
 	return err;
 }
 
@@ -446,8 +436,6 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
-	sdio_claim_host(sdiodev->func[1]);
-
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
@@ -467,8 +455,6 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 					 addr, pkt);
 
 done:
-	sdio_release_host(sdiodev->func[1]);
-
 	return err;
 }
 
@@ -510,10 +496,8 @@ int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
-	sdio_claim_host(sdiodev->func[1]);
 	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
 				 SDIO_CCCR_ABORT, &t_func);
-	sdio_release_host(sdiodev->func[1]);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c3247d5..c62ec2a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -372,9 +372,7 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Enable Function 1 */
-	sdio_claim_host(sdiodev->func[1]);
 	err_ret = sdio_enable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
 	if (err_ret)
 		brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
 
@@ -393,16 +391,14 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->num_funcs = 2;
 
 	sdio_claim_host(sdiodev->func[1]);
+
 	err_ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
-	sdio_release_host(sdiodev->func[1]);
 	if (err_ret) {
 		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
 		goto out;
 	}
 
-	sdio_claim_host(sdiodev->func[2]);
 	err_ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
-	sdio_release_host(sdiodev->func[2]);
 	if (err_ret) {
 		brcmf_dbg(ERROR, "Failed to set F2 blocksize\n");
 		goto out;
@@ -411,6 +407,7 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdioh_enablefuncs(sdiodev);
 
 out:
+	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(TRACE, "Done\n");
 	return err_ret;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e328852..7b8c653 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -584,8 +584,6 @@ struct brcmf_sdio {
 	struct list_head dpc_tsklst;
 	spinlock_t dpc_tl_lock;
 
-	struct semaphore sdsem;
-
 	const struct firmware *firmware;
 	u32 fw_ptr;
 
@@ -1274,7 +1272,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
-		down(&bus->sdsem);
+		sdio_claim_host(bus->sdiodev->func[1]);
 		if (usechain) {
 			errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
 					bus->sdiodev->sbwad,
@@ -1296,7 +1294,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				  dlen);
 			errcode = -1;
 		}
-		up(&bus->sdsem);
+		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe, allow a couple retries */
@@ -1305,6 +1303,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				  dlen, errcode);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
 
+			sdio_claim_host(bus->sdiodev->func[1]);
 			if (bus->glomerr++ < 3) {
 				brcmf_sdbrcm_rxfail(bus, true, true);
 			} else {
@@ -1313,6 +1312,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				bus->sdcnt.rxglomfail++;
 				brcmf_sdbrcm_free_glom(bus);
 			}
+			sdio_release_host(bus->sdiodev->func[1]);
 			return 0;
 		}
 
@@ -1322,8 +1322,10 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
+		sdio_claim_host(bus->sdiodev->func[1]);
 		errcode = -!brcmf_sdio_hdparser(bus, pfirst->data, &rd_new,
 						   BRCMF_SDIO_FT_SUPER);
+		sdio_release_host(bus->sdiodev->func[1]);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */
@@ -1339,9 +1341,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
+			sdio_claim_host(bus->sdiodev->func[1]);
 			errcode = -!brcmf_sdio_hdparser(bus, pnext->data,
 							   &rd_new,
 							   BRCMF_SDIO_FT_SUB);
+			sdio_release_host(bus->sdiodev->func[1]);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
 
@@ -1351,6 +1355,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (errcode) {
 			/* Terminate frame on error, request
 				 a couple retries */
+			sdio_claim_host(bus->sdiodev->func[1]);
 			if (bus->glomerr++ < 3) {
 				/* Restore superframe header space */
 				skb_push(pfirst, sfdoff);
@@ -1361,6 +1366,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				bus->sdcnt.rxglomfail++;
 				brcmf_sdbrcm_free_glom(bus);
 			}
+			sdio_release_host(bus->sdiodev->func[1]);
 			bus->cur_read.len = 0;
 			return 0;
 		}
@@ -1585,7 +1591,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		rd->len_left = rd->len;
 		/* read header first for unknow frame length */
-		down(&bus->sdsem);
+		sdio_claim_host(bus->sdiodev->func[1]);
 		if (!rd->len) {
 			sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 						      bus->sdiodev->sbwad,
@@ -1598,7 +1604,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  sdret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdbrcm_rxfail(bus, true, true);
-				up(&bus->sdsem);
+				sdio_release_host(bus->sdiodev->func[1]);
 				continue;
 			}
 
@@ -1608,7 +1614,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
 						 BRCMF_SDIO_FT_NORMAL)) {
-				up(&bus->sdsem);
+				sdio_release_host(bus->sdiodev->func[1]);
 				if (!bus->rxpending)
 					break;
 				else
@@ -1624,7 +1630,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				rd->len_nxtfrm = 0;
 				/* treat all packet as event if we don't know */
 				rd->channel = SDPCM_EVENT_CHANNEL;
-				up(&bus->sdsem);
+				sdio_release_host(bus->sdiodev->func[1]);
 				continue;
 			}
 			rd->len_left = rd->len > BRCMF_FIRSTREAD ?
@@ -1642,7 +1648,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			bus->sdiodev->bus_if->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
-			up(&bus->sdsem);
+			sdio_release_host(bus->sdiodev->func[1]);
 			continue;
 		}
 		skb_pull(pkt, head_read);
@@ -1651,15 +1657,17 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
 		bus->sdcnt.f2rxdata++;
-		up(&bus->sdsem);
+		sdio_release_host(bus->sdiodev->func[1]);
 
 		if (sdret < 0) {
 			brcmf_dbg(ERROR, "read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, sdret);
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
+			sdio_claim_host(bus->sdiodev->func[1]);
 			brcmf_sdbrcm_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
+			sdio_release_host(bus->sdiodev->func[1]);
 			continue;
 		}
 
@@ -1670,6 +1678,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		} else {
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
+			sdio_claim_host(bus->sdiodev->func[1]);
 			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new,
 						 BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
@@ -1682,9 +1691,11 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
 				brcmf_sdbrcm_rxfail(bus, true, true);
+				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
+			sdio_release_host(bus->sdiodev->func[1]);
 			rd->len_nxtfrm = rd_new.len_nxtfrm;
 			rd->channel = rd_new.channel;
 			rd->dat_offset = rd_new.dat_offset;
@@ -1700,7 +1711,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
+				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdbrcm_rxfail(bus, false, true);
+				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
@@ -1723,7 +1736,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			} else {
 				brcmf_dbg(ERROR, "%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
+				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdbrcm_rxfail(bus, false, false);
+				sdio_release_host(bus->sdiodev->func[1]);
 			}
 			/* prepare the descriptor for the next read */
 			rd->len = rd->len_nxtfrm << 4;
@@ -1879,7 +1894,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 	if (len & (ALIGNMENT - 1))
 			len = roundup(len, ALIGNMENT);
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 				    SDIO_FUNC_2, F2SYNC, pkt);
 	bus->sdcnt.f2txdata++;
@@ -1907,7 +1922,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		}
 
 	}
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 	if (ret == 0)
 		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
@@ -1955,11 +1970,11 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
-			down(&bus->sdsem);
+			sdio_claim_host(bus->sdiodev->func[1]);
 			ret = r_sdreg32(bus, &intstatus,
 					offsetof(struct sdpcmd_regs,
 						 intstatus));
-			up(&bus->sdsem);
+			sdio_release_host(bus->sdiodev->func[1]);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
 				break;
@@ -1996,7 +2011,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 		bus->watchdog_tsk = NULL;
 	}
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Enable clock for device interrupts */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -2030,7 +2045,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 
 	/* Turn off the backplane clock (only) */
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
@@ -2132,7 +2147,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* If waiting for HTAVAIL, check status */
 	if (bus->clkstate == CLK_PENDING) {
@@ -2186,9 +2201,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	/* Pending interrupt indicates new device status */
 	if (atomic_read(&bus->ipend) > 0) {
 		atomic_set(&bus->ipend, 0);
-		sdio_claim_host(bus->sdiodev->func[1]);
 		err = brcmf_sdio_intr_rstatus(bus);
-		sdio_release_host(bus->sdiodev->func[1]);
 	}
 
 	/* Start with leftover status bits */
@@ -2217,7 +2230,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		intstatus |= brcmf_sdbrcm_hostmail(bus);
 	}
 
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
@@ -2265,7 +2278,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		(bus->clkstate == CLK_AVAIL)) {
 		int i;
 
-		down(&bus->sdsem);
+		sdio_claim_host(bus->sdiodev->func[1]);
 		err = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
 			SDIO_FUNC_2, F2SYNC, bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len);
@@ -2299,7 +2312,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		} else {
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 		}
-		up(&bus->sdsem);
+		sdio_release_host(bus->sdiodev->func[1]);
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -2329,7 +2342,9 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	if ((bus->clkstate != CLK_PENDING)
 	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
 		bus->activity = false;
+		sdio_claim_host(bus->sdiodev->func[1]);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		sdio_release_host(bus->sdiodev->func[1]);
 	}
 }
 
@@ -2622,9 +2637,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
 	/* Make sure backplane clock is on */
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	*(__le16 *) frame = cpu_to_le16((u16) msglen);
@@ -2666,9 +2681,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 				   frame, min_t(u16, len, 16), "TxHdr:\n");
 
 		do {
-			down(&bus->sdsem);
+			sdio_claim_host(bus->sdiodev->func[1]);
 			ret = brcmf_tx_frame(bus, frame, len);
-			up(&bus->sdsem);
+			sdio_release_host(bus->sdiodev->func[1]);
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
@@ -2678,9 +2693,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 
 		bus->activity = false;
-		down(&bus->sdsem);
+		sdio_claim_host(bus->sdiodev->func[1]);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-		up(&bus->sdsem);
+		sdio_release_host(bus->sdiodev->func[1]);
 	} else {
 		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
@@ -2714,10 +2729,10 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * Read last word in socram to determine
 	 * address of sdpcm_shared structure
 	 */
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
 				   (u8 *)&addr_le, 4);
-	up(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	if (rv < 0)
 		return rv;
 
@@ -2736,8 +2751,10 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	}
 
 	/* Read hndrte_shared structure */
+	sdio_claim_host(bus->sdiodev->func[1]);
 	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&sh_le,
 				   sizeof(struct sdpcm_shared_le));
+	sdio_release_host(bus->sdiodev->func[1]);
 	if (rv < 0)
 		return rv;
 
@@ -2840,14 +2857,14 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 	if ((sh->flags & SDPCM_SHARED_TRAP) == 0)
 		return 0;
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
 				      sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
 	nbytes = brcmf_sdio_dump_console(bus, sh, data, count);
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 	if (nbytes < 0)
 		return nbytes;
 
@@ -2893,7 +2910,7 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 		return 0;
 	}
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 	if (sh->assert_file_addr != 0) {
 		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_file_addr,
 					      (u8 *)file, 80);
@@ -2906,7 +2923,7 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 		if (error < 0)
 			return error;
 	}
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	res = scnprintf(buf, sizeof(buf),
 			"dongle assert: %s:%d: assert(%s)\n",
@@ -3366,13 +3383,16 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 {
 	bool ret;
 
-	/* Download the firmware */
+	sdio_claim_host(bus->sdiodev->func[1]);
+
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	ret = _brcmf_sdbrcm_download_firmware(bus) == 0;
 
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
+	sdio_release_host(bus->sdiodev->func[1]);
+
 	return ret;
 }
 
@@ -3401,7 +3421,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
-	down(&bus->sdsem);
+	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3470,7 +3490,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
-	up(&bus->sdsem);
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	return ret;
 }
@@ -3533,9 +3553,11 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				u8 devpend;
 				spin_unlock_irqrestore(&bus->dpc_tl_lock,
 						       flags);
+				sdio_claim_host(bus->sdiodev->func[1]);
 				devpend = brcmf_sdio_regrb(bus->sdiodev,
 							   SDIO_CCCR_INTx,
 							   NULL);
+				sdio_release_host(bus->sdiodev->func[1]);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
 					       INTR_STATUS_FUNC2);
@@ -3565,13 +3587,13 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
-			down(&bus->sdsem);
+			sdio_claim_host(bus->sdiodev->func[1]);
 			/* Make sure backplane clock is on */
 			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 			if (brcmf_sdbrcm_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
-			up(&bus->sdsem);
+			sdio_release_host(bus->sdiodev->func[1]);
 		}
 	}
 #endif				/* DEBUG */
@@ -3584,9 +3606,9 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->activity = false;
 				brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 			} else {
-				down(&bus->sdsem);
+				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
-				up(&bus->sdsem);
+				sdio_release_host(bus->sdiodev->func[1]);
 			}
 		}
 	}
@@ -3685,6 +3707,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 
 	bus->alp_only = true;
 
+	sdio_claim_host(bus->sdiodev->func[1]);
+
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
 		 brcmf_sdio_regrl(bus->sdiodev, SI_ENUM_BASE, NULL));
 
@@ -3732,6 +3756,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	reg_val = brcmf_sdio_regrl(bus->sdiodev, reg_addr, NULL);
 	brcmf_sdio_regwl(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN, NULL);
 
+	sdio_release_host(bus->sdiodev->func[1]);
+
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
 	/* Locate an appropriately-aligned portion of hdrbuf */
@@ -3747,6 +3773,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	return true;
 
 fail:
+	sdio_release_host(bus->sdiodev->func[1]);
 	return false;
 }
 
@@ -3754,6 +3781,8 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
+	sdio_claim_host(bus->sdiodev->func[1]);
+
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
@@ -3764,6 +3793,8 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	/* Done with backplane-dependent accesses, can drop clock... */
 	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
+	sdio_release_host(bus->sdiodev->func[1]);
+
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
 	bus->idletime = BRCMF_IDLE_INTERVAL;
@@ -3819,8 +3850,10 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->ci) {
+		sdio_claim_host(bus->sdiodev->func[1]);
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		sdio_release_host(bus->sdiodev->func[1]);
 		brcmf_sdio_chip_detach(&bus->ci);
 		if (bus->vars && bus->varsz)
 			kfree(bus->vars);
@@ -3905,9 +3938,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->timer.data = (unsigned long)bus;
 	bus->timer.function = brcmf_sdbrcm_watchdog;
 
-	/* Initialize thread based operation and lock */
-	sema_init(&bus->sdsem, 1);
-
 	/* Initialize watchdog thread */
 	init_completion(&bus->watchdog_wait);
 	bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
-- 
1.7.9.5



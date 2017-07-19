Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59528 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751911AbdGSTNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:13:14 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 33/34] brcmfmac: Remove array of functions
Date: Wed, 19 Jul 2017 20:08:21 +0100
Message-Id: <20170719190822.10857-34-ian@mnementh.co.uk> (sfid-20170719_211319_667749_042C4369)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the array of functions with a pair of pointers to the
 relevant functions.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 115 +++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 164 ++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  15 +-
 3 files changed, 144 insertions(+), 150 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 43a9c28738b3..d9fe2faf2b04 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -118,7 +118,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		ret = request_irq(pdata->oob_irq_nr, brcmf_sdiod_oob_irqhandler,
 				  pdata->oob_irq_flags, "brcmf_oob_intr",
-				  &sdiodev->func[1]->dev);
+				  &sdiodev->func1->dev);
 		if (ret != 0) {
 			brcmf_err("request_irq failed %d\n", ret);
 			return ret;
@@ -132,7 +132,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		}
 		sdiodev->irq_wake = true;
 
-		sdio_claim_host(sdiodev->func[1]);
+		sdio_claim_host(sdiodev->func1);
 
 		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
 			/* assign GPIO to SDIO core */
@@ -156,13 +156,13 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
 			data |= SDIO_SEPINT_ACT_HI;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
-		sdio_release_host(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func1);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
-		sdio_claim_host(sdiodev->func[1]);
-		sdio_claim_irq(sdiodev->func[1], brcmf_sdiod_ib_irqhandler);
-		sdio_claim_irq(sdiodev->func[2], brcmf_sdiod_dummy_irqhandler);
-		sdio_release_host(sdiodev->func[1]);
+		sdio_claim_host(sdiodev->func1);
+		sdio_claim_irq(sdiodev->func1, brcmf_sdiod_ib_irqhandler);
+		sdio_claim_irq(sdiodev->func2, brcmf_sdiod_dummy_irqhandler);
+		sdio_release_host(sdiodev->func1);
 		sdiodev->sd_irq_requested = true;
 	}
 
@@ -180,26 +180,26 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		struct brcmfmac_sdio_pd *pdata;
 
 		pdata = &sdiodev->settings->bus.sdio;
-		sdio_claim_host(sdiodev->func[1]);
+		sdio_claim_host(sdiodev->func1);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
-		sdio_release_host(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func1);
 
 		sdiodev->oob_irq_requested = false;
 		if (sdiodev->irq_wake) {
 			disable_irq_wake(pdata->oob_irq_nr);
 			sdiodev->irq_wake = false;
 		}
-		free_irq(pdata->oob_irq_nr, &sdiodev->func[1]->dev);
+		free_irq(pdata->oob_irq_nr, &sdiodev->func1->dev);
 		sdiodev->irq_en = false;
 		sdiodev->oob_irq_requested = false;
 	}
 
 	if (sdiodev->sd_irq_requested) {
-		sdio_claim_host(sdiodev->func[1]);
-		sdio_release_irq(sdiodev->func[2]);
-		sdio_release_irq(sdiodev->func[1]);
-		sdio_release_host(sdiodev->func[1]);
+		sdio_claim_host(sdiodev->func1);
+		sdio_release_irq(sdiodev->func2);
+		sdio_release_irq(sdiodev->func1);
+		sdio_release_host(sdiodev->func1);
 		sdiodev->sd_irq_requested = false;
 	}
 }
@@ -261,7 +261,7 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
-		data = sdio_readl(sdiodev->func[1], addr, &retval);
+		data = sdio_readl(sdiodev->func1, addr, &retval);
 
 out:
 	if (ret)
@@ -283,7 +283,7 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
-		sdio_writel(sdiodev->func[1], data, addr, &retval);
+		sdio_writel(sdiodev->func1, data, addr, &retval);
 
 out:
 	if (ret)
@@ -541,7 +541,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr, pkt);
 
 done:
 	return err;
@@ -566,13 +566,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr,
+		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
 					 pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[2], addr,
+		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
 					 glom_skb);
 		if (err)
 			goto done;
@@ -582,7 +582,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], false, addr,
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func2, false, addr,
 					    pktq);
 
 done:
@@ -614,7 +614,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
-		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2], addr, mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 
@@ -640,13 +640,13 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[2],
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2,
 						 addr, skb);
 			if (err)
 				break;
 		}
 	else
-		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func[2], true, addr,
+		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func2, true, addr,
 					    pktq);
 
 	return err;
@@ -676,7 +676,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	else
 		dsize = size;
 
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 
 	/* Do the transfer(s) */
 	while (size) {
@@ -696,11 +696,11 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 		if (write) {
 			memcpy(pkt->data, data, dsize);
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func[1],
+			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func1,
 						      sdaddr, pkt);
 		}
 		else {
-			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func[1],
+			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func1,
 						      sdaddr, pkt);
 		}
 
@@ -724,7 +724,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	dev_kfree_skb(pkt);
 
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 
 	return err;
 }
@@ -748,7 +748,7 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	uint nents;
 	int err;
 
-	func = sdiodev->func[2];
+	func = sdiodev->func2;
 	host = func->card->host;
 	sdiodev->sg_support = host->max_segs > 1;
 	max_blocks = min_t(uint, host->max_blk_count, 511u);
@@ -809,17 +809,17 @@ static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_trigger_dpc(sdiodev->bus);
 	wait_event(sdiodev->freezer->thread_freeze,
 		   atomic_read(expect) == sdiodev->freezer->frozen_count);
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 	res = brcmf_sdio_sleep(sdiodev->bus, true);
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 	return res;
 }
 
 static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 {
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 	brcmf_sdio_sleep(sdiodev->bus, false);
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 	atomic_set(&sdiodev->freezer->freezing, 0);
 	complete_all(&sdiodev->freezer->resumed);
 }
@@ -869,19 +869,19 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdiod_freezer_detach(sdiodev);
 
 	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func[2]);
-	sdio_disable_func(sdiodev->func[2]);
-	sdio_release_host(sdiodev->func[2]);
+	sdio_claim_host(sdiodev->func2);
+	sdio_disable_func(sdiodev->func2);
+	sdio_release_host(sdiodev->func2);
 
 	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func[1]);
-	sdio_disable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
+	sdio_disable_func(sdiodev->func1);
+	sdio_release_host(sdiodev->func1);
 
 	sg_free_table(&sdiodev->sgtable);
 	sdiodev->sbwad = 0;
 
-	pm_runtime_allow(sdiodev->func[1]->card->host->parent);
+	pm_runtime_allow(sdiodev->func1->card->host->parent);
 	return 0;
 }
 
@@ -897,29 +897,27 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 
-	sdiodev->num_funcs = 2;
+	sdio_claim_host(sdiodev->func1);
 
-	sdio_claim_host(sdiodev->func[1]);
-
-	ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
+	ret = sdio_set_block_size(sdiodev->func1, SDIO_FUNC1_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F1 blocksize\n");
-		sdio_release_host(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func1);
 		goto out;
 	}
-	ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
+	ret = sdio_set_block_size(sdiodev->func2, SDIO_FUNC2_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F2 blocksize\n");
-		sdio_release_host(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func1);
 		goto out;
 	}
 
 	/* increase F2 timeout */
-	sdiodev->func[2]->enable_timeout = SDIO_WAIT_F2RDY;
+	sdiodev->func2->enable_timeout = SDIO_WAIT_F2RDY;
 
 	/* Enable Function 1 */
-	ret = sdio_enable_func(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
+	ret = sdio_enable_func(sdiodev->func1);
+	sdio_release_host(sdiodev->func1);
 	if (ret) {
 		brcmf_err("Failed to enable F1: err=%d\n", ret);
 		goto out;
@@ -935,7 +933,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-	brcmf_sdiod_host_fixup(sdiodev->func[2]->card->host);
+	brcmf_sdiod_host_fixup(sdiodev->func2->card->host);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
@@ -1022,16 +1020,15 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	/* store refs to functions used. mmc_card does
 	 * not hold the F0 function pointer.
 	 */
-	sdiodev->func[0] = NULL;
-	sdiodev->func[1] = func->card->sdio_func[0];
-	sdiodev->func[2] = func;
+	sdiodev->func1 = func->card->sdio_func[0];
+	sdiodev->func2 = func;
 
 	sdiodev->bus_if = bus_if;
 	bus_if->bus_priv.sdio = sdiodev;
 	bus_if->proto_type = BRCMF_PROTO_BCDC;
 	dev_set_drvdata(&func->dev, bus_if);
-	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
-	sdiodev->dev = &sdiodev->func[1]->dev;
+	dev_set_drvdata(&sdiodev->func1->dev, bus_if);
+	sdiodev->dev = &sdiodev->func1->dev;
 
 	brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DOWN);
 
@@ -1047,7 +1044,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 fail:
 	dev_set_drvdata(&func->dev, NULL);
-	dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
+	dev_set_drvdata(&sdiodev->func1->dev, NULL);
 	kfree(sdiodev);
 	kfree(bus_if);
 	return err;
@@ -1076,8 +1073,8 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		/* only proceed with rest of cleanup if func 1 */
 		brcmf_sdiod_remove(sdiodev);
 
-		dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
-		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
+		dev_set_drvdata(&sdiodev->func1->dev, NULL);
+		dev_set_drvdata(&sdiodev->func2->dev, NULL);
 
 		kfree(bus_if);
 		kfree(sdiodev);
@@ -1122,7 +1119,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 		else
 			sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
 	}
-	if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
+	if (sdio_set_host_pm_flags(sdiodev->func1, sdio_flags))
 		brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
 	return 0;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c94625b6549f..5f90f747e76a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -972,7 +972,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/*
@@ -1006,7 +1006,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	if (rv < 0)
 		goto fail;
 
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 	/* Endianness */
 	sh->flags = le32_to_cpu(sh_le.flags);
@@ -1028,7 +1028,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 fail:
 	brcmf_err("unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
 		  rv, addr);
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 	return rv;
 }
 
@@ -1144,7 +1144,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		  rtx ? ", send NAK" : "");
 
 	if (abort)
-		brcmf_sdiod_abort(bus->sdiodev, bus->sdiodev->func[2]);
+		brcmf_sdiod_abort(bus->sdiodev, bus->sdiodev->func2);
 
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
@@ -1193,7 +1193,7 @@ static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 	brcmf_err("sdio error, abort command and terminate frame\n");
 	bus->sdcnt.tx_sderrs++;
 
-	brcmf_sdiod_abort(sdiodev, sdiodev->func[2]);
+	brcmf_sdiod_abort(sdiodev, sdiodev->func2);
 	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
@@ -1549,10 +1549,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
-		sdio_claim_host(bus->sdiodev->func[1]);
+		sdio_claim_host(bus->sdiodev->func1);
 		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
 						 &bus->glom, dlen);
-		sdio_release_host(bus->sdiodev->func[1]);
+		sdio_release_host(bus->sdiodev->func1);
 		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe */
@@ -1560,11 +1560,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			return 0;
 		}
 
@@ -1574,10 +1574,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
-		sdio_claim_host(bus->sdiodev->func[1]);
+		sdio_claim_host(bus->sdiodev->func1);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
-		sdio_release_host(bus->sdiodev->func[1]);
+		sdio_release_host(bus->sdiodev->func1);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */
@@ -1593,10 +1593,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
 						     BRCMF_SDIO_FT_SUB);
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
 
@@ -1605,11 +1605,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		if (errcode) {
 			/* Terminate frame on error */
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			bus->cur_read.len = 0;
 			return 0;
 		}
@@ -1817,7 +1817,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		rd->len_left = rd->len;
 		/* read header first for unknow frame length */
-		sdio_claim_host(bus->sdiodev->func[1]);
+		sdio_claim_host(bus->sdiodev->func1);
 		if (!rd->len) {
 			ret = brcmf_sdiod_recv_buf(bus->sdiodev,
 						   bus->rxhdr, BRCMF_FIRSTREAD);
@@ -1827,7 +1827,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  ret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdio_rxfail(bus, true, true);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				continue;
 			}
 
@@ -1837,7 +1837,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, rd,
 					       BRCMF_SDIO_FT_NORMAL)) {
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				if (!bus->rxpending)
 					break;
 				else
@@ -1853,7 +1853,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				rd->len_nxtfrm = 0;
 				/* treat all packet as event if we don't know */
 				rd->channel = SDPCM_EVENT_CHANNEL;
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				continue;
 			}
 			rd->len_left = rd->len > BRCMF_FIRSTREAD ?
@@ -1870,7 +1870,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
 			brcmf_sdio_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			continue;
 		}
 		skb_pull(pkt, head_read);
@@ -1878,16 +1878,16 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		ret = brcmf_sdiod_recv_pkt(bus->sdiodev, pkt);
 		bus->sdcnt.f2rxdata++;
-		sdio_release_host(bus->sdiodev->func[1]);
+		sdio_release_host(bus->sdiodev->func1);
 
 		if (ret < 0) {
 			brcmf_err("read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			brcmf_sdio_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			continue;
 		}
 
@@ -1898,7 +1898,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		} else {
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
@@ -1911,11 +1911,11 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
 				brcmf_sdio_rxfail(bus, true, true);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			rd->len_nxtfrm = rd_new.len_nxtfrm;
 			rd->channel = rd_new.channel;
 			rd->dat_offset = rd_new.dat_offset;
@@ -1931,9 +1931,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
-				sdio_claim_host(bus->sdiodev->func[1]);
+				sdio_claim_host(bus->sdiodev->func1);
 				brcmf_sdio_rxfail(bus, false, true);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
@@ -1956,9 +1956,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			} else {
 				brcmf_err("%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
-				sdio_claim_host(bus->sdiodev->func[1]);
+				sdio_claim_host(bus->sdiodev->func1);
 				brcmf_sdio_rxfail(bus, false, false);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 			}
 			/* prepare the descriptor for the next read */
 			rd->len = rd->len_nxtfrm << 4;
@@ -2055,7 +2055,7 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 	int ntail, ret;
 
 	sdiodev = bus->sdiodev;
-	blksize = sdiodev->func[2]->cur_blksize;
+	blksize = sdiodev->func2->cur_blksize;
 	/* sg entry alignment should be a divisor of block size */
 	WARN_ON(blksize % bus->sgentry_align);
 
@@ -2234,14 +2234,14 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	if (ret)
 		goto done;
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0)
 		brcmf_sdio_txfail(bus);
 
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 done:
 	brcmf_sdio_txpkt_postp(bus, pktq);
@@ -2297,10 +2297,10 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			intstatus = brcmf_sdiod_readl(bus->sdiodev, core->base +
 							__sd_reg(intstatus), &ret);
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
 				break;
@@ -2400,7 +2400,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	}
 
 	if (sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-		sdio_claim_host(sdiodev->func[1]);
+		sdio_claim_host(sdiodev->func1);
 
 		/* Enable clock for device interrupts */
 		brcmf_sdio_bus_sleep(bus, false, false);
@@ -2423,13 +2423,13 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 
 		/* Turn off the bus (F2), free any pending packets */
 		brcmf_dbg(INTR, "disable SDIO interrupts\n");
-		sdio_disable_func(sdiodev->func[2]);
+		sdio_disable_func(sdiodev->func2);
 
 		/* Clear any pending interrupts now that F2 is disabled */
 		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus),
 					local_hostintmask, NULL);
 
-		sdio_release_host(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func1);
 	}
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
@@ -2501,7 +2501,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 
 	/* If waiting for HTAVAIL, check status */
 	if (!bus->sr_enabled && bus->clkstate == CLK_PENDING) {
@@ -2564,7 +2564,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		intstatus |= brcmf_sdio_hostmail(bus);
 	}
 
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
@@ -2607,7 +2607,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
 	    data_ok(bus)) {
-		sdio_claim_host(bus->sdiodev->func[1]);
+		sdio_claim_host(bus->sdiodev->func1);
 		if (bus->ctrl_frame_stat) {
 			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
 						      bus->ctrl_frame_len);
@@ -2615,7 +2615,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 			wmb();
 			bus->ctrl_frame_stat = false;
 		}
-		sdio_release_host(bus->sdiodev->func[1]);
+		sdio_release_host(bus->sdiodev->func1);
 		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
@@ -2631,14 +2631,14 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			if (bus->ctrl_frame_stat) {
 				bus->ctrl_frame_err = -ENODEV;
 				wmb();
 				bus->ctrl_frame_stat = false;
 				brcmf_sdio_wait_event_wakeup(bus);
 			}
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 		}
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
@@ -2853,13 +2853,13 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 					 CTL_DONE_TIMEOUT);
 	ret = 0;
 	if (bus->ctrl_frame_stat) {
-		sdio_claim_host(bus->sdiodev->func[1]);
+		sdio_claim_host(bus->sdiodev->func1);
 		if (bus->ctrl_frame_stat) {
 			brcmf_dbg(SDIO, "ctrl_frame timeout\n");
 			bus->ctrl_frame_stat = false;
 			ret = -ETIMEDOUT;
 		}
-		sdio_release_host(bus->sdiodev->func[1]);
+		sdio_release_host(bus->sdiodev->func1);
 	}
 	if (!ret) {
 		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
@@ -2983,7 +2983,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		return 0;
 	}
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 	if (sh->assert_file_addr != 0) {
 		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
 					  sh->assert_file_addr, (u8 *)file, 80);
@@ -2996,7 +2996,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		if (error < 0)
 			return error;
 	}
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 	seq_printf(seq, "dongle assert: %s:%d: assert(%s)\n",
 		   file, sh->assert_line, expr);
@@ -3270,7 +3270,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	int bcmerror;
 	u32 rstvec;
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	rstvec = get_unaligned_le32(fw->data);
@@ -3299,7 +3299,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 
 err:
 	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 	return bcmerror;
 }
 
@@ -3413,7 +3413,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (sdiodev->sg_support) {
 		bus->txglom = false;
 		value = 1;
-		pad_size = bus->sdiodev->func[2]->cur_blksize << 1;
+		pad_size = bus->sdiodev->func2->cur_blksize << 1;
 		err = brcmf_iovar_data_set(bus->sdiodev->dev, "bus:rxglom",
 					   &value, sizeof(u32));
 		if (err < 0) {
@@ -3455,7 +3455,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 
 	address = bus->ci->rambase;
 	offset = err = 0;
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 	while (offset < mem_size) {
 		len = ((offset + MEMBLOCK) < mem_size) ? MEMBLOCK :
 		      mem_size - offset;
@@ -3471,7 +3471,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 	}
 
 done:
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 	return err;
 }
 
@@ -3528,11 +3528,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (!bus->dpc_triggered) {
 				u8 devpend;
 
-				sdio_claim_host(bus->sdiodev->func[1]);
+				sdio_claim_host(bus->sdiodev->func1);
 				devpend = brcmf_sdiod_func0_rb(bus->sdiodev,
 							    SDIO_CCCR_INTx,
 							    NULL);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 				intstatus = devpend & (INTR_STATUS_FUNC1 |
 						       INTR_STATUS_FUNC2);
 			}
@@ -3558,13 +3558,13 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 		bus->console.count += jiffies_to_msecs(BRCMF_WD_POLL);
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
-			sdio_claim_host(bus->sdiodev->func[1]);
+			sdio_claim_host(bus->sdiodev->func1);
 			/* Make sure backplane clock is on */
 			brcmf_sdio_bus_sleep(bus, false, false);
 			if (brcmf_sdio_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
-			sdio_release_host(bus->sdiodev->func[1]);
+			sdio_release_host(bus->sdiodev->func1);
 		}
 	}
 #endif				/* DEBUG */
@@ -3577,11 +3577,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			bus->idlecount++;
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
-				sdio_claim_host(bus->sdiodev->func[1]);
+				sdio_claim_host(bus->sdiodev->func1);
 				brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 			}
 		} else {
 			bus->idlecount = 0;
@@ -3751,8 +3751,8 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	/* Force 4339 chips over rev2 to use the same ID */
 	/* This is borderline tolerable whilst there is only two exceptions */
 	/* But could be handled better */
-	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-		sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
+	if ((sdiodev->func1->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
+		sdiodev->func1->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
 		addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
@@ -3792,7 +3792,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	u32 drivestrength;
 
 	sdiodev = bus->sdiodev;
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 
 	/*
 	 * Force PLL off until brcmf_chip_attach()
@@ -3854,8 +3854,8 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	/* wowl can be supported when KEEP_POWER is true and (WAKE_SDIO_IRQ
 	 * is true or when platform data OOB irq is true).
 	 */
-	if ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_KEEP_POWER) &&
-	    ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_WAKE_SDIO_IRQ) ||
+	if ((sdio_get_host_pm_caps(sdiodev->func1) & MMC_PM_KEEP_POWER) &&
+	    ((sdio_get_host_pm_caps(sdiodev->func1) & MMC_PM_WAKE_SDIO_IRQ) ||
 	     (sdiodev->settings->bus.sdio.oob_irq_supported)))
 		sdiodev->bus_if->wowl_supported = true;
 #endif
@@ -3894,7 +3894,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	if (err)
 		goto fail;
 
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
@@ -3915,7 +3915,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	return true;
 
 fail:
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 	return false;
 }
 
@@ -4002,7 +4002,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdio_wd_timer(bus, true);
 
-	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_host(sdiodev->func1);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
@@ -4024,7 +4024,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailboxdata),
 				SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT, NULL);
 
-	err = sdio_enable_func(sdiodev->func[2]);
+	err = sdio_enable_func(sdiodev->func2);
 
 
 	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
@@ -4040,7 +4040,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
-		sdio_disable_func(sdiodev->func[2]);
+		sdio_disable_func(sdiodev->func2);
 		goto release;
 	}
 
@@ -4064,7 +4064,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (err != 0)
 		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 
 	err = brcmf_bus_started(dev);
 	if (err != 0) {
@@ -4074,11 +4074,11 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	return;
 
 release:
-	sdio_release_host(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func1);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
 	device_release_driver(dev);
-	device_release_driver(&sdiodev->func[2]->dev);
+	device_release_driver(&sdiodev->func2->dev);
 }
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
@@ -4104,7 +4104,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	/* single-threaded workqueue */
 	wq = alloc_ordered_workqueue("brcmf_wq/%s", WQ_MEM_RECLAIM,
-				     dev_name(&sdiodev->func[1]->dev));
+				     dev_name(&sdiodev->func1->dev));
 	if (!wq) {
 		brcmf_err("insufficient memory to create txworkqueue\n");
 		goto fail;
@@ -4133,7 +4133,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	init_completion(&bus->watchdog_wait);
 	bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
 					bus, "brcmf_wdog/%s",
-					dev_name(&sdiodev->func[1]->dev));
+					dev_name(&sdiodev->func1->dev));
 	if (IS_ERR(bus->watchdog_tsk)) {
 		pr_warn("brcmf_watchdog thread failed to start\n");
 		bus->watchdog_tsk = NULL;
@@ -4164,7 +4164,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdiod_sgtable_alloc(bus->sdiodev);
 
 	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
+	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
 	/* Allocate buffers */
@@ -4180,17 +4180,17 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		}
 	}
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	sdio_disable_func(bus->sdiodev->func[2]);
+	sdio_disable_func(bus->sdiodev->func2);
 
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
@@ -4242,7 +4242,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 
 		if (bus->ci) {
 			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-				sdio_claim_host(bus->sdiodev->func[1]);
+				sdio_claim_host(bus->sdiodev->func1);
 				brcmf_sdio_wd_timer(bus, false);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4252,7 +4252,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 				msleep(20);
 				brcmf_chip_set_passive(bus->ci);
 				brcmf_sdio_clkctl(bus, CLK_NONE, false);
-				sdio_release_host(bus->sdiodev->func[1]);
+				sdio_release_host(bus->sdiodev->func1);
 			}
 			brcmf_chip_detach(bus->ci);
 		}
@@ -4299,9 +4299,9 @@ int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
 {
 	int ret;
 
-	sdio_claim_host(bus->sdiodev->func[1]);
+	sdio_claim_host(bus->sdiodev->func1);
 	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
-	sdio_release_host(bus->sdiodev->func[1]);
+	sdio_release_host(bus->sdiodev->func1);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index bc9e9bcf40e2..cb93289caf8c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -21,9 +21,6 @@
 #include <linux/firmware.h>
 #include "firmware.h"
 
-/* Maximum number of I/O funcs */
-#define NUM_SDIO_FUNCS	3
-
 #define SDIOD_FBR_SIZE		0x100
 
 /* io_en */
@@ -173,8 +170,8 @@ struct brcmf_sdio;
 struct brcmf_sdiod_freezer;
 
 struct brcmf_sdio_dev {
-	struct sdio_func *func[NUM_SDIO_FUNCS];
-	u8 num_funcs;			/* Supported funcs on client */
+	struct sdio_func *func1;
+	struct sdio_func *func2;
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_core *cc_core;	/* chipcommon core info struct */
 	struct brcmf_sdio *bus;
@@ -295,17 +292,17 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 /* SDIO device register access interface */
 /* Functions for accessing SDIO Function 0 */
 #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
-	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
+	sdio_f0_readb((sdiodev)->func1, (addr), (r))
 
 #define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
-	sdio_f0_writeb((sdiodev)->func[1], (v), (addr), (ret))
+	sdio_f0_writeb((sdiodev)->func1, (v), (addr), (ret))
 
 /* Functions for accessing SDIO Function 1 */
 #define brcmf_sdiod_readb(sdiodev, addr, r) \
-	sdio_readb((sdiodev)->func[1], (addr), (r))
+	sdio_readb((sdiodev)->func1, (addr), (r))
 
 #define brcmf_sdiod_writeb(sdiodev, addr, v, ret) \
-	sdio_writeb((sdiodev)->func[1], (v), (addr), (ret))
+	sdio_writeb((sdiodev)->func1, (v), (addr), (ret))
 
 u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
 void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data, int *ret);
-- 
2.11.0

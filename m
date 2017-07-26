Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:47372 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbdGZUoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:44:13 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 34/34] brcmfmac: Reduce the noise from repeatedly dereferencing common pointers
Date: Wed, 26 Jul 2017 21:25:57 +0100
Message-Id: <20170726202557.15632-35-ian@mnementh.co.uk> (sfid-20170726_224417_644155_A391FCA3)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces no functional changes, but makes the code drastically more
readable, reducing the amount of dereferencing performed inside functions
throughout the SDIO core.

For example, reduce:
	sdio_release_host(bus->sdiodev->func1);
to:
	sdio_release_host(func1);

Fixup a few inconsistently named pointers whilst we are at it ie.

sdiod -> sdiodev

Signed-off-by: Ian Molton <ian@mnementh.co.uk>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 140 +++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 409 +++++++++++----------
 2 files changed, 294 insertions(+), 255 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 8cfd2cbb1dfa..c2f821b28fee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -105,6 +105,8 @@ static void brcmf_sdiod_dummy_irqhandler(struct sdio_func *func)
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	struct brcmfmac_sdio_pd *pdata;
+	struct sdio_func *func1 = sdiodev->func1;
+	struct sdio_func *func2 = sdiodev->func2;
 	int ret = 0;
 	u8 data;
 	u32 addr, gpiocontrol;
@@ -118,7 +120,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		ret = request_irq(pdata->oob_irq_nr, brcmf_sdiod_oob_irqhandler,
 				  pdata->oob_irq_flags, "brcmf_oob_intr",
-				  &sdiodev->func1->dev);
+				  &func1->dev);
 		if (ret != 0) {
 			brcmf_err("request_irq failed %d\n", ret);
 			return ret;
@@ -132,7 +134,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		}
 		sdiodev->irq_wake = true;
 
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host(func1);
 
 		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
 			/* assign GPIO to SDIO core */
@@ -157,13 +159,13 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
 			data |= SDIO_SEPINT_ACT_HI;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
-		sdio_release_host(sdiodev->func1);
+		sdio_release_host(func1);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
-		sdio_claim_host(sdiodev->func1);
-		sdio_claim_irq(sdiodev->func1, brcmf_sdiod_ib_irqhandler);
-		sdio_claim_irq(sdiodev->func2, brcmf_sdiod_dummy_irqhandler);
-		sdio_release_host(sdiodev->func1);
+		sdio_claim_host(func1);
+		sdio_claim_irq(func1, brcmf_sdiod_ib_irqhandler);
+		sdio_claim_irq(func2, brcmf_sdiod_dummy_irqhandler);
+		sdio_release_host(func1);
 		sdiodev->sd_irq_requested = true;
 	}
 
@@ -172,6 +174,8 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
+	struct sdio_func *func1 = sdiodev->func1;
+	struct sdio_func *func2 = sdiodev->func2;
 
 	brcmf_dbg(SDIO, "Entering oob=%d sd=%d\n",
 		  sdiodev->oob_irq_requested,
@@ -181,26 +185,26 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		struct brcmfmac_sdio_pd *pdata;
 
 		pdata = &sdiodev->settings->bus.sdio;
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host(func1);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
-		sdio_release_host(sdiodev->func1);
+		sdio_release_host(func1);
 
 		sdiodev->oob_irq_requested = false;
 		if (sdiodev->irq_wake) {
 			disable_irq_wake(pdata->oob_irq_nr);
 			sdiodev->irq_wake = false;
 		}
-		free_irq(pdata->oob_irq_nr, &sdiodev->func1->dev);
+		free_irq(pdata->oob_irq_nr, &func1->dev);
 		sdiodev->irq_en = false;
 		sdiodev->oob_irq_requested = false;
 	}
 
 	if (sdiodev->sd_irq_requested) {
-		sdio_claim_host(sdiodev->func1);
-		sdio_release_irq(sdiodev->func2);
-		sdio_release_irq(sdiodev->func1);
-		sdio_release_host(sdiodev->func1);
+		sdio_claim_host(func1);
+		sdio_release_irq(func2);
+		sdio_release_irq(func1);
+		sdio_release_host(func1);
 		sdiodev->sd_irq_requested = false;
 	}
 }
@@ -252,6 +256,7 @@ brcmf_sdiod_set_backplane_window(struct brcmf_sdio_dev *sdiodev, u32 addr)
 
 u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
+	struct sdio_func *func1 = sdiodev->func1;
 	u32 data = 0;
 	int retval;
 
@@ -263,7 +268,7 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
-		data = sdio_readl(sdiodev->func1, addr, &retval);
+		data = sdio_readl(func1, addr, &retval);
 
 out:
 	if (ret)
@@ -275,6 +280,7 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			u32 data, int *ret)
 {
+	struct sdio_func *func1 = sdiodev->func1;
 	int retval;
 
 	retval = brcmf_sdiod_set_backplane_window(sdiodev, addr);
@@ -285,7 +291,7 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
-		sdio_writel(sdiodev->func1, data, addr, &retval);
+		sdio_writel(func1, data, addr, &retval);
 
 out:
 	if (ret)
@@ -536,6 +542,7 @@ int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
+	struct sdio_func *func2 = sdiodev->func2;
 	u32 addr = sdiodev->cc_core->base;
 	int err = 0;
 
@@ -548,7 +555,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, func2, addr, pkt);
 
 done:
 	return err;
@@ -557,6 +564,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			   struct sk_buff_head *pktq, uint totlen)
 {
+	struct sdio_func *func2 = sdiodev->func2;
 	struct sk_buff *glom_skb = NULL;
 	struct sk_buff *skb;
 	u32 addr = sdiodev->cc_core->base;
@@ -573,14 +581,12 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
-					    pktq->next);
+		err = brcmf_sdiod_buff_read(sdiodev, func2, addr, pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
-					    glom_skb);
+		err = brcmf_sdiod_buff_read(sdiodev, func2, addr, glom_skb);
 		if (err)
 			goto done;
 
@@ -589,8 +595,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			skb_pull(glom_skb, skb->len);
 		}
 	} else
-		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func2, false,
-					    addr, pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, func2, false, addr, pktq);
 
 done:
 	brcmu_pkt_buf_free_skb(glom_skb);
@@ -600,6 +605,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
+	struct sdio_func *func2 = sdiodev->func2;
 	u32 addr = sdiodev->cc_core->base;
 	int err;
 
@@ -621,8 +627,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
-		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2, addr,
-					     mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, func2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 
@@ -634,6 +639,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
+	struct sdio_func *func2 = sdiodev->func2;
 	u32 addr = sdiodev->cc_core->base;
 	int err;
 
@@ -648,14 +654,12 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2,
-						     addr, skb);
+			err = brcmf_sdiod_buff_write(sdiodev, func2, addr, skb);
 			if (err)
 				break;
 		}
 	else
-		err = brcmf_sdiod_sglist_rw(sdiodev, sdiodev->func2, true, addr,
-					    pktq);
+		err = brcmf_sdiod_sglist_rw(sdiodev, func2, true, addr, pktq);
 
 	return err;
 }
@@ -664,6 +668,7 @@ int
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
+	struct sdio_func *func1 = sdiodev->func1;
 	int err = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
@@ -684,7 +689,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	else
 		dsize = size;
 
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host(func1);
 
 	/* Do the transfer(s) */
 	while (size) {
@@ -704,11 +709,9 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 		if (write) {
 			memcpy(pkt->data, data, dsize);
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func1,
-						     sdaddr, pkt);
+			err = brcmf_sdiod_buff_write(sdiodev, func1, sdaddr, pkt);
 		} else {
-			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func1,
-						    sdaddr, pkt);
+			err = brcmf_sdiod_buff_read(sdiodev, func1, sdaddr, pkt);
 		}
 
 		if (err) {
@@ -731,7 +734,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	dev_kfree_skb(pkt);
 
-	sdio_release_host(sdiodev->func1);
+	sdio_release_host(func1);
 
 	return err;
 }
@@ -749,18 +752,16 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, struct sdio_func *func)
 
 void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdio_func *func;
-	struct mmc_host *host;
+	struct sdio_func *func2 = sdiodev->func2;
+	struct mmc_host *host = func2->card->host;
 	uint max_blocks;
 	uint nents;
 	int err;
 
-	func = sdiodev->func2;
-	host = func->card->host;
 	sdiodev->sg_support = host->max_segs > 1;
 	max_blocks = min_t(uint, host->max_blk_count, 511u);
 	sdiodev->max_request_size = min_t(uint, host->max_req_size,
-					  max_blocks * func->cur_blksize);
+					  max_blocks * func2->cur_blksize);
 	sdiodev->max_segment_count = min_t(uint, host->max_segs,
 					   SG_MAX_SINGLE_ALLOC);
 	sdiodev->max_segment_size = host->max_seg_size;
@@ -807,6 +808,7 @@ static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
 
 static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 {
+	struct sdio_func *func1 = sdiodev->func1;
 	atomic_t *expect = &sdiodev->freezer->thread_count;
 	int res = 0;
 
@@ -816,17 +818,19 @@ static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_trigger_dpc(sdiodev->bus);
 	wait_event(sdiodev->freezer->thread_freeze,
 		   atomic_read(expect) == sdiodev->freezer->frozen_count);
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host(func1);
 	res = brcmf_sdio_sleep(sdiodev->bus, true);
-	sdio_release_host(sdiodev->func1);
+	sdio_release_host(func1);
 	return res;
 }
 
 static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 {
-	sdio_claim_host(sdiodev->func1);
+	struct sdio_func *func1 = sdiodev->func1;
+
+	sdio_claim_host(func1);
 	brcmf_sdio_sleep(sdiodev->bus, false);
-	sdio_release_host(sdiodev->func1);
+	sdio_release_host(func1);
 	atomic_set(&sdiodev->freezer->freezing, 0);
 	complete_all(&sdiodev->freezer->resumed);
 }
@@ -867,6 +871,9 @@ static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
 
 static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
+	struct sdio_func *func1 = sdiodev->func1;
+	struct sdio_func *func2 = sdiodev->func2;
+
 	sdiodev->state = BRCMF_SDIOD_DOWN;
 	if (sdiodev->bus) {
 		brcmf_sdio_remove(sdiodev->bus);
@@ -876,19 +883,19 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdiod_freezer_detach(sdiodev);
 
 	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func2);
-	sdio_disable_func(sdiodev->func2);
-	sdio_release_host(sdiodev->func2);
+	sdio_claim_host(func2);
+	sdio_disable_func(func2);
+	sdio_release_host(func2);
 
 	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func1);
-	sdio_disable_func(sdiodev->func1);
-	sdio_release_host(sdiodev->func1);
+	sdio_claim_host(func1);
+	sdio_disable_func(func1);
+	sdio_release_host(func1);
 
 	sg_free_table(&sdiodev->sgtable);
 	sdiodev->sbwad = 0;
 
-	pm_runtime_allow(sdiodev->func1->card->host->parent);
+	pm_runtime_allow(func1->card->host->parent);
 	return 0;
 }
 
@@ -902,29 +909,32 @@ static void brcmf_sdiod_host_fixup(struct mmc_host *host)
 
 static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
+	struct sdio_func *func1 = sdiodev->func1;
+	struct sdio_func *func2 = sdiodev->func2;
+
 	int ret = 0;
 
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host(func1);
 
-	ret = sdio_set_block_size(sdiodev->func1, SDIO_FUNC1_BLOCKSIZE);
+	ret = sdio_set_block_size(func1, SDIO_FUNC1_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F1 blocksize\n");
-		sdio_release_host(sdiodev->func1);
+		sdio_release_host(func1);
 		goto out;
 	}
-	ret = sdio_set_block_size(sdiodev->func2, SDIO_FUNC2_BLOCKSIZE);
+	ret = sdio_set_block_size(func2, SDIO_FUNC2_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F2 blocksize\n");
-		sdio_release_host(sdiodev->func1);
+		sdio_release_host(func1);
 		goto out;
 	}
 
 	/* increase F2 timeout */
-	sdiodev->func2->enable_timeout = SDIO_WAIT_F2RDY;
+	func2->enable_timeout = SDIO_WAIT_F2RDY;
 
 	/* Enable Function 1 */
-	ret = sdio_enable_func(sdiodev->func1);
-	sdio_release_host(sdiodev->func1);
+	ret = sdio_enable_func(func1);
+	sdio_release_host(func1);
 	if (ret) {
 		brcmf_err("Failed to enable F1: err=%d\n", ret);
 		goto out;
@@ -940,7 +950,8 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-	brcmf_sdiod_host_fixup(sdiodev->func2->card->host);
+
+	brcmf_sdiod_host_fixup(func2->card->host);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
@@ -1060,7 +1071,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
 	struct brcmf_bus *bus_if;
-	struct brcmf_sdio_dev *sdiodev;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "sdio vendor ID: 0x%04x\n", func->vendor);
@@ -1069,7 +1079,9 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 
 	bus_if = dev_get_drvdata(&func->dev);
 	if (bus_if) {
-		sdiodev = bus_if->bus_priv.sdio;
+		struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+		struct sdio_func *func1 = sdiodev->func1;
+		struct sdio_func *func2 = sdiodev->func2;
 
 		/* start by unregistering irqs */
 		brcmf_sdiod_intr_unregister(sdiodev);
@@ -1080,8 +1092,8 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		/* only proceed with rest of cleanup if func 1 */
 		brcmf_sdiod_remove(sdiodev);
 
-		dev_set_drvdata(&sdiodev->func1->dev, NULL);
-		dev_set_drvdata(&sdiodev->func2->dev, NULL);
+		dev_set_drvdata(&func1->dev, NULL);
+		dev_set_drvdata(&func2->dev, NULL);
 
 		kfree(bus_if);
 		kfree(sdiodev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 618d9ea4fc05..a38b7985f0a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -662,6 +662,7 @@ static bool data_ok(struct brcmf_sdio *bus)
 static int
 brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	u8 wr_val = 0, rd_val, cmp_val, bmask;
 	int err = 0;
 	int err_cnt = 0;
@@ -671,7 +672,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
-	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
 
 	if (on) {
 		/* device WAKEUP through KSO:
@@ -697,8 +698,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		 * just one write attempt may fail,
 		 * read it back until it matches written value
 		 */
-		rd_val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-					   &err);
+		rd_val = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 		if (!err) {
 			if ((rd_val & bmask) == cmp_val)
 				break;
@@ -709,9 +709,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 			break;
 
 		udelay(KSO_WAIT_US);
-		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val,
-				   &err);
-
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
 
 	if (try_cnt > 2)
@@ -729,6 +727,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 /* Turn backplane clock on or off */
 static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int err;
 	u8 clkctl, clkreq, devctl;
 	unsigned long timeout;
@@ -747,16 +746,14 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				   clkreq, &err);
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
 			brcmf_err("HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdiod_readb(bus->sdiodev,
-					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_err("HT Avail read error: %d\n", err);
 			return -EBADE;
@@ -765,34 +762,34 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdiod_readb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(sdiodev, SBSDIO_DEVICE_CTL,
+						   &err);
 			if (err) {
 				brcmf_err("Devctl error setting CA: %d\n", err);
 				return -EBADE;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					   devctl, &err);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
 			brcmf_dbg(SDIO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_readb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(sdiodev, SBSDIO_DEVICE_CTL,
+						   &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					   devctl, &err);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdiod_readb(bus->sdiodev,
+			clkctl = brcmf_sdiod_readb(sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if (time_after(jiffies, timeout))
@@ -826,16 +823,15 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_readb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(sdiodev, SBSDIO_DEVICE_CTL,
+						   &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					   devctl, &err);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				   clkreq, &err);
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
 			brcmf_err("Failed access turning clock off: %d\n",
@@ -910,6 +906,7 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 static int
 brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int err = 0;
 	u8 clkcsr;
 
@@ -925,12 +922,12 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 
 		/* Going to sleep */
 		if (sleep) {
-			clkcsr = brcmf_sdiod_readb(bus->sdiodev,
+			clkcsr = brcmf_sdiod_readb(sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if ((clkcsr & SBSDIO_CSR_MASK) == 0) {
 				brcmf_dbg(SDIO, "no clock, set ALP\n");
-				brcmf_sdiod_writeb(bus->sdiodev,
+				brcmf_sdiod_writeb(sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   SBSDIO_ALP_AVAIL_REQ, &err);
 			}
@@ -972,13 +969,15 @@ static inline bool brcmf_sdio_valid_shared_address(u32 addr)
 static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 				 struct sdpcm_shared *sh)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	u32 addr = 0;
 	int rv;
 	u32 shaddr = 0;
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(func1);
 	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/*
@@ -988,7 +987,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	shaddr = bus->ci->rambase + bus->ci->ramsize - 4;
 	if (!bus->ci->rambase && brcmf_chip_sr_capable(bus->ci))
 		shaddr -= bus->ci->srsize;
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr,
+	rv = brcmf_sdiod_ramrw(sdiodev, false, shaddr,
 			       (u8 *)&addr_le, 4);
 	if (rv < 0)
 		goto fail;
@@ -1007,12 +1006,12 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
 
 	/* Read hndrte_shared structure */
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, (u8 *)&sh_le,
 			       sizeof(struct sdpcm_shared_le));
 	if (rv < 0)
 		goto fail;
 
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 
 	/* Endianness */
 	sh->flags = le32_to_cpu(sh_le.flags);
@@ -1034,7 +1033,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 fail:
 	brcmf_err("unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
 		  rv, addr);
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 	return rv;
 }
 
@@ -1053,7 +1052,7 @@ static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
 
 static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct brcmf_core *core = bus->sdio_core;
 	u32 intstatus = 0;
 	u32 hmb_data;
@@ -1063,11 +1062,11 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
-	hmb_data = brcmf_sdiod_readl(sdiod, core->base +
+	hmb_data = brcmf_sdiod_readl(sdiodev, core->base +
 					__sd_reg(tohostmailboxdata), &ret);
 
 	if (!ret)
-		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailbox),
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(tosbmailbox),
 				   SMB_INT_ACK, &ret);
 
 	bus->sdcnt.f1regdata += 2;
@@ -1138,7 +1137,8 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 {
-	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func2 = sdiodev->func2;
 	struct brcmf_core *core = bus->sdio_core;
 	uint retries = 0;
 	u16 lastrbc;
@@ -1150,16 +1150,15 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		  rtx ? ", send NAK" : "");
 
 	if (abort)
-		brcmf_sdiod_abort(bus->sdiodev, bus->sdiodev->func2);
+		brcmf_sdiod_abort(sdiodev, func2);
 
-	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM,
-			   &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_RFRAMEBCHI, &err);
-		lo = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_RFRAMEBCLO, &err);
+		hi = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_RFRAMEBCHI, &err);
+		lo = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_RFRAMEBCLO, &err);
 		bus->sdcnt.f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -1179,7 +1178,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->sdcnt.rxrtx++;
-		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailbox),
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(tosbmailbox),
 				   SMB_NAK, &err);
 
 		bus->sdcnt.f1regdata++;
@@ -1194,13 +1193,14 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 {
 	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func2 = sdiodev->func2;
 	u8 i, hi, lo;
 
 	/* On failure, abort the command and terminate the frame */
 	brcmf_err("sdio error, abort command and terminate frame\n");
 	bus->sdcnt.tx_sderrs++;
 
-	brcmf_sdiod_abort(sdiodev, sdiodev->func2);
+	brcmf_sdiod_abort(sdiodev, func2);
 	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
@@ -1449,6 +1449,8 @@ static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 
 static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
 	u16 sublen;
@@ -1556,10 +1558,9 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
-		sdio_claim_host(bus->sdiodev->func1);
-		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
-						 &bus->glom, dlen);
-		sdio_release_host(bus->sdiodev->func1);
+		sdio_claim_host(func1);
+		errcode = brcmf_sdiod_recv_chain(sdiodev, &bus->glom, dlen);
+		sdio_release_host(func1);
 		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe */
@@ -1567,11 +1568,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host(func1);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 			return 0;
 		}
 
@@ -1581,10 +1582,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host(func1);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
-		sdio_release_host(bus->sdiodev->func1);
+		sdio_release_host(func1);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */
@@ -1600,10 +1601,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host(func1);
 			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
 						     BRCMF_SDIO_FT_SUB);
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
 
@@ -1612,11 +1613,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		if (errcode) {
 			/* Terminate frame on error */
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host(func1);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 			bus->cur_read.len = 0;
 			return 0;
 		}
@@ -1650,9 +1651,9 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
 			if (brcmf_sdio_fromevntchan(&dptr[SDPCM_HWHDR_LEN]))
-				brcmf_rx_event(bus->sdiodev->dev, pfirst);
+				brcmf_rx_event(sdiodev->dev, pfirst);
 			else
-				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
+				brcmf_rx_frame(sdiodev->dev, pfirst,
 					       false);
 			bus->sdcnt.rxglompkts++;
 		}
@@ -1693,6 +1694,7 @@ static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 static void
 brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	uint rdlen, pad;
 	u8 *buf = NULL, *rbuf;
 	int sdret;
@@ -1719,30 +1721,30 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
 		pad = bus->blocksize - (rdlen % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-		    ((len + pad) < bus->sdiodev->bus_if->maxctl))
+		    ((len + pad) < sdiodev->bus_if->maxctl))
 			rdlen += pad;
 	} else if (rdlen % bus->head_align) {
 		rdlen += bus->head_align - (rdlen % bus->head_align);
 	}
 
 	/* Drop if the read is too big or it exceeds our maximum */
-	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
+	if ((rdlen + BRCMF_FIRSTREAD) > sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
-			  rdlen, bus->sdiodev->bus_if->maxctl);
+			  rdlen, sdiodev->bus_if->maxctl);
 		brcmf_sdio_rxfail(bus, false, false);
 		goto done;
 	}
 
-	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
+	if ((len - doff) > sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
-			  len, len - doff, bus->sdiodev->bus_if->maxctl);
+			  len, len - doff, sdiodev->bus_if->maxctl);
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdio_rxfail(bus, false, false);
 		goto done;
 	}
 
 	/* Read remain of frame body */
-	sdret = brcmf_sdiod_recv_buf(bus->sdiodev, rbuf, rdlen);
+	sdret = brcmf_sdiod_recv_buf(sdiodev, rbuf, rdlen);
 	bus->sdcnt.f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -2017,6 +2019,7 @@ brcmf_sdio_wait_event_wakeup(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct brcmf_bus_stats *stats;
 	u16 head_pad;
 	u8 *dat_buf;
@@ -2027,7 +2030,7 @@ static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 	head_pad = ((unsigned long)dat_buf % bus->head_align);
 	if (head_pad) {
 		if (skb_headroom(pkt) < head_pad) {
-			stats = &bus->sdiodev->bus_if->stats;
+			stats = &sdiodev->bus_if->stats;
 			atomic_inc(&stats->pktcowed);
 			if (skb_cow_head(pkt, head_pad)) {
 				atomic_inc(&stats->pktcow_failed);
@@ -2054,14 +2057,13 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 				    struct sk_buff_head *pktq,
 				    struct sk_buff *pkt, u16 total_len)
 {
-	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct sk_buff *pkt_pad;
 	u16 tail_pad, tail_chop, chain_pad;
 	unsigned int blksize;
 	bool lastfrm;
 	int ntail, ret;
 
-	sdiodev = bus->sdiodev;
 	blksize = sdiodev->func2->cur_blksize;
 	/* sg entry alignment should be a divisor of block size */
 	WARN_ON(blksize % bus->sgentry_align);
@@ -2232,6 +2234,9 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 			    uint chan)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
+
 	int ret;
 	struct sk_buff *pkt_next, *tmp;
 
@@ -2241,14 +2246,14 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	if (ret)
 		goto done;
 
-	sdio_claim_host(bus->sdiodev->func1);
-	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
+	sdio_claim_host(func1);
+	ret = brcmf_sdiod_send_pkt(sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0)
 		brcmf_sdio_txfail(bus);
 
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 
 done:
 	brcmf_sdio_txpkt_postp(bus, pktq);
@@ -2256,7 +2261,7 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		bus->tx_seq = (bus->tx_seq + pktq->qlen) % SDPCM_SEQ_WRAP;
 	skb_queue_walk_safe(pktq, pkt_next, tmp) {
 		__skb_unlink(pkt_next, pktq);
-		brcmf_proto_bcdc_txcomplete(bus->sdiodev->dev, pkt_next,
+		brcmf_proto_bcdc_txcomplete(sdiodev->dev, pkt_next,
 					    ret == 0);
 	}
 	return ret;
@@ -2264,6 +2269,8 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 
 static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	struct brcmf_core *core = bus->sdio_core;
 	struct sk_buff *pkt;
 	struct sk_buff_head pktq;
@@ -2281,7 +2288,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		pkt_num = 1;
 		if (bus->txglom)
 			pkt_num = min_t(u8, bus->tx_max - bus->tx_seq,
-					bus->sdiodev->txglomsz);
+					sdiodev->txglomsz);
 		pkt_num = min_t(u32, pkt_num,
 				brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol));
 		__skb_queue_head_init(&pktq);
@@ -2304,11 +2311,11 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
-			sdio_claim_host(bus->sdiodev->func1);
-			intstatus = brcmf_sdiod_readl(bus->sdiodev, core->base +
+			sdio_claim_host(func1);
+			intstatus = brcmf_sdiod_readl(sdiodev, core->base +
 						      __sd_reg(intstatus),
 						      &ret);
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
 				break;
@@ -2318,10 +2325,10 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if ((bus->sdiodev->state == BRCMF_SDIOD_DATA) &&
+	if ((sdiodev->state == BRCMF_SDIOD_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = false;
-		brcmf_proto_bcdc_txflowblock(bus->sdiodev->dev, false);
+		brcmf_proto_bcdc_txflowblock(sdiodev->dev, false);
 	}
 
 	return cnt;
@@ -2329,6 +2336,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 
 static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio *bus, u8 *frame, u16 len)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	u8 doff;
 	u16 pad;
 	uint retries = 0;
@@ -2378,7 +2386,7 @@ static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio *bus, u8 *frame, u16 len)
 			   frame, min_t(u16, len, 16), "TxHdr:\n");
 
 	do {
-		ret = brcmf_sdiod_send_buf(bus->sdiodev, frame, len);
+		ret = brcmf_sdiod_send_buf(sdiodev, frame, len);
 
 		if (ret < 0)
 			brcmf_sdio_txfail(bus);
@@ -2475,34 +2483,36 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct brcmf_core *core = bus->sdio_core;
 	unsigned long val;
 	int ret;
 
-	val = brcmf_sdiod_readl(bus->sdiodev, core->base + __sd_reg(intstatus),
-				&ret);
+	val = brcmf_sdiod_readl(sdiodev, core->base + __sd_reg(intstatus), &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
-		return ret;
+		goto out;
 
 	val &= bus->hostintmask;
 	atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
 
+	if (!val)
+		goto out;
+
 	/* Clear interrupts */
-	if (val) {
-		brcmf_sdiod_writel(bus->sdiodev,
-				   core->base + __sd_reg(intstatus), val, &ret);
-		bus->sdcnt.f1regdata++;
-		atomic_or(val, &bus->intstatus);
-	}
+	brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus), val, &ret);
+	bus->sdcnt.f1regdata++;
+	atomic_or(val, &bus->intstatus);
 
+out:
 	return ret;
 }
 
 static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
 	struct brcmf_core *core = bus->sdio_core;
-	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	u32 newstatus = 0;
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
@@ -2511,7 +2521,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(func1);
 
 	/* If waiting for HTAVAIL, check status */
 	if (!bus->sr_enabled && bus->clkstate == CLK_PENDING) {
@@ -2519,23 +2529,21 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 #ifdef DEBUG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					   &err);
+		devctl = brcmf_sdiod_readb(sdiodev, SBSDIO_DEVICE_CTL, &err);
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdiod_readb(bus->sdiodev,
-					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 		brcmf_dbg(SDIO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdiod_readb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(sdiodev, SBSDIO_DEVICE_CTL,
+						   &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_writeb(bus->sdiodev,
-					   SBSDIO_DEVICE_CTL, devctl, &err);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
 			bus->clkstate = CLK_AVAIL;
 		}
 	}
@@ -2558,10 +2566,10 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(intstatus),
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus),
 				   I_HMB_FC_CHANGE, &err);
 
-		newstatus = brcmf_sdiod_readl(sdiod,
+		newstatus = brcmf_sdiod_readl(sdiodev,
 					      core->base + __sd_reg(intstatus),
 					      &err);
 
@@ -2577,7 +2585,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		intstatus |= brcmf_sdio_hostmail(bus);
 	}
 
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
@@ -2620,7 +2628,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
 	    data_ok(bus)) {
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host(func1);
 		if (bus->ctrl_frame_stat) {
 			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
 						      bus->ctrl_frame_len);
@@ -2628,7 +2636,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 			wmb();
 			bus->ctrl_frame_stat = false;
 		}
-		sdio_release_host(bus->sdiodev->func1);
+		sdio_release_host(func1);
 		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
@@ -2640,18 +2648,18 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_sdio_sendfromq(bus, framecnt);
 	}
 
-	if ((bus->sdiodev->state != BRCMF_SDIOD_DATA) || (err != 0)) {
+	if ((sdiodev->state != BRCMF_SDIOD_DATA) || (err != 0)) {
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host(func1);
 			if (bus->ctrl_frame_stat) {
 				bus->ctrl_frame_err = -ENODEV;
 				wmb();
 				bus->ctrl_frame_stat = false;
 				brcmf_sdio_wait_event_wakeup(bus);
 			}
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 		}
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
@@ -2768,6 +2776,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 
 static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct brcmf_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
 	u32 n, idx, addr;
@@ -2779,7 +2788,7 @@ static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 
 	/* Read console log struct */
 	addr = bus->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&c->log_le,
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, (u8 *)&c->log_le,
 			       sizeof(c->log_le));
 	if (rv < 0)
 		return rv;
@@ -2805,7 +2814,7 @@ static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 
 	/* Read the console buffer */
 	addr = le32_to_cpu(c->log_le.buf);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, c->buf, c->bufsize);
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, c->buf, c->bufsize);
 	if (rv < 0)
 		return rv;
 
@@ -2848,6 +2857,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct sdio_func *func1 = sdiodev->func1;
 	struct brcmf_sdio *bus = sdiodev->bus;
 	int ret;
 
@@ -2866,13 +2876,13 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 					 CTL_DONE_TIMEOUT);
 	ret = 0;
 	if (bus->ctrl_frame_stat) {
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host(func1);
 		if (bus->ctrl_frame_stat) {
 			brcmf_dbg(SDIO, "ctrl_frame timeout\n");
 			bus->ctrl_frame_stat = false;
 			ret = -ETIMEDOUT;
 		}
-		sdio_release_host(bus->sdiodev->func1);
+		sdio_release_host(func1);
 	}
 	if (!ret) {
 		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
@@ -2893,6 +2903,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 static int brcmf_sdio_dump_console(struct seq_file *seq, struct brcmf_sdio *bus,
 				   struct sdpcm_shared *sh)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	u32 addr, console_ptr, console_size, console_index;
 	char *conbuf = NULL;
 	__le32 sh_val;
@@ -2900,22 +2911,19 @@ static int brcmf_sdio_dump_console(struct seq_file *seq, struct brcmf_sdio *bus,
 
 	/* obtain console information from device memory */
 	addr = sh->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
-			       (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_ptr = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.buf_size);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
-			       (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_size = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.idx);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr,
-			       (u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdiod_ramrw(sdiodev, false, addr, (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_index = le32_to_cpu(sh_val);
@@ -2929,7 +2937,7 @@ static int brcmf_sdio_dump_console(struct seq_file *seq, struct brcmf_sdio *bus,
 
 	/* obtain the console data from device */
 	conbuf[console_size] = '\0';
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, console_ptr, (u8 *)conbuf,
+	rv = brcmf_sdiod_ramrw(sdiodev, false, console_ptr, (u8 *)conbuf,
 			       console_size);
 	if (rv < 0)
 		goto done;
@@ -2984,6 +2992,8 @@ static int brcmf_sdio_trap_info(struct seq_file *seq, struct brcmf_sdio *bus,
 static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 				  struct sdpcm_shared *sh)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	int error = 0;
 	char file[80] = "?";
 	char expr[80] = "<???>";
@@ -2996,20 +3006,20 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		return 0;
 	}
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(func1);
 	if (sh->assert_file_addr != 0) {
-		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
+		error = brcmf_sdiod_ramrw(sdiodev, false,
 					  sh->assert_file_addr, (u8 *)file, 80);
 		if (error < 0)
 			return error;
 	}
 	if (sh->assert_exp_addr != 0) {
-		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
+		error = brcmf_sdiod_ramrw(sdiodev, false,
 					  sh->assert_exp_addr, (u8 *)expr, 80);
 		if (error < 0)
 			return error;
 	}
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 
 	seq_printf(seq, "dongle assert: %s:%d: assert(%s)\n",
 		   file, sh->assert_line, expr);
@@ -3241,16 +3251,17 @@ brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
 static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 					 const struct firmware *fw)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	err = brcmf_sdiod_ramrw(bus->sdiodev, true, bus->ci->rambase,
-				(u8 *)fw->data, fw->size);
+	err = brcmf_sdiod_ramrw(sdiodev, true, bus->ci->rambase, (u8 *)fw->data,
+				fw->size);
 	if (err)
 		brcmf_err("error %d on writing %d membytes at 0x%08x\n",
 			  err, (int)fw->size, bus->ci->rambase);
-	else if (!brcmf_sdio_verifymemory(bus->sdiodev, bus->ci->rambase,
+	else if (!brcmf_sdio_verifymemory(sdiodev, bus->ci->rambase,
 					  (u8 *)fw->data, fw->size))
 		err = -EIO;
 
@@ -3260,17 +3271,18 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 				     void *vars, u32 varsz)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int address;
 	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	address = bus->ci->ramsize - varsz + bus->ci->rambase;
-	err = brcmf_sdiod_ramrw(bus->sdiodev, true, address, vars, varsz);
+	err = brcmf_sdiod_ramrw(sdiodev, true, address, vars, varsz);
 	if (err)
 		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
 			  err, varsz, address);
-	else if (!brcmf_sdio_verifymemory(bus->sdiodev, address, vars, varsz))
+	else if (!brcmf_sdio_verifymemory(sdiodev, address, vars, varsz))
 		err = -EIO;
 
 	return err;
@@ -3280,10 +3292,12 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 					const struct firmware *fw,
 					void *nvram, u32 nvlen)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	int bcmerror;
 	u32 rstvec;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(func1);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	rstvec = get_unaligned_le32(fw->data);
@@ -3312,32 +3326,33 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 
 err:
 	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 	return bcmerror;
 }
 
 static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int err = 0;
 	u8 val;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
+	val = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
-	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	/* Add CMD14 Support */
-	brcmf_sdiod_func0_wb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
+	brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_CARDCAP,
 			     (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
 			      SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
 			     &err);
@@ -3346,8 +3361,8 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 		return;
 	}
 
-	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			   SBSDIO_FORCE_HT, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, SBSDIO_FORCE_HT,
+			   &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
@@ -3361,6 +3376,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 /* enable KSO bit */
 static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	struct brcmf_core *core = bus->sdio_core;
 	u8 val;
 	int err = 0;
@@ -3371,7 +3387,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (core->rev < 12)
 		return 0;
 
-	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
+	val = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
 		return err;
@@ -3380,7 +3396,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (!(val & SBSDIO_FUNC1_SLEEPCSR_KSO_MASK)) {
 		val |= (SBSDIO_FUNC1_SLEEPCSR_KSO_EN <<
 			SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
-		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, val, &err);
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SLEEPCSR, val, &err);
 		if (err) {
 			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
 			return err;
@@ -3396,6 +3412,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct sdio_func *func2 = sdiodev->func2;
 	struct brcmf_core *core = bus->sdio_core;
 	uint pad_size;
 	u32 value;
@@ -3426,8 +3443,8 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (sdiodev->sg_support) {
 		bus->txglom = false;
 		value = 1;
-		pad_size = bus->sdiodev->func2->cur_blksize << 1;
-		err = brcmf_iovar_data_set(bus->sdiodev->dev, "bus:rxglom",
+		pad_size = func2->cur_blksize << 1;
+		err = brcmf_iovar_data_set(sdiodev->dev, "bus:rxglom",
 					   &value, sizeof(u32));
 		if (err < 0) {
 			/* bus:rxglom is allowed to fail */
@@ -3437,7 +3454,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 			bus->tx_hdrlen += SDPCM_HWEXT_LEN;
 		}
 	}
-	brcmf_bus_add_txhdrlen(bus->sdiodev->dev, bus->tx_hdrlen);
+	brcmf_bus_add_txhdrlen(sdiodev->dev, bus->tx_hdrlen);
 
 done:
 	return err;
@@ -3524,6 +3541,9 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
+
 	brcmf_dbg(TIMER, "Enter\n");
 
 	/* Poll period: check device if appropriate. */
@@ -3541,11 +3561,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (!bus->dpc_triggered) {
 				u8 devpend;
 
-				sdio_claim_host(bus->sdiodev->func1);
-				devpend = brcmf_sdiod_func0_rb(bus->sdiodev,
-				sdio_release_host(bus->sdiodev->func[1]);
-						  SDIO_CCCR_INTx, NULL);
-				sdio_release_host(bus->sdiodev->func1);
+				sdio_claim_host(func1);
+				devpend = brcmf_sdiod_func0_rb(sdiodev,
+							       SDIO_CCCR_INTx,
+							       NULL);
+				sdio_release_host(func1);
 				intstatus = devpend & (INTR_STATUS_FUNC1 |
 						       INTR_STATUS_FUNC2);
 			}
@@ -3566,18 +3586,18 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
-	if (bus->sdiodev->state == BRCMF_SDIOD_DATA && BRCMF_FWCON_ON() &&
+	if (sdiodev->state == BRCMF_SDIOD_DATA && BRCMF_FWCON_ON() &&
 	    bus->console_interval != 0) {
 		bus->console.count += jiffies_to_msecs(BRCMF_WD_POLL);
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host(func1);
 			/* Make sure backplane clock is on */
 			brcmf_sdio_bus_sleep(bus, false, false);
 			if (brcmf_sdio_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
-			sdio_release_host(bus->sdiodev->func1);
+			sdio_release_host(func1);
 		}
 	}
 #endif				/* DEBUG */
@@ -3590,11 +3610,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			bus->idlecount++;
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host(func1);
 				brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
-				sdio_release_host(bus->sdiodev->func1);
+				sdio_release_host(func1);
 			}
 		} else {
 			bus->idlecount = 0;
@@ -3608,6 +3628,7 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 {
 	struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
 					      datawork);
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 
 	bus->dpc_running = true;
 	wmb();
@@ -3617,10 +3638,10 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 		bus->idlecount = 0;
 	}
 	bus->dpc_running = false;
-	if (brcmf_sdiod_freezing(bus->sdiodev)) {
-		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DOWN);
-		brcmf_sdiod_try_freeze(bus->sdiodev);
-		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
+	if (brcmf_sdiod_freezing(sdiodev)) {
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DOWN);
+		brcmf_sdiod_try_freeze(sdiodev);
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DATA);
 	}
 }
 
@@ -3799,15 +3820,15 @@ static const struct brcmf_buscore_ops brcmf_sdio_buscore_ops = {
 static bool
 brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	u8 clkctl = 0;
 	int err = 0;
 	int reg_addr;
 	u32 reg_val;
 	u32 drivestrength;
 
-	sdiodev = bus->sdiodev;
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host(func1);
 
 	/*
 	 * Force PLL off until brcmf_chip_attach()
@@ -3940,18 +3961,19 @@ static int
 brcmf_sdio_watchdog_thread(void *data)
 {
 	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	int wait;
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
-	brcmf_sdiod_freezer_count(bus->sdiodev);
+	brcmf_sdiod_freezer_count(sdiodev);
 	while (1) {
 		if (kthread_should_stop())
 			break;
-		brcmf_sdiod_freezer_uncount(bus->sdiodev);
+		brcmf_sdiod_freezer_uncount(sdiodev);
 		wait = wait_for_completion_interruptible(&bus->watchdog_wait);
-		brcmf_sdiod_freezer_count(bus->sdiodev);
-		brcmf_sdiod_try_freeze(bus->sdiodev);
+		brcmf_sdiod_freezer_count(sdiodev);
+		brcmf_sdiod_try_freeze(sdiodev);
 		if (!wait) {
 			brcmf_sdio_bus_watchdog(bus);
 			/* Count the tick for reference */
@@ -3995,8 +4017,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct sdio_func *func1 = sdiodev->func1;
+	struct sdio_func *func2 = sdiodev->func2;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
 	struct brcmf_core *core = bus->sdio_core;
 	u8 saveclk;
 
@@ -4019,7 +4042,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdio_wd_timer(bus, true);
 
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host(func1);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
@@ -4038,10 +4061,10 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	}
 
 	/* Enable function 2 (frame transfers) */
-	brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailboxdata),
+	brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(tosbmailboxdata),
 			   SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT, NULL);
 
-	err = sdio_enable_func(sdiodev->func2);
+	err = sdio_enable_func(func2);
 
 
 	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
@@ -4050,14 +4073,13 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (!err) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(hostintmask),
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(hostintmask),
 				   bus->hostintmask, NULL);
 
-
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
-		sdio_disable_func(sdiodev->func2);
+		sdio_disable_func(func2);
 		goto release;
 	}
 
@@ -4070,7 +4092,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 
 	if (err == 0) {
 		/* Allow full data communication using DPC from now on. */
-		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DATA);
 
 		err = brcmf_sdiod_intr_register(sdiodev);
 		if (err != 0)
@@ -4081,7 +4103,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (err != 0)
 		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 
-	sdio_release_host(sdiodev->func1);
+	sdio_release_host(func1);
 
 	err = brcmf_bus_started(dev);
 	if (err != 0) {
@@ -4091,11 +4113,11 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	return;
 
 release:
-	sdio_release_host(sdiodev->func1);
+	sdio_release_host(func1);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
 	device_release_driver(dev);
-	device_release_driver(&sdiodev->func2->dev);
+	device_release_driver(&func2->dev);
 }
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
@@ -4160,16 +4182,16 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->dpc_running = false;
 
 	/* Assign bus interface call back */
-	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
-	bus->sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
-	bus->sdiodev->bus_if->chip = bus->ci->chip;
-	bus->sdiodev->bus_if->chiprev = bus->ci->chiprev;
+	sdiodev->bus_if->dev = sdiodev->dev;
+	sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
+	sdiodev->bus_if->chip = bus->ci->chip;
+	sdiodev->bus_if->chiprev = bus->ci->chiprev;
 
 	/* default sdio bus header length for tx packet */
 	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
 
 	/* Attach to the common layer, reserve hdr space */
-	ret = brcmf_attach(bus->sdiodev->dev, bus->sdiodev->settings);
+	ret = brcmf_attach(sdiodev->dev, sdiodev->settings);
 	if (ret != 0) {
 		brcmf_err("brcmf_attach failed\n");
 		goto fail;
@@ -4178,17 +4200,17 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* allocate scatter-gather table. sg support
 	 * will be disabled upon allocation failure.
 	 */
-	brcmf_sdiod_sgtable_alloc(bus->sdiodev);
+	brcmf_sdiod_sgtable_alloc(sdiodev);
 
 	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func2->cur_blksize;
+	bus->blocksize = sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
 	/* Allocate buffers */
-	if (bus->sdiodev->bus_if->maxctl) {
-		bus->sdiodev->bus_if->maxctl += bus->roundup;
+	if (sdiodev->bus_if->maxctl) {
+		sdiodev->bus_if->maxctl += bus->roundup;
 		bus->rxblen =
-		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
+		    roundup((sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + bus->head_align;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
@@ -4197,17 +4219,17 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		}
 	}
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(sdiodev->func1);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	sdio_disable_func(bus->sdiodev->func2);
+	sdio_disable_func(sdiodev->func2);
 
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(sdiodev->func1);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
@@ -4248,18 +4270,21 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus) {
+		struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+		struct sdio_func *func1 = sdiodev->func1;
+
 		/* De-register interrupt handler */
-		brcmf_sdiod_intr_unregister(bus->sdiodev);
+		brcmf_sdiod_intr_unregister(sdiodev);
 
-		brcmf_detach(bus->sdiodev->dev);
+		brcmf_detach(sdiodev->dev);
 
 		cancel_work_sync(&bus->datawork);
 		if (bus->brcmf_wq)
 			destroy_workqueue(bus->brcmf_wq);
 
 		if (bus->ci) {
-			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-				sdio_claim_host(bus->sdiodev->func1);
+			if (sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
+				sdio_claim_host(sdiodev->func1);
 				brcmf_sdio_wd_timer(bus, false);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4269,12 +4294,12 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 				msleep(20);
 				brcmf_chip_set_passive(bus->ci);
 				brcmf_sdio_clkctl(bus, CLK_NONE, false);
-				sdio_release_host(bus->sdiodev->func1);
+				sdio_release_host(func1);
 			}
 			brcmf_chip_detach(bus->ci);
 		}
-		if (bus->sdiodev->settings)
-			brcmf_release_module_param(bus->sdiodev->settings);
+		if (sdiodev->settings)
+			brcmf_release_module_param(sdiodev->settings);
 
 		kfree(bus->rxbuf);
 		kfree(bus->hdrbuf);
@@ -4314,11 +4339,13 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, bool active)
 
 int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
 {
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct sdio_func *func1 = sdiodev->func1;
 	int ret;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host(func1);
 	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
-	sdio_release_host(bus->sdiodev->func1);
+	sdio_release_host(func1);
 
 	return ret;
 }
-- 
2.11.0

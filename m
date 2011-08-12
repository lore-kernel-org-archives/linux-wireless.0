Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1920 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/14] staging: brcm80211: remove global var gInstance
 from brcmfmac
Date: Fri, 12 Aug 2011 15:34:51 +0200
Message-ID: <1313156101-16817-5-git-send-email-arend@broadcom.com> (sfid-20110812_153523_524804_607A486A)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use sdio function pointer stored in struct brcmf_sdio_dev instead
of those in gInstance.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    5 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  198 +++++++++------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    7 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   18 +--
 4 files changed, 99 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6a9ac1d..aaf13f4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -21,6 +21,7 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/mmc/card.h>
 
 #include <defs.h>
 #include <brcm_hw_ids.h>
@@ -55,12 +56,12 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_register();
+	return brcmf_sdioh_interrupt_register(sdiodev);
 }
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_deregister();
+	return brcmf_sdioh_interrupt_deregister(sdiodev);
 }
 
 u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 877428c..76b3394 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -58,8 +58,6 @@ static int brcmf_sdio_resume(struct device *dev);
 
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-struct brcmf_sdmmc_instance *gInstance;
-
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
@@ -133,9 +131,9 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Enable Function 1 */
-	sdio_claim_host(gInstance->func[1]);
-	err_ret = sdio_enable_func(gInstance->func[1]);
-	sdio_release_host(gInstance->func[1]);
+	sdio_claim_host(sdiodev->func[1]);
+	err_ret = sdio_enable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
 	if (err_ret)
 		BRCMF_ERROR(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
 			"Err: 0x%08x\n", err_ret));
@@ -152,32 +150,23 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 
 	BRCMF_TRACE(("%s\n", __func__));
 
-	if (gInstance == NULL) {
-		BRCMF_ERROR(("%s: SDIO Device not present\n", __func__));
-		err_ret = -ENODEV;
-		goto out;
-	}
-
 	sdiodev->num_funcs = 2;
 
-	sdio_claim_host(gInstance->func[1]);
-	err_ret = sdio_set_block_size(gInstance->func[1], 64);
-	sdio_release_host(gInstance->func[1]);
+	sdio_claim_host(sdiodev->func[1]);
+	err_ret = sdio_set_block_size(sdiodev->func[1], 64);
+	sdio_release_host(sdiodev->func[1]);
 	if (err_ret) {
 		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
 		goto out;
 	}
 
-	if (gInstance->func[2]) {
-		sdio_claim_host(gInstance->func[2]);
-		err_ret =
-		    sdio_set_block_size(gInstance->func[2], sd_f2_blocksize);
-		sdio_release_host(gInstance->func[2]);
-		if (err_ret) {
-			BRCMF_ERROR(("%s: Failed to set F2 blocksize"
-				" to %d\n", __func__, sd_f2_blocksize));
-			goto out;
-		}
+	sdio_claim_host(sdiodev->func[2]);
+	err_ret = sdio_set_block_size(sdiodev->func[2], sd_f2_blocksize);
+	sdio_release_host(sdiodev->func[2]);
+	if (err_ret) {
+		BRCMF_ERROR(("%s: Failed to set F2 blocksize"
+			" to %d\n", __func__, sd_f2_blocksize));
+		goto out;
 	}
 
 	brcmf_sdioh_enablefuncs(sdiodev);
@@ -192,56 +181,56 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 	BRCMF_TRACE(("%s\n", __func__));
 
 	/* Disable Function 2 */
-	sdio_claim_host(gInstance->func[2]);
-	sdio_disable_func(gInstance->func[2]);
-	sdio_release_host(gInstance->func[2]);
+	sdio_claim_host(sdiodev->func[2]);
+	sdio_disable_func(sdiodev->func[2]);
+	sdio_release_host(sdiodev->func[2]);
 
 	/* Disable Function 1 */
-	sdio_claim_host(gInstance->func[1]);
-	sdio_disable_func(gInstance->func[1]);
-	sdio_release_host(gInstance->func[1]);
+	sdio_claim_host(sdiodev->func[1]);
+	sdio_disable_func(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
 
 }
 
 /* Configure callback to client when we receive client interrupt */
 extern int
-brcmf_sdioh_interrupt_register(void)
+brcmf_sdioh_interrupt_register(struct brcmf_sdio_dev *sdiodev)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
 
 	/* register and unmask irq */
-	if (gInstance->func[2]) {
-		sdio_claim_host(gInstance->func[2]);
-		sdio_claim_irq(gInstance->func[2], brcmf_sdioh_irqhandler_f2);
-		sdio_release_host(gInstance->func[2]);
+	if (sdiodev->func[2]) {
+		sdio_claim_host(sdiodev->func[2]);
+		sdio_claim_irq(sdiodev->func[2], brcmf_sdioh_irqhandler_f2);
+		sdio_release_host(sdiodev->func[2]);
 	}
 
-	if (gInstance->func[1]) {
-		sdio_claim_host(gInstance->func[1]);
-		sdio_claim_irq(gInstance->func[1], brcmf_sdioh_irqhandler);
-		sdio_release_host(gInstance->func[1]);
+	if (sdiodev->func[1]) {
+		sdio_claim_host(sdiodev->func[1]);
+		sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
+		sdio_release_host(sdiodev->func[1]);
 	}
 
 	return 0;
 }
 
-extern int brcmf_sdioh_interrupt_deregister(void)
+int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
 
-	if (gInstance->func[1]) {
+	if (sdiodev->func[1]) {
 		/* register and unmask irq */
-		sdio_claim_host(gInstance->func[1]);
-		sdio_release_irq(gInstance->func[1]);
-		sdio_release_host(gInstance->func[1]);
+		sdio_claim_host(sdiodev->func[1]);
+		sdio_release_irq(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func[1]);
 	}
 
-	if (gInstance->func[2]) {
+	if (sdiodev->func[2]) {
 		/* Claim host controller F2 */
-		sdio_claim_host(gInstance->func[2]);
-		sdio_release_irq(gInstance->func[2]);
+		sdio_claim_host(sdiodev->func[2]);
+		sdio_release_irq(sdiodev->func[2]);
 		/* Release host controller F2 */
-		sdio_release_host(gInstance->func[2]);
+		sdio_release_host(sdiodev->func[2]);
 	}
 
 	return 0;
@@ -450,8 +439,8 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	BRCMF_INFO(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
 		 regaddr));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, gInstance);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, sdiodev);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
 			/* Can only directly write to some F0 registers.
@@ -459,13 +448,13 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			 * as a special case.
 			 */
 			if (regaddr == SDIO_CCCR_IOEx) {
-				if (gInstance->func[2]) {
-					sdio_claim_host(gInstance->func[2]);
+				if (sdiodev->func[2]) {
+					sdio_claim_host(sdiodev->func[2]);
 					if (*byte & SDIO_FUNC_ENABLE_2) {
 						/* Enable Function 2 */
 						err_ret =
 						    sdio_enable_func
-						    (gInstance->func[2]);
+						    (sdiodev->func[2]);
 						if (err_ret)
 							BRCMF_ERROR((
 								"request_byte: "
@@ -476,7 +465,7 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 						/* Disable Function 2 */
 						err_ret =
 						    sdio_disable_func
-						    (gInstance->func[2]);
+						    (sdiodev->func[2]);
 						if (err_ret)
 							BRCMF_ERROR((
 								"request_byte: "
@@ -484,55 +473,55 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 								"failed:%d\n",
 								 err_ret));
 					}
-					sdio_release_host(gInstance->func[2]);
+					sdio_release_host(sdiodev->func[2]);
 				}
 			}
 			/* to allow abort command through F1 */
 			else if (regaddr == SDIO_CCCR_ABORT) {
-				sdio_claim_host(gInstance->func[func]);
+				sdio_claim_host(sdiodev->func[func]);
 				/*
 				 * this sdio_f0_writeb() can be replaced
 				 * with another api
 				 * depending upon MMC driver change.
 				 * As of this time, this is temporaray one
 				 */
-				sdio_writeb(gInstance->func[func], *byte,
+				sdio_writeb(sdiodev->func[func], *byte,
 					    regaddr, &err_ret);
-				sdio_release_host(gInstance->func[func]);
+				sdio_release_host(sdiodev->func[func]);
 			} else if (regaddr < 0xF0) {
 				BRCMF_ERROR(("brcmf: F0 Wr:0x%02x: write "
 					"disallowed\n", regaddr));
 			} else {
 				/* Claim host controller, perform F0 write,
 				 and release */
-				sdio_claim_host(gInstance->func[func]);
-				sdio_f0_writeb(gInstance->func[func], *byte,
+				sdio_claim_host(sdiodev->func[func]);
+				sdio_f0_writeb(sdiodev->func[func], *byte,
 					       regaddr, &err_ret);
-				sdio_release_host(gInstance->func[func]);
+				sdio_release_host(sdiodev->func[func]);
 			}
 		} else {
 			/* Claim host controller, perform Fn write,
 			 and release */
-			sdio_claim_host(gInstance->func[func]);
-			sdio_writeb(gInstance->func[func], *byte, regaddr,
+			sdio_claim_host(sdiodev->func[func]);
+			sdio_writeb(sdiodev->func[func], *byte, regaddr,
 				    &err_ret);
-			sdio_release_host(gInstance->func[func]);
+			sdio_release_host(sdiodev->func[func]);
 		}
 	} else {		/* CMD52 Read */
 		/* Claim host controller, perform Fn read, and release */
-		sdio_claim_host(gInstance->func[func]);
+		sdio_claim_host(sdiodev->func[func]);
 
 		if (func == 0) {
 			*byte =
-			    sdio_f0_readb(gInstance->func[func], regaddr,
+			    sdio_f0_readb(sdiodev->func[func], regaddr,
 					  &err_ret);
 		} else {
 			*byte =
-			    sdio_readb(gInstance->func[func], regaddr,
+			    sdio_readb(sdiodev->func[func], regaddr,
 				       &err_ret);
 		}
 
-		sdio_release_host(gInstance->func[func]);
+		sdio_release_host(sdiodev->func[func]);
 	}
 
 	if (err_ret)
@@ -557,17 +546,17 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 	BRCMF_INFO(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		 __func__, cmd_type, rw, func, addr, nbytes));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, gInstance);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, sdiodev);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 	/* Claim host controller */
-	sdio_claim_host(gInstance->func[func]);
+	sdio_claim_host(sdiodev->func[func]);
 
 	if (rw) {		/* CMD52 Write */
 		if (nbytes == 4)
-			sdio_writel(gInstance->func[func], *word, addr,
+			sdio_writel(sdiodev->func[func], *word, addr,
 				    &err_ret);
 		else if (nbytes == 2)
-			sdio_writew(gInstance->func[func], (*word & 0xFFFF),
+			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
 				    addr, &err_ret);
 		else
 			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
@@ -575,10 +564,10 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 	} else {		/* CMD52 Read */
 		if (nbytes == 4)
 			*word =
-			    sdio_readl(gInstance->func[func], addr, &err_ret);
+			    sdio_readl(sdiodev->func[func], addr, &err_ret);
 		else if (nbytes == 2)
 			*word =
-			    sdio_readw(gInstance->func[func], addr,
+			    sdio_readw(sdiodev->func[func], addr,
 				       &err_ret) & 0xFFFF;
 		else
 			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
@@ -586,7 +575,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 	}
 
 	/* Release host controller */
-	sdio_release_host(gInstance->func[func]);
+	sdio_release_host(sdiodev->func[func]);
 
 	if (err_ret)
 		BRCMF_ERROR(("brcmf: Failed to %s word, Err: 0x%08x\n",
@@ -608,30 +597,30 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, gInstance);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, sdiodev);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 
 	/* Claim host controller */
-	sdio_claim_host(gInstance->func[func]);
+	sdio_claim_host(sdiodev->func[func]);
 	for (pnext = pkt; pnext; pnext = pnext->next) {
 		uint pkt_len = pnext->len;
 		pkt_len += 3;
 		pkt_len &= 0xFFFFFFFC;
 
 		if ((write) && (!fifo)) {
-			err_ret = sdio_memcpy_toio(gInstance->func[func], addr,
+			err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
 						   ((u8 *) (pnext->data)),
 						   pkt_len);
 		} else if (write) {
-			err_ret = sdio_memcpy_toio(gInstance->func[func], addr,
+			err_ret = sdio_memcpy_toio(sdiodev->func[func], addr,
 						   ((u8 *) (pnext->data)),
 						   pkt_len);
 		} else if (fifo) {
-			err_ret = sdio_readsb(gInstance->func[func],
+			err_ret = sdio_readsb(sdiodev->func[func],
 					      ((u8 *) (pnext->data)),
 					      addr, pkt_len);
 		} else {
-			err_ret = sdio_memcpy_fromio(gInstance->func[func],
+			err_ret = sdio_memcpy_fromio(sdiodev->func[func],
 						     ((u8 *) (pnext->data)),
 						     addr, pkt_len);
 		}
@@ -655,7 +644,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 	}
 
 	/* Release host controller */
-	sdio_release_host(gInstance->func[func]);
+	sdio_release_host(sdiodev->func[func]);
 
 	BRCMF_TRACE(("%s: Exit\n", __func__));
 	return err_ret;
@@ -687,8 +676,8 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, gInstance);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, sdiodev);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
 		BRCMF_DATA(("%s: Creating new %s Packet, len=%d\n",
@@ -795,11 +784,11 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 
 	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
 
-	sdio_release_host(gInstance->func[0]);
+	sdio_release_host(func);
 
 	brcmf_sdbrcm_isr(sdiodev->bus);
 
-	sdio_claim_host(gInstance->func[0]);
+	sdio_claim_host(func);
 }
 
 /* interrupt handler for F2 (dummy handler) */
@@ -812,7 +801,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			      const struct sdio_device_id *id)
 {
 	int ret = 0;
-	static struct sdio_func sdio_func_0;
 	struct brcmf_sdio_dev *sdiodev;
 	BRCMF_TRACE(("sdio_probe: %s Enter\n", __func__));
 	BRCMF_TRACE(("sdio_probe: func->class=%x\n", func->class));
@@ -821,10 +809,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	BRCMF_TRACE(("Function#: 0x%04x\n", func->num));
 
 	if (func->num == 1) {
-		sdio_func_0.num = 0;
-		sdio_func_0.card = func->card;
-		gInstance->func[0] = &sdio_func_0;
-
 		if (dev_get_drvdata(&func->card->dev)) {
 			BRCMF_ERROR(("%s: card private drvdata occupied.\n",
 				     __func__));
@@ -833,19 +817,18 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
 		if (!sdiodev)
 			return -ENOMEM;
-		sdiodev->func1 = func;
+		sdiodev->func[0] = func->card->sdio_func[0];
+		sdiodev->func[1] = func;
 		dev_set_drvdata(&func->card->dev, sdiodev);
 
-		atomic_set(&gInstance->suspend, false);
+		atomic_set(&sdiodev->suspend, false);
 	}
 
-	gInstance->func[func->num] = func;
-
 	if (func->num == 2) {
 		sdiodev = dev_get_drvdata(&func->card->dev);
-		if ((!sdiodev) || (sdiodev->func1->card != func->card))
+		if ((!sdiodev) || (sdiodev->func[1]->card != func->card))
 			return -ENODEV;
-		sdiodev->func2 = func;
+		sdiodev->func[2] = func;
 
 		brcmf_cfg80211_sdio_func(func);
 		BRCMF_TRACE(("F2 found, calling brcmf_sdio_probe...\n"));
@@ -884,21 +867,22 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 	BRCMF_TRACE(("%s\n", __func__));
 
-	atomic_set(&gInstance->suspend, true);
+	sdiodev = dev_get_drvdata(&func->card->dev);
+
+	atomic_set(&sdiodev->suspend, true);
 
-	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
+	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
 		BRCMF_ERROR(("Host can't keep power while suspended\n"));
 		return -EINVAL;
 	}
 
-	ret = sdio_set_host_pm_flags(gInstance->func[1], MMC_PM_KEEP_POWER);
+	ret = sdio_set_host_pm_flags(sdiodev->func[1], MMC_PM_KEEP_POWER);
 	if (ret) {
 		BRCMF_ERROR(("Failed to set pm_flags\n"));
 		return ret;
 	}
 
-	sdiodev = dev_get_drvdata(&func->card->dev);
 	brcmf_sdio_wdtmr_enable(sdiodev, false);
 
 	return ret;
@@ -911,7 +895,7 @@ static int brcmf_sdio_resume(struct device *dev)
 
 	sdiodev = dev_get_drvdata(&func->card->dev);
 	brcmf_sdio_wdtmr_enable(sdiodev, true);
-	atomic_set(&gInstance->suspend, false);
+	atomic_set(&sdiodev->suspend, false);
 	return 0;
 }
 #endif		/* CONFIG_PM_SLEEP */
@@ -924,10 +908,6 @@ int brcmf_sdio_function_init(void)
 	int error = 0;
 	BRCMF_TRACE(("brcmf_sdio_function_init: %s Enter\n", __func__));
 
-	gInstance = kzalloc(sizeof(struct brcmf_sdmmc_instance), GFP_KERNEL);
-	if (!gInstance)
-		return -ENOMEM;
-
 	error = sdio_register_driver(&brcmf_sdmmc_driver);
 
 	return error;
@@ -941,6 +921,4 @@ void brcmf_sdio_function_cleanup(void)
 	BRCMF_TRACE(("%s Enter\n", __func__));
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
-
-	kfree(gInstance);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6e1fe5c..85ce5d9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
+#include <linux/mmc/card.h>
 #include <linux/semaphore.h>
 #include <linux/firmware.h>
 #include <asm/unaligned.h>
@@ -5685,7 +5686,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
 	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func2->cur_blksize;
+	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
 	/* Query if bus module supports packet chaining,
@@ -5828,7 +5829,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 
 	bus->fw_name = BCM4329_FW_NAME;
 	ret = request_firmware(&bus->firmware, bus->fw_name,
-			       &gInstance->func[2]->dev);
+			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		BRCMF_ERROR(("%s: Fail to request firmware %d\n",
 			     __func__, ret));
@@ -5930,7 +5931,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 
 	bus->nv_name = BCM4329_NV_NAME;
 	ret = request_firmware(&bus->firmware, bus->nv_name,
-			       &gInstance->func[2]->dev);
+			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		BRCMF_ERROR(("%s: Fail to request nvram %d\n", __func__, ret));
 		return ret;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index dc95c4d..4296c93 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -122,20 +122,14 @@ struct brcmf_sdreg {
 	int value;
 };
 
-struct brcmf_sdmmc_instance {
-	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
-	u32 host_claimed;
-	atomic_t suspend;	/* suspend flag */
-};
-
 struct brcmf_sdio_dev {
-	struct sdio_func *func1;
-	struct sdio_func *func2;
+	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
 	u32 sbwad;			/* Save backplane window address */
 	bool regfail;			/* status of last reg_r/w call */
 	void *bus;
+	atomic_t suspend;		/* suspend flag */
 };
 
 /* Register/deregister device interrupt handler. */
@@ -253,10 +247,8 @@ extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev);
 
-extern int
-brcmf_sdioh_interrupt_register(void);
-
-extern int brcmf_sdioh_interrupt_deregister(void);
+extern int brcmf_sdioh_interrupt_register(struct brcmf_sdio_dev *sdiodev);
+extern int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev);
 
 /* read or write one byte using cmd52 */
 extern int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
@@ -298,8 +290,6 @@ extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 
 extern uint sd_f2_blocksize;
 
-extern struct brcmf_sdmmc_instance *gInstance;
-
 extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 				u32 regsva, struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
-- 
1.7.4.1



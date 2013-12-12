Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30964 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3LLK7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:15 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/18] brcmfmac: remove unnecessary function prototypes
Date: Thu, 12 Dec 2013 11:58:51 +0100
Message-ID: <1386845946-9859-4-git-send-email-arend@broadcom.com> (sfid-20131212_115923_217980_8DB3A53B)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the merge of bcmsdh.c and bcmsdh_mmc.c several function prototypes
are no longer necessary and can be removed. Consequence is reordering
some of the functions.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  467 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   27 --
 2 files changed, 231 insertions(+), 263 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 91ce875..f22c798 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -47,6 +47,12 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
+#define SDIO_VENDOR_ID_BROADCOM		0x02d0
+
+#define DMA_ALIGN_MASK	0x03
+
+#define SDIO_FUNC1_BLOCKSIZE		64
+#define SDIO_FUNC2_BLOCKSIZE		512
 
 static irqreturn_t brcmf_sdio_oob_irqhandler(int irq, void *dev_id)
 {
@@ -83,6 +89,25 @@ static void brcmf_sdio_dummy_irqhandler(struct sdio_func *func)
 {
 }
 
+static bool brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
+{
+	bool is_err = false;
+#ifdef CONFIG_PM_SLEEP
+	is_err = atomic_read(&sdiodev->suspend);
+#endif
+	return is_err;
+}
+
+static void brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
+				 wait_queue_head_t *wq)
+{
+#ifdef CONFIG_PM_SLEEP
+	int retry = 0;
+	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
+		wait_event_timeout(*wq, false, HZ/100);
+#endif
+}
+
 int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
@@ -169,6 +194,144 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
+static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
+					    uint regaddr, u8 *byte)
+{
+	struct sdio_func *sdfunc = sdiodev->func[0];
+	int err_ret;
+
+	/*
+	 * Can only directly write to some F0 registers.
+	 * Handle F2 enable/disable and Abort command
+	 * as a special case.
+	 */
+	if (regaddr == SDIO_CCCR_IOEx) {
+		sdfunc = sdiodev->func[2];
+		if (sdfunc) {
+			if (*byte & SDIO_FUNC_ENABLE_2) {
+				/* Enable Function 2 */
+				err_ret = sdio_enable_func(sdfunc);
+				if (err_ret)
+					brcmf_err("enable F2 failed:%d\n",
+						  err_ret);
+			} else {
+				/* Disable Function 2 */
+				err_ret = sdio_disable_func(sdfunc);
+				if (err_ret)
+					brcmf_err("Disable F2 failed:%d\n",
+						  err_ret);
+			}
+		} else {
+			err_ret = -ENOENT;
+		}
+	} else if ((regaddr == SDIO_CCCR_ABORT) ||
+		   (regaddr == SDIO_CCCR_IENx)) {
+		sdfunc = kmemdup(sdiodev->func[0], sizeof(struct sdio_func),
+				 GFP_KERNEL);
+		if (!sdfunc)
+			return -ENOMEM;
+		sdfunc->num = 0;
+		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
+		kfree(sdfunc);
+	} else if (regaddr < 0xF0) {
+		brcmf_err("F0 Wr:0x%02x: write disallowed\n", regaddr);
+		err_ret = -EPERM;
+	} else {
+		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
+	}
+
+	return err_ret;
+}
+
+static int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
+				    uint func, uint regaddr, u8 *byte)
+{
+	int err_ret;
+
+	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
+
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
+
+	if (rw && func == 0) {
+		/* handle F0 separately */
+		err_ret = brcmf_sdioh_f0_write_byte(sdiodev, regaddr, byte);
+	} else {
+		if (rw) /* CMD52 Write */
+			sdio_writeb(sdiodev->func[func], *byte, regaddr,
+				    &err_ret);
+		else if (func == 0) {
+			*byte = sdio_f0_readb(sdiodev->func[func], regaddr,
+					      &err_ret);
+		} else {
+			*byte = sdio_readb(sdiodev->func[func], regaddr,
+					   &err_ret);
+		}
+	}
+
+	if (err_ret) {
+		/*
+		 * SleepCSR register access can fail when
+		 * waking up the device so reduce this noise
+		 * in the logs.
+		 */
+		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
+			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+				  rw ? "write" : "read", func, regaddr, *byte,
+				  err_ret);
+		else
+			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+				  rw ? "write" : "read", func, regaddr, *byte,
+				  err_ret);
+	}
+	return err_ret;
+}
+
+static int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
+				    uint func, uint addr, u32 *word,
+				    uint nbytes)
+{
+	int err_ret = -EIO;
+
+	if (func == 0) {
+		brcmf_err("Only CMD52 allowed to F0\n");
+		return -EINVAL;
+	}
+
+	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+		  rw, func, addr, nbytes);
+
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
+
+	if (rw) {		/* CMD52 Write */
+		if (nbytes == 4)
+			sdio_writel(sdiodev->func[func], *word, addr,
+				    &err_ret);
+		else if (nbytes == 2)
+			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
+				    addr, &err_ret);
+		else
+			brcmf_err("Invalid nbytes: %d\n", nbytes);
+	} else {		/* CMD52 Read */
+		if (nbytes == 4)
+			*word = sdio_readl(sdiodev->func[func], addr, &err_ret);
+		else if (nbytes == 2)
+			*word = sdio_readw(sdiodev->func[func], addr,
+					   &err_ret) & 0xFFFF;
+		else
+			brcmf_err("Invalid nbytes: %d\n", nbytes);
+	}
+
+	if (err_ret)
+		brcmf_err("Failed to %s word, Err: 0x%08x\n",
+			  rw ? "write" : "read", err_ret);
+
+	return err_ret;
+}
+
 static int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
@@ -757,237 +920,6 @@ int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	return 0;
 }
 
-int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
-{
-	u32 regs = 0;
-	int ret = 0;
-
-	ret = brcmf_sdioh_attach(sdiodev);
-	if (ret)
-		goto out;
-
-	regs = SI_ENUM_BASE;
-
-	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
-	if (!sdiodev->bus) {
-		brcmf_err("device attach failed\n");
-		ret = -ENODEV;
-		goto out;
-	}
-
-out:
-	if (ret)
-		brcmf_sdio_remove(sdiodev);
-
-	return ret;
-}
-
-int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
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
-void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
-{
-	if (enable)
-		brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
-	else
-		brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
-}
-
-#define SDIO_VENDOR_ID_BROADCOM		0x02d0
-
-#define DMA_ALIGN_MASK	0x03
-
-#define SDIO_FUNC1_BLOCKSIZE		64
-#define SDIO_FUNC2_BLOCKSIZE		512
-
-/* devices we support, null terminated */
-static const struct sdio_device_id brcmf_sdmmc_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43143)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
-		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
-	{ /* end: all zeroes */ },
-};
-MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
-
-static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
-
-
-bool
-brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
-{
-	bool is_err = false;
-#ifdef CONFIG_PM_SLEEP
-	is_err = atomic_read(&sdiodev->suspend);
-#endif
-	return is_err;
-}
-
-void
-brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
-{
-#ifdef CONFIG_PM_SLEEP
-	int retry = 0;
-	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
-		wait_event_timeout(*wq, false, HZ/100);
-#endif
-}
-
-static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
-					    uint regaddr, u8 *byte)
-{
-	struct sdio_func *sdfunc = sdiodev->func[0];
-	int err_ret;
-
-	/*
-	 * Can only directly write to some F0 registers.
-	 * Handle F2 enable/disable and Abort command
-	 * as a special case.
-	 */
-	if (regaddr == SDIO_CCCR_IOEx) {
-		sdfunc = sdiodev->func[2];
-		if (sdfunc) {
-			if (*byte & SDIO_FUNC_ENABLE_2) {
-				/* Enable Function 2 */
-				err_ret = sdio_enable_func(sdfunc);
-				if (err_ret)
-					brcmf_err("enable F2 failed:%d\n",
-						  err_ret);
-			} else {
-				/* Disable Function 2 */
-				err_ret = sdio_disable_func(sdfunc);
-				if (err_ret)
-					brcmf_err("Disable F2 failed:%d\n",
-						  err_ret);
-			}
-		} else {
-			err_ret = -ENOENT;
-		}
-	} else if ((regaddr == SDIO_CCCR_ABORT) ||
-		   (regaddr == SDIO_CCCR_IENx)) {
-		sdfunc = kmemdup(sdiodev->func[0], sizeof(struct sdio_func),
-				 GFP_KERNEL);
-		if (!sdfunc)
-			return -ENOMEM;
-		sdfunc->num = 0;
-		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
-		kfree(sdfunc);
-	} else if (regaddr < 0xF0) {
-		brcmf_err("F0 Wr:0x%02x: write disallowed\n", regaddr);
-		err_ret = -EPERM;
-	} else {
-		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
-	}
-
-	return err_ret;
-}
-
-int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
-			     uint regaddr, u8 *byte)
-{
-	int err_ret;
-
-	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
-
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
-	if (brcmf_pm_resume_error(sdiodev))
-		return -EIO;
-
-	if (rw && func == 0) {
-		/* handle F0 separately */
-		err_ret = brcmf_sdioh_f0_write_byte(sdiodev, regaddr, byte);
-	} else {
-		if (rw) /* CMD52 Write */
-			sdio_writeb(sdiodev->func[func], *byte, regaddr,
-				    &err_ret);
-		else if (func == 0) {
-			*byte = sdio_f0_readb(sdiodev->func[func], regaddr,
-					      &err_ret);
-		} else {
-			*byte = sdio_readb(sdiodev->func[func], regaddr,
-					   &err_ret);
-		}
-	}
-
-	if (err_ret) {
-		/*
-		 * SleepCSR register access can fail when
-		 * waking up the device so reduce this noise
-		 * in the logs.
-		 */
-		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
-				  rw ? "write" : "read", func, regaddr, *byte,
-				  err_ret);
-		else
-			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
-				  rw ? "write" : "read", func, regaddr, *byte,
-				  err_ret);
-	}
-	return err_ret;
-}
-
-int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
-			     uint rw, uint func, uint addr, u32 *word,
-			     uint nbytes)
-{
-	int err_ret = -EIO;
-
-	if (func == 0) {
-		brcmf_err("Only CMD52 allowed to F0\n");
-		return -EINVAL;
-	}
-
-	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
-		  rw, func, addr, nbytes);
-
-	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
-	if (brcmf_pm_resume_error(sdiodev))
-		return -EIO;
-
-	if (rw) {		/* CMD52 Write */
-		if (nbytes == 4)
-			sdio_writel(sdiodev->func[func], *word, addr,
-				    &err_ret);
-		else if (nbytes == 2)
-			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
-				    addr, &err_ret);
-		else
-			brcmf_err("Invalid nbytes: %d\n", nbytes);
-	} else {		/* CMD52 Read */
-		if (nbytes == 4)
-			*word = sdio_readl(sdiodev->func[func], addr, &err_ret);
-		else if (nbytes == 2)
-			*word = sdio_readw(sdiodev->func[func], addr,
-					   &err_ret) & 0xFFFF;
-		else
-			brcmf_err("Invalid nbytes: %d\n", nbytes);
-	}
-
-	if (err_ret)
-		brcmf_err("Failed to %s word, Err: 0x%08x\n",
-			  rw ? "write" : "read", err_ret);
-
-	return err_ret;
-}
-
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
@@ -1042,10 +974,7 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	return false;
 }
 
-/*
- *	Public entry points & extern's
- */
-int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
+static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret = 0;
 	struct mmc_host *host;
@@ -1092,7 +1021,7 @@ out:
 	return err_ret;
 }
 
-void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
+static void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(SDIO, "\n");
 
@@ -1108,6 +1037,64 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
+static int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
+{
+	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+
+	if (sdiodev->bus) {
+		brcmf_sdbrcm_disconnect(sdiodev->bus);
+		sdiodev->bus = NULL;
+	}
+
+	brcmf_sdioh_detach(sdiodev);
+
+	sdiodev->sbwad = 0;
+
+	return 0;
+}
+
+static int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
+{
+	u32 regs = 0;
+	int ret = 0;
+
+	ret = brcmf_sdioh_attach(sdiodev);
+	if (ret)
+		goto out;
+
+	regs = SI_ENUM_BASE;
+
+	/* try to attach to the target device */
+	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
+	if (!sdiodev->bus) {
+		brcmf_err("device attach failed\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+out:
+	if (ret)
+		brcmf_sdio_remove(sdiodev);
+
+	return ret;
+}
+
+/* devices we support, null terminated */
+static const struct sdio_device_id brcmf_sdmmc_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43143)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
+		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
+	{ /* end: all zeroes */ },
+};
+MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
+
+static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
+
+
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 				const struct sdio_device_id *id)
 {
@@ -1201,6 +1188,14 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
+{
+	if (enable)
+		brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
+	else
+		brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
+}
+
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index fc0d4f0..c1dfa97 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -236,43 +236,16 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
  *   nbytes:   number of bytes to transfer to/from buf
  * Returns 0 or error code.
  */
-int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
-			u8 *buf, uint nbytes);
 int brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		     u8 *data, uint size);
 
 /* Issue an abort to the specified function */
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
-/* platform specific/high level functions */
-int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
-int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
-
-/* attach, return handler on success, NULL if failed.
- *  The handler shall be provided by all subsequent calls. No local cache
- *  cfghdl points to the starting address of pci device mapped memory
- */
-int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev);
-void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev);
-
-/* read or write one byte using cmd52 */
-int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint fnc,
-			     uint addr, u8 *byte);
-
-/* read or write 2/4 bytes using cmd53 */
-int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw, uint fnc,
-			     uint addr, u32 *word, uint nbyte);
-
-/* Watchdog timer interface for pm ops */
-void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable);
-
 void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdbrcm_disconnect(void *ptr);
 void brcmf_sdbrcm_isr(void *arg);
 
 void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 
-void brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev,
-			  wait_queue_head_t *wq);
-bool brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4


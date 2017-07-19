Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59682 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755301AbdGSTN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:13:27 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 12/34] brcmfmac: Replace old IO functions with simpler ones.
Date: Wed, 19 Jul 2017 20:08:00 +0100
Message-Id: <20170719190822.10857-13-ian@mnementh.co.uk> (sfid-20170719_211332_994694_6E264195)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Primarily this patch removes:

brcmf_sdiod_f0_writeb()
brcmf_sdiod_reg_write()
brcmf_sdiod_reg_read()

Since we no longer use the quirky method of deciding which function to
address via the address being accessed, take the opportunity to rename
some IO functions more in line with common kernel code.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 165 +++------------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 157 +++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  27 ++--
 3 files changed, 111 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 013b9b852d81..13f20b58d34e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -137,27 +137,25 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
 			/* assign GPIO to SDIO core */
 			addr = CORE_CC_REG(SI_ENUM_BASE, gpiocontrol);
-			gpiocontrol = brcmf_sdiod_regrl(sdiodev, addr, &ret);
+			gpiocontrol = brcmf_sdiod_readl(sdiodev, addr, &ret);
 			gpiocontrol |= 0x2;
-			brcmf_sdiod_regwl(sdiodev, addr, gpiocontrol, &ret);
+			brcmf_sdiod_writel(sdiodev, addr, gpiocontrol, &ret);
 
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_SELECT, 0xf,
-					  &ret);
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_GPIO_SELECT, 0xf, &ret);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
 		}
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
-		data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
+		data = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
 		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
+		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
 		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
 			data |= SDIO_SEPINT_ACT_HI;
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
-
+		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 		sdio_release_host(sdiodev->func[1]);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
@@ -183,8 +181,8 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 
 		pdata = &sdiodev->settings->bus.sdio;
 		sdio_claim_host(sdiodev->func[1]);
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
+		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
+		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 		sdio_release_host(sdiodev->func[1]);
 
 		sdiodev->oob_irq_requested = false;
@@ -242,7 +240,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
 
 	for ( i = 0 ; i < 3 && !err ; i++, addr >>= 8 )
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
 					&err);
 
 	return err;
@@ -268,124 +266,15 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 	return 0;
 }
 
-static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte, uint regaddr)
-{
-	int err_ret;
-
-	/*
-	 * Can only directly write to some F0 registers.
-	 * Handle CCCR_IENx and CCCR_ABORT command
-	 * as a special case.
-	 */
-	if ((regaddr == SDIO_CCCR_ABORT) ||
-	    (regaddr == SDIO_CCCR_IENx))
-		sdio_writeb(func, byte, regaddr, &err_ret);
-	else
-		sdio_f0_writeb(func, byte, regaddr, &err_ret);
-
-	return err_ret;
-}
-
-static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				   u8 regsz, void *data)
-{
-	int ret;
-
-	/*
-	 * figure out how to read the register based on address range
-	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
-	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
-	 * The rest: function 1 silicon backplane core registers
-	 * f0 writes must be bytewise
-	 */
-
-	if ((addr & ~REG_F0_REG_MASK) == 0) {
-		if (WARN_ON(regsz > 1))
-			return -EINVAL;
-		ret = brcmf_sdiod_f0_writeb(sdiodev->func[0], *(u8 *)data, addr);
-	}
-	else {
-		switch (regsz) {
-			case 1:
-				sdio_writeb(sdiodev->func[1], *(u8 *)data, addr, &ret);
-				break;
-			case 4:
-				ret = brcmf_sdiod_addrprep(sdiodev, &addr);
-				if (ret)
-					goto done;
-
-				sdio_writel(sdiodev->func[1], *(u32 *)data, addr, &ret);
-				break;
-			default:
-				BUG();
-				ret = -EINVAL;
-				break;
-		}
-	}
-
-done:
-	return ret;
-}
-
-static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				   u8 regsz, void *data)
-{
-	int ret;
-
-	/*
-	 * figure out how to read the register based on address range
-	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
-	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
-	 * The rest: function 1 silicon backplane core registers
-	 * f0 reads must be bytewise
-	 */
-	if ((addr & ~REG_F0_REG_MASK) == 0) {
-		if (WARN_ON(regsz > 1))
-			return -EINVAL;
-		*(u8 *)data = sdio_f0_readb(sdiodev->func[0], addr, &ret);
-	}
-	else {
-		switch (regsz) {
-			case 1:
-				*(u8 *)data = sdio_readb(sdiodev->func[1], addr, &ret);
-				break;
-			case 4:
-				ret = brcmf_sdiod_addrprep(sdiodev, &addr);
-				if (ret)
-					goto done;
-
-				*(u32 *)data = sdio_readl(sdiodev->func[1], addr, &ret);
-				break;
-			default:
-				BUG();
-				ret = -EINVAL;
-				break;
-		}
-	}
-
-done:
-	return ret;
-}
-
-u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
-{
-	u8 data = 0;
-	int retval;
-
-	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
-
-	if (ret)
-		*ret = retval;
-
-	return data;
-}
-
-u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
+u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
 	u32 data = 0;
 	int retval;
 
-	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
+
+	if (!retval)
+		data = sdio_readl(sdiodev->func[1], addr, &retval);
 
 	if (ret)
 		*ret = retval;
@@ -393,23 +282,15 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	return data;
 }
 
-void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
-		      u8 data, int *ret)
-{
-	int retval;
-
-	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
-
-	if (ret)
-		*ret = retval;
-}
-
-void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
+void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		      u32 data, int *ret)
 {
 	int retval;
 
-	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
+
+	if (!retval)
+		sdio_writel(sdiodev->func[1], data, addr, &retval);
 
 	if (ret)
 		*ret = retval;
@@ -848,8 +729,8 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
-	/* issue abort cmd52 command through F0 */
-	brcmf_sdiod_reg_write(sdiodev, SDIO_CCCR_ABORT, 1, &fn);
+	/* Issue abort cmd52 command through F0 */
+	brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_ABORT, fn, NULL);
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fbcbb4325936..152905e985d2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -666,7 +666,7 @@ static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 	int ret;
 
 	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
-	*regvar = brcmf_sdiod_regrl(bus->sdiodev, core->base + offset, &ret);
+	*regvar = brcmf_sdiod_readl(bus->sdiodev, core->base + offset, &ret);
 
 	return ret;
 }
@@ -677,7 +677,7 @@ static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 	int ret;
 
 	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
-	brcmf_sdiod_regwl(bus->sdiodev, core->base + reg_offset, regval, &ret);
+	brcmf_sdiod_writel(bus->sdiodev, core->base + reg_offset, regval, &ret);
 
 	return ret;
 }
@@ -694,8 +694,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-			  wr_val, &err);
+	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
 
 	if (on) {
 		/* device WAKEUP through KSO:
@@ -721,8 +720,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		 * just one write attempt may fail,
 		 * read it back until it matches written value
 		 */
-		rd_val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-					   &err);
+		rd_val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 		if (!err) {
 			if ((rd_val & bmask) == cmp_val)
 				break;
@@ -732,8 +730,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		if (err && (err_cnt++ > BRCMF_SDIO_MAX_ACCESS_ERRORS))
 			break;
 		udelay(KSO_WAIT_US);
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-				  wr_val, &err);
+		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
 
 	if (try_cnt > 2)
@@ -769,16 +766,14 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  clkreq, &err);
+		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
 			brcmf_err("HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
-					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_err("HT Avail read error: %d\n", err);
 			return -EBADE;
@@ -787,8 +782,8 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+							&err);
 			if (err) {
 				brcmf_err("Devctl error setting CA: %d\n",
 					  err);
@@ -796,26 +791,26 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					  devctl, &err);
+			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL, devctl,
+						&err);
 			brcmf_dbg(SDIO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+							&err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					  devctl, &err);
+			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL, devctl,
+						&err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+			clkctl = brcmf_sdiod_readb(bus->sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if (time_after(jiffies, timeout))
@@ -849,16 +844,15 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+							&err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					  devctl, &err);
+			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL, devctl,
+						&err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  clkreq, &err);
+		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
 			brcmf_err("Failed access turning clock off: %d\n",
@@ -948,12 +942,12 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 
 		/* Going to sleep */
 		if (sleep) {
-			clkcsr = brcmf_sdiod_regrb(bus->sdiodev,
+			clkcsr = brcmf_sdiod_readb(bus->sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if ((clkcsr & SBSDIO_CSR_MASK) == 0) {
 				brcmf_dbg(SDIO, "no clock, set ALP\n");
-				brcmf_sdiod_regwb(bus->sdiodev,
+				brcmf_sdiod_writeb(bus->sdiodev,
 						  SBSDIO_FUNC1_CHIPCLKCSR,
 						  SBSDIO_ALP_AVAIL_REQ, &err);
 			}
@@ -1170,16 +1164,13 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	if (abort)
 		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
 
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-			  SFC_RF_TERM, &err);
+	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdiod_regrb(bus->sdiodev,
-				       SBSDIO_FUNC1_RFRAMEBCHI, &err);
-		lo = brcmf_sdiod_regrb(bus->sdiodev,
-				       SBSDIO_FUNC1_RFRAMEBCLO, &err);
+		hi = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_RFRAMEBCHI, &err);
+		lo = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_RFRAMEBCLO, &err);
 		bus->sdcnt.f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -1221,12 +1212,12 @@ static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 	bus->sdcnt.tx_sderrs++;
 
 	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
 	for (i = 0; i < 3; i++) {
-		hi = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-		lo = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCLO, NULL);
+		hi = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+		lo = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 		bus->sdcnt.f1regdata += 2;
 		if ((hi == 0) && (lo == 0))
 			break;
@@ -2437,10 +2428,10 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		bus->hostintmask = 0;
 
 		/* Force backplane clocks to assure F2 interrupt propagates */
-		saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		saveclk = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					    &err);
 		if (!err)
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					  (saveclk | SBSDIO_FORCE_HT), &err);
 		if (err)
 			brcmf_err("Failed to force clock for F2: err %d\n",
@@ -2500,7 +2491,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
 
-	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
+	val = brcmf_sdiod_readl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
 		return ret;
@@ -2510,7 +2501,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 	/* Clear interrupts */
 	if (val) {
-		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
+		brcmf_sdiod_writel(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
 		atomic_or(val, &bus->intstatus);
 	}
@@ -2536,23 +2527,21 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 #ifdef DEBUG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdiod_regrb(bus->sdiodev,
-					   SBSDIO_DEVICE_CTL, &err);
+		devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL, &err);
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
-					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 		brcmf_dbg(SDIO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
-						   SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+							&err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-					  devctl, &err);
+			brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_DEVICE_CTL, devctl,
+						&err);
 			bus->clkstate = CLK_AVAIL;
 		}
 	}
@@ -3338,21 +3327,21 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
+	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
+	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	/* Add CMD14 Support */
-	brcmf_sdiod_regwb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
+	brcmf_sdiod_func0_wb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
 			  (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
 			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
 			  &err);
@@ -3361,8 +3350,8 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 		return;
 	}
 
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			  SBSDIO_FORCE_HT, &err);
+	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, SBSDIO_FORCE_HT,
+				&err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
@@ -3385,7 +3374,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12)
 		return 0;
 
-	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
+	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
 		return err;
@@ -3394,8 +3383,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (!(val & SBSDIO_FUNC1_SLEEPCSR_KSO_MASK)) {
 		val |= (SBSDIO_FUNC1_SLEEPCSR_KSO_EN <<
 			SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
-				  val, &err);
+		brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, val, &err);
 		if (err) {
 			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
 			return err;
@@ -3556,7 +3544,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 				u8 devpend;
 
 				sdio_claim_host(bus->sdiodev->func[1]);
-				devpend = brcmf_sdiod_regrb(bus->sdiodev,
+				devpend = brcmf_sdiod_func0_rb(bus->sdiodev,
 							    SDIO_CCCR_INTx,
 							    NULL);
 				sdio_release_host(bus->sdiodev->func[1]);
@@ -3696,12 +3684,12 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			}
 		}
 		addr = CORE_CC_REG(pmu->base, chipcontrol_addr);
-		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
-		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
+		brcmf_sdiod_writel(sdiodev, addr, 1, NULL);
+		cc_data_temp = brcmf_sdiod_readl(sdiodev, addr, NULL);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdiod_regwl(sdiodev, addr, cc_data_temp, NULL);
+		brcmf_sdiod_writel(sdiodev, addr, cc_data_temp, NULL);
 
 		brcmf_dbg(INFO, "SDIO: %d mA (req=%d mA) drive strength selected, set to 0x%08x\n",
 			  str_tab[i].strength, drivestrength, cc_data_temp);
@@ -3716,7 +3704,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
 		brcmf_err("error writing for HT off\n");
 		return err;
@@ -3724,8 +3712,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdiod_regrb(sdiodev,
-				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+	clkval = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
 		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
@@ -3733,8 +3720,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 		return -EACCES;
 	}
 
-	SPINWAIT(((clkval = brcmf_sdiod_regrb(sdiodev,
-					      SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
+	SPINWAIT(((clkval = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
 	if (!SBSDIO_ALPAV(clkval)) {
@@ -3744,11 +3730,11 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 	}
 
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	udelay(65);
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
 	return 0;
 }
@@ -3763,7 +3749,7 @@ static void brcmf_sdio_buscore_activate(void *ctx, struct brcmf_chip *chip,
 	/* clear all interrupts */
 	core = brcmf_chip_get_core(chip, BCMA_CORE_SDIO_DEV);
 	reg_addr = core->base + offsetof(struct sdpcmd_regs, intstatus);
-	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+	brcmf_sdiod_writel(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
 	if (rstvec)
 		/* Write reset vector to address 0 */
@@ -3776,7 +3762,7 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	struct brcmf_sdio_dev *sdiodev = ctx;
 	u32 val, rev;
 
-	val = brcmf_sdiod_regrl(sdiodev, addr, NULL);
+	val = brcmf_sdiod_readl(sdiodev, addr, NULL);
 	if ((sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
 	     sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
 	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
@@ -3793,7 +3779,7 @@ static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
 {
 	struct brcmf_sdio_dev *sdiodev = ctx;
 
-	brcmf_sdiod_regwl(sdiodev, addr, val, NULL);
+	brcmf_sdiod_writel(sdiodev, addr, val, NULL);
 }
 
 static const struct brcmf_buscore_ops brcmf_sdio_buscore_ops = {
@@ -3817,18 +3803,16 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	sdio_claim_host(sdiodev->func[1]);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
-		 brcmf_sdiod_regrl(sdiodev, SI_ENUM_BASE, NULL));
+		 brcmf_sdiod_readl(sdiodev, SI_ENUM_BASE, NULL));
 
 	/*
 	 * Force PLL off until brcmf_chip_attach()
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			  BRCMF_INIT_CLKCTL1, &err);
+	brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
-		clkctl = brcmf_sdiod_regrb(sdiodev,
-					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
 		brcmf_err("ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
@@ -3888,25 +3872,25 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	brcmf_sdio_drivestrengthinit(sdiodev, bus->ci, drivestrength);
 
 	/* Set card control so an SDIO card reset does a WLAN backplane reset */
-	reg_val = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, &err);
+	reg_val = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, &err);
 	if (err)
 		goto fail;
 
 	reg_val |= SDIO_CCCR_BRCM_CARDCTRL_WLANRESET;
 
-	brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
+	brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
 	if (err)
 		goto fail;
 
 	/* set PMUControl so a backplane reset does PMU state reload */
 	reg_addr = CORE_CC_REG(brcmf_chip_get_pmu(bus->ci)->base, pmucontrol);
-	reg_val = brcmf_sdiod_regrl(sdiodev, reg_addr, &err);
+	reg_val = brcmf_sdiod_readl(sdiodev, reg_addr, &err);
 	if (err)
 		goto fail;
 
 	reg_val |= (BCMA_CC_PMU_CTL_RES_RELOAD << BCMA_CC_PMU_CTL_RES_SHIFT);
 
-	brcmf_sdiod_regwl(sdiodev, reg_addr, reg_val, &err);
+	brcmf_sdiod_writel(sdiodev, reg_addr, reg_val, &err);
 	if (err)
 		goto fail;
 
@@ -4027,9 +4011,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		goto release;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
@@ -4052,7 +4036,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		w_sdreg32(bus, bus->hostintmask,
 			  offsetof(struct sdpcmd_regs, hostintmask));
 
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_WATERMARK, 8, &err);
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
@@ -4063,8 +4047,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdio_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  saveclk, &err);
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 	}
 
 	if (err == 0) {
@@ -4204,7 +4187,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	sdio_release_host(bus->sdiodev->func[1]);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 1e4b4760159f..2f32c9270eaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -50,6 +50,7 @@
 #define SBSDIO_NUM_FUNCTION		3
 
 /* function 0 vendor specific CCCR registers */
+
 #define SDIO_CCCR_BRCM_CARDCAP			0xf0
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
@@ -131,8 +132,6 @@
 /* with b15, maps to 32-bit SB access */
 #define SBSDIO_SB_ACCESS_2_4B_FLAG	0x08000
 
-/* valid bits in SBSDIO_FUNC1_SBADDRxxx regs */
-
 /* Address bits from SBADDR regs */
 #define SBSDIO_SBWINDOW_MASK		0xffff8000
 
@@ -293,13 +292,23 @@ struct sdpcmd_regs {
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
-/* sdio device register access interface */
-u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr, u8 data,
-		       int *ret);
-void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
-		       int *ret);
+/* SDIO device register access interface */
+/* Functions for accessing SDIO Function 0 */
+#define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
+	sdio_readb((sdiodev)->func[0], (addr), (r))
+
+#define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
+	sdio_writeb((sdiodev)->func[0], (v), (addr), (ret))
+
+/* Functions for accessing SDIO Function 1 */
+#define brcmf_sdiod_readb(sdiodev, addr, r) \
+	sdio_readb((sdiodev)->func[1], (addr), (r))
+
+#define brcmf_sdiod_writeb(sdiodev, addr, v, ret) \
+	sdio_writeb((sdiodev)->func[1], (v), (addr), (ret))
+
+u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
+void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data, int *ret);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
-- 
2.11.0

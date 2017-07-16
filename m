Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46214 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:43:07 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 08/21] brcmfmac: Sanitise all byte-wise IO
Date: Sun, 16 Jul 2017 12:21:16 +0100
Message-Id: <20170716112129.10206-9-ian@mnementh.co.uk> (sfid-20170716_134313_013138_46466F52)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 181 +++------------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  96 +++++------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  19 ++-
 3 files changed, 83 insertions(+), 213 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 0d5004e18cb0..84ae67c11970 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -143,23 +143,22 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 			gpiocontrol |= 0x2;
 			brcmf_sdiod_regwl(sdiodev, addr, gpiocontrol, &ret);
 
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_SELECT, 0xf,
+			brcm_sdio_func1_wb(sdiodev, SBSDIO_GPIO_SELECT, 0xf,
 					  &ret);
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
+			brcm_sdio_func1_wb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
+			brcm_sdio_func1_wb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
 		}
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
-		data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
+		data = brcm_sdio_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
 		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
+		brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
 		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
 			data |= SDIO_SEPINT_ACT_HI;
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
-
+		brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 		sdio_release_host(sdiodev->func[1]);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
@@ -185,8 +184,8 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 
 		pdata = &sdiodev->settings->bus.sdio;
 		sdio_claim_host(sdiodev->func[1]);
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
-		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
+		brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
+		brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 		sdio_release_host(sdiodev->func[1]);
 
 		sdiodev->oob_irq_requested = false;
@@ -240,13 +239,11 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 
 	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
 
-	for (i = 0; i < 3; i++) {
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
-					&err);
-		if (err)
-			break;
-
+	for (i = 0 ; i < 3 && !err ; i++) {
+		u8 data = addr & 0xff;
 		addr = addr >> 8;
+
+		brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, data, &err);
 	}
 
 	return err;
@@ -278,117 +275,6 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
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
-#if 0
-	if (ret != 0) {
-		/*
-		 * SleepCSR register access can fail when
-		 * waking up the device so reduce this noise
-		 * in the logs.
-		 */
-		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to write data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-		else
-			brcmf_dbg(SDIO, "failed to write data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-	}
-#endif
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
 #if 0
 	if (ret != 0) {
 		/*
@@ -405,30 +291,15 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	}
 #endif
 
-done:
-	return ret;
-}
-
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
 u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
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
@@ -436,23 +307,15 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
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
 void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
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
@@ -890,12 +753,12 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	return err;
 }
 
-int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
-	brcmf_sdiod_f0_writeb(sdiodev->func[0], (u8)fn, SDIO_CCCR_ABORT);
+	brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_ABORT, fn, NULL);//FIXME we dont care about errors, right?
 
 
 	brcmf_dbg(SDIO, "Exit\n");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5653d6dd38f6..ce540625c29e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -691,7 +691,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+	brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 			  wr_val, &err);
 
 	if (on) {
@@ -718,7 +718,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		 * just one write attempt may fail,
 		 * read it back until it matches written value
 		 */
-		rd_val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+		rd_val = brcm_sdio_func1_rb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 					   &err);
 		if (!err) {
 			if ((rd_val & bmask) == cmp_val)
@@ -729,7 +729,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		if (err && (err_cnt++ > BRCMF_SDIO_MAX_ACCESS_ERRORS))
 			break;
 		udelay(KSO_WAIT_US);
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+		brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 				  wr_val, &err);
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
 
@@ -766,7 +766,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  clkreq, &err);
 		if (err) {
 			brcmf_err("HT Avail request error: %d\n", err);
@@ -774,7 +774,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+		clkctl = brcm_sdio_func1_rb(bus->sdiodev,
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_err("HT Avail read error: %d\n", err);
@@ -784,7 +784,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+			devctl = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				brcmf_err("Devctl error setting CA: %d\n",
@@ -793,7 +793,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+			brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					  devctl, &err);
 			brcmf_dbg(SDIO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
@@ -801,10 +801,10 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			return 0;
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+			devctl = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+			brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					  devctl, &err);
 		}
 
@@ -812,7 +812,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+			clkctl = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if (time_after(jiffies, timeout))
@@ -846,15 +846,15 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+			devctl = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+			brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					  devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  clkreq, &err);
 		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
@@ -945,12 +945,12 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 
 		/* Going to sleep */
 		if (sleep) {
-			clkcsr = brcmf_sdiod_regrb(bus->sdiodev,
+			clkcsr = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_FUNC1_CHIPCLKCSR,
 						   &err);
 			if ((clkcsr & SBSDIO_CSR_MASK) == 0) {
 				brcmf_dbg(SDIO, "no clock, set ALP\n");
-				brcmf_sdiod_regwb(bus->sdiodev,
+				brcm_sdio_func1_wb(bus->sdiodev,
 						  SBSDIO_FUNC1_CHIPCLKCSR,
 						  SBSDIO_ALP_AVAIL_REQ, &err);
 			}
@@ -1167,15 +1167,15 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	if (abort)
 		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
 
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+	brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
 			  SFC_RF_TERM, &err);
 	bus->sdcnt.f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdiod_regrb(bus->sdiodev,
+		hi = brcm_sdio_func1_rb(bus->sdiodev,
 				       SBSDIO_FUNC1_RFRAMEBCHI, &err);
-		lo = brcmf_sdiod_regrb(bus->sdiodev,
+		lo = brcm_sdio_func1_rb(bus->sdiodev,
 				       SBSDIO_FUNC1_RFRAMEBCLO, &err);
 		bus->sdcnt.f1regdata += 2;
 
@@ -1218,12 +1218,12 @@ static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 	bus->sdcnt.tx_sderrs++;
 
 	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
+	brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
 	bus->sdcnt.f1regdata++;
 
 	for (i = 0; i < 3; i++) {
-		hi = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-		lo = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCLO, NULL);
+		hi = brcm_sdio_func1_rb(sdiodev, SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+		lo = brcm_sdio_func1_rb(sdiodev, SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 		bus->sdcnt.f1regdata += 2;
 		if ((hi == 0) && (lo == 0))
 			break;
@@ -2431,10 +2431,10 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		bus->hostintmask = 0;
 
 		/* Force backplane clocks to assure F2 interrupt propagates */
-		saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		saveclk = brcm_sdio_func1_rb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					    &err);
 		if (!err)
-			brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					  (saveclk | SBSDIO_FORCE_HT), &err);
 		if (err)
 			brcmf_err("Failed to force clock for F2: err %d\n",
@@ -2530,22 +2530,22 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 #ifdef DEBUG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdiod_regrb(bus->sdiodev,
+		devctl = brcm_sdio_func1_rb(bus->sdiodev,
 					   SBSDIO_DEVICE_CTL, &err);
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
+		clkctl = brcm_sdio_func1_rb(bus->sdiodev,
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 		brcmf_dbg(SDIO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdiod_regrb(bus->sdiodev,
+			devctl = brcm_sdio_func1_rb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+			brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					  devctl, &err);
 			bus->clkstate = CLK_AVAIL;
 		}
@@ -3332,21 +3332,21 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
+	val = brcm_sdio_func1_rb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
+	brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	/* Add CMD14 Support */
-	brcmf_sdiod_regwb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
+	brcm_sdio_func0_wb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
 			  (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
 			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
 			  &err);
@@ -3355,7 +3355,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 		return;
 	}
 
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 			  SBSDIO_FORCE_HT, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
@@ -3379,7 +3379,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12)
 		return 0;
 
-	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
+	val = brcm_sdio_func1_rb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
 		return err;
@@ -3388,7 +3388,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	if (!(val & SBSDIO_FUNC1_SLEEPCSR_KSO_MASK)) {
 		val |= (SBSDIO_FUNC1_SLEEPCSR_KSO_EN <<
 			SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+		brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 				  val, &err);
 		if (err) {
 			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
@@ -3550,7 +3550,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 				u8 devpend;
 
 				sdio_claim_host(bus->sdiodev->func[1]);
-				devpend = brcmf_sdiod_regrb(bus->sdiodev,
+				devpend = brcm_sdio_func0_rb(bus->sdiodev,
 							    SDIO_CCCR_INTx,
 							    NULL);
 				sdio_release_host(bus->sdiodev->func[1]);
@@ -3710,7 +3710,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
 		brcmf_err("error writing for HT off\n");
 		return err;
@@ -3718,7 +3718,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdiod_regrb(sdiodev,
+	clkval = brcm_sdio_func1_rb(sdiodev,
 				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
@@ -3727,7 +3727,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 		return -EACCES;
 	}
 
-	SPINWAIT(((clkval = brcmf_sdiod_regrb(sdiodev,
+	SPINWAIT(((clkval = brcm_sdio_func1_rb(sdiodev,
 					      SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
@@ -3738,11 +3738,11 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 	}
 
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	udelay(65);
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+	brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
 	return 0;
 }
@@ -3818,10 +3818,10 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 			  BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
-		clkctl = brcmf_sdiod_regrb(sdiodev,
+		clkctl = brcm_sdio_func1_rb(sdiodev,
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
@@ -3882,13 +3882,13 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	brcmf_sdio_drivestrengthinit(sdiodev, bus->ci, drivestrength);
 
 	/* Set card control so an SDIO card reset does a WLAN backplane reset */
-	reg_val = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, &err);
+	reg_val = brcm_sdio_func0_rb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, &err);
 	if (err)
 		goto fail;
 
 	reg_val |= SDIO_CCCR_BRCM_CARDCTRL_WLANRESET;
 
-	brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
+	brcm_sdio_func0_wb(sdiodev, SDIO_CCCR_BRCM_CARDCTRL, reg_val, &err);
 	if (err)
 		goto fail;
 
@@ -4021,9 +4021,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		goto release;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcm_sdio_func1_rb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
@@ -4046,7 +4046,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		w_sdreg32(bus, bus->hostintmask,
 			  offsetof(struct sdpcmd_regs, hostintmask));
 
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_WATERMARK, 8, &err);
+		brcm_sdio_func1_wb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
@@ -4057,7 +4057,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdio_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+		brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  saveclk, &err);
 	}
 
@@ -4198,7 +4198,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcm_sdio_func1_wb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	sdio_release_host(bus->sdiodev->func[1]);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index f3da32fc6360..5220a878bed3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -50,6 +50,18 @@
 #define SBSDIO_NUM_FUNCTION		3
 
 /* function 0 vendor specific CCCR registers */
+
+#define brcm_sdio_func0_rb(sdiodev, addr, r) \
+	sdio_readb((sdiodev)->func[0], (addr), (r))
+
+#define brcm_sdio_func0_wb(sdiodev, addr, v, ret) \
+	sdio_writeb((sdiodev)->func[0], (v), (addr), (ret))
+
+#define brcm_sdio_func1_rb(sdiodev, addr, r) \
+	sdio_readb((sdiodev)->func[1], (addr), (r))
+
+#define brcm_sdio_func1_wb(sdiodev, addr, v, ret) \
+	sdio_writeb((sdiodev)->func[1], (v), (addr), (ret))
 #define SDIO_CCCR_BRCM_CARDCAP			0xf0
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
@@ -131,11 +143,6 @@
 /* with b15, maps to 32-bit SB access */
 #define SBSDIO_SB_ACCESS_2_4B_FLAG	0x08000
 
-/* valid bits in SBSDIO_FUNC1_SBADDRxxx regs */
-
-#define SBSDIO_SBADDRLOW_MASK		0x80	/* Valid bits in SBADDRLOW */
-#define SBSDIO_SBADDRMID_MASK		0xff	/* Valid bits in SBADDRMID */
-#define SBSDIO_SBADDRHIGH_MASK		0xffU	/* Valid bits in SBADDRHIGH */
 /* Address bits from SBADDR regs */
 #define SBSDIO_SBWINDOW_MASK		0xffff8000
 
@@ -342,7 +349,7 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		      u8 *data, uint size);
 
 /* Issue an abort to the specified function */
-int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
+int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn);
 void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 			      enum brcmf_sdiod_state state);
-- 
2.11.0

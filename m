Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1411 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] brcmfmac: replace brcmf_sdcard_cfg_write with
 brcmf_sdio_regwb
Date: Fri, 4 May 2012 18:27:33 -0700
Message-ID: <1336181258-7305-7-git-send-email-frankyl@broadcom.com> (sfid-20120505_032837_454343_26EA2639)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced brcmf_sdio_regwb to replace
brcmf_sdcard_cfg_write as part of the SDIO WiFi dongle register
access interface clean up.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   32 +------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   96 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    9 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    9 --
 4 files changed, 48 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index fc5c628..f6bb148 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -87,15 +87,13 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 	/* must configure SDIO_CCCR_IENx to enable irq */
 	data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
 	data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_IENx,
-			       data, &ret);
+	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 	/* redirect, configure ane enable io for interrupt signal */
 	data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
 	if (sdiodev->irq_flags | IRQF_TRIGGER_HIGH)
 		data |= SDIO_SEPINT_ACT_HI;
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_BRCM_SEPINT,
-			       data, &ret);
+	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 
 	return 0;
 }
@@ -104,9 +102,8 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_BRCM_SEPINT,
-			       0, NULL);
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_IENx, 0, NULL);
+	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
+	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 
 	if (sdiodev->irq_wake) {
 		disable_irq_wake(sdiodev->irq);
@@ -157,27 +154,6 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 }
 #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
-void
-brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
-		       u8 data, int *err)
-{
-	int status;
-	s32 retry = 0;
-
-	do {
-		if (retry)	/* wait for 1 ms till bus get settled down */
-			udelay(1000);
-		status = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, fnc_num,
-						  addr, (u8 *) &data);
-	} while (status != 0
-		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
-	if (err)
-		*err = status;
-
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, u8data = 0x%x\n",
-		  fnc_num, addr, data);
-}
-
 int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 85f277c..1e35a3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -696,8 +696,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 clkreq, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
 			return -EBADE;
@@ -723,8 +723,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_DEVICE_CTL, devctl, &err);
+			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					 devctl, &err);
 			brcmf_dbg(INFO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
@@ -734,8 +734,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			devctl = brcmf_sdio_regrb(bus->sdiodev,
 						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL, devctl, &err);
+			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					 devctl, &err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
@@ -780,13 +780,13 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			devctl = brcmf_sdio_regrb(bus->sdiodev,
 						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL, devctl, &err);
+			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					 devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 clkreq, &err);
 		brcmf_dbg(INFO, "CLKCTL: turned OFF\n");
 		if (err) {
 			brcmf_dbg(ERROR, "Failed access turning clock off: %d\n",
@@ -897,14 +897,12 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			SBSDIO_FUNC1_CHIPCLKCSR,
-			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			SBSDIO_DEVICE_CTL,
-			SBSDIO_DEVCTL_PADS_ISO, NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+				 SBSDIO_DEVCTL_PADS_ISO, NULL);
 
 		/* Change state */
 		bus->sleeping = true;
@@ -912,8 +910,8 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 	} else {
 		/* Waking up: bus power up is ok, set local state */
 
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 0, NULL);
 
 		/* Make sure the controller has the bus up */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -1035,9 +1033,8 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	if (abort)
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_FRAMECTRL,
-			       SFC_RF_TERM, &err);
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+			 SFC_RF_TERM, &err);
 	bus->f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
@@ -2173,9 +2170,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		bus->tx_sderrs++;
 
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
-				 NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+				 SFC_WF_TERM, NULL);
 		bus->f1regdata++;
 
 		for (i = 0; i < 3; i++) {
@@ -2305,17 +2301,16 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	saveclk = brcmf_sdio_regrb(bus->sdiodev,
 				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR,
-				       (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err)
 		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
 
 	/* Turn off the bus (F2), free any pending packets */
 	brcmf_dbg(INTR, "disable SDIO interrupts\n");
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			 SDIO_FUNC_ENABLE_1, NULL);
+	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, SDIO_FUNC_ENABLE_1,
+			 NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
 	w_sdreg32(bus, local_hostintmask,
@@ -2414,8 +2409,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL, devctl, &err);
+			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
+					 devctl, &err);
 			if (err) {
 				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
 					  err);
@@ -2536,9 +2531,8 @@ clkwait:
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
-					 NULL);
+			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+					 SFC_WF_TERM, NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
@@ -2874,9 +2868,8 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_FRAMECTRL,
-				       SFC_WF_TERM, NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
+				 SFC_WF_TERM, NULL);
 		bus->f1regdata++;
 
 		for (i = 0; i < 3; i++) {
@@ -3461,9 +3454,8 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	saveclk = brcmf_sdio_regrb(bus->sdiodev,
 				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR,
-				       (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
 		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
@@ -3475,8 +3467,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			       enable, NULL);
+	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, enable, NULL);
 
 	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
 	ready = 0;
@@ -3499,19 +3490,16 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		w_sdreg32(bus, bus->hostintmask,
 			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
 
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_WATERMARK, 8, &err);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0,
-				       SDIO_CCCR_IOEx, enable, NULL);
+		brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, enable, NULL);
 		ret = -ENODEV;
 	}
 
 	/* Restore previous clock setting */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	if (ret == 0) {
 		ret = brcmf_sdio_intr_register(bus->sdiodev);
@@ -3729,9 +3717,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR,
-			       BRCMF_INIT_CLKCTL1, &err);
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			 BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
 		clkctl = brcmf_sdio_regrb(bus->sdiodev,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
@@ -3792,16 +3779,15 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			       SDIO_FUNC_ENABLE_1, NULL);
+	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx,
+			 SDIO_FUNC_ENABLE_1, NULL);
 
 	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 654b7e0..d4b390c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -425,8 +425,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR,	clkset, &err);
+	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
 		brcmf_dbg(ERROR, "error writing for HT off\n");
 		return err;
@@ -454,13 +453,11 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	udelay(65);
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index decfe0d..7a97cb5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -168,15 +168,6 @@ struct brcmf_sdio_dev {
 extern int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
-/* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
- *   fn:   function number
- *   addr: unmodified SDIO-space address
- *   data: data byte to write
- *   err:  pointer to error code (or NULL)
- */
-extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
-				   u32 addr, u8 data, int *err);
-
 /* Synchronous access to device (client) core registers via CMD53 to F1.
  *   addr: backplane address (i.e. >= regsva from attach)
  *   size: register width in bytes (2 or 4)
-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1414 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] brcmfmac: replace brcmf_sdcard_cfg_read with
 brcmf_sdio_regrb
Date: Fri, 4 May 2012 18:27:32 -0700
Message-ID: <1336181258-7305-6-git-send-email-frankyl@broadcom.com> (sfid-20120505_032831_308953_B9EDB867)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced brcmf_sdio_regrb to replace
brcmf_sdcard_cfg_read as part of the SDIO WiFi dongle register
access interface clean up.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   26 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  103 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    8 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 -
 4 files changed, 49 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 5e719d8..fc5c628 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -85,8 +85,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->irq_wake = true;
 
 	/* must configure SDIO_CCCR_IENx to enable irq */
-	data = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_0,
-				     SDIO_CCCR_IENx, &ret);
+	data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
 	data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
 	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_0, SDIO_CCCR_IENx,
 			       data, &ret);
@@ -158,29 +157,6 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 }
 #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
-u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
-			 int *err)
-{
-	int status;
-	s32 retry = 0;
-	u8 data = 0;
-
-	do {
-		if (retry)	/* wait for 1 ms till bus get settled down */
-			udelay(1000);
-		status = brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, fnc_num,
-						  addr, (u8 *) &data);
-	} while (status != 0
-		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
-	if (err)
-		*err = status;
-
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, u8data = 0x%x\n",
-		  fnc_num, addr, data);
-
-	return data;
-}
-
 void
 brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		       u8 data, int *err)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7ed215d..85f277c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -704,8 +704,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdio_regrb(bus->sdiodev,
+					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "HT Avail read error: %d\n", err);
 			return -EBADE;
@@ -714,9 +714,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
-					SDIO_FUNC_1,
-					SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdio_regrb(bus->sdiodev,
+						  SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				brcmf_dbg(ERROR, "Devctl error setting CA: %d\n",
 					  err);
@@ -732,8 +731,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			return 0;
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl =
-			    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+			devctl = brcmf_sdio_regrb(bus->sdiodev,
 						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
@@ -744,10 +742,9 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdcard_cfg_read(bus->sdiodev,
-						       SDIO_FUNC_1,
-						       SBSDIO_FUNC1_CHIPCLKCSR,
-						       &err);
+			clkctl = brcmf_sdio_regrb(bus->sdiodev,
+						  SBSDIO_FUNC1_CHIPCLKCSR,
+						  &err);
 			if (time_after(jiffies, timeout))
 				break;
 			else
@@ -780,9 +777,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
-					SDIO_FUNC_1,
-					SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdio_regrb(bus->sdiodev,
+						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
@@ -1046,10 +1042,10 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
-		lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
+		hi = brcmf_sdio_regrb(bus->sdiodev,
+				      SBSDIO_FUNC1_RFRAMEBCHI, NULL);
+		lo = brcmf_sdio_regrb(bus->sdiodev,
+				      SBSDIO_FUNC1_RFRAMEBCLO, NULL);
 		bus->f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -2184,14 +2180,10 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
-			hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCHI,
-					     NULL);
-			lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCLO,
-					     NULL);
+			hi = brcmf_sdio_regrb(bus->sdiodev,
+					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+			lo = brcmf_sdio_regrb(bus->sdiodev,
+					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 			bus->f1regdata += 2;
 			if ((hi == 0) && (lo == 0))
 				break;
@@ -2310,8 +2302,8 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcmf_sdio_regrb(bus->sdiodev,
+				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
@@ -2393,8 +2385,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 #ifdef DEBUG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_DEVICE_CTL, &err);
+		devctl = brcmf_sdio_regrb(bus->sdiodev,
+					  SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
@@ -2402,8 +2394,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		clkctl = brcmf_sdio_regrb(bus->sdiodev,
+					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "error reading CSR: %d\n",
 				  err);
@@ -2414,9 +2406,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
-						       SDIO_FUNC_1,
-						       SBSDIO_DEVICE_CTL, &err);
+			devctl = brcmf_sdio_regrb(bus->sdiodev,
+						  SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
 					  err);
@@ -2552,14 +2543,12 @@ clkwait:
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCHI,
-						     NULL);
-				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCLO,
-						     NULL);
+				hi = brcmf_sdio_regrb(bus->sdiodev,
+						      SBSDIO_FUNC1_WFRAMEBCHI,
+						      NULL);
+				lo = brcmf_sdio_regrb(bus->sdiodev,
+						      SBSDIO_FUNC1_WFRAMEBCLO,
+						      NULL);
 				bus->f1regdata += 2;
 				if ((hi == 0) && (lo == 0))
 					break;
@@ -2892,12 +2881,10 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
-			hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-						   SBSDIO_FUNC1_WFRAMEBCHI,
-						   NULL);
-			lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-						   SBSDIO_FUNC1_WFRAMEBCLO,
-						   NULL);
+			hi = brcmf_sdio_regrb(bus->sdiodev,
+					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+			lo = brcmf_sdio_regrb(bus->sdiodev,
+					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
 			bus->f1regdata += 2;
 			if (hi == 0 && lo == 0)
 				break;
@@ -3471,9 +3458,8 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		goto exit;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk =
-	    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	saveclk = brcmf_sdio_regrb(bus->sdiodev,
+				   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
@@ -3495,8 +3481,8 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
 	ready = 0;
 	while (enable != ready) {
-		ready = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_0,
-					      SDIO_CCCR_IORx, NULL);
+		ready = brcmf_sdio_regrb(bus->sdiodev,
+					 SDIO_CCCR_IORx, NULL);
 		if (time_after(jiffies, timeout))
 			break;
 		else if (time_after(jiffies, timeout - BRCMF_WAIT_F2RDY + 50))
@@ -3605,9 +3591,9 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 			if (!bus->dpc_sched) {
 				u8 devpend;
-				devpend = brcmf_sdcard_cfg_read(bus->sdiodev,
-						SDIO_FUNC_0, SDIO_CCCR_INTx,
-						NULL);
+				devpend = brcmf_sdio_regrb(bus->sdiodev,
+							   SDIO_CCCR_INTx,
+							   NULL);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
 					       INTR_STATUS_FUNC2);
@@ -3747,8 +3733,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 			       SBSDIO_FUNC1_CHIPCLKCSR,
 			       BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
-		clkctl =
-		    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+		clkctl = brcmf_sdio_regrb(bus->sdiodev,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 3ced613..654b7e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -434,8 +434,8 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+	clkval = brcmf_sdio_regrb(sdiodev,
+				  SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
 		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
@@ -443,8 +443,8 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 		return -EACCES;
 	}
 
-	SPINWAIT(((clkval = brcmf_sdcard_cfg_read(sdiodev, SDIO_FUNC_1,
-				SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
+	SPINWAIT(((clkval = brcmf_sdio_regrb(sdiodev,
+					     SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
 	if (!SBSDIO_ALPAV(clkval)) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index d6ed2d8..decfe0d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -174,8 +174,6 @@ extern int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
  *   data: data byte to write
  *   err:  pointer to error code (or NULL)
  */
-extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint func,
-				u32 addr, int *err);
 extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
 				   u32 addr, u8 data, int *err);
 
-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1390 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] brcmfmac: remove redundant retries for SDIO core
 register access
Date: Fri, 4 May 2012 18:27:36 -0700
Message-ID: <1336181258-7305-10-git-send-email-frankyl@broadcom.com> (sfid-20120505_032828_754011_20BE941B)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new brcmf_sdio_regrl/regwl interface has already performed
retries on failed attempts. It is no longer necessary to have the
retry mechanism in r_sdreg32/w_sdreg32.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  110 ++++++++------------
 1 file changed, 44 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2c644a9..5338f57 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -629,43 +629,29 @@ static bool data_ok(struct brcmf_sdio *bus)
  * Reads a register in the SDIO hardware block. This block occupies a series of
  * adresses on the 32 bit backplane bus.
  */
-static void
-r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset, u32 *retryvar)
+static int
+r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	int ret;
-	*retryvar = 0;
-	do {
-		*regvar = brcmf_sdio_regrl(bus->sdiodev,
-					   bus->ci->c_inf[idx].base + offset,
-					   &ret);
-	} while ((ret != 0) && (++(*retryvar) <= retry_limit));
-	if (*retryvar) {
-		bus->regfails += (*retryvar-1);
-		if (*retryvar > retry_limit) {
-			brcmf_dbg(ERROR, "FAILED READ %Xh\n", offset);
-			*regvar = 0;
-		}
-	}
+
+	*regvar = brcmf_sdio_regrl(bus->sdiodev,
+				   bus->ci->c_inf[idx].base + offset, &ret);
+
+	return ret;
 }
 
-static void
-w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset, u32 *retryvar)
+static int
+w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	int ret;
-	*retryvar = 0;
-	do {
-		brcmf_sdio_regwl(bus->sdiodev,
-				 bus->ci->c_inf[idx].base + reg_offset,
-				 regval, &ret);
-	} while ((ret != 0) && (++(*retryvar) <= retry_limit));
-	if (*retryvar) {
-		bus->regfails += (*retryvar-1);
-		if (*retryvar > retry_limit)
-			brcmf_dbg(ERROR, "FAILED REGISTER WRITE %Xh\n",
-				  reg_offset);
-	}
+
+	brcmf_sdio_regwl(bus->sdiodev,
+			 bus->ci->c_inf[idx].base + reg_offset,
+			 regval, &ret);
+
+	return ret;
 }
 
 #define PKT_AVAILABLE()		(intstatus & I_HMB_FRAME_IND)
@@ -870,7 +856,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 
 static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 {
-	uint retries = 0;
+	int ret;
 
 	brcmf_dbg(INFO, "request %s (currently %s)\n",
 		  sleep ? "SLEEP" : "WAKE",
@@ -890,9 +876,9 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Tell device to start using OOB wakeup */
-		w_sdreg32(bus, SMB_USE_OOB,
-			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
-		if (retries > retry_limit)
+		ret = w_sdreg32(bus, SMB_USE_OOB,
+				offsetof(struct sdpcmd_regs, tosbmailbox));
+		if (ret != 0)
 			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
 
 		/* Turn off our contribution to the HT clock request */
@@ -918,14 +904,13 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Send misc interrupt to indicate OOB not needed */
-		w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, tosbmailboxdata),
-			  &retries);
-		if (retries <= retry_limit)
-			w_sdreg32(bus, SMB_DEV_INT,
-				  offsetof(struct sdpcmd_regs, tosbmailbox),
-				  &retries);
-
-		if (retries > retry_limit)
+		ret = w_sdreg32(bus, 0,
+				offsetof(struct sdpcmd_regs, tosbmailboxdata));
+		if (ret == 0)
+			ret = w_sdreg32(bus, SMB_DEV_INT,
+				offsetof(struct sdpcmd_regs, tosbmailbox));
+
+		if (ret != 0)
 			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
 
 		/* Make sure we have SD bus access */
@@ -949,17 +934,17 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 	u32 intstatus = 0;
 	u32 hmb_data;
 	u8 fcbits;
-	uint retries = 0;
+	int ret;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
-	r_sdreg32(bus, &hmb_data,
-		  offsetof(struct sdpcmd_regs, tohostmailboxdata), &retries);
+	ret = r_sdreg32(bus, &hmb_data,
+			offsetof(struct sdpcmd_regs, tohostmailboxdata));
 
-	if (retries <= retry_limit)
+	if (ret == 0)
 		w_sdreg32(bus, SMB_INT_ACK,
-			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
+			  offsetof(struct sdpcmd_regs, tosbmailbox));
 	bus->f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -1063,11 +1048,11 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->rxrtx++;
-		w_sdreg32(bus, SMB_NAK,
-			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
+		err = w_sdreg32(bus, SMB_NAK,
+				offsetof(struct sdpcmd_regs, tosbmailbox));
 
 		bus->f1regdata++;
-		if (retries <= retry_limit)
+		if (err == 0)
 			bus->rxskip = true;
 	}
 
@@ -2207,7 +2192,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
 	u32 intstatus = 0;
-	uint retries = 0;
 	int ret = 0, prec_out;
 	uint cnt = 0;
 	uint datalen;
@@ -2238,8 +2222,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
 			r_sdreg32(bus, &intstatus,
-				  offsetof(struct sdpcmd_regs, intstatus),
-				  &retries);
+				  offsetof(struct sdpcmd_regs, intstatus));
 			bus->f2txdata++;
 			if (brcmf_sdcard_regfail(bus->sdiodev))
 				break;
@@ -2263,7 +2246,6 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
-	uint retries;
 	int err;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -2291,7 +2273,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Disable and clear interrupts at the chip level also */
-	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
+	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
 	local_hostintmask = bus->hostintmask;
 	bus->hostintmask = 0;
 
@@ -2315,7 +2297,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 
 	/* Clear any pending interrupts now that F2 is disabled */
 	w_sdreg32(bus, local_hostintmask,
-		  offsetof(struct sdpcmd_regs, intstatus), &retries);
+		  offsetof(struct sdpcmd_regs, intstatus));
 
 	/* Turn off the backplane clock (only) */
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -2360,7 +2342,6 @@ static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
 static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
 	u32 intstatus, newstatus = 0;
-	uint retries = 0;
 	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
@@ -2434,7 +2415,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	if (bus->ipend) {
 		bus->ipend = false;
 		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+			  offsetof(struct sdpcmd_regs, intstatus));
 		bus->f1regdata++;
 		if (brcmf_sdcard_regfail(bus->sdiodev))
 			newstatus = 0;
@@ -2442,8 +2423,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
 		if (newstatus) {
 			w_sdreg32(bus, newstatus,
-				  offsetof(struct sdpcmd_regs, intstatus),
-				  &retries);
+				  offsetof(struct sdpcmd_regs, intstatus));
 			bus->f1regdata++;
 		}
 	}
@@ -2459,10 +2439,10 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
 		w_sdreg32(bus, I_HMB_FC_CHANGE,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+			  offsetof(struct sdpcmd_regs, intstatus));
 
 		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+			  offsetof(struct sdpcmd_regs, intstatus));
 		bus->f1regdata += 2;
 		bus->fcstate =
 		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
@@ -3168,7 +3148,6 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 
 static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 {
-	uint retries;
 	int bcmerror = 0;
 	struct chip_info *ci = bus->ci;
 
@@ -3202,7 +3181,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 		}
 
 		w_sdreg32(bus, 0xFFFFFFFF,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+			  offsetof(struct sdpcmd_regs, intstatus));
 
 		ci->resetcore(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
 
@@ -3424,7 +3403,6 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 	unsigned long timeout;
-	uint retries = 0;
 	u8 ready, enable;
 	int err, ret = 0;
 	u8 saveclk;
@@ -3465,7 +3443,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 	/* Enable function 2 (frame transfers) */
 	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
-		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
+		  offsetof(struct sdpcmd_regs, tosbmailboxdata));
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
 	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, enable, NULL);
@@ -3489,7 +3467,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
 		w_sdreg32(bus, bus->hostintmask,
-			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
+			  offsetof(struct sdpcmd_regs, hostintmask));
 
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
-- 
1.7.9.5



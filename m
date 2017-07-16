Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48018 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:28 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 11/21] brcmfmac: cleanup horrid offsetof() mess
Date: Sun, 16 Jul 2017 12:21:19 +0100
Message-Id: <20170716112129.10206-12-ian@mnementh.co.uk> (sfid-20170716_134531_383663_30053625)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 37 ++++++++--------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ce540625c29e..2d819d44358a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -159,8 +159,8 @@ struct rte_console {
 /* manfid tuple length, include tuple, link bytes */
 #define SBSDIO_CIS_MANFID_TUPLE_LEN	6
 
-#define CORE_BUS_REG(base, field) \
-		(base + offsetof(struct sdpcmd_regs, field))
+#define __sd_reg(field) \
+		(offsetof(struct sdpcmd_regs, field))
 
 /* SDIO function 1 register CHIPCLKCSR */
 /* Force ALP request to backplane */
@@ -1081,12 +1081,10 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
-	ret = r_sdreg32(bus, &hmb_data,
-			offsetof(struct sdpcmd_regs, tohostmailboxdata));
+	ret = r_sdreg32(bus, &hmb_data,	__sd_reg(tohostmailboxdata));
 
 	if (ret == 0)
-		w_sdreg32(bus, SMB_INT_ACK,
-			  offsetof(struct sdpcmd_regs, tosbmailbox));
+		w_sdreg32(bus, SMB_INT_ACK, __sd_reg(tosbmailbox));
 	bus->sdcnt.f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -1196,8 +1194,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->sdcnt.rxrtx++;
-		err = w_sdreg32(bus, SMB_NAK,
-				offsetof(struct sdpcmd_regs, tosbmailbox));
+		err = w_sdreg32(bus, SMB_NAK, __sd_reg(tosbmailbox));
 
 		bus->sdcnt.f1regdata++;
 		if (err == 0)
@@ -2318,9 +2315,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
 			sdio_claim_host(bus->sdiodev->func[1]);
-			ret = r_sdreg32(bus, &intstatus,
-					offsetof(struct sdpcmd_regs,
-						 intstatus));
+			ret = r_sdreg32(bus, &intstatus, __sd_reg(intstatus));
 			sdio_release_host(bus->sdiodev->func[1]);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
@@ -2426,7 +2421,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		brcmf_sdio_bus_sleep(bus, false, false);
 
 		/* Disable and clear interrupts at the chip level also */
-		w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
+		w_sdreg32(bus, 0, __sd_reg(hostintmask));
 		local_hostintmask = bus->hostintmask;
 		bus->hostintmask = 0;
 
@@ -2445,8 +2440,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
 
 		/* Clear any pending interrupts now that F2 is disabled */
-		w_sdreg32(bus, local_hostintmask,
-			  offsetof(struct sdpcmd_regs, intstatus));
+		w_sdreg32(bus, local_hostintmask, __sd_reg(intstatus));
 
 		sdio_release_host(sdiodev->func[1]);
 	}
@@ -2492,7 +2486,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	int ret;
 
 	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
-	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
+	addr = buscore->base + __sd_reg(intstatus);
 
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
@@ -2569,11 +2563,9 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		err = w_sdreg32(bus, I_HMB_FC_CHANGE,
-				offsetof(struct sdpcmd_regs, intstatus));
+		err = w_sdreg32(bus, I_HMB_FC_CHANGE, __sd_reg(intstatus));
 
-		err = r_sdreg32(bus, &newstatus,
-				offsetof(struct sdpcmd_regs, intstatus));
+		err = r_sdreg32(bus, &newstatus, __sd_reg(intstatus));
 		bus->sdcnt.f1regdata += 2;
 		atomic_set(&bus->fcstate,
 			   !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE)));
@@ -3756,7 +3748,7 @@ static void brcmf_sdio_buscore_activate(void *ctx, struct brcmf_chip *chip,
 
 	/* clear all interrupts */
 	core = brcmf_chip_get_core(chip, BCMA_CORE_SDIO_DEV);
-	reg_addr = core->base + offsetof(struct sdpcmd_regs, intstatus);
+	reg_addr = core->base + __sd_reg(intstatus);
 	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
 	if (rstvec)
@@ -4033,7 +4025,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 
 	/* Enable function 2 (frame transfers) */
 	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
-		  offsetof(struct sdpcmd_regs, tosbmailboxdata));
+		  __sd_reg(tosbmailboxdata));
 	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
 
 
@@ -4043,8 +4035,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (!err) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		w_sdreg32(bus, bus->hostintmask,
-			  offsetof(struct sdpcmd_regs, hostintmask));
+		w_sdreg32(bus, bus->hostintmask, __sd_reg(hostintmask));
 
 		brcm_sdio_func1_wb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
-- 
2.11.0

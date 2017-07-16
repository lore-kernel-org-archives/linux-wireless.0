Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48060 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:32 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 21/21] brcmfmac: rename horridly named IO functions
Date: Sun, 16 Jul 2017 12:21:29 +0100
Message-Id: <20170716112129.10206-22-ian@mnementh.co.uk> (sfid-20170716_140043_084238_722BCF7E)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 45b8000680c0..b41f2afe4d5a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -660,7 +660,7 @@ static bool data_ok(struct brcmf_sdio *bus)
  * Reads a register in the SDIO hardware block. This block occupies a series of
  * adresses on the 32 bit backplane bus.
  */
-static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
+static int brcm_sdio_readl(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 {
 	struct brcmf_core *core = bus->sdio_core;
 	int ret;
@@ -670,7 +670,7 @@ static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 	return ret;
 }
 
-static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
+static int brcm_sdio_writel(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 {
 	struct brcmf_core *core = bus->sdio_core;
 	int ret;
@@ -1082,10 +1082,10 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
-	ret = r_sdreg32(bus, &hmb_data,	__sd_reg(tohostmailboxdata));
+	ret = brcm_sdio_readl(bus, &hmb_data, __sd_reg(tohostmailboxdata));
 
 	if (ret == 0)
-		w_sdreg32(bus, SMB_INT_ACK, __sd_reg(tosbmailbox));
+		brcm_sdio_writel(bus, SMB_INT_ACK, __sd_reg(tosbmailbox));
 	bus->sdcnt.f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -1195,7 +1195,7 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->sdcnt.rxrtx++;
-		err = w_sdreg32(bus, SMB_NAK, __sd_reg(tosbmailbox));
+		err = brcm_sdio_writel(bus, SMB_NAK, __sd_reg(tosbmailbox));
 
 		bus->sdcnt.f1regdata++;
 		if (err == 0)
@@ -2316,7 +2316,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
 			sdio_claim_host(bus->sdiodev->func[1]);
-			ret = r_sdreg32(bus, &intstatus, __sd_reg(intstatus));
+			ret = brcm_sdio_readl(bus, &intstatus, __sd_reg(intstatus));
 			sdio_release_host(bus->sdiodev->func[1]);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
@@ -2422,7 +2422,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		brcmf_sdio_bus_sleep(bus, false, false);
 
 		/* Disable and clear interrupts at the chip level also */
-		w_sdreg32(bus, 0, __sd_reg(hostintmask));
+		brcm_sdio_writel(bus, 0, __sd_reg(hostintmask));
 		local_hostintmask = bus->hostintmask;
 		bus->hostintmask = 0;
 
@@ -2441,7 +2441,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
 
 		/* Clear any pending interrupts now that F2 is disabled */
-		w_sdreg32(bus, local_hostintmask, __sd_reg(intstatus));
+		brcm_sdio_writel(bus, local_hostintmask, __sd_reg(intstatus));
 
 		sdio_release_host(sdiodev->func[1]);
 	}
@@ -2562,9 +2562,9 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		err = w_sdreg32(bus, I_HMB_FC_CHANGE, __sd_reg(intstatus));
+		err = brcm_sdio_writel(bus, I_HMB_FC_CHANGE, __sd_reg(intstatus));
 
-		err = r_sdreg32(bus, &newstatus, __sd_reg(intstatus));
+		err = brcm_sdio_readl(bus, &newstatus, __sd_reg(intstatus));
 		bus->sdcnt.f1regdata += 2;
 		atomic_set(&bus->fcstate,
 			   !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE)));
@@ -4033,7 +4033,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	}
 
 	/* Enable function 2 (frame transfers) */
-	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
+	brcm_sdio_writel(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
 		  __sd_reg(tosbmailboxdata));
 	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
 
@@ -4044,7 +4044,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (!err) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		w_sdreg32(bus, bus->hostintmask, __sd_reg(hostintmask));
+		brcm_sdio_writel(bus, bus->hostintmask, __sd_reg(hostintmask));
 
 		brcm_sdio_func1_wb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
-- 
2.11.0

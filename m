Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49886 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQQr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:47:29 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 27/29] brcmfmac: Remove {r,w}_sdreg32
Date: Mon, 17 Jul 2017 17:16:35 +0100
Message-Id: <20170717161637.4652-28-ian@mnementh.co.uk> (sfid-20170717_184734_529794_D15B4A74)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove yet another IO function from the code and replace with one
that already exists.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 88 +++++++++++-----------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 96f4416ad106..87eca68d6e4f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -659,30 +659,6 @@ static bool data_ok(struct brcmf_sdio *bus)
 	       ((u8)(bus->tx_max - bus->tx_seq) & 0x80) == 0;
 }
 
-/*
- * Reads a register in the SDIO hardware block. This block occupies a series of
- * adresses on the 32 bit backplane bus.
- */
-static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
-{
-	struct brcmf_core *core = bus->sdio_core;
-	int ret;
-
-	*regvar = brcmf_sdiod_readl(bus->sdiodev, core->base + offset, &ret);
-
-	return ret;
-}
-
-static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
-{
-	struct brcmf_core *core = bus->sdio_core;
-	int ret;
-
-	brcmf_sdiod_writel(bus->sdiodev, core->base + reg_offset, regval, &ret);
-
-	return ret;
-}
-
 static int
 brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 {
@@ -1071,6 +1047,8 @@ static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
 
 static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 {
+	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_core *core = bus->sdio_core;
 	u32 intstatus = 0;
 	u32 hmb_data;
 	u8 fcbits;
@@ -1079,10 +1057,13 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
-	ret = r_sdreg32(bus, &hmb_data,	__sd_reg(tohostmailboxdata));
+	hmb_data = brcmf_sdiod_readl(sdiod, core->base +
+					__sd_reg(tohostmailboxdata), &ret);
+
+	if (!ret)
+		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailbox),
+					SMB_INT_ACK, &ret);
 
-	if (ret == 0)
-		w_sdreg32(bus, SMB_INT_ACK, __sd_reg(tosbmailbox));
 	bus->sdcnt.f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -1151,6 +1132,8 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 {
+	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_core *core = bus->sdio_core;
 	uint retries = 0;
 	u16 lastrbc;
 	u8 hi, lo;
@@ -1189,7 +1172,8 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->sdcnt.rxrtx++;
-		err = w_sdreg32(bus, SMB_NAK, __sd_reg(tosbmailbox));
+		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailbox),
+					SMB_NAK, &err);
 
 		bus->sdcnt.f1regdata++;
 		if (err == 0)
@@ -2273,6 +2257,7 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 
 static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
+	struct brcmf_core *core = bus->sdio_core;
 	struct sk_buff *pkt;
 	struct sk_buff_head pktq;
 	u32 intstatus = 0;
@@ -2313,7 +2298,8 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
 			sdio_claim_host(bus->sdiodev->func[1]);
-			ret = r_sdreg32(bus, &intstatus, __sd_reg(intstatus));
+			intstatus = brcmf_sdiod_readl(bus->sdiodev, core->base +
+							__sd_reg(intstatus), &ret);
 			sdio_release_host(bus->sdiodev->func[1]);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
@@ -2397,12 +2383,13 @@ static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio *bus, u8 *frame, u16 len)
 
 static void brcmf_sdio_bus_stop(struct device *dev)
 {
-	u32 local_hostintmask;
-	u8 saveclk;
-	int err;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_core *core = bus->sdio_core;
+	u32 local_hostintmask;
+	u8 saveclk;
+	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2419,7 +2406,8 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		brcmf_sdio_bus_sleep(bus, false, false);
 
 		/* Disable and clear interrupts at the chip level also */
-		w_sdreg32(bus, 0, __sd_reg(hostintmask));
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(hostintmask), 0, NULL);
+
 		local_hostintmask = bus->hostintmask;
 		bus->hostintmask = 0;
 
@@ -2438,7 +2426,8 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
 
 		/* Clear any pending interrupts now that F2 is disabled */
-		w_sdreg32(bus, local_hostintmask, __sd_reg(intstatus));
+		brcmf_sdiod_writel(sdiodev, core->base + __sd_reg(intstatus),
+					local_hostintmask, NULL);
 
 		sdio_release_host(sdiodev->func[1]);
 	}
@@ -2504,6 +2493,8 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
+	struct brcmf_core *core = bus->sdio_core;
+	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
 	u32 newstatus = 0;
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
@@ -2557,9 +2548,12 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		err = w_sdreg32(bus, I_HMB_FC_CHANGE, __sd_reg(intstatus));
+		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(intstatus),
+				       I_HMB_FC_CHANGE, &err);
+
+		newstatus = brcmf_sdiod_readl(sdiod, core->base + __sd_reg(intstatus),
+						&err);
 
-		err = r_sdreg32(bus, &newstatus, __sd_reg(intstatus));
 		bus->sdcnt.f1regdata += 2;
 		atomic_set(&bus->fcstate,
 			   !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE)));
@@ -3977,22 +3971,21 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					 const struct firmware *code,
 					 void *nvram, u32 nvram_len)
 {
-	struct brcmf_bus *bus_if;
-	struct brcmf_sdio_dev *sdiodev;
-	struct brcmf_sdio *bus;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
+	struct brcmf_core *core = bus->sdio_core;
 	u8 saveclk;
 
 	brcmf_dbg(TRACE, "Enter: dev=%s, err=%d\n", dev_name(dev), err);
-	bus_if = dev_get_drvdata(dev);
-	sdiodev = bus_if->bus_priv.sdio;
+
 	if (err)
 		goto fail;
 
 	if (!bus_if->drvr)
 		return;
 
-	bus = sdiodev->bus;
-
 	/* try to download image and nvram to the dongle */
 	bus->alp_only = true;
 	err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
@@ -4023,8 +4016,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	}
 
 	/* Enable function 2 (frame transfers) */
-	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
-		  __sd_reg(tosbmailboxdata));
+	brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailboxdata),
+				SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT, NULL);
+
 	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
 
 
@@ -4034,7 +4028,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (!err) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		w_sdreg32(bus, bus->hostintmask, __sd_reg(hostintmask));
+		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(hostintmask),
+			       bus->hostintmask, NULL);
+
 
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
-- 
2.11.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43783 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753036AbdLHMKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: Remove repeated calls to brcmf_chip_get_core()
Date: Fri,  8 Dec 2017 13:10:35 +0100
Message-Id: <1512735035-342-11-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131058_006751_6E8BD689)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

There is no need to repeatdly call brcmf_chip_get_core(), which
traverses a list of cores every time its called (including during
register access code!).

Call it once, and store a pointer to the core structure. The existing
code does nto keep track of users of the cores anyway, and even so, this
will allow for easier refcounting in future.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 25 +++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 1e1e198..93a1a0c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -436,6 +436,7 @@ struct brcmf_sdio_count {
 struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct brcmf_chip *ci;	/* Chip info struct */
+	struct brcmf_core *sdio_core; /* sdio core info struct */
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	atomic_t intstatus;	/* Intstatus bits (events) pending */
@@ -665,10 +666,9 @@ static bool data_ok(struct brcmf_sdio *bus)
  */
 static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 {
-	struct brcmf_core *core;
+	struct brcmf_core *core = bus->sdio_core;
 	int ret;
 
-	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	*regvar = brcmf_sdiod_readl(bus->sdiodev, core->base + offset, &ret);
 
 	return ret;
@@ -676,10 +676,9 @@ static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 
 static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 {
-	struct brcmf_core *core;
+	struct brcmf_core *core = bus->sdio_core;
 	int ret;
 
-	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	brcmf_sdiod_writel(bus->sdiodev, core->base + reg_offset, regval, &ret);
 
 	return ret;
@@ -2495,12 +2494,11 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	struct brcmf_core *buscore;
+	struct brcmf_core *buscore = bus->sdio_core;
 	u32 addr;
 	unsigned long val;
 	int ret;
 
-	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + SD_REG(intstatus);
 
 	val = brcmf_sdiod_readl(bus->sdiodev, addr, &ret);
@@ -3377,13 +3375,14 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 /* enable KSO bit */
 static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 {
+	struct brcmf_core *core = bus->sdio_core;
 	u8 val;
 	int err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* KSO bit added in SDIO core rev 12 */
-	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12)
+	if (core->rev < 12)
 		return 0;
 
 	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
@@ -3412,6 +3411,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_core *core = bus->sdio_core;
 	uint pad_size;
 	u32 value;
 	int err;
@@ -3420,7 +3420,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
 	 */
-	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12) {
+	if (core->rev < 12) {
 		/* for sdio core rev < 12, disable txgloming */
 		value = 0;
 		err = brcmf_iovar_data_set(dev, "bus:txglom", &value,
@@ -3758,11 +3758,10 @@ static void brcmf_sdio_buscore_activate(void *ctx, struct brcmf_chip *chip,
 					u32 rstvec)
 {
 	struct brcmf_sdio_dev *sdiodev = ctx;
-	struct brcmf_core *core;
+	struct brcmf_core *core = sdiodev->bus->sdio_core;
 	u32 reg_addr;
 
 	/* clear all interrupts */
-	core = brcmf_chip_get_core(chip, BCMA_CORE_SDIO_DEV);
 	reg_addr = core->base + SD_REG(intstatus);
 	brcmf_sdiod_writel(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
@@ -3843,6 +3842,12 @@ static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
 		bus->ci = NULL;
 		goto fail;
 	}
+
+	/* Pick up the SDIO core info struct from chip.c */
+	bus->sdio_core   = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
+	if (!bus->sdio_core)
+		goto fail;
+
 	sdiodev->settings = brcmf_get_module_param(sdiodev->dev,
 						   BRCMF_BUSTYPE_SDIO,
 						   bus->ci->chip,
-- 
1.9.1

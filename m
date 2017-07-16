Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49024 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdGPLqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:46:46 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 19/21] brcmfmac: Remove repeated and annoying calls to brcmf_chip_get_core()
Date: Sun, 16 Jul 2017 12:21:27 +0100
Message-Id: <20170716112129.10206-20-ian@mnementh.co.uk> (sfid-20170716_140042_742804_471C1C3C)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 23 ++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 2d819d44358a..95d325921ce2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -435,6 +435,7 @@ struct brcmf_sdio_count {
 struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct brcmf_chip *ci;	/* Chip info struct */
+	struct brcmf_core *sdio_core; /* sdio core info struct */
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	atomic_t intstatus;	/* Intstatus bits (events) pending */
@@ -659,10 +660,9 @@ static bool data_ok(struct brcmf_sdio *bus)
  */
 static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 {
-	struct brcmf_core *core;
+	struct brcmf_core *core = bus->sdio_core;
 	int ret;
 
-	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	*regvar = brcmf_sdiod_regrl(bus->sdiodev, core->base + offset, &ret);
 
 	return ret;
@@ -670,10 +670,9 @@ static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 
 static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 {
-	struct brcmf_core *core;
+	struct brcmf_core *core = bus->sdio_core;
 	int ret;
 
-	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	brcmf_sdiod_regwl(bus->sdiodev, core->base + reg_offset, regval, &ret);
 
 	return ret;
@@ -2480,12 +2479,11 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	struct brcmf_core *buscore;
+	struct brcmf_core *buscore = bus->sdio_core;
 	u32 addr;
 	unsigned long val;
 	int ret;
 
-	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
 	addr = buscore->base + __sd_reg(intstatus);
 
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
@@ -3362,13 +3360,14 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
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
 
 	val = brcm_sdio_func1_rb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
@@ -3397,6 +3396,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_core *core = bus->sdio_core;
 	uint pad_size;
 	u32 value;
 	int err;
@@ -3405,7 +3405,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
 	 */
-	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12) {
+	if (core->rev < 12) {
 		/* for sdio core rev < 12, disable txgloming */
 		value = 0;
 		err = brcmf_iovar_data_set(dev, "bus:txglom", &value,
@@ -3743,11 +3743,10 @@ static void brcmf_sdio_buscore_activate(void *ctx, struct brcmf_chip *chip,
 					u32 rstvec)
 {
 	struct brcmf_sdio_dev *sdiodev = ctx;
-	struct brcmf_core *core;
+	struct brcmf_core *core = sdiodev->bus->sdio_core;
 	u32 reg_addr;
 
 	/* clear all interrupts */
-	core = brcmf_chip_get_core(chip, BCMA_CORE_SDIO_DEV);
 	reg_addr = core->base + __sd_reg(intstatus);
 	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
@@ -3828,6 +3827,10 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		bus->ci = NULL;
 		goto fail;
 	}
+
+	/* Pick up the SDIO core info struct from chip.c */
+	bus->sdio_core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
+
 	sdiodev->settings = brcmf_get_module_param(sdiodev->dev,
 						   BRCMF_BUSTYPE_SDIO,
 						   bus->ci->chip,
-- 
2.11.0

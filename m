Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57759 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/16] brcmfmac: use asynchronous firmware request in SDIO
Date: Tue, 27 May 2014 12:56:22 +0200
Message-ID: <1401188188-16492-11-git-send-email-arend@broadcom.com> (sfid-20140527_125723_997302_58AB8D5F)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds use of asynchronous firmware request to
the driver SDIO layer.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  271 +++++++++-----------
 1 file changed, 124 insertions(+), 147 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index efb8c4f..506ef0d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -632,43 +632,28 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BCM4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
-
-static const struct firmware *brcmf_sdio_get_fw(struct brcmf_sdio *bus,
-						  enum brcmf_firmware_type type)
+static const char *brcmf_sdio_get_fwname(struct brcmf_chip *ci,
+					 enum brcmf_firmware_type type)
 {
-	const struct firmware *fw;
-	const char *name;
-	int err, i;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(brcmf_fwname_data); i++) {
-		if (brcmf_fwname_data[i].chipid == bus->ci->chip &&
-		    brcmf_fwname_data[i].revmsk & BIT(bus->ci->chiprev)) {
+		if (brcmf_fwname_data[i].chipid == ci->chip &&
+		    brcmf_fwname_data[i].revmsk & BIT(ci->chiprev)) {
 			switch (type) {
 			case BRCMF_FIRMWARE_BIN:
-				name = brcmf_fwname_data[i].bin;
-				break;
+				return brcmf_fwname_data[i].bin;
 			case BRCMF_FIRMWARE_NVRAM:
-				name = brcmf_fwname_data[i].nv;
-				break;
+				return brcmf_fwname_data[i].nv;
 			default:
 				brcmf_err("invalid firmware type (%d)\n", type);
 				return NULL;
 			}
-			goto found;
 		}
 	}
 	brcmf_err("Unknown chipid %d [%d]\n",
-		  bus->ci->chip, bus->ci->chiprev);
+		  ci->chip, ci->chiprev);
 	return NULL;
-
-found:
-	err = request_firmware(&fw, name, &bus->sdiodev->func[2]->dev);
-	if ((err) || (!fw)) {
-		brcmf_err("fail to request firmware %s (%d)\n", name, err);
-		return NULL;
-	}
-
-	return fw;
 }
 
 static void pkt_align(struct sk_buff *p, int len, int align)
@@ -3278,20 +3263,13 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 }
 
 static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
-				     const struct firmware *nv)
+				     void *vars, u32 varsz)
 {
-	void *vars;
-	u32 varsz;
 	int address;
 	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	vars = brcmf_fw_nvram_strip(nv, &varsz);
-
-	if (vars == NULL)
-		return -EINVAL;
-
 	address = bus->ci->ramsize - varsz + bus->ci->rambase;
 	err = brcmf_sdiod_ramrw(bus->sdiodev, true, address, vars, varsz);
 	if (err)
@@ -3300,15 +3278,14 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 	else if (!brcmf_sdio_verifymemory(bus->sdiodev, address, vars, varsz))
 		err = -EIO;
 
-	brcmf_fw_nvram_free(vars);
-
 	return err;
 }
 
-static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
+					const struct firmware *fw,
+					void *nvram, u32 nvlen)
 {
 	int bcmerror = -EFAULT;
-	const struct firmware *fw;
 	u32 rstvec;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
@@ -3317,12 +3294,6 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 	/* Keep arm in reset */
 	brcmf_chip_enter_download(bus->ci);
 
-	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
-	if (fw == NULL) {
-		bcmerror = -ENOENT;
-		goto err;
-	}
-
 	rstvec = get_unaligned_le32(fw->data);
 	brcmf_dbg(SDIO, "firmware rstvec: %x\n", rstvec);
 
@@ -3330,17 +3301,12 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 	release_firmware(fw);
 	if (bcmerror) {
 		brcmf_err("dongle image file download failed\n");
+		brcmf_fw_nvram_free(nvram);
 		goto err;
 	}
 
-	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
-	if (fw == NULL) {
-		bcmerror = -ENOENT;
-		goto err;
-	}
-
-	bcmerror = brcmf_sdio_download_nvram(bus, fw);
-	release_firmware(fw);
+	bcmerror = brcmf_sdio_download_nvram(bus, nvram, nvlen);
+	brcmf_fw_nvram_free(nvram);
 	if (bcmerror) {
 		brcmf_err("dongle nvram file download failed\n");
 		goto err;
@@ -3490,97 +3456,6 @@ done:
 	return err;
 }
 
-static int brcmf_sdio_bus_init(struct device *dev)
-{
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
-	struct brcmf_sdio *bus = sdiodev->bus;
-	int err, ret = 0;
-	u8 saveclk;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* try to download image and nvram to the dongle */
-	if (bus_if->state == BRCMF_BUS_DOWN) {
-		bus->alp_only = true;
-		err = brcmf_sdio_download_firmware(bus);
-		if (err)
-			return err;
-		bus->alp_only = false;
-	}
-
-	if (!bus->sdiodev->bus_if->drvr)
-		return 0;
-
-	/* Start the watchdog timer */
-	bus->sdcnt.tickcnt = 0;
-	brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
-
-	sdio_claim_host(bus->sdiodev->func[1]);
-
-	/* Make sure backplane clock is on, needed to generate F2 interrupt */
-	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
-	if (bus->clkstate != CLK_AVAIL)
-		goto exit;
-
-	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdiod_regrb(bus->sdiodev,
-				    SBSDIO_FUNC1_CHIPCLKCSR, &err);
-	if (!err) {
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  (saveclk | SBSDIO_FORCE_HT), &err);
-	}
-	if (err) {
-		brcmf_err("Failed to force clock for F2: err %d\n", err);
-		goto exit;
-	}
-
-	/* Enable function 2 (frame transfers) */
-	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
-		  offsetof(struct sdpcmd_regs, tosbmailboxdata));
-	err = sdio_enable_func(bus->sdiodev->func[SDIO_FUNC_2]);
-
-
-	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
-
-	/* If F2 successfully enabled, set core and enable interrupts */
-	if (!err) {
-		/* Set up the interrupt mask and enable interrupts */
-		bus->hostintmask = HOSTINTMASK;
-		w_sdreg32(bus, bus->hostintmask,
-			  offsetof(struct sdpcmd_regs, hostintmask));
-
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
-	} else {
-		/* Disable F2 again */
-		sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
-		ret = -ENODEV;
-	}
-
-	if (brcmf_chip_sr_capable(bus->ci)) {
-		brcmf_sdio_sr_init(bus);
-	} else {
-		/* Restore previous clock setting */
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  saveclk, &err);
-	}
-
-	if (ret == 0) {
-		ret = brcmf_sdiod_intr_register(bus->sdiodev);
-		if (ret != 0)
-			brcmf_err("intr register failed:%d\n", ret);
-	}
-
-	/* If we didn't come up, turn off backplane clock */
-	if (ret != 0)
-		brcmf_sdio_clkctl(bus, CLK_NONE, false);
-
-exit:
-	sdio_release_host(bus->sdiodev->func[1]);
-
-	return ret;
-}
-
 void brcmf_sdio_isr(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -4026,6 +3901,108 @@ static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.gettxq = brcmf_sdio_bus_gettxq,
 };
 
+static void brcmf_sdio_firmware_callback(struct device *dev,
+					 const struct firmware *code,
+					 void *nvram, u32 nvram_len)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
+	int err = 0;
+	u8 saveclk;
+
+	brcmf_dbg(TRACE, "Enter: dev=%s\n", dev_name(dev));
+
+	/* try to download image and nvram to the dongle */
+	if (bus_if->state == BRCMF_BUS_DOWN) {
+		bus->alp_only = true;
+		err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
+		if (err)
+			goto fail;
+		bus->alp_only = false;
+	}
+
+	if (!bus_if->drvr)
+		return;
+
+	/* Start the watchdog timer */
+	bus->sdcnt.tickcnt = 0;
+	brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
+
+	sdio_claim_host(sdiodev->func[1]);
+
+	/* Make sure backplane clock is on, needed to generate F2 interrupt */
+	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
+	if (bus->clkstate != CLK_AVAIL)
+		goto release;
+
+	/* Force clocks on backplane to be sure F2 interrupt propagates */
+	saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	if (!err) {
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  (saveclk | SBSDIO_FORCE_HT), &err);
+	}
+	if (err) {
+		brcmf_err("Failed to force clock for F2: err %d\n", err);
+		goto release;
+	}
+
+	/* Enable function 2 (frame transfers) */
+	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
+		  offsetof(struct sdpcmd_regs, tosbmailboxdata));
+	err = sdio_enable_func(sdiodev->func[SDIO_FUNC_2]);
+
+
+	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
+
+	/* If F2 successfully enabled, set core and enable interrupts */
+	if (!err) {
+		/* Set up the interrupt mask and enable interrupts */
+		bus->hostintmask = HOSTINTMASK;
+		w_sdreg32(bus, bus->hostintmask,
+			  offsetof(struct sdpcmd_regs, hostintmask));
+
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_WATERMARK, 8, &err);
+	} else {
+		/* Disable F2 again */
+		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
+		goto release;
+	}
+
+	if (brcmf_chip_sr_capable(bus->ci)) {
+		brcmf_sdio_sr_init(bus);
+	} else {
+		/* Restore previous clock setting */
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				  saveclk, &err);
+	}
+
+	if (err == 0) {
+		err = brcmf_sdiod_intr_register(sdiodev);
+		if (err != 0)
+			brcmf_err("intr register failed:%d\n", err);
+	}
+
+	/* If we didn't come up, turn off backplane clock */
+	if (err != 0)
+		brcmf_sdio_clkctl(bus, CLK_NONE, false);
+
+	sdio_release_host(sdiodev->func[1]);
+
+	err = brcmf_bus_start(dev);
+	if (err != 0) {
+		brcmf_err("dongle is not responding\n");
+		goto fail;
+	}
+	return;
+
+release:
+	sdio_release_host(sdiodev->func[1]);
+fail:
+	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
+	device_release_driver(dev);
+}
+
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
@@ -4149,14 +4126,14 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
-	ret = brcmf_sdio_bus_init(sdiodev->dev);
-	if (ret)
-		goto fail;
-
-	/* if firmware path present try to download and bring up bus */
-	ret = brcmf_bus_start(bus->sdiodev->dev);
+	ret = brcmf_fw_get_firmwares(sdiodev->dev, BRCMF_FW_REQUEST_NVRAM,
+				     brcmf_sdio_get_fwname(bus->ci,
+							   BRCMF_FIRMWARE_BIN),
+				     brcmf_sdio_get_fwname(bus->ci,
+							   BRCMF_FIRMWARE_NVRAM),
+				     brcmf_sdio_firmware_callback);
 	if (ret != 0) {
-		brcmf_err("dongle is not responding\n");
+		brcmf_err("async firmware request failed: %d\n", ret);
 		goto fail;
 	}
 
-- 
1.7.9.5


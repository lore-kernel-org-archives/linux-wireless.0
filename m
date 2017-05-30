Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37521 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdE3MgK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 08:36:10 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFT 1/3] brcmfmac: add parameter to pass error code in firmware callback
Date: Tue, 30 May 2017 13:35:52 +0100
Message-Id: <1496147754-2303-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170530_143618_813069_69FAC98B)
In-Reply-To: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend the parameters in the firmware callback so it can be called
upon success and failure. This allows the caller to properly clear
all resources in the failure path. Right now the error code is
always zero, ie. success.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 10 +++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.h |  4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 17 ++++++++++++-----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 17 +++++++++++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c  |  6 ++++--
 5 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c7c1e99..ae61a24 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -442,7 +442,7 @@ struct brcmf_fw {
 	const char *nvram_name;
 	u16 domain_nr;
 	u16 bus_nr;
-	void (*done)(struct device *dev, const struct firmware *fw,
+	void (*done)(struct device *dev, int err, const struct firmware *fw,
 		     void *nvram_image, u32 nvram_len);
 };
 
@@ -477,7 +477,7 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 		goto fail;
 
-	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length);
+	fwctx->done(fwctx->dev, 0, fwctx->code, nvram, nvram_length);
 	kfree(fwctx);
 	return;
 
@@ -499,7 +499,7 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 
 	/* only requested code so done here */
 	if (!(fwctx->flags & BRCMF_FW_REQUEST_NVRAM)) {
-		fwctx->done(fwctx->dev, fw, NULL, 0);
+		fwctx->done(fwctx->dev, 0, fw, NULL, 0);
 		kfree(fwctx);
 		return;
 	}
@@ -522,7 +522,7 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 
 int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
 				const char *code, const char *nvram,
-				void (*fw_cb)(struct device *dev,
+				void (*fw_cb)(struct device *dev, int err,
 					      const struct firmware *fw,
 					      void *nvram_image, u32 nvram_len),
 				u16 domain_nr, u16 bus_nr)
@@ -555,7 +555,7 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
 
 int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
 			   const char *code, const char *nvram,
-			   void (*fw_cb)(struct device *dev,
+			   void (*fw_cb)(struct device *dev, int err,
 					 const struct firmware *fw,
 					 void *nvram_image, u32 nvram_len))
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index d3c9f0d..8fa4b7e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -73,13 +73,13 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
  */
 int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
 				const char *code, const char *nvram,
-				void (*fw_cb)(struct device *dev,
+				void (*fw_cb)(struct device *dev, int err,
 					      const struct firmware *fw,
 					      void *nvram_image, u32 nvram_len),
 				u16 domain_nr, u16 bus_nr);
 int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
 			   const char *code, const char *nvram,
-			   void (*fw_cb)(struct device *dev,
+			   void (*fw_cb)(struct device *dev, int err,
 					 const struct firmware *fw,
 					 void *nvram_image, u32 nvram_len));
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f36b96d..f878706 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1650,16 +1650,23 @@ static void brcmf_pcie_buscore_activate(void *ctx, struct brcmf_chip *chip,
 	.write32 = brcmf_pcie_buscore_write32,
 };
 
-static void brcmf_pcie_setup(struct device *dev, const struct firmware *fw,
+static void brcmf_pcie_setup(struct device *dev, int ret,
+			     const struct firmware *fw,
 			     void *nvram, u32 nvram_len)
 {
-	struct brcmf_bus *bus = dev_get_drvdata(dev);
-	struct brcmf_pciedev *pcie_bus_dev = bus->bus_priv.pcie;
-	struct brcmf_pciedev_info *devinfo = pcie_bus_dev->devinfo;
+	struct brcmf_bus *bus;
+	struct brcmf_pciedev *pcie_bus_dev;
+	struct brcmf_pciedev_info *devinfo;
 	struct brcmf_commonring **flowrings;
-	int ret;
 	u32 i;
 
+	/* check firmware loading result */
+	if (ret)
+		goto fail;
+
+	bus = dev_get_drvdata(dev);
+	pcie_bus_dev = bus->bus_priv.pcie;
+	devinfo = pcie_bus_dev->devinfo;
 	brcmf_pcie_attach(devinfo);
 
 	/* Some of the firmwares have the size of the memory of the device
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a999f95..270c0ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3978,21 +3978,26 @@ static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
 	.get_memdump = brcmf_sdio_bus_get_memdump,
 };
 
-static void brcmf_sdio_firmware_callback(struct device *dev,
+static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					 const struct firmware *code,
 					 void *nvram, u32 nvram_len)
 {
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
-	struct brcmf_sdio *bus = sdiodev->bus;
-	int err = 0;
+	struct brcmf_bus *bus_if;
+	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_sdio *bus;
 	u8 saveclk;
 
-	brcmf_dbg(TRACE, "Enter: dev=%s\n", dev_name(dev));
+	brcmf_dbg(TRACE, "Enter: dev=%s, err=%d\n", dev_name(dev), err);
+	if (err)
+		goto fail;
 
+	bus_if = dev_get_drvdata(dev);
 	if (!bus_if->drvr)
 		return;
 
+	sdiodev = bus_if->bus_priv.sdio;
+	bus = sdiodev->bus;
+
 	/* try to download image and nvram to the dongle */
 	bus->alp_only = true;
 	err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index e4d545f..9ce3b55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1159,13 +1159,15 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 	return ret;
 }
 
-static void brcmf_usb_probe_phase2(struct device *dev,
+static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 				   const struct firmware *fw,
 				   void *nvram, u32 nvlen)
 {
 	struct brcmf_bus *bus = dev_get_drvdata(dev);
 	struct brcmf_usbdev_info *devinfo;
-	int ret;
+
+	if (ret)
+		goto error;
 
 	brcmf_dbg(USB, "Start fw downloading\n");
 
-- 
1.9.1

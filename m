Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:46068 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753031AbeCPKMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:12:08 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: add extension to .get_fwname() callbacks
Date: Fri, 16 Mar 2018 11:11:22 +0100
Message-Id: <1521195085-439-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180316_111225_805992_5689BF02)
In-Reply-To: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the bus layer api by having the caller provide an
extension. With this the callback can use brcmf_fw_alloc_request()
to get the needed firmware name.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  6 +--
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 43 +++-------------------
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 27 +++++++-------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 26 +++++++------
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 27 ++++++++------
 5 files changed, 51 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 0b90a63b..31858a2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -88,7 +88,7 @@ struct brcmf_bus_ops {
 	void (*wowl_config)(struct device *dev, bool enabled);
 	size_t (*get_ramsize)(struct device *dev);
 	int (*get_memdump)(struct device *dev, void *data, size_t len);
-	int (*get_fwname)(struct device *dev, uint chip, uint chiprev,
+	int (*get_fwname)(struct device *dev, const char *ext,
 			  unsigned char *fw_name);
 };
 
@@ -228,10 +228,10 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
 }
 
 static inline
-int brcmf_bus_get_fwname(struct brcmf_bus *bus, uint chip, uint chiprev,
+int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
 			 unsigned char *fw_name)
 {
-	return bus->ops->get_fwname(bus->dev, chip, chiprev, fw_name);
+	return bus->ops->get_fwname(bus->dev, ext, fw_name);
 }
 
 /*
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6c54cae..76788e9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -125,42 +125,9 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 	return err;
 }
 
-static int brcmf_c_get_clm_name(struct brcmf_if *ifp, u8 *clm_name)
-{
-	struct brcmf_bus *bus = ifp->drvr->bus_if;
-	u8 fw_name[BRCMF_FW_NAME_LEN];
-	u8 *ptr;
-	size_t len;
-	s32 err;
-
-	memset(fw_name, 0, BRCMF_FW_NAME_LEN);
-	err = brcmf_bus_get_fwname(bus, bus->chip, bus->chiprev, fw_name);
-	if (err) {
-		brcmf_err("get firmware name failed (%d)\n", err);
-		goto done;
-	}
-
-	/* generate CLM blob file name */
-	ptr = strrchr(fw_name, '.');
-	if (!ptr) {
-		err = -ENOENT;
-		goto done;
-	}
-
-	len = ptr - fw_name + 1;
-	if (len + strlen(".clm_blob") > BRCMF_FW_NAME_LEN) {
-		err = -E2BIG;
-	} else {
-		strlcpy(clm_name, fw_name, len);
-		strlcat(clm_name, ".clm_blob", BRCMF_FW_NAME_LEN);
-	}
-done:
-	return err;
-}
-
 static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 {
-	struct device *dev = ifp->drvr->bus_if->dev;
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_dload_data_le *chunk_buf;
 	const struct firmware *clm = NULL;
 	u8 clm_name[BRCMF_FW_NAME_LEN];
@@ -173,16 +140,16 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	memset(clm_name, 0, BRCMF_FW_NAME_LEN);
-	err = brcmf_c_get_clm_name(ifp, clm_name);
+	memset(clm_name, 0, sizeof(clm_name));
+	err = brcmf_bus_get_fwname(bus, ".clm_blob", clm_name);
 	if (err) {
 		brcmf_err("get CLM blob file name failed (%d)\n", err);
 		return err;
 	}
 
-	err = request_firmware(&clm, clm_name, dev);
+	err = request_firmware(&clm, clm_name, bus->dev);
 	if (err) {
-		brcmf_info("no clm_blob available(err=%d), device may have limited channels available\n",
+		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
 			   err);
 		return 0;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 179177a..091c191 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1350,23 +1350,24 @@ static int brcmf_pcie_get_memdump(struct device *dev, void *data, size_t len)
 	return 0;
 }
 
-static int brcmf_pcie_get_fwname(struct device *dev, u32 chip, u32 chiprev,
-				 u8 *fw_name)
+static
+int brcmf_pcie_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
-	struct brcmf_pciedev_info *devinfo = buspub->devinfo;
-	int ret = 0;
+	struct brcmf_fw_request *fwreq;
+	struct brcmf_fw_name fwnames[] = {
+		{ ext, fw_name },
+	};
 
-	if (devinfo->fw_name[0] != '\0')
-		strlcpy(fw_name, devinfo->fw_name, BRCMF_FW_NAME_LEN);
-	else
-		ret = brcmf_fw_map_chip_to_name(chip, chiprev,
-						brcmf_pcie_fwnames,
-						ARRAY_SIZE(brcmf_pcie_fwnames),
-						fw_name, NULL);
+	fwreq = brcmf_fw_alloc_request(bus_if->chip, bus_if->chiprev,
+				       brcmf_pcie_fwnames,
+				       ARRAY_SIZE(brcmf_pcie_fwnames),
+				       fwnames, ARRAY_SIZE(fwnames));
+	if (!fwreq)
+		return -ENOMEM;
 
-	return ret;
+	kfree(fwreq);
+	return 0;
 }
 
 static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 24dbf7e..1037df7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4000,22 +4000,24 @@ static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
 	}
 }
 
-static int brcmf_sdio_get_fwname(struct device *dev, u32 chip, u32 chiprev,
-				 u8 *fw_name)
+static
+int brcmf_sdio_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
-	int ret = 0;
+	struct brcmf_fw_request *fwreq;
+	struct brcmf_fw_name fwnames[] = {
+		{ ext, fw_name },
+	};
 
-	if (sdiodev->fw_name[0] != '\0')
-		strlcpy(fw_name, sdiodev->fw_name, BRCMF_FW_NAME_LEN);
-	else
-		ret = brcmf_fw_map_chip_to_name(chip, chiprev,
-						brcmf_sdio_fwnames,
-						ARRAY_SIZE(brcmf_sdio_fwnames),
-						fw_name, NULL);
+	fwreq = brcmf_fw_alloc_request(bus_if->chip, bus_if->chiprev,
+				       brcmf_sdio_fwnames,
+				       ARRAY_SIZE(brcmf_sdio_fwnames),
+				       fwnames, ARRAY_SIZE(fwnames));
+	if (!fwreq)
+		return -ENOMEM;
 
-	return ret;
+	kfree(fwreq);
+	return 0;
 }
 
 static const struct brcmf_bus_ops brcmf_sdio_bus_ops = {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 1c5f135..a0873ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1128,21 +1128,24 @@ static void brcmf_usb_wowl_config(struct device *dev, bool enabled)
 		device_set_wakeup_enable(devinfo->dev, false);
 }
 
-static int brcmf_usb_get_fwname(struct device *dev, u32 chip, u32 chiprev,
-				u8 *fw_name)
+static
+int brcmf_usb_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
 {
-	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
-	int ret = 0;
+	struct brcmf_bus *bus = dev_get_drvdata(dev);
+	struct brcmf_fw_request *fwreq;
+	struct brcmf_fw_name fwnames[] = {
+		{ ext, fw_name },
+	};
 
-	if (devinfo->fw_name[0] != '\0')
-		strlcpy(fw_name, devinfo->fw_name, BRCMF_FW_NAME_LEN);
-	else
-		ret = brcmf_fw_map_chip_to_name(chip, chiprev,
-						brcmf_usb_fwnames,
-						ARRAY_SIZE(brcmf_usb_fwnames),
-						fw_name, NULL);
+	fwreq = brcmf_fw_alloc_request(bus->chip, bus->chiprev,
+				       brcmf_usb_fwnames,
+				       ARRAY_SIZE(brcmf_usb_fwnames),
+				       fwnames, ARRAY_SIZE(fwnames));
+	if (!fwreq)
+		return -ENOMEM;
 
-	return ret;
+	kfree(fwreq);
+	return 0;
 }
 
 static const struct brcmf_bus_ops brcmf_usb_bus_ops = {
-- 
1.9.1

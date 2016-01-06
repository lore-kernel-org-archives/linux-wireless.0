Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33235 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbcAFXVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 18:21:11 -0500
Received: by mail-lb0-f172.google.com with SMTP id sv6so191609796lbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2016 15:21:10 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC HACK][PATCH] brcmfmac: provide country found in NVRAM as regulatory hint
Date: Thu,  7 Jan 2016 00:20:52 +0100
Message-Id: <1452122452-20732-1-git-send-email-zajec5@gmail.com> (sfid-20160107_002115_496339_A5E074E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NVRAM may contain info about device country. Example from SR40ac (US):
wl_country_code=US
wl0_country_code=US
wl1_country_code=US
or Netgear R8000 (Canada):
wl0_country_code=CA
wl1_country_code=CA
wl2_country_code=CA

Read it when parsing NVRAM and provide to regulatory.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This is HACKy code, do not apply!

Hi, I wanted to post this suggestion for improving brcmfmac. It's bothering
OpenWrt users that have to set country manually.

This code is ugly. I think done callback is getting too complex and I don't
like the way of referencing wiphy in pcie.c.

But it gives a basic idea and I'd like to see if there will be any comments.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  3 ++
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 53 ++++++++++++++--------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  6 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 16 ++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 +-
 6 files changed, 59 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index c17b6d5..cb96f68 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -20,6 +20,9 @@
 /* for brcmu_d11inf */
 #include <brcmu_d11.h>
 
+#include "fwil_types.h"
+#include "p2p.h"
+
 #define WL_NUM_SCAN_MAX			10
 #define WL_TLV_INFO_MAX			1024
 #define WL_BSS_INFO_MAX			2048
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 1e4d5f6..6692ef1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -32,6 +32,19 @@ static char brcmf_firmware_path[BRCMF_FW_NAME_LEN];
 module_param_string(alternative_fw_path, brcmf_firmware_path,
 		    BRCMF_FW_NAME_LEN, 0440);
 
+struct brcmf_fw {
+	struct device *dev;
+	u16 flags;
+	const struct firmware *code;
+	const char *nvram_name;
+	u16 domain_nr;
+	u16 bus_nr;
+	char alpha2[2];
+	void (*done)(struct device *dev, const struct firmware *fw,
+		     void *nvram_image, u32 nvram_len, const char *alpha2);
+	struct completion *completion;
+};
+
 enum nvram_parser_state {
 	IDLE,
 	KEY,
@@ -65,6 +78,7 @@ struct nvram_parser {
 	u32 entry;
 	bool multi_dev_v1;
 	bool multi_dev_v2;
+	char alpha2[2];
 };
 
 /**
@@ -127,6 +141,11 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
 			nvp->multi_dev_v1 = true;
 		if (strncmp(&nvp->data[nvp->entry], "pcie/", 5) == 0)
 			nvp->multi_dev_v2 = true;
+		/* TODO: Use wl%d_country_code */
+		if (!strncmp(&nvp->data[nvp->entry], "wl0_country_code", 16)) {
+			nvp->alpha2[0] = nvp->data[nvp->pos + 1];
+			nvp->alpha2[1] = nvp->data[nvp->pos + 2];
+		}
 	} else if (!is_nvram_char(c) || c == ' ') {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
 			  nvp->line, nvp->column);
@@ -364,7 +383,7 @@ fail:
  * End of buffer is completed with token identifying length of buffer.
  */
 static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
-				  u32 *new_length, u16 domain_nr, u16 bus_nr)
+				  u32 *new_length, struct brcmf_fw *fwctx)
 {
 	struct nvram_parser nvp;
 	u32 pad;
@@ -380,9 +399,14 @@ static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
 			break;
 	}
 	if (nvp.multi_dev_v1)
-		brcmf_fw_strip_multi_v1(&nvp, domain_nr, bus_nr);
+		brcmf_fw_strip_multi_v1(&nvp, fwctx->domain_nr, fwctx->bus_nr);
 	else if (nvp.multi_dev_v2)
-		brcmf_fw_strip_multi_v2(&nvp, domain_nr, bus_nr);
+		brcmf_fw_strip_multi_v2(&nvp, fwctx->domain_nr, fwctx->bus_nr);
+
+	if (nvp.alpha2[0]) {
+		fwctx->alpha2[0] = nvp.alpha2[0];
+		fwctx->alpha2[1] = nvp.alpha2[1];
+	}
 
 	if (nvp.nvram_len == 0) {
 		kfree(nvp.nvram);
@@ -411,17 +435,6 @@ void brcmf_fw_nvram_free(void *nvram)
 	kfree(nvram);
 }
 
-struct brcmf_fw {
-	struct device *dev;
-	u16 flags;
-	const struct firmware *code;
-	const char *nvram_name;
-	u16 domain_nr;
-	u16 bus_nr;
-	void (*done)(struct device *dev, const struct firmware *fw,
-		     void *nvram_image, u32 nvram_len);
-};
-
 static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
@@ -445,7 +458,7 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 
 	if (data)
 		nvram = brcmf_fw_nvram_strip(data, data_len, &nvram_length,
-					     fwctx->domain_nr, fwctx->bus_nr);
+					     fwctx);
 
 	if (raw_nvram)
 		bcm47xx_nvram_release_contents(data);
@@ -453,7 +466,7 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 		goto fail;
 
-	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length);
+	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length, fwctx->alpha2[0] ? fwctx->alpha2 : NULL);
 	kfree(fwctx);
 	return;
 
@@ -475,7 +488,7 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 
 	/* only requested code so done here */
 	if (!(fwctx->flags & BRCMF_FW_REQUEST_NVRAM)) {
-		fwctx->done(fwctx->dev, fw, NULL, 0);
+		fwctx->done(fwctx->dev, fw, NULL, 0, NULL);
 		kfree(fwctx);
 		return;
 	}
@@ -500,7 +513,8 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
 				const char *code, const char *nvram,
 				void (*fw_cb)(struct device *dev,
 					      const struct firmware *fw,
-					      void *nvram_image, u32 nvram_len),
+					      void *nvram_image, u32 nvram_len,
+					      const char *alpha2),
 				u16 domain_nr, u16 bus_nr)
 {
 	struct brcmf_fw *fwctx;
@@ -533,7 +547,8 @@ int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
 			   const char *code, const char *nvram,
 			   void (*fw_cb)(struct device *dev,
 					 const struct firmware *fw,
-					 void *nvram_image, u32 nvram_len))
+					 void *nvram_image, u32 nvram_len,
+					 const char *alpha2))
 {
 	return brcmf_fw_get_firmwares_pcie(dev, flags, code, nvram, fw_cb, 0,
 					   0);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index ef06f57..963e929 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -76,12 +76,14 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
 				const char *code, const char *nvram,
 				void (*fw_cb)(struct device *dev,
 					      const struct firmware *fw,
-					      void *nvram_image, u32 nvram_len),
+					      void *nvram_image, u32 nvram_len,
+					      const char *alpha2),
 				u16 domain_nr, u16 bus_nr);
 int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
 			   const char *code, const char *nvram,
 			   void (*fw_cb)(struct device *dev,
 					 const struct firmware *fw,
-					 void *nvram_image, u32 nvram_len));
+					 void *nvram_image, u32 nvram_len,
+					 const char *alpha2));
 
 #endif /* BRCMFMAC_FIRMWARE_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3d2d790..1980416 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1682,8 +1682,11 @@ static const struct brcmf_buscore_ops brcmf_pcie_buscore_ops = {
 	.write32 = brcmf_pcie_buscore_write32,
 };
 
+#include "core.h"
+#include "cfg80211.h"
+
 static void brcmf_pcie_setup(struct device *dev, const struct firmware *fw,
-			     void *nvram, u32 nvram_len)
+			     void *nvram, u32 nvram_len, const char *alpha2)
 {
 	struct brcmf_bus *bus = dev_get_drvdata(dev);
 	struct brcmf_pciedev *pcie_bus_dev = bus->bus_priv.pcie;
@@ -1734,8 +1737,17 @@ static void brcmf_pcie_setup(struct device *dev, const struct firmware *fw,
 	init_waitqueue_head(&devinfo->mbdata_resp_wait);
 
 	brcmf_pcie_intr_enable(devinfo);
-	if (brcmf_pcie_attach_bus(bus->dev) == 0)
+	if (brcmf_pcie_attach_bus(bus->dev) == 0) {
+		if (alpha2) {
+			struct brcmf_bus *bus_if = dev_get_drvdata(bus->dev);
+			struct brcmf_pub *drvr = bus_if->drvr;
+			struct brcmf_cfg80211_info *cfg = drvr->config;
+
+			regulatory_hint(cfg->wiphy, alpha2);
+		}
+
 		return;
+	}
 
 	brcmf_pcie_bus_console_read(devinfo);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ceb2a75..e8552ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3928,7 +3928,8 @@ static const struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 
 static void brcmf_sdio_firmware_callback(struct device *dev,
 					 const struct firmware *code,
-					 void *nvram, u32 nvram_len)
+					 void *nvram, u32 nvram_len,
+					 const char *alpha2)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 66c26a9..78ae9d3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1159,7 +1159,8 @@ fail:
 
 static void brcmf_usb_probe_phase2(struct device *dev,
 				   const struct firmware *fw,
-				   void *nvram, u32 nvlen)
+				   void *nvram, u32 nvlen,
+				   const char *alpha2)
 {
 	struct brcmf_bus *bus = dev_get_drvdata(dev);
 	struct brcmf_usbdev_info *devinfo;
-- 
1.8.4.5


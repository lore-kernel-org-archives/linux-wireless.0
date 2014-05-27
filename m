Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54050 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/16] brcmfmac: introduce asynchronous firmware loading
Date: Tue, 27 May 2014 12:56:21 +0200
Message-ID: <1401188188-16492-10-git-send-email-arend@broadcom.com> (sfid-20140527_125723_337373_C42FC8B8)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver needs firmware to be loaded to the device, which
is done through the firmware class API. The synchronous call
request_firmware() need root filesystem to be mounted and/or
user-mode helper. These may not be avaliable on the moment
it is called. Instead use request_firmware_nowait().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  107 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h |   15 ++-
 2 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index ff5b867..d92fed0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/firmware.h>
 
 #include "dhd_dbg.h"
@@ -224,3 +225,109 @@ void brcmf_fw_nvram_free(void *nvram)
 	kfree(nvram);
 }
 
+struct brcmf_fw {
+	struct device *dev;
+	u16 flags;
+	const struct firmware *code;
+	const char *nvram_name;
+	void (*done)(struct device *dev, const struct firmware *fw,
+		     void *nvram_image, u32 nvram_len);
+};
+
+static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
+{
+	struct brcmf_fw *fwctx = ctx;
+	u32 nvram_length = 0;
+	void *nvram = NULL;
+
+	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
+	if (!fw && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+		goto fail;
+
+	if (fw) {
+		nvram = brcmf_fw_nvram_strip(fw, &nvram_length);
+		release_firmware(fw);
+		if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+			goto fail;
+	}
+
+	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length);
+	kfree(fwctx);
+	return;
+
+fail:
+	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
+	if (fwctx->code)
+		release_firmware(fwctx->code);
+	device_release_driver(fwctx->dev);
+	kfree(fwctx);
+}
+
+static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
+{
+	struct brcmf_fw *fwctx = ctx;
+	int ret;
+
+	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
+	if (!fw)
+		goto fail;
+
+	/* only requested code so done here */
+	if (!(fwctx->flags & BRCMF_FW_REQUEST_NVRAM)) {
+		fwctx->done(fwctx->dev, fw, NULL, 0);
+		kfree(fwctx);
+		return;
+	}
+	fwctx->code = fw;
+	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
+				      fwctx->dev, GFP_KERNEL, fwctx,
+				      brcmf_fw_request_nvram_done);
+
+	if (!ret)
+		return;
+
+	/* when nvram is optional call .done() callback here */
+	if (fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL) {
+		fwctx->done(fwctx->dev, fw, NULL, 0);
+		kfree(fwctx);
+		return;
+	}
+
+	/* failed nvram request */
+	release_firmware(fw);
+fail:
+	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
+	device_release_driver(fwctx->dev);
+	kfree(fwctx);
+}
+
+int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
+			   const char *code, const char *nvram,
+			   void (*fw_cb)(struct device *dev,
+					 const struct firmware *fw,
+					 void *nvram_image, u32 nvram_len))
+{
+	struct brcmf_fw *fwctx;
+
+	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
+	if (!fw_cb || !code)
+		return -EINVAL;
+
+	if ((flags & BRCMF_FW_REQUEST_NVRAM) && !nvram)
+		return -EINVAL;
+
+	fwctx = kzalloc(sizeof(*fwctx), GFP_KERNEL);
+	if (!fwctx)
+		return -ENOMEM;
+
+	fwctx->dev = dev;
+	fwctx->flags = flags;
+	fwctx->done = fw_cb;
+	if (flags & BRCMF_FW_REQUEST_NVRAM)
+		fwctx->nvram_name = nvram;
+
+	return request_firmware_nowait(THIS_MODULE, true, code, dev,
+				       GFP_KERNEL, fwctx,
+				       brcmf_fw_request_code_done);
+}
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
index 127633b..25b64bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.h
@@ -16,9 +16,22 @@
 #ifndef BRCMFMAC_FIRMWARE_H
 #define BRCMFMAC_FIRMWARE_H
 
+#define BRCMF_FW_REQUEST		0x000F
+#define  BRCMF_FW_REQUEST_NVRAM		0x0001
+#define BRCMF_FW_REQ_FLAGS		0x00F0
+#define  BRCMF_FW_REQ_NV_OPTIONAL	0x0010
 
 void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length);
 void brcmf_fw_nvram_free(void *nvram);
-
+/*
+ * Request firmware(s) asynchronously. When the asynchronous request
+ * fails it will not use the callback, but call device_release_driver()
+ * instead which will call the driver .remove() callback.
+ */
+int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
+			   const char *code, const char *nvram,
+			   void (*fw_cb)(struct device *dev,
+					 const struct firmware *fw,
+					 void *nvram_image, u32 nvram_len));
 
 #endif /* BRCMFMAC_FIRMWARE_H */
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45942 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbHTUGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 16:06:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V3 6/6] brcmfmac: Add support for host platform NVRAM loading.
Date: Thu, 20 Aug 2015 22:06:08 +0200
Message-ID: <1440101168-2252-7-git-send-email-arend@broadcom.com> (sfid-20150820_220618_850268_062D38CF)
In-Reply-To: <1440101168-2252-1-git-send-email-arend@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Host platforms such as routers supported by OpenWRT can
support NVRAM reading directly from internal NVRAM store.
With this patch the nvram load routines will fall back to
this method when there is no nvram file and support is
available in the kernel.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
V2:
 - addressed comments from Rafał.
V3:
 - remove redundant braces.
 - move bcm47xx_release_contents() call.
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 39 +++++++++++++---------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 743f16b..971920f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/bcm47xx_nvram.h>
 
 #include "debug.h"
 #include "firmware.h"
@@ -426,18 +427,32 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	struct brcmf_fw *fwctx = ctx;
 	u32 nvram_length = 0;
 	void *nvram = NULL;
+	u8 *data = NULL;
+	size_t data_len;
+	bool raw_nvram;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
-	if (!fw && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-		goto fail;
+	if (fw && fw->data) {
+		data = (u8 *)fw->data;
+		data_len = fw->size;
+		raw_nvram = false;
+	} else {
+		data = bcm47xx_nvram_get_contents(&data_len);
+		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+			goto fail;
+		raw_nvram = true;
+	}
 
-	if (fw) {
-		nvram = brcmf_fw_nvram_strip(fw->data, fw->size, &nvram_length,
+	if (data)
+		nvram = brcmf_fw_nvram_strip(data, data_len, &nvram_length,
 					     fwctx->domain_nr, fwctx->bus_nr);
+
+	if (raw_nvram)
+		bcm47xx_nvram_release_contents(data);
+	if (fw)
 		release_firmware(fw);
-		if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-			goto fail;
-	}
+	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+		goto fail;
 
 	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length);
 	kfree(fwctx);
@@ -473,15 +488,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 	if (!ret)
 		return;
 
-	/* when nvram is optional call .done() callback here */
-	if (fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL) {
-		fwctx->done(fwctx->dev, fw, NULL, 0);
-		kfree(fwctx);
-		return;
-	}
+	brcmf_fw_request_nvram_done(NULL, fwctx);
+	return;
 
-	/* failed nvram request */
-	release_firmware(fw);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
 	device_release_driver(fwctx->dev);
-- 
1.9.1


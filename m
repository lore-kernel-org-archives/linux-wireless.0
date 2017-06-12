Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:47527 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752623AbdFLLrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 07:47:52 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.12 2/3] brcmfmac: use firmware callback upon failure to load
Date: Mon, 12 Jun 2017 12:47:33 +0100
Message-Id: <1497268054-4507-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170612_134756_624228_3AA6EAC5)
In-Reply-To: <1497268054-4507-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497268054-4507-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When firmware loading failed the code used to unbind the device provided
by the calling code. However, for the sdio driver two devices are bound
and both need to be released upon failure. The callback has been extended
with parameter to pass error code so add that in this commit upon firmware
loading failure.

Cc: stable@vger.kernel.org # 4.9.x-
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 27 +++++++++++-----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index ae61a24..d231042 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -484,39 +484,38 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
 	release_firmware(fwctx->code);
-	device_release_driver(fwctx->dev);
+	fwctx->done(fwctx->dev, -ENOENT, NULL, NULL, 0);
 	kfree(fwctx);
 }
 
 static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
-	int ret;
+	int ret = 0;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
-	if (!fw)
+	if (!fw) {
+		ret = -ENOENT;
 		goto fail;
-
-	/* only requested code so done here */
-	if (!(fwctx->flags & BRCMF_FW_REQUEST_NVRAM)) {
-		fwctx->done(fwctx->dev, 0, fw, NULL, 0);
-		kfree(fwctx);
-		return;
 	}
+	/* only requested code so done here */
+	if (!(fwctx->flags & BRCMF_FW_REQUEST_NVRAM))
+		goto done;
+
 	fwctx->code = fw;
 	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
 				      fwctx->dev, GFP_KERNEL, fwctx,
 				      brcmf_fw_request_nvram_done);
 
-	if (!ret)
-		return;
-
-	brcmf_fw_request_nvram_done(NULL, fwctx);
+	/* pass NULL to nvram callback for bcm47xx fallback */
+	if (ret)
+		brcmf_fw_request_nvram_done(NULL, fwctx);
 	return;
 
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
-	device_release_driver(fwctx->dev);
+done:
+	fwctx->done(fwctx->dev, ret, fw, NULL, 0);
 	kfree(fwctx);
 }
 
-- 
1.9.1

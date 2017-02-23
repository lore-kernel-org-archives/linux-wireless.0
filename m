Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32993 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdBWShN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 13:37:13 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V4 2/2] brcmfmac: don't warn user about NVRAM if fallback to platform one succeeds
Date: Thu, 23 Feb 2017 19:30:18 +0100
Message-Id: <20170223183018.16704-2-zajec5@gmail.com> (sfid-20170223_193739_284370_7F6C58DE)
In-Reply-To: <20170223183018.16704-1-zajec5@gmail.com>
References: <20170221094754.15406-1-zajec5@gmail.com>
 <20170223183018.16704-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Failing to load NVRAM file isn't critical if we manage to get platform
one in the fallback path. It means warnings like:
[   10.801506] brcmfmac 0000:01:00.0: Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
are unnecessary & disturbing for people with platform NVRAM. This is
very common case for Broadcom home routers.

So instead of printing warning immediately with the firmware subsystem
let's first try our fallback code. If that fails as well, then it's a
right moment to print an error.

This should reduce amount of false reports from users seeing this
warning while having wireless working perfectly fine.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Update commit message as it wasn't clear enough (thanks Andy) & add extra
    messages to the firmware.c.
V3: Set FW_OPT_UEVENT to don't change behavior
V4: Switch to the new request_firmware_async syntax
---
 .../wireless/broadcom/brcm80211/brcmfmac/firmware.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c7c1e9906500..da7da1dc059d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -462,8 +462,14 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 		raw_nvram = false;
 	} else {
 		data = bcm47xx_nvram_get_contents(&data_len);
-		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-			goto fail;
+		if (!data) {
+			brcmf_dbg(TRACE, "Failed to get platform NVRAM\n");
+			if (!(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL)) {
+				brcmf_err("Loading NVRAM from %s and using platform one both failed\n",
+					  fwctx->nvram_name);
+				goto fail;
+			}
+		}
 		raw_nvram = true;
 	}
 
@@ -491,6 +497,9 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
+	struct firmware_opts fw_opts = {
+		.optional = true,
+	};
 	int ret;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
@@ -504,9 +513,8 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 		return;
 	}
 	fwctx->code = fw;
-	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
-				      fwctx->dev, GFP_KERNEL, fwctx,
-				      brcmf_fw_request_nvram_done);
+	ret = request_firmware_async(fwctx->nvram_name, &fw_opts, fwctx->dev,
+				     fwctx, brcmf_fw_request_nvram_done);
 
 	if (!ret)
 		return;
-- 
2.11.0

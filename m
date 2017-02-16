Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32890 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdBPH06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 02:26:58 -0500
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
Subject: [PATCH V2 2/2] brcmfmac: don't warn user about NVRAM if fallback to platform one succeeds
Date: Thu, 16 Feb 2017 08:26:36 +0100
Message-Id: <20170216072636.7128-2-zajec5@gmail.com> (sfid-20170216_082732_972587_FAC99F7D)
In-Reply-To: <20170216072636.7128-1-zajec5@gmail.com>
References: <20170215222948.21030-1-zajec5@gmail.com>
 <20170216072636.7128-1-zajec5@gmail.com>
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

Kalle, Arend: this patch is strictly related to the bigger 1/2. Could you ack
this change as I expect this patchset to be picked by Ming, Luis or Greg?
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c  | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c7c1e9906500..510a76d99eee 100644
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
 
@@ -504,9 +510,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 		return;
 	}
 	fwctx->code = fw;
-	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
-				      fwctx->dev, GFP_KERNEL, fwctx,
-				      brcmf_fw_request_nvram_done);
+	ret = request_firmware_async(THIS_MODULE, FW_OPT_NO_WARN,
+				     fwctx->nvram_name, fwctx->dev, GFP_KERNEL,
+				     fwctx, brcmf_fw_request_nvram_done);
 
 	if (!ret)
 		return;
-- 
2.11.0

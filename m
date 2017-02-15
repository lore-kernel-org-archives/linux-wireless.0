Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34328 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbdBOWaJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 17:30:09 -0500
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
Subject: [PATCH 2/2] brcmfmac: don't warn user if loading firmware file with NVRAM fails
Date: Wed, 15 Feb 2017 23:29:48 +0100
Message-Id: <20170215222948.21030-2-zajec5@gmail.com> (sfid-20170215_233058_595410_F0925DAA)
In-Reply-To: <20170215222948.21030-1-zajec5@gmail.com>
References: <20170215222948.21030-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This isn't critical as we use platform NVRAM as fallback and it's very
common case of all Broadcom home routers. Thanks for the new firmware
loading function we can achieve this by simply passing FW_OPT_NO_WARN.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Kalle, Arend: this patch is strictly related to the bigger 1/2. Could you ack
this change as I expect this patchset to be picked by Ming, Luis or Greg.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c7c1e9906500..26ec445a8d2d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -504,9 +504,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
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

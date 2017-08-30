Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34371 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdH3GEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 02:04:11 -0400
Received: by mail-pf0-f195.google.com with SMTP id p69so3730708pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Aug 2017 23:04:11 -0700 (PDT)
To: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        ian@mnementh.co.uk, linux-wireless@vger.kernel.org
From: Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH] brcmfmac: feature check for multi-scheduled scan fails on
 bcm4345 devices
Message-ID: <277a202d-7949-ddba-4893-17536d909559@gmail.com> (sfid-20170830_080457_898129_8EA22CEF)
Date: Wed, 30 Aug 2017 16:04:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware feature check introduced for multi-scheduled scan is also
failing for bcm4345 devices resulting in a firmware crash.
The reason for this crash has not yet been root cause so this patch avoids
the feature check for those device as a short-term fix.

Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
Signed-off-by: Ian W Morrison <ianwmorrison@gmail.com>
---
Tested on MINIX NEO Z83-4 and MINIX NEO Z83-4 Pro devices.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index f1b60740e..53ae302 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -159,7 +159,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)

        brcmf_feat_firmware_capabilities(ifp);
        memset(&gscan_cfg, 0, sizeof(gscan_cfg));
-       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
+       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID &&
+           drvr->bus_if->chip != BRCM_CC_4345_CHIP_ID)
                brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
                                          "pfn_gscan_cfg",
                                          &gscan_cfg, sizeof(gscan_cfg));
-- 
1.9.1

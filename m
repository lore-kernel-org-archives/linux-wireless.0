Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34362 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdH3WvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 18:51:06 -0400
Received: by mail-pf0-f193.google.com with SMTP id v22so349934pfk.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 15:51:05 -0700 (PDT)
To: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        ian@mnementh.co.uk, linux-wireless@vger.kernel.org
From: Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH v2] brcmfmac: feature check for multi-scheduled scan fails on
 bcm4345 devices
Message-ID: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com> (sfid-20170831_005113_477238_B5820B3D)
Date: Thu, 31 Aug 2017 08:51:03 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware feature check introduced for multi-scheduled scan is also
failing for bcm4345 devices resulting in a firmware crash.
The reason for this crash has not yet been root cause so this patch avoids
the feature check for those device as a short-term fix.

Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
---
v2: Fixed tabs being replaced by spaces in patch submission
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
-	if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
+	if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID &&
+	    drvr->bus_if->chip != BRCM_CC_4345_CHIP_ID)
 		brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
 					  "pfn_gscan_cfg",
 					  &gscan_cfg, sizeof(gscan_cfg));
-- 
1.9.1

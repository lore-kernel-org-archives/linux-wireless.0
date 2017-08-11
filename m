Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:47579 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752730AbdHKKHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 06:07:40 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.13] brcmfmac: feature check for multi-scheduled scan fails on bcm4343x devices
Date: Fri, 11 Aug 2017 11:07:36 +0100
Message-Id: <1502446056-30035-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170811_120744_349735_BED92F88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware feature check introduced for multi-scheduled scan turned out
to be failing for bcm4343{0,1,8} devices resulting in a firmware crash.
The reason for this crash has not yet been root cause so this patch avoids
the feature check for those device as a short-term fix.

Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Reported-by: Ian Molton <ian@mnementh.co.uk>
Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d21258d..f1b60740e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -159,8 +159,10 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 
 	brcmf_feat_firmware_capabilities(ifp);
 	memset(&gscan_cfg, 0, sizeof(gscan_cfg));
-	brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
-				  &gscan_cfg, sizeof(gscan_cfg));
+	if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
+		brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
+					  "pfn_gscan_cfg",
+					  &gscan_cfg, sizeof(gscan_cfg));
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
-- 
1.9.1

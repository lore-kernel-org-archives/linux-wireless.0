Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4419 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbCTVTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 17:19:41 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-4.0] brcmfmac: disable MBSS feature for BCM43362
Date: Fri, 20 Mar 2015 22:18:17 +0100
Message-ID: <1426886313-2936-1-git-send-email-arend@broadcom.com> (sfid-20150320_221944_193739_4E38E6F2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM43362 firmware falsely reports it is capable of providing
MBSS. As a result AP mode no longer works for this device. Therefor
disable MBSS in the driver for this chipset.

Cc: stable@vger.kernel.org # 3.19.y
Reported-by: Jorg Krause <jkrause@posteo.de>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/feature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index defb7a4..7748a1c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -126,7 +126,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
-	brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
+	if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
+		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
 
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
-- 
1.9.1


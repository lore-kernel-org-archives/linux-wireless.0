Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp110.iad3a.emailsrvr.com ([173.203.187.110]:58723 "EHLO
        smtp110.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751239AbeEDG4r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 02:56:47 -0400
From: Sean Lanigan <sean@lano.id.au>
To: arend.vanspriel@broadcom.com
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        ulf.hansson@linaro.org, ian@mnementh.co.uk,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        linux-mmc@vger.kernel.org, Sean Lanigan <sean@lano.id.au>
Subject: [PATCH] brcmfmac: Add support for bcm43364 wireless chipset
Date: Fri,  4 May 2018 16:48:23 +1000
Message-Id: <1525416503-832-1-git-send-email-sean@lano.id.au> (sfid-20180504_085650_972833_6369D996)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the BCM43364 chipset via an SDIO interface, as used in 
e.g. the Murata 1FX module. 

The BCM43364 uses the same firmware as the BCM43430 (which is already 
included), the only difference is the omission of Bluetooth. 

However, the SDIO_ID for the BCM43364 is 02D0:A9A4, giving it a MODALIAS 
of sdio:c00v02D0dA9A4, which doesn't get recognised and hence doesn't 
load the brcmfmac module. Adding the 'A9A4' ID in the appropriate place 
triggers the brcmfmac driver to load, and then correctly use the 
firmware file 'brcmfmac43430-sdio.bin'. 


Signed-off-by: Sean Lanigan <sean@lano.id.au>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
 include/linux/mmc/sdio_ids.h                              | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 0b68240..4648a3d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -963,6 +963,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43340),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
+ 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43364),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index cdd66a5..0a7abe8 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -35,6 +35,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
 #define SDIO_DEVICE_ID_BROADCOM_4339		0x4339
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
+#define SDIO_DEVICE_ID_BROADCOM_43364		0xa9a4
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
 #define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
-- 
2.7.4

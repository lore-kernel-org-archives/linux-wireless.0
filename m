Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:35329 "EHLO
        mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933289AbcIEKmU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 06:42:20 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/2] brcmfmac: add support for bcm4339 chip with modalias sdio:c00v02D0d4339
Date: Mon,  5 Sep 2016 11:42:12 +0100
Message-Id: <1473072133-4266-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160905_124227_918006_3DD1A6BD)
In-Reply-To: <1473072133-4266-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1473072133-4266-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver already supports the bcm4339 chipset but only for the variant
that shares the same modalias as the bcm4335, ie. sdio:c00v02D0d4335.
It turns out that there are also bcm4339 devices out there that have a
more distiguishable modalias sdio:c00v02D0d4339.

Reported-by: Steve deRosier <derosier@gmail.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 3 ++-
 include/linux/mmc/sdio_ids.h                              | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index f549c25..03404cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1101,6 +1101,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 68ab3ac..589a49c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3757,7 +3757,8 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	u32 val, rev;
 
 	val = brcmf_sdiod_regrl(sdiodev, addr, NULL);
-	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
+	if ((sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
+	     sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
 	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 		if (rev >= 2) {
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 0d126ae..d43ef96 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -32,6 +32,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43340		0xa94c
 #define SDIO_DEVICE_ID_BROADCOM_43341		0xa94d
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
+#define SDIO_DEVICE_ID_BROADCOM_4339		0x4339
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
 #define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
-- 
1.9.1

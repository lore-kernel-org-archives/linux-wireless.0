Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935988AbdEZLC6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 07:02:58 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then hardcoded "4" for bus:txglomalign
Date: Fri, 26 May 2017 13:02:55 +0200
Message-Id: <20170526110255.21342-1-hdegoede@redhat.com> (sfid-20170526_130304_010370_C89E38A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

This fixes the following errors showing up in dmesg:

[   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
[   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
[   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8

Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fc64b8913aa6..e03450059b06 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3422,7 +3422,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 		/* otherwise, set txglomalign */
 		value = sdiodev->settings->bus.sdio.sd_sgentry_align;
 		/* SDIO ADMA requires at least 32 bit alignment */
-		value = max_t(u32, value, 4);
+		value = max_t(u32, value, ALIGNMENT);
 		err = brcmf_iovar_data_set(dev, "bus:txglomalign", &value,
 					   sizeof(u32));
 	}
-- 
2.13.0

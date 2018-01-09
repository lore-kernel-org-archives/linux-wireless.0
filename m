Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:56580 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752152AbeAIMXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:23:02 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 2/3] brcmfmac: add comment block in brcmf_sdio_buscore_read()
Date: Tue,  9 Jan 2018 13:22:53 +0100
Message-Id: <1515500574-16321-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180109_132307_708063_4827BEFA)
In-Reply-To: <1515500574-16321-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1515500574-16321-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_sdio_buscore_read() there is some special handling upon
register access to chipid register of the chipcommon core. Add
comment explaining why it is done here.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 81eb776..0868614 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3772,6 +3772,13 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 
 	val = brcmf_sdiod_readl(sdiodev, addr, NULL);
 
+	/*
+	 * this is a bit of special handling if reading the chipcommon chipid
+	 * register. The 4339 is a next-gen of the 4335. It uses the same
+	 * SDIO device id as 4335 and the chipid register returns 4335 as well.
+	 * It can be identified as 4339 by looking at the chip revision. It
+	 * is corrected here so the chip.c module has the right info.
+	 */
 	if (addr == CORE_CC_REG(SI_ENUM_BASE, chipid) &&
 	    (sdiodev->func1->device == SDIO_DEVICE_ID_BROADCOM_4339 ||
 	     sdiodev->func1->device == SDIO_DEVICE_ID_BROADCOM_4335_4339)) {
-- 
1.9.1

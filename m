Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26513 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbcGOKvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 06:51:15 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: defer DPC processing during probe
Date: Fri, 15 Jul 2016 12:39:13 +0200
Message-Id: <1468579153-14292-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160715_125203_640557_8A4AE0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio dpc starts processing when in SDIOD_STATE_DATA. This state was
entered right after firmware download. This patch moves that transition
just before enabling sdio interrupt handling thus avoiding watchdog
expiry which would put the bus to sleep while probing.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

Here a straggler commit for wireless-drivers-next. No harm if it does
not make it in v4.8.

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5fb8b91..68ab3ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3305,10 +3305,6 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 		goto err;
 	}
 
-	/* Allow full data communication using DPC from now on. */
-	brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
-	bcmerror = 0;
-
 err:
 	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
 	sdio_release_host(bus->sdiodev->func[1]);
@@ -4046,6 +4042,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 	}
 
 	if (err == 0) {
+		/* Allow full data communication using DPC from now on. */
+		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
+
 		err = brcmf_sdiod_intr_register(sdiodev);
 		if (err != 0)
 			brcmf_err("intr register failed:%d\n", err);
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34219 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaG2MXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 08:23:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH v4 4/4] brcmfmac: Fix OOB interrupt not working for BCM43362
Date: Tue, 29 Jul 2014 14:23:23 +0200
Message-ID: <1406636603-1451-1-git-send-email-arend@broadcom.com> (sfid-20140729_142342_241972_7878ED7A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

It has taken me a long long time to get the OOB interrupt working on the
AP6210 sdio wifi/bt module found on various Allwinner A20 boards. In the
end I found these magic register pokes in the cubietruck kernel tree:
https://github.com/cubieboard2/linux-sunxi/commit/7f08ba395617d17e7a711507503d89a50406fe7a

This is also done for the bcm43362 in broadcom's internal/proprietary driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
[arend@broadcom.com: rebased changing BCM43362 chip id to fix compilation]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

The last patch in this series introduced the compilation issue
so I only fixed that. Hope you still have the whole series somewhere.
This patch replaces the one with:

Message-ID: <1404051421-24377-5-git-send-email-hdegoede@redhat.com>

It applies to the master branch of the wireless-next repository.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index dc2db47..8dbd5db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -38,7 +38,9 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
+#include <chipcommon.h>
 #include <soc.h>
+#include "chip.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
@@ -118,6 +120,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 	u8 data;
+	u32 addr, gpiocontrol;
 	unsigned long flags;
 
 	if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
@@ -147,6 +150,19 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		sdio_claim_host(sdiodev->func[1]);
 
+		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
+			/* assign GPIO to SDIO core */
+			addr = CORE_CC_REG(SI_ENUM_BASE, gpiocontrol);
+			gpiocontrol = brcmf_sdiod_regrl(sdiodev, addr, &ret);
+			gpiocontrol |= 0x2;
+			brcmf_sdiod_regwl(sdiodev, addr, gpiocontrol, &ret);
+
+			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_SELECT, 0xf,
+					  &ret);
+			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
+			brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
+		}
+
 		/* must configure SDIO_CCCR_IENx to enable irq */
 		data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
 		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-- 
1.9.1


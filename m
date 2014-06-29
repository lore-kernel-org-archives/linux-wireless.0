Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaF2ORo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 10:17:44 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 4/4] brcmfmac: Fix OOB interrupt not working for BCM43362
Date: Sun, 29 Jun 2014 16:17:01 +0200
Message-Id: <1404051421-24377-5-git-send-email-hdegoede@redhat.com> (sfid-20140629_161748_729105_5039B285)
In-Reply-To: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
References: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has taken me a long long time to get the OOB interrupt working on the
AP6210 sdio wifi/bt module found on various Allwinner A20 boards. In the
end I found these magic register pokes in the cubietruck kernel tree:
https://github.com/cubieboard2/linux-sunxi/commit/7f08ba395617d17e7a711507503d89a50406fe7a

This is also done for the bcm43362 in broadcom's internal/proprietary driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 0fc707c..58e86a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -39,7 +39,9 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
+#include <chipcommon.h>
 #include <soc.h>
+#include "chip.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
@@ -119,6 +121,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 	u8 data;
+	u32 addr, gpiocontrol;
 	unsigned long flags;
 
 	if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
@@ -148,6 +151,19 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		sdio_claim_host(sdiodev->func[1]);
 
+		if (sdiodev->bus_if->chip == BCM43362_CHIP_ID) {
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
2.0.0


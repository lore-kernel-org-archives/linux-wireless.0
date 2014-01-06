Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5265 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaAFLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/15] brcmfmac: correct detection of save&restore device capability
Date: Mon, 6 Jan 2014 12:40:43 +0100
Message-ID: <1389008450-28529-9-git-send-email-arend@broadcom.com> (sfid-20140106_124134_858772_FFF13FE0)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The detection of the save&restore capability in brcmf_sdio_sr_capable()
is only valid for certain chipsets. This patch should cover it for all
chipsets currently supported.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 +++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 270cf9b..ae5f040 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3384,7 +3384,8 @@ err:
 
 static bool brcmf_sdio_sr_capable(struct brcmf_sdio *bus)
 {
-	u32 addr, reg;
+	u32 addr, reg, pmu_cc3_mask = ~0;
+	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3392,13 +3393,27 @@ static bool brcmf_sdio_sr_capable(struct brcmf_sdio *bus)
 	if (bus->ci->pmurev < 17)
 		return false;
 
-	/* read PMU chipcontrol register 3*/
-	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_addr);
-	brcmf_sdiod_regwl(bus->sdiodev, addr, 3, NULL);
-	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_data);
-	reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
+	switch (bus->ci->chip) {
+	case BCM43241_CHIP_ID:
+	case BCM4335_CHIP_ID:
+	case BCM4339_CHIP_ID:
+		/* read PMU chipcontrol register 3 */
+		addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_addr);
+		brcmf_sdiod_regwl(bus->sdiodev, addr, 3, NULL);
+		addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_data);
+		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
+		return (reg & pmu_cc3_mask) != 0;
+	default:
+		addr = CORE_CC_REG(bus->ci->c_inf[0].base, pmucapabilities_ext);
+		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, &err);
+		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
+			return false;
 
-	return (bool)reg;
+		addr = CORE_CC_REG(bus->ci->c_inf[0].base, retention_ctl);
+		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
+		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
+			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
+	}
 }
 
 static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
-- 
1.7.10.4


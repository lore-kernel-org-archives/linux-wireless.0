Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3677 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/16] brcm80211: fmac: move dongle gpio reset code to
 chip attach function
Date: Fri, 4 Nov 2011 22:23:33 +0100
Message-ID: <1320441822-4615-8-git-send-email-arend@broadcom.com> (sfid-20111104_222418_287968_ADE9C2F3)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the abstracting chip backplane handle code
series.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 -----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c98986f..30187c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3885,11 +3885,6 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	if (err)
 		goto fail;
 
-	brcmf_sdcard_reg_write(bus->sdiodev,
-		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
-	brcmf_sdcard_reg_write(bus->sdiodev,
-		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
-
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 		SDIO_FUNC_ENABLE_1, NULL);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 486f145..002157f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -266,5 +266,10 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
+	brcmf_sdcard_reg_write(sdiodev,
+		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
+	brcmf_sdcard_reg_write(sdiodev,
+		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
+
 	return ret;
 }
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1868 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab3FRL3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: remove redundant chip ID check in
 dhd_sdio
Date: Tue, 18 Jun 2013 13:29:27 +0200
Message-ID: <1371554970-23495-7-git-send-email-arend@broadcom.com> (sfid-20130618_132948_865752_08998B96)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

There is an ID table registered to SDIO stack which consists of all SDIO devices
supported by brcmfmac. It is not necessary to have an extra check.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   22 --------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d4db0c7..cb22f2f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3509,23 +3509,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 	return (atomic_read(&bus->ipend) > 0);
 }
 
-static bool brcmf_sdbrcm_chipmatch(u16 chipid)
-{
-	if (chipid == BCM43143_CHIP_ID)
-		return true;
-	if (chipid == BCM43241_CHIP_ID)
-		return true;
-	if (chipid == BCM4329_CHIP_ID)
-		return true;
-	if (chipid == BCM4330_CHIP_ID)
-		return true;
-	if (chipid == BCM4334_CHIP_ID)
-		return true;
-	if (chipid == BCM4335_CHIP_ID)
-		return true;
-	return false;
-}
-
 static void brcmf_sdio_dataworker(struct work_struct *work)
 {
 	struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
@@ -3622,11 +3605,6 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		goto fail;
 	}
 
-	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
-		brcmf_err("unsupported chip: 0x%04x\n", bus->ci->chip);
-		goto fail;
-	}
-
 	if (brcmf_sdbrcm_kso_init(bus)) {
 		brcmf_err("error enabling KSO\n");
 		goto fail;
-- 
1.7.10.4



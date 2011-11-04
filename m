Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3678 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab1KDVYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/16] brcm80211: fmac: move chip detach function to
 sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:39 +0100
Message-ID: <1320441822-4615-14-git-send-email-arend@broadcom.com> (sfid-20111104_222426_512472_26A9EFCD)
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
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   11 +----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    9 +++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    1 +
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index af6f3a4..e05c784 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3967,15 +3967,6 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 	}
 }
 
-static void
-brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	kfree(bus->ci);
-	bus->ci = NULL;
-}
-
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3983,7 +3974,7 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 	if (bus->ci) {
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
-		brcmf_sdbrcm_chip_detach(bus);
+		brcmf_sdio_chip_detach(&bus->ci);
 		if (bus->vars && bus->varsz)
 			kfree(bus->vars);
 		bus->vars = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 4acdda1..ea12a4c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -354,3 +354,12 @@ err:
 	kfree(ci);
 	return ret;
 }
+
+void
+brcmf_sdio_chip_detach(struct chip_info **ci_ptr)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	kfree(*ci_ptr);
+	*ci_ptr = NULL;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 6ad5ea6..13b09a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -141,5 +141,6 @@ extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
 					u32 corebase);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info **ci_ptr, u32 regs);
+extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3248 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab2KOCqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:32 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 15/19] brcmfmac: sdio unload fix.
Date: Wed, 14 Nov 2012 18:46:19 -0800
Message-ID: <1352947583-25341-16-git-send-email-frankyl@broadcom.com> (sfid-20121115_034653_606061_1BFF1CC1)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

on sdio remove the bus_if should be configured for close, so
new data from higher layers will be blocked. Also the access
to bus_if in the watchdog should be checked for null pointer
access on sdio remove.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 1aec434..b924ed7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -535,6 +535,8 @@ EXPORT_SYMBOL(brcmf_sdio_probe);
 
 int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 {
+	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+
 	if (sdiodev->bus) {
 		brcmf_sdbrcm_disconnect(sdiodev->bus);
 		sdiodev->bus = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 40a37ac..4572545 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3576,7 +3576,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
-	if (bus_if->state == BRCMF_BUS_DATA &&
+	if (bus_if && bus_if->state == BRCMF_BUS_DATA &&
 	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1648 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/24] brcm80211: fmac: stop using brcmf_pub in
 brcmf_sdbrcm_bus_watchdog
Date: Tue, 22 Nov 2011 17:21:53 -0800
Message-ID: <1322011319-24863-19-git-send-email-frankyl@broadcom.com> (sfid-20111123_022233_040608_8A716063)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

structure brcmf_pub contains context for generic layer and should
not be used in brcmf_sdbrcm_bus_watchdog. This patch is part of
fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7c8b5f7..885d16a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3535,14 +3535,14 @@ void brcmf_sdbrcm_isr(void *arg)
 		complete(&bus->dpc_wait);
 }
 
-static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
+static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio *bus;
+#ifdef BCMDBG
+	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
+#endif	/* BCMDBG */
 
 	brcmf_dbg(TIMER, "Enter\n");
 
-	bus = drvr->bus;
-
 	/* Ignore the timer if simulating bus down */
 	if (bus->sleeping)
 		return false;
@@ -3586,7 +3586,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	}
 #ifdef BCMDBG
 	/* Poll for console output periodically */
-	if (drvr->bus_if->state == BRCMF_BUS_DATA &&
+	if (bus_if->state == BRCMF_BUS_DATA &&
 	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
@@ -3801,7 +3801,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (kthread_should_stop())
 			break;
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
-			brcmf_sdbrcm_bus_watchdog(bus->drvr);
+			brcmf_sdbrcm_bus_watchdog(bus);
 			/* Count the tick for reference */
 			bus->drvr->tickcnt++;
 		} else
-- 
1.7.5.4



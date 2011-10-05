Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2121 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934702Ab1JENUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/15] staging: brcm80211: fix thread blocking issue in
 brcmf_sdbrcm_bus_stop()
Date: Wed, 5 Oct 2011 15:20:06 +0200
Message-ID: <1317820814-7083-8-git-send-email-arend@broadcom.com> (sfid-20111005_152043_133265_A4D6B85C)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_sdbrcm_bus_stop() terminates the watchdog and dpc
thread, but this function can be called from the dpc thread itself.
Stopping the dpc thread is only done when it is not the 'current'
thread.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0f7b80d..6885755 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2694,7 +2694,10 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
+				/* after stopping the bus, exit thread */
 				brcmf_sdbrcm_bus_stop(bus);
+				bus->dpc_tsk = NULL;
+				break;
 			}
 		} else
 			break;
@@ -3601,25 +3604,25 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	down(&bus->sdsem);
-
-	bus_wake(bus);
-
-	/* Enable clock for device interrupts */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
 	if (bus->watchdog_tsk) {
 		send_sig(SIGTERM, bus->watchdog_tsk, 1);
 		kthread_stop(bus->watchdog_tsk);
 		bus->watchdog_tsk = NULL;
 	}
 
-	if (bus->dpc_tsk) {
+	if (bus->dpc_tsk && bus->dpc_tsk != current) {
 		send_sig(SIGTERM, bus->dpc_tsk, 1);
 		kthread_stop(bus->dpc_tsk);
 		bus->dpc_tsk = NULL;
 	}
 
+	down(&bus->sdsem);
+
+	bus_wake(bus);
+
+	/* Enable clock for device interrupts */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+
 	/* Disable and clear interrupts at the chip level also */
 	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
 	local_hostintmask = bus->hostintmask;
-- 
1.7.4.1



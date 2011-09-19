Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4566 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab1ISV0d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/20] staging: brcm80211: remove fullmac module_param
 for watchdog
Date: Mon, 19 Sep 2011 14:25:58 -0700
Message-ID: <1316467568-27683-11-git-send-email-frankyl@broadcom.com> (sfid-20110919_232646_175519_A280B087)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use constant to replace global variable used for watchdog polling

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h  |    6 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   45 +++++++++---------------
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index d9d1592..5906337 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -375,7 +375,7 @@ void brcmf_sdio_unregister(void)
 void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
 {
 	if (enable)
-		brcmf_sdbrcm_wd_timer(sdiodev->bus, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	else
 		brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index d02cb10..104c0e7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -20,6 +20,9 @@
 /* Packet alignment for most efficient SDIO (can change based on platform) */
 #define BRCMF_SDALIGN	(1 << 6)
 
+/* watchdog polling interval in ms */
+#define BRCMF_WD_POLL_MS	10
+
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
@@ -28,9 +31,6 @@
 extern uint brcmf_txbound;
 extern uint brcmf_rxbound;
 
-/* Watchdog timer interval */
-extern uint brcmf_watchdog_ms;
-
 /* Indicate (dis)interest in finding dongles. */
 extern int brcmf_bus_register(void);
 extern void brcmf_bus_unregister(void);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 53de5a7..4033e73 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -612,6 +612,7 @@ struct brcmf_bus {
 	uint pollcnt;		/* Count of active polls */
 
 #ifdef BCMDBG
+	uint console_interval;
 	struct brcmf_console console;	/* Console output polling support */
 	uint console_addr;	/* Console address from shared struct */
 #endif				/* BCMDBG */
@@ -735,20 +736,10 @@ static int tx_packets[NUMPRIO];
 int brcmf_watchdog_prio = 97;
 module_param(brcmf_watchdog_prio, int, 0);
 
-/* Watchdog interval */
-uint brcmf_watchdog_ms = 10;
-module_param(brcmf_watchdog_ms, uint, 0);
-
 /* DPC thread priority, -1 to use tasklet */
 int brcmf_dpc_prio = 98;
 module_param(brcmf_dpc_prio, int, 0);
 
-#ifdef BCMDBG
-/* Console poll interval */
-uint brcmf_console_ms;
-module_param(brcmf_console_ms, uint, 0);
-#endif		/* BCMDBG */
-
 /* Tx/Rx bounds */
 uint brcmf_txbound;
 uint brcmf_rxbound;
@@ -1023,7 +1014,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
 		if (target == CLK_AVAIL) {
-			brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+			brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 			bus->activity = true;
 		}
 		return 0;
@@ -1036,7 +1027,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 			brcmf_sdbrcm_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
 		brcmf_sdbrcm_htclk(bus, true, pendok);
-		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 		bus->activity = true;
 		break;
 
@@ -1049,7 +1040,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 		else
 			brcmf_dbg(ERROR, "request for %d -> %d\n",
 				  bus->clkstate, target);
-		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 		break;
 
 	case CLK_NONE:
@@ -4038,7 +4029,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 	/* Start the watchdog timer */
 	bus->drvr->tickcnt = 0;
-	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
 	if (enforce_mutex)
 		brcmf_sdbrcm_sdlock(bus);
@@ -4207,15 +4198,15 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	}
 #ifdef BCMDBG
 	/* Poll for console output periodically */
-	if (drvr->busstate == BRCMF_BUS_DATA && brcmf_console_ms != 0) {
-		bus->console.count += brcmf_watchdog_ms;
-		if (bus->console.count >= brcmf_console_ms) {
-			bus->console.count -= brcmf_console_ms;
+	if (drvr->busstate == BRCMF_BUS_DATA && bus->console_interval != 0) {
+		bus->console.count += BRCMF_WD_POLL_MS;
+		if (bus->console.count >= bus->console_interval) {
+			bus->console.count -= bus->console_interval;
 			/* Make sure backplane clock is on */
 			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 			if (brcmf_sdbrcm_readconsole(bus) < 0)
-				brcmf_console_ms = 0;	/* On error,
-							 stop trying */
+				/* stop on error */
+				bus->console_interval = 0;
 		}
 	}
 #endif				/* BCMDBG */
@@ -4226,7 +4217,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 			bus->idlecount = 0;
 			if (bus->activity) {
 				bus->activity = false;
-				brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+				brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 			} else {
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 			}
@@ -4723,7 +4714,7 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 
 	/* Reschedule the watchdog */
 	if (bus->wd_timer_valid)
-		mod_timer(&bus->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
+		mod_timer(&bus->timer, jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
 }
 
 static void
@@ -5017,7 +5008,7 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
 			bcmerror = -EIO;
 		}
-		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 	}
 	return bcmerror;
 }
@@ -5038,9 +5029,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 	}
 
 	if (wdtick) {
-		brcmf_watchdog_ms = (uint) wdtick;
-
-		if (bus->save_ms != brcmf_watchdog_ms) {
+		if (bus->save_ms != BRCMF_WD_POLL_MS) {
 			if (bus->wd_timer_valid == true)
 				/* Stop timer and restart at new value */
 				del_timer_sync(&bus->timer);
@@ -5049,13 +5038,13 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 			   dynamically changed or in the first instance
 			 */
 			bus->timer.expires =
-				jiffies + brcmf_watchdog_ms * HZ / 1000;
+				jiffies + BRCMF_WD_POLL_MS * HZ / 1000;
 			add_timer(&bus->timer);
 
 		} else {
 			/* Re arm the timer, at last watchdog period */
 			mod_timer(&bus->timer,
-				jiffies + brcmf_watchdog_ms * HZ / 1000);
+				jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
 		}
 
 		bus->wd_timer_valid = true;
-- 
1.7.1



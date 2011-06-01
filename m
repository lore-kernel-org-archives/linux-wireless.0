Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3783 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161163Ab1FALqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:20 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/83] staging: brcm80211: remove WLC_WATCHDOG_TBTT
 macro
Date: Wed, 1 Jun 2011 13:44:50 +0200
Message-ID: <1306928768-7501-5-git-send-email-rvossen@broadcom.com> (sfid-20110601_134627_100158_D017E9BE)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The expanded macro expression will always be false so it has been
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   34 -------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c078ea0..56ea77f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -100,10 +100,6 @@
  * calibration and scb update
  */
 
-/* watchdog trigger mode: OSL timer or TBTT */
-#define WLC_WATCHDOG_TBTT(wlc) \
-	(wlc->stas_associated > 0 && wlc->PM != PM_OFF && wlc->pub->align_wd_tbtt)
-
 /* To inform the ucode of the last mcast frame posted so that it can clear moredata bit */
 #define BCMCFID(wlc, fid) wlc_bmac_write_shm((wlc)->hw, M_BCMC_FID, (fid))
 
@@ -1945,14 +1941,7 @@ bool wlc_radio_monitor_stop(struct wlc_info *wlc)
 
 static void wlc_watchdog_by_timer(void *arg)
 {
-	struct wlc_info *wlc = (struct wlc_info *) arg;
 	wlc_watchdog(arg);
-	if (WLC_WATCHDOG_TBTT(wlc)) {
-		/* set to normal osl watchdog period */
-		wl_del_timer(wlc->wl, wlc->wdtimer);
-		wl_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG,
-			     true);
-	}
 }
 
 /* common watchdog code */
@@ -4281,29 +4270,6 @@ void wlc_tbtt(struct wlc_info *wlc, d11regs_t *regs)
 {
 	struct wlc_bsscfg *cfg = wlc->cfg;
 
-	if (BSSCFG_STA(cfg)) {
-		/* run watchdog here if the watchdog timer is not armed */
-		if (WLC_WATCHDOG_TBTT(wlc)) {
-			u32 cur, delta;
-			if (wlc->WDarmed) {
-				wl_del_timer(wlc->wl, wlc->wdtimer);
-				wlc->WDarmed = false;
-			}
-
-			cur = OSL_SYSUPTIME();
-			delta = cur > wlc->WDlast ? cur - wlc->WDlast :
-			    (u32) ~0 - wlc->WDlast + cur + 1;
-			if (delta >= TIMER_INTERVAL_WATCHDOG) {
-				wlc_watchdog((void *)wlc);
-				wlc->WDlast = cur;
-			}
-
-			wl_add_timer(wlc->wl, wlc->wdtimer,
-				     wlc_watchdog_backup_bi(wlc), true);
-			wlc->WDarmed = true;
-		}
-	}
-
 	if (!cfg->BSS) {
 		/* DirFrmQ is now valid...defer setting until end of ATIM window */
 		wlc->qvalid |= MCMD_DIRFRMQVAL;
-- 
1.7.4.1



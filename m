Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3789 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/20] staging: brcm80211: remove static function
 variable in brcmfmac
Date: Mon, 12 Sep 2011 12:14:52 +0200
Message-ID: <1315822504-24210-9-git-send-email-rvossen@broadcom.com> (sfid-20110912_121536_301539_9077BF14)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The static local variable save_ms in brcmf_sdbrcm_wd_timer() has been
removed and placed in the structure brcmf_bus definition.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index efff099..823567f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -654,6 +654,7 @@ struct brcmf_bus {
 	struct completion watchdog_wait;
 	struct task_struct *watchdog_tsk;
 	bool wd_timer_valid;
+	uint save_ms;
 
 	struct tasklet_struct tasklet;
 	struct task_struct *dpc_tsk;
@@ -5031,8 +5032,6 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 void
 brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 {
-	static uint save_ms;
-
 	/* don't start the wd until fw is loaded */
 	if (bus->drvr->busstate == BRCMF_BUS_DOWN)
 		return;
@@ -5041,14 +5040,14 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 	if (!wdtick && bus->wd_timer_valid == true) {
 		del_timer_sync(&bus->timer);
 		bus->wd_timer_valid = false;
-		save_ms = wdtick;
+		bus->save_ms = wdtick;
 		return;
 	}
 
 	if (wdtick) {
 		brcmf_watchdog_ms = (uint) wdtick;
 
-		if (save_ms != brcmf_watchdog_ms) {
+		if (bus->save_ms != brcmf_watchdog_ms) {
 			if (bus->wd_timer_valid == true)
 				/* Stop timer and restart at new value */
 				del_timer_sync(&bus->timer);
@@ -5067,7 +5066,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 		}
 
 		bus->wd_timer_valid = true;
-		save_ms = wdtick;
+		bus->save_ms = wdtick;
 	}
 }
 
-- 
1.7.4.1



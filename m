Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22248 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcAEKGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:06:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: change brcmf_sdio_wd_timer() prototype
Date: Tue, 5 Jan 2016 11:05:47 +0100
Message-ID: <1451988350-2197-4-git-send-email-arend@broadcom.com> (sfid-20160105_110616_885836_47B67EB0)
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_sdio_wd_timer() has wdtick parameter. However, it
is only called with two values and as such the parameter is replaced
with boolean value indicating the timer should be active or not.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 33 ++++++++--------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  2 +-
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ceb2a75..2f02020 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -503,8 +503,7 @@ struct brcmf_sdio {
 	struct timer_list timer;
 	struct completion watchdog_wait;
 	struct task_struct *watchdog_tsk;
-	bool wd_timer_valid;
-	uint save_ms;
+	bool wd_active;
 
 	struct workqueue_struct *brcmf_wq;
 	struct work_struct datawork;
@@ -961,7 +960,7 @@ end:
 			brcmf_sdio_clkctl(bus, CLK_NONE, pendok);
 	} else {
 		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
-		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
+		brcmf_sdio_wd_timer(bus, true);
 	}
 	bus->sleeping = sleep;
 	brcmf_dbg(SDIO, "new state %s\n",
@@ -3576,7 +3575,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdio_wd_timer(bus, 0);
+				brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
 				sdio_release_host(bus->sdiodev->func[1]);
@@ -3908,7 +3907,7 @@ brcmf_sdio_watchdog(unsigned long data)
 	if (bus->watchdog_tsk) {
 		complete(&bus->watchdog_wait);
 		/* Reschedule the watchdog */
-		if (bus->wd_timer_valid)
+		if (bus->wd_active)
 			mod_timer(&bus->timer,
 				  jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
 	}
@@ -3950,7 +3949,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 
 	/* Start the watchdog timer */
 	bus->sdcnt.tickcnt = 0;
-	brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
+	brcmf_sdio_wd_timer(bus, true);
 
 	sdio_claim_host(sdiodev->func[1]);
 
@@ -4195,7 +4194,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		if (bus->ci) {
 			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdio_wd_timer(bus, 0);
+				brcmf_sdio_wd_timer(bus, false);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
 				 * 'passive'. This is done by resetting all
@@ -4217,13 +4216,12 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
+void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, bool active)
 {
 	/* Totally stop the timer */
-	if (!wdtick && bus->wd_timer_valid) {
+	if (!active && bus->wd_active) {
 		del_timer_sync(&bus->timer);
-		bus->wd_timer_valid = false;
-		bus->save_ms = wdtick;
+		bus->wd_active = false;
 		return;
 	}
 
@@ -4231,27 +4229,20 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	if (bus->sdiodev->state != BRCMF_SDIOD_DATA)
 		return;
 
-	if (wdtick) {
-		if (bus->save_ms != BRCMF_WD_POLL_MS) {
-			if (bus->wd_timer_valid)
-				/* Stop timer and restart at new value */
-				del_timer_sync(&bus->timer);
-
+	if (active) {
+		if (!bus->wd_active) {
 			/* Create timer again when watchdog period is
 			   dynamically changed or in the first instance
 			 */
 			bus->timer.expires =
 				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS);
 			add_timer(&bus->timer);
-
+			bus->wd_active = true;
 		} else {
 			/* Re arm the timer, at last watchdog period */
 			mod_timer(&bus->timer,
 				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
 		}
-
-		bus->wd_timer_valid = true;
-		bus->save_ms = wdtick;
 	}
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index d86ecf2..ff47cee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -369,7 +369,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
-void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
+void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, bool active);
 void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
 int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep);
 void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus);
-- 
1.9.1


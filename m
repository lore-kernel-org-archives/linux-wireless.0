Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2135 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934711Ab1JENUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/15] staging: brcm80211: remove threads_only code from
 fullmac
Date: Wed, 5 Oct 2011 15:20:01 +0200
Message-ID: <1317820814-7083-3-git-send-email-arend@broadcom.com> (sfid-20111005_152045_228666_AB844F40)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

threads_only is always true as we never use the tasklet implementation.
So related code is removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  100 ++++++++-----------------
 1 files changed, 30 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index f3e6249..0ae8dc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -651,11 +651,9 @@ struct brcmf_bus {
 	bool wd_timer_valid;
 	uint save_ms;
 
-	struct tasklet_struct tasklet;
 	struct task_struct *dpc_tsk;
 	struct completion dpc_wait;
 
-	bool threads_only;
 	struct semaphore sdsem;
 
 	const char *fw_name;
@@ -2704,29 +2702,6 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 	return 0;
 }
 
-static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *) data;
-
-	/* Call bus dpc unless it indicated down (then clean stop) */
-	if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
-		if (brcmf_sdbrcm_dpc(bus))
-			tasklet_schedule(&bus->tasklet);
-	} else {
-		brcmf_sdbrcm_bus_stop(bus);
-	}
-}
-
-static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus)
-{
-	if (bus->dpc_tsk) {
-		complete(&bus->dpc_wait);
-		return;
-	}
-
-	tasklet_schedule(&bus->tasklet);
-}
-
 int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
@@ -2770,7 +2745,8 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	/* Schedule DPC if needed to send queued packet(s) */
 	if (!bus->dpc_sched) {
 		bus->dpc_sched = true;
-		brcmf_sdbrcm_sched_dpc(bus);
+		if (bus->dpc_tsk)
+			complete(&bus->dpc_wait);
 	}
 
 	return ret;
@@ -3642,8 +3618,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 		send_sig(SIGTERM, bus->dpc_tsk, 1);
 		kthread_stop(bus->dpc_tsk);
 		bus->dpc_tsk = NULL;
-	} else
-		tasklet_kill(&bus->tasklet);
+	}
 
 	/* Disable and clear interrupts at the chip level also */
 	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
@@ -3831,7 +3806,8 @@ void brcmf_sdbrcm_isr(void *arg)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
 	bus->dpc_sched = true;
-	brcmf_sdbrcm_sched_dpc(bus);
+	if (bus->dpc_tsk)
+		complete(&bus->dpc_wait);
 }
 
 static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
@@ -3875,8 +3851,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 				bus->ipend = true;
 
 				bus->dpc_sched = true;
-				brcmf_sdbrcm_sched_dpc(bus);
-
+				if (bus->dpc_tsk)
+					complete(&bus->dpc_wait);
 			}
 		}
 
@@ -4366,21 +4342,13 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)data;
 
-	if (bus->threads_only) {
-		if (bus->watchdog_tsk)
-			complete(&bus->watchdog_wait);
-		else
-			return;
-	} else {
-		brcmf_sdbrcm_bus_watchdog(bus->drvr);
-
-		/* Count the tick for reference */
-		bus->drvr->tickcnt++;
+	if (bus->watchdog_tsk) {
+		complete(&bus->watchdog_wait);
+		/* Reschedule the watchdog */
+		if (bus->wd_timer_valid)
+			mod_timer(&bus->timer,
+				  jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
 	}
-
-	/* Reschedule the watchdog */
-	if (bus->wd_timer_valid)
-		mod_timer(&bus->timer, jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
 }
 
 static void
@@ -4465,7 +4433,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
-	bus->threads_only = true;
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
@@ -4483,32 +4450,25 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	bus->timer.function = brcmf_sdbrcm_watchdog;
 
 	/* Initialize thread based operation and lock */
-	if (bus->threads_only) {
-		sema_init(&bus->sdsem, 1);
-
-		/* Initialize watchdog thread */
-		init_completion(&bus->watchdog_wait);
-		bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
-						bus, "brcmf_watchdog");
-		if (IS_ERR(bus->watchdog_tsk)) {
-			printk(KERN_WARNING
-			       "brcmf_watchdog thread failed to start\n");
-			bus->watchdog_tsk = NULL;
-		}
-		/* Initialize DPC thread */
-		init_completion(&bus->dpc_wait);
-		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
-					   bus, "brcmf_dpc");
-		if (IS_ERR(bus->dpc_tsk)) {
-			printk(KERN_WARNING
-			       "brcmf_dpc thread failed to start\n");
-			bus->dpc_tsk = NULL;
-		}
-	} else {
+	sema_init(&bus->sdsem, 1);
+
+	/* Initialize watchdog thread */
+	init_completion(&bus->watchdog_wait);
+	bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
+					bus, "brcmf_watchdog");
+	if (IS_ERR(bus->watchdog_tsk)) {
+		printk(KERN_WARNING
+		       "brcmf_watchdog thread failed to start\n");
 		bus->watchdog_tsk = NULL;
+	}
+	/* Initialize DPC thread */
+	init_completion(&bus->dpc_wait);
+	bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
+				   bus, "brcmf_dpc");
+	if (IS_ERR(bus->dpc_tsk)) {
+		printk(KERN_WARNING
+		       "brcmf_dpc thread failed to start\n");
 		bus->dpc_tsk = NULL;
-		tasklet_init(&bus->tasklet, brcmf_sdbrcm_dpc_tasklet,
-			     (unsigned long)bus);
 	}
 
 	/* Attach to the brcmf/OS/network interface */
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4456 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177Ab1F2XtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:18 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 081/119] staging: brcm80211: move dpc code to dhd_sdio.c
Date: Wed, 29 Jun 2011 16:47:45 -0700
Message-ID: <1309391303-22741-82-git-send-email-frankyl@broadcom.com> (sfid-20110630_015229_924831_A1BC5EAC)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dpc thread handles data transaction which should be placed in
bus interface layer. Move related code to dhd_sdio.c for clean up.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |  113 ---------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |  128 +++++++++++++++++++++---
 3 files changed, 112 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index eab5cdd..1038ddb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -58,8 +58,6 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 extern int
 brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 
-/* Deferred processing for the bus, return true requests reschedule */
-extern bool dhd_bus_dpc(struct dhd_bus *bus);
 extern void dhd_bus_isr(bool *InterruptRecognized,
 			bool *QueueMiniportHandleInterrupt, void *arg);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 8491b4e..fac8302 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -82,13 +82,10 @@ typedef struct dhd_info {
 
 	struct semaphore proto_sem;
 	wait_queue_head_t ioctl_resp_wait;
-	struct tasklet_struct tasklet;
 	spinlock_t sdlock;
 	/* Thread based operation */
 	bool threads_only;
 	struct semaphore sdsem;
-	struct task_struct *dpc_tsk;
-	struct semaphore dpc_sem;
 
 	/* Thread to issue ioctl for multicast */
 	struct task_struct *sysioc_tsk;
@@ -145,11 +142,6 @@ module_param(brcmf_pkt_filter_init, uint, 0);
 uint brcmf_master_mode = true;
 module_param(brcmf_master_mode, uint, 1);
 
-/* DPC thread priority, -1 to use tasklet */
-int brcmf_dpc_prio = 98;
-module_param(brcmf_dpc_prio, int, 0);
-
-/* DPC thread priority, -1 to use tasklet */
 extern int brcmf_dongle_memsize;
 module_param(brcmf_dongle_memsize, int, 0);
 
@@ -190,10 +182,6 @@ extern uint brcmf_rxbound;
 module_param(brcmf_txbound, uint, 0);
 module_param(brcmf_rxbound, uint, 0);
 
-/* Deferred transmits */
-extern uint brcmf_deferred_tx;
-module_param(brcmf_deferred_tx, uint, 0);
-
 #ifdef SDTEST
 /* Echo packet generator (pkts/s) */
 uint brcmf_pktgen;
@@ -211,7 +199,6 @@ module_param(brcmf_pktgen_len, uint, 0);
 #define DHD_COMPILED
 #endif
 
-static void brcmf_dpc(unsigned long data);
 static int brcmf_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
 static int brcmf_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
 static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
@@ -1012,69 +999,6 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	return &ifp->stats;
 }
 
-static int brcmf_dpc_thread(void *data)
-{
-	dhd_info_t *dhd = (dhd_info_t *) data;
-
-	/* This thread doesn't need any user-level access,
-	 * so get rid of all our resources
-	 */
-	if (brcmf_dpc_prio > 0) {
-		struct sched_param param;
-		param.sched_priority =
-		    (brcmf_dpc_prio <
-		     MAX_RT_PRIO) ? brcmf_dpc_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
-
-	allow_signal(SIGTERM);
-	/* Run until signal received */
-	while (1) {
-		if (kthread_should_stop())
-			break;
-		if (down_interruptible(&dhd->dpc_sem) == 0) {
-			/* Call bus dpc unless it indicated down
-				 (then clean stop) */
-			if (dhd->pub.busstate != DHD_BUS_DOWN) {
-				if (dhd_bus_dpc(dhd->pub.bus)) {
-					up(&dhd->dpc_sem);
-				}
-			} else {
-				brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
-			}
-		} else
-			break;
-	}
-	return 0;
-}
-
-static void brcmf_dpc(unsigned long data)
-{
-	dhd_info_t *dhd;
-
-	dhd = (dhd_info_t *) data;
-
-	/* Call bus dpc unless it indicated down (then clean stop) */
-	if (dhd->pub.busstate != DHD_BUS_DOWN) {
-		if (dhd_bus_dpc(dhd->pub.bus))
-			tasklet_schedule(&dhd->tasklet);
-	} else {
-		brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
-	}
-}
-
-void brcmf_sched_dpc(dhd_pub_t *dhdp)
-{
-	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
-
-	if (dhd->dpc_tsk) {
-		up(&dhd->dpc_sem);
-		return;
-	}
-
-	tasklet_schedule(&dhd->tasklet);
-}
-
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
 static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
@@ -1598,21 +1522,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	else
 		dhd->threads_only = false;
 
-	/* Set up the bottom half handler */
-	if (brcmf_dpc_prio >= 0) {
-		/* Initialize DPC thread */
-		sema_init(&dhd->dpc_sem, 0);
-		dhd->dpc_tsk = kthread_run(brcmf_dpc_thread, dhd, "dhd_dpc");
-		if (IS_ERR(dhd->dpc_tsk)) {
-			printk(KERN_WARNING
-				"dhd_dpc thread failed to start\n");
-			dhd->dpc_tsk = NULL;
-		}
-	} else {
-		tasklet_init(&dhd->tasklet, brcmf_dpc, (unsigned long) dhd);
-		dhd->dpc_tsk = NULL;
-	}
-
 	if (brcmf_sysioc) {
 		sema_init(&dhd->sysioc_sem, 0);
 		dhd->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, dhd,
@@ -1866,13 +1775,6 @@ void brcmf_detach(dhd_pub_t *dhdp)
 				unregister_netdev(ifp->net);
 			}
 
-			if (dhd->dpc_tsk) {
-				send_sig(SIGTERM, dhd->dpc_tsk, 1);
-				kthread_stop(dhd->dpc_tsk);
-				dhd->dpc_tsk = NULL;
-			} else
-				tasklet_kill(&dhd->tasklet);
-
 			if (dhd->sysioc_tsk) {
 				send_sig(SIGTERM, dhd->sysioc_tsk, 1);
 				kthread_stop(dhd->sysioc_tsk);
@@ -1907,21 +1809,6 @@ static int __init brcmf_module_init(void)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	/* Sanity check on the module parameters */
-	do {
-		/* Both watchdog and DPC as tasklets are ok */
-		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
-			break;
-
-		/* If both watchdog and DPC are threads, TX must be deferred */
-		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
-		    && brcmf_deferred_tx)
-			break;
-
-		DHD_ERROR(("Invalid module parameters.\n"));
-		return -EINVAL;
-	} while (0);
-
 	error = dhd_bus_register();
 
 	if (error) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index b79e5cd..6f69413 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -593,6 +593,10 @@ typedef struct dhd_bus {
 	struct completion watchdog_wait;
 	struct task_struct *watchdog_tsk;
 	bool wd_timer_valid;
+
+	struct tasklet_struct tasklet;
+	struct task_struct *dpc_tsk;
+	struct completion dpc_wait;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -649,7 +653,8 @@ static int tx_packets[NUMPRIO];
 #endif				/* BCMDBG */
 
 /* Deferred transmit */
-const uint brcmf_deferred_tx = 1;
+uint brcmf_deferred_tx = 1;
+module_param(brcmf_deferred_tx, uint, 0);
 
 /* Watchdog thread priority, -1 to use kernel timer */
 int brcmf_watchdog_prio = 97;
@@ -659,6 +664,10 @@ module_param(brcmf_watchdog_prio, int, 0);
 uint brcmf_watchdog_ms = 10;
 module_param(brcmf_watchdog_ms, uint, 0);
 
+/* DPC thread priority, -1 to use tasklet */
+int brcmf_dpc_prio = 98;
+module_param(brcmf_dpc_prio, int, 0);
+
 #ifdef BCMDBG
 /* Console poll interval */
 uint brcmf_console_ms;
@@ -804,6 +813,9 @@ static void brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar);
 static void brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus);
 static void brcmf_sdbrcm_watchdog(unsigned long data);
 static int brcmf_sdbrcm_watchdog_thread(void *data);
+static int brcmf_sdbrcm_dpc_thread(void *data);
+static void brcmf_sdbrcm_dpc_tasklet(unsigned long data);
+static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -1355,7 +1367,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		/* Schedule DPC if needed to send queued packet(s) */
 		if (brcmf_deferred_tx && !bus->dpc_sched) {
 			bus->dpc_sched = true;
-			brcmf_sched_dpc(bus->dhd);
+			brcmf_sdbrcm_sched_dpc(bus);
 		}
 	} else {
 		/* Lock: we're about to use shared data/code (and SDIO) */
@@ -3033,6 +3045,13 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 		bus->watchdog_tsk = NULL;
 	}
 
+	if (bus->dpc_tsk) {
+		send_sig(SIGTERM, bus->dpc_tsk, 1);
+		kthread_stop(bus->dpc_tsk);
+		bus->dpc_tsk = NULL;
+	} else
+		tasklet_kill(&bus->tasklet);
+
 	/* Disable and clear interrupts at the chip level also */
 	W_SDREG(0, &bus->regs->hostintmask, retries);
 	local_hostintmask = bus->hostintmask;
@@ -4459,7 +4478,7 @@ static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
 	return intstatus;
 }
 
-bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
+static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 {
 	struct brcmf_sdio *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -4711,17 +4730,6 @@ clkwait:
 	return resched;
 }
 
-bool dhd_bus_dpc(struct dhd_bus *bus)
-{
-	bool resched;
-
-	/* Call the DPC directly. */
-	DHD_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
-	resched = brcmf_sdbrcm_dpc(bus);
-
-	return resched;
-}
-
 void brcmf_sdbrcm_isr(void *arg)
 {
 	dhd_bus_t *bus = (dhd_bus_t *) arg;
@@ -4765,7 +4773,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		;
 #else
 	bus->dpc_sched = true;
-	brcmf_sched_dpc(bus->dhd);
+	brcmf_sdbrcm_sched_dpc(bus);
 #endif
 
 }
@@ -5077,7 +5085,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 					brcmf_sdcard_intr_disable(bus->sdh);
 
 				bus->dpc_sched = true;
-				brcmf_sched_dpc(bus->dhd);
+				brcmf_sdbrcm_sched_dpc(bus);
 
 			}
 		}
@@ -5323,6 +5331,23 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	} else
 		bus->watchdog_tsk = NULL;
 
+	/* Set up the bottom half handler */
+	if (brcmf_dpc_prio >= 0) {
+		/* Initialize DPC thread */
+		init_completion(&bus->dpc_wait);
+		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
+					   bus, "dhd_dpc");
+		if (IS_ERR(bus->dpc_tsk)) {
+			printk(KERN_WARNING
+			       "dhd_dpc thread failed to start\n");
+			bus->dpc_tsk = NULL;
+		}
+	} else {
+		tasklet_init(&bus->tasklet, brcmf_sdbrcm_dpc_tasklet,
+			     (unsigned long)bus);
+		bus->dpc_tsk = NULL;
+	}
+
 	/* Attach to the dhd/OS/network interface */
 	bus->dhd = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->dhd) {
@@ -5679,6 +5704,21 @@ int dhd_bus_register(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
+	/* Sanity check on the module parameters */
+	do {
+		/* Both watchdog and DPC as tasklets are ok */
+		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
+			break;
+
+		/* If both watchdog and DPC are threads, TX must be deferred */
+		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
+		    && brcmf_deferred_tx)
+			break;
+
+		DHD_ERROR(("Invalid module parameters.\n"));
+		return -EINVAL;
+	} while (0);
+
 	return brcmf_sdio_register(&dhd_sdio);
 }
 
@@ -6542,3 +6582,59 @@ brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick)
 		save_ms = wdtick;
 	}
 }
+
+static int brcmf_sdbrcm_dpc_thread(void *data)
+{
+	dhd_bus_t *bus = (dhd_bus_t *) data;
+
+	/* This thread doesn't need any user-level access,
+	 * so get rid of all our resources
+	 */
+	if (brcmf_dpc_prio > 0) {
+		struct sched_param param;
+		param.sched_priority = (brcmf_dpc_prio < MAX_RT_PRIO) ?
+				       brcmf_dpc_prio : (MAX_RT_PRIO - 1);
+		sched_setscheduler(current, SCHED_FIFO, &param);
+	}
+
+	allow_signal(SIGTERM);
+	/* Run until signal received */
+	while (1) {
+		if (kthread_should_stop())
+			break;
+		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
+			/* Call bus dpc unless it indicated down
+			(then clean stop) */
+			if (bus->dhd->busstate != DHD_BUS_DOWN) {
+				if (brcmf_sdbrcm_dpc(bus))
+					complete(&bus->dpc_wait);
+			} else {
+				brcmf_sdbrcm_bus_stop(bus, true);
+			}
+		} else
+			break;
+	}
+	return 0;
+}
+
+static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
+{
+	dhd_bus_t *bus = (dhd_bus_t *) data;
+
+	/* Call bus dpc unless it indicated down (then clean stop) */
+	if (bus->dhd->busstate != DHD_BUS_DOWN) {
+		if (brcmf_sdbrcm_dpc(bus))
+			tasklet_schedule(&bus->tasklet);
+	} else
+		brcmf_sdbrcm_bus_stop(bus, true);
+}
+
+static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus)
+{
+	if (bus->dpc_tsk) {
+		complete(&bus->dpc_wait);
+		return;
+	}
+
+	tasklet_schedule(&bus->tasklet);
+}
-- 
1.7.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4552 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1F2Xs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 079/119] staging: brcm80211: move fullmac watchdog timer
 code to dhd_sdio.c
Date: Wed, 29 Jun 2011 16:47:43 -0700
Message-ID: <1309391303-22741-80-git-send-email-frankyl@broadcom.com> (sfid-20110630_015137_004152_1FEA16EE)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog timer is used in bus interface layer in fullmac. Move
related code to dhd_sdio.c for clean up.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   16 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  159 ------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  184 ++++++++++++++++++++-
 6 files changed, 191 insertions(+), 189 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index d0be99f..ce8323c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -35,6 +35,7 @@ extern void brcmf_sdbrcm_isr(void *args);
 
 #include "dngl_stats.h"
 #include "dhd.h"
+#include "dhd_bus.h"
 
 /**
  * SDIO Host Controller info
@@ -222,7 +223,7 @@ module_param(sd_f2_blocksize, int, 0);
 void brcmf_sdio_wdtmr_enable(bool enable)
 {
 	if (enable)
-		brcmf_os_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
 	else
-		brcmf_os_wd_timer(sdhcinfo->ch, 0);
+		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, 0);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index ffdee84..2c67df0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -773,9 +773,6 @@ extern atomic_t brcmf_mmc_suspend;
  * Insmod parameters for debug/test
  */
 
-/* Watchdog timer interval */
-extern uint brcmf_watchdog_ms;
-
 #if defined(BCMDBG)
 /* Console output poll interval */
 extern uint brcmf_console_ms;
@@ -818,6 +815,10 @@ extern uint brcmf_sdiod_drive_strength;
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
+/* thread priority for watchdog and dpc */
+extern int brcmf_watchdog_prio;
+extern int brcmf_dpc_prio;
+
 #ifdef SDTEST
 /* Echo packet generator (SDIO), pkts/s */
 extern uint brcmf_pktgen;
@@ -923,7 +924,6 @@ extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
 extern void *brcmf_os_open_image(char *filename);
 extern int brcmf_os_get_image_block(char *buf, int len, void *image);
 extern void brcmf_os_close_image(void *image);
-extern void brcmf_os_wd_timer(void *bus, uint wdtick);
 extern void brcmf_os_sdlock(dhd_pub_t *pub);
 extern void brcmf_os_sdunlock(dhd_pub_t *pub);
 extern void brcmf_os_sdlock_sndup_rxq(dhd_pub_t *pub);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 722dbb4..5bbe09d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -29,6 +29,9 @@
  * Exported from dhd bus module (dhd_usb, dhd_sdio)
  */
 
+/* Watchdog timer interval */
+extern uint brcmf_watchdog_ms;
+
 /* Indicate (dis)interest in finding dongles. */
 extern int dhd_bus_register(void);
 extern void dhd_bus_unregister(void);
@@ -55,9 +58,6 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 extern int
 brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 
-/* Watchdog timer function */
-extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhd);
-
 #ifdef BCMDBG
 /* Device console input function */
 extern int
@@ -91,4 +91,6 @@ extern void *dhd_bus_pub(struct dhd_bus *bus);
 extern void *dhd_bus_txq(struct dhd_bus *bus);
 extern uint dhd_bus_hdrlen(struct dhd_bus *bus);
 
+extern void brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick);
+
 #endif				/* _dhd_bus_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5207fa9..38a3502 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -52,7 +52,6 @@ enum {
 	IOV_MSGLEVEL,
 	IOV_BCMERRORSTR,
 	IOV_BCMERROR,
-	IOV_WDTICK,
 	IOV_DUMP,
 #ifdef BCMDBG
 	IOV_CONS,
@@ -78,8 +77,6 @@ const struct brcmu_iovar brcmf_iovars[] = {
 	,
 	{"bcmerror", IOV_BCMERROR, 0, IOVT_INT8, 0}
 	,
-	{"wdtick", IOV_WDTICK, 0, IOVT_UINT32, 0}
-	,
 	{"dump", IOV_DUMP, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
 	,
 #ifdef BCMDBG
@@ -237,19 +234,6 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_WDTICK):
-		int_val = (s32) brcmf_watchdog_ms;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_WDTICK):
-		if (!dhd_pub->up) {
-			bcmerror = -ENOLINK;
-			break;
-		}
-		brcmf_os_wd_timer(dhd_pub, (uint) int_val);
-		break;
-
 	case IOV_GVAL(IOV_DUMP):
 		bcmerror = brcmf_c_dump(dhd_pub, arg, len);
 		break;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6516cc6..abd829d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -82,15 +82,11 @@ typedef struct dhd_info {
 
 	struct semaphore proto_sem;
 	wait_queue_head_t ioctl_resp_wait;
-	struct timer_list timer;
-	bool wd_timer_valid;
 	struct tasklet_struct tasklet;
 	spinlock_t sdlock;
 	/* Thread based operation */
 	bool threads_only;
 	struct semaphore sdsem;
-	struct task_struct *watchdog_tsk;
-	struct semaphore watchdog_sem;
 	struct task_struct *dpc_tsk;
 	struct semaphore dpc_sem;
 
@@ -128,10 +124,6 @@ module_param(brcmf_msg_level, int, 0);
 uint brcmf_sysioc = true;
 module_param(brcmf_sysioc, uint, 0);
 
-/* Watchdog interval */
-uint brcmf_watchdog_ms = 10;
-module_param(brcmf_watchdog_ms, uint, 0);
-
 #ifdef BCMDBG
 /* Console poll interval */
 uint brcmf_console_ms;
@@ -159,10 +151,6 @@ module_param(brcmf_pkt_filter_init, uint, 0);
 uint brcmf_master_mode = true;
 module_param(brcmf_master_mode, uint, 1);
 
-/* Watchdog thread priority, -1 to use kernel timer */
-int brcmf_watchdog_prio = 97;
-module_param(brcmf_watchdog_prio, int, 0);
-
 /* DPC thread priority, -1 to use tasklet */
 int brcmf_dpc_prio = 98;
 module_param(brcmf_dpc_prio, int, 0);
@@ -1030,64 +1018,6 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	return &ifp->stats;
 }
 
-static int brcmf_watchdog_thread(void *data)
-{
-	dhd_info_t *dhd = (dhd_info_t *) data;
-
-	/* This thread doesn't need any user-level access,
-	 * so get rid of all our resources
-	 */
-	if (brcmf_watchdog_prio > 0) {
-		struct sched_param param;
-		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
-		    brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
-
-	allow_signal(SIGTERM);
-	/* Run until signal received */
-	while (1) {
-		if (kthread_should_stop())
-			break;
-		if (down_interruptible(&dhd->watchdog_sem) == 0) {
-			if (dhd->pub.dongle_reset == false) {
-				/* Call the bus module watchdog */
-				brcmf_sdbrcm_bus_watchdog(&dhd->pub);
-			}
-			/* Count the tick for reference */
-			dhd->pub.tickcnt++;
-		} else
-			break;
-	}
-	return 0;
-}
-
-static void brcmf_watchdog(unsigned long data)
-{
-	dhd_info_t *dhd = (dhd_info_t *) data;
-
-	if (dhd->watchdog_tsk) {
-		up(&dhd->watchdog_sem);
-
-		/* Reschedule the watchdog */
-		if (dhd->wd_timer_valid) {
-			mod_timer(&dhd->timer,
-				  jiffies + brcmf_watchdog_ms * HZ / 1000);
-		}
-		return;
-	}
-
-	/* Call the bus module watchdog */
-	brcmf_sdbrcm_bus_watchdog(&dhd->pub);
-
-	/* Count the tick for reference */
-	dhd->pub.tickcnt++;
-
-	/* Reschedule the watchdog */
-	if (dhd->wd_timer_valid)
-		mod_timer(&dhd->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
-}
-
 static int brcmf_dpc_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
@@ -1667,11 +1597,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		strcpy(brcmf_nv_path, wl_cfg80211_get_nvramname());
 	}
 
-	/* Set up the watchdog timer */
-	init_timer(&dhd->timer);
-	dhd->timer.data = (unsigned long) dhd;
-	dhd->timer.function = brcmf_watchdog;
-
 	/* Initialize thread based operation and lock */
 	sema_init(&dhd->sdsem, 1);
 	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0))
@@ -1679,20 +1604,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	else
 		dhd->threads_only = false;
 
-	if (brcmf_dpc_prio >= 0) {
-		/* Initialize watchdog thread */
-		sema_init(&dhd->watchdog_sem, 0);
-		dhd->watchdog_tsk = kthread_run(brcmf_watchdog_thread, dhd,
-						"dhd_watchdog");
-		if (IS_ERR(dhd->watchdog_tsk)) {
-			printk(KERN_WARNING
-				"dhd_watchdog thread failed to start\n");
-			dhd->watchdog_tsk = NULL;
-		}
-	} else {
-		dhd->watchdog_tsk = NULL;
-	}
-
 	/* Set up the bottom half handler */
 	if (brcmf_dpc_prio >= 0) {
 		/* Initialize DPC thread */
@@ -1773,10 +1684,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 		}
 	}
 
-	/* Start the watchdog timer */
-	dhd->pub.tickcnt = 0;
-	brcmf_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
-
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
 	if (ret != 0) {
@@ -1787,8 +1694,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 
 	/* If bus is not ready, can't come up */
 	if (dhd->pub.busstate != DHD_BUS_DATA) {
-		del_timer_sync(&dhd->timer);
-		dhd->wd_timer_valid = false;
 		DHD_ERROR(("%s failed bus is not ready\n", __func__));
 		return -ENODEV;
 	}
@@ -1935,10 +1840,6 @@ static void brcmf_bus_detach(dhd_pub_t *dhdp)
 
 			/* Stop the bus module */
 			brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
-
-			/* Clear the watchdog timer */
-			del_timer_sync(&dhd->timer);
-			dhd->wd_timer_valid = false;
 		}
 	}
 }
@@ -1971,12 +1872,6 @@ void brcmf_detach(dhd_pub_t *dhdp)
 				unregister_netdev(ifp->net);
 			}
 
-			if (dhd->watchdog_tsk) {
-				send_sig(SIGTERM, dhd->watchdog_tsk, 1);
-				kthread_stop(dhd->watchdog_tsk);
-				dhd->watchdog_tsk = NULL;
-			}
-
 			if (dhd->dpc_tsk) {
 				send_sig(SIGTERM, dhd->dpc_tsk, 1);
 				kthread_stop(dhd->dpc_tsk);
@@ -2119,51 +2014,6 @@ int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub)
 	return 0;
 }
 
-void brcmf_os_wd_timer(void *bus, uint wdtick)
-{
-	dhd_pub_t *pub = bus;
-	static uint save_dhd_watchdog_ms;
-	dhd_info_t *dhd = (dhd_info_t *) pub->info;
-
-	/* don't start the wd until fw is loaded */
-	if (pub->busstate == DHD_BUS_DOWN)
-		return;
-
-	/* Totally stop the timer */
-	if (!wdtick && dhd->wd_timer_valid == true) {
-		del_timer_sync(&dhd->timer);
-		dhd->wd_timer_valid = false;
-		save_dhd_watchdog_ms = wdtick;
-		return;
-	}
-
-	if (wdtick) {
-		brcmf_watchdog_ms = (uint) wdtick;
-
-		if (save_dhd_watchdog_ms != brcmf_watchdog_ms) {
-
-			if (dhd->wd_timer_valid == true)
-				/* Stop timer and restart at new value */
-				del_timer_sync(&dhd->timer);
-
-			/* Create timer again when watchdog period is
-			   dynamically changed or in the first instance
-			 */
-			dhd->timer.expires =
-			    jiffies + brcmf_watchdog_ms * HZ / 1000;
-			add_timer(&dhd->timer);
-
-		} else {
-			/* Re arm the timer, at last watchdog period */
-			mod_timer(&dhd->timer,
-				  jiffies + brcmf_watchdog_ms * HZ / 1000);
-		}
-
-		dhd->wd_timer_valid = true;
-		save_dhd_watchdog_ms = wdtick;
-	}
-}
-
 void *brcmf_os_open_image(char *filename)
 {
 	struct file *fp;
@@ -2257,17 +2107,8 @@ int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
-	/* Turning off watchdog */
-	if (flag)
-		brcmf_os_wd_timer(&dhd->pub, 0);
-
 	brcmf_bus_devreset(&dhd->pub, flag);
 
-	/* Turning on watchdog back */
-	if (!flag)
-		brcmf_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
-	DHD_ERROR(("%s:  WLAN OFF DONE\n", __func__));
-
 	return 1;
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ec2c744..aeef2dc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/printk.h>
 #include <linux/pci_ids.h>
 #include <linux/netdevice.h>
@@ -587,6 +588,11 @@ typedef struct dhd_bus {
 
 	spinlock_t txqlock;
 	wait_queue_head_t ctrl_wait;
+
+	struct timer_list timer;
+	struct completion watchdog_wait;
+	struct task_struct *watchdog_tsk;
+	bool wd_timer_valid;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -645,6 +651,14 @@ static int tx_packets[NUMPRIO];
 /* Deferred transmit */
 const uint brcmf_deferred_tx = 1;
 
+/* Watchdog thread priority, -1 to use kernel timer */
+int brcmf_watchdog_prio = 97;
+module_param(brcmf_watchdog_prio, int, 0);
+
+/* Watchdog interval */
+uint brcmf_watchdog_ms = 10;
+module_param(brcmf_watchdog_ms, uint, 0);
+
 /* Tx/Rx bounds */
 uint brcmf_txbound;
 uint brcmf_rxbound;
@@ -780,6 +794,8 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
 static void brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar);
 static void brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus);
+static void brcmf_sdbrcm_watchdog(unsigned long data);
+static int brcmf_sdbrcm_watchdog_thread(void *data);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -975,7 +991,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
 		if (target == CLK_AVAIL) {
-			brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+			brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 			bus->activity = true;
 		}
 		return 0;
@@ -988,7 +1004,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 			brcmf_sdbrcm_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
 		brcmf_sdbrcm_htclk(bus, true, pendok);
-		brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 		bus->activity = true;
 		break;
 
@@ -1001,7 +1017,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		else
 			DHD_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
 				   "\n", bus->clkstate, target));
-		brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 		break;
 
 	case CLK_NONE:
@@ -1010,7 +1026,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 			brcmf_sdbrcm_htclk(bus, false, false);
 		/* Now remove the SD clock */
 		brcmf_sdbrcm_sdclk(bus, false);
-		brcmf_os_wd_timer(bus->dhd, 0);
+		brcmf_sdbrcm_wd_timer(bus, 0);
 		break;
 	}
 #ifdef BCMDBG
@@ -1671,6 +1687,7 @@ enum {
 	IOV_IDLECLOCK,
 	IOV_SD1IDLE,
 	IOV_SLEEP,
+	IOV_WDTICK,
 	IOV_VARS
 };
 
@@ -1691,6 +1708,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	{"alignctl", IOV_ALIGNCTL, 0, IOVT_BOOL, 0},
 	{"sdalign", IOV_SDALIGN, 0, IOVT_BOOL, 0},
 	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
+	{"wdtick", IOV_WDTICK, 0, IOVT_UINT32, 0},
 #ifdef BCMDBG
 	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
@@ -2703,6 +2721,19 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 		break;
 
+	case IOV_GVAL(IOV_WDTICK):
+		int_val = (s32) brcmf_watchdog_ms;
+		memcpy(arg, &int_val, val_size);
+		break;
+
+	case IOV_SVAL(IOV_WDTICK):
+		if (!bus->dhd->up) {
+			bcmerror = -ENOLINK;
+			break;
+		}
+		brcmf_sdbrcm_wd_timer(bus, (uint) int_val);
+		break;
+
 	default:
 		bcmerror = -ENOTSUPP;
 		break;
@@ -2967,6 +2998,12 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	/* Enable clock for device interrupts */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
+	if (bus->watchdog_tsk) {
+		send_sig(SIGTERM, bus->watchdog_tsk, 1);
+		kthread_stop(bus->watchdog_tsk);
+		bus->watchdog_tsk = NULL;
+	}
+
 	/* Disable and clear interrupts at the chip level also */
 	W_SDREG(0, &bus->regs->hostintmask, retries);
 	local_hostintmask = bus->hostintmask;
@@ -3022,6 +3059,10 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	if (enforce_mutex)
 		brcmf_os_sdunlock(bus->dhd);
+
+#if defined(OOB_INTR_ONLY)
+	brcmf_sdio_unregister_oob_intr();
+#endif		/* defined(OOB_INTR_ONLY) */
 }
 
 int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
@@ -3039,6 +3080,10 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	if (!bus->dhd)
 		return 0;
 
+	/* Start the watchdog timer */
+	bus->dhd->tickcnt = 0;
+	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+
 	if (enforce_mutex)
 		brcmf_os_sdlock(bus->dhd);
 
@@ -3121,6 +3166,19 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 saveclk, &err);
 
+#if defined(OOB_INTR_ONLY)
+	/* Host registration for OOB interrupt */
+	if (brcmf_sdio_register_oob_intr(bus->dhd)) {
+		brcmf_sdbrcm_wd_timer(bus, 0);
+		DHD_ERROR(("%s Host failed to resgister for OOB\n", __func__));
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	/* Enable oob at firmware */
+	brcmf_sdbrcm_enable_oob_intr(bus, true);
+#endif		/* defined(OOB_INTR_ONLY) */
+
 	/* If we didn't come up, turn off backplane clock */
 	if (dhdp->busstate != DHD_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
@@ -5029,7 +5087,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 			bus->idlecount = 0;
 			if (bus->activity) {
 				bus->activity = false;
-				brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+				brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 			} else {
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 			}
@@ -5218,6 +5276,24 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	spin_lock_init(&bus->txqlock);
 	init_waitqueue_head(&bus->ctrl_wait);
 
+	/* Set up the watchdog timer */
+	init_timer(&bus->timer);
+	bus->timer.data = (unsigned long)bus;
+	bus->timer.function = brcmf_sdbrcm_watchdog;
+
+	if (brcmf_dpc_prio >= 0) {
+		/* Initialize watchdog thread */
+		init_completion(&bus->watchdog_wait);
+		bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
+						bus, "brcmf_watchdog");
+		if (IS_ERR(bus->watchdog_tsk)) {
+			printk(KERN_WARNING
+			       "brcmf_watchdog thread failed to start\n");
+			bus->watchdog_tsk = NULL;
+		}
+	} else
+		bus->watchdog_tsk = NULL;
+
 	/* Attach to the dhd/OS/network interface */
 	bus->dhd = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->dhd) {
@@ -5868,6 +5944,7 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 	bus = dhdp->bus;
 
 	if (flag == true) {
+		brcmf_sdbrcm_wd_timer(bus, 0);
 		if (!bus->dhd->dongle_reset) {
 			/* Expect app to have torn down any
 			 connection before calling */
@@ -5924,6 +6001,7 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 				"is on\n", __func__));
 			bcmerror = -EIO;
 		}
+		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 	}
 	return bcmerror;
 }
@@ -6339,3 +6417,99 @@ brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus)
 		wake_up_interruptible(&bus->ctrl_wait);
 	return;
 }
+
+static int
+brcmf_sdbrcm_watchdog_thread(void *data)
+{
+	dhd_bus_t *bus = (dhd_bus_t *)data;
+
+	/* This thread doesn't need any user-level access,
+	* so get rid of all our resources
+	*/
+	if (brcmf_watchdog_prio > 0) {
+		struct sched_param param;
+		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
+				       brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
+		sched_setscheduler(current, SCHED_FIFO, &param);
+	}
+
+	allow_signal(SIGTERM);
+	/* Run until signal received */
+	while (1) {
+		if (kthread_should_stop())
+			break;
+		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
+			if (bus->dhd->dongle_reset == false)
+				brcmf_sdbrcm_bus_watchdog(bus->dhd);
+			/* Count the tick for reference */
+			bus->dhd->tickcnt++;
+		} else
+			break;
+	}
+	return 0;
+}
+
+static void
+brcmf_sdbrcm_watchdog(unsigned long data)
+{
+	dhd_bus_t *bus = (dhd_bus_t *)data;
+
+	if (brcmf_watchdog_prio >= 0) {
+		if (bus->watchdog_tsk)
+			complete(&bus->watchdog_wait);
+		else
+			return;
+	} else {
+		brcmf_sdbrcm_bus_watchdog(bus->dhd);
+
+		/* Count the tick for reference */
+		bus->dhd->tickcnt++;
+	}
+
+	/* Reschedule the watchdog */
+	if (bus->wd_timer_valid)
+		mod_timer(&bus->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
+}
+
+void
+brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick)
+{
+	static uint save_ms;
+
+	/* don't start the wd until fw is loaded */
+	if (bus->dhd->busstate == DHD_BUS_DOWN)
+		return;
+
+	/* Totally stop the timer */
+	if (!wdtick && bus->wd_timer_valid == true) {
+		del_timer_sync(&bus->timer);
+		bus->wd_timer_valid = false;
+		save_ms = wdtick;
+		return;
+	}
+
+	if (wdtick) {
+		brcmf_watchdog_ms = (uint) wdtick;
+
+		if (save_ms != brcmf_watchdog_ms) {
+			if (bus->wd_timer_valid == true)
+				/* Stop timer and restart at new value */
+				del_timer_sync(&bus->timer);
+
+			/* Create timer again when watchdog period is
+			   dynamically changed or in the first instance
+			 */
+			bus->timer.expires =
+				jiffies + brcmf_watchdog_ms * HZ / 1000;
+			add_timer(&bus->timer);
+
+		} else {
+			/* Re arm the timer, at last watchdog period */
+			mod_timer(&bus->timer,
+				jiffies + brcmf_watchdog_ms * HZ / 1000);
+		}
+
+		bus->wd_timer_valid = true;
+		save_ms = wdtick;
+	}
+}
-- 
1.7.1



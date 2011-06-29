Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4642 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 082/119] staging: brcm80211: move sdio resource lock to
 dhd_sdio.c
Date: Wed, 29 Jun 2011 16:47:46 -0700
Message-ID: <1309391303-22741-83-git-send-email-frankyl@broadcom.com> (sfid-20110630_015003_224464_6AE98675)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fullmac the lock is for race condition for sdio interface. Move
the code to dhd_sdio.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    6 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   38 --------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |  109 +++++++++++++++---------
 3 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index e7746f7..b11eeee 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -810,10 +810,6 @@ extern uint brcmf_sdiod_drive_strength;
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
-/* thread priority for watchdog and dpc */
-extern int brcmf_watchdog_prio;
-extern int brcmf_dpc_prio;
-
 #ifdef SDTEST
 /* Echo packet generator (SDIO), pkts/s */
 extern uint brcmf_pktgen;
@@ -919,8 +915,6 @@ extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
 extern void *brcmf_os_open_image(char *filename);
 extern int brcmf_os_get_image_block(char *buf, int len, void *image);
 extern void brcmf_os_close_image(void *image);
-extern void brcmf_os_sdlock(dhd_pub_t *pub);
-extern void brcmf_os_sdunlock(dhd_pub_t *pub);
 extern void brcmf_os_sdlock_sndup_rxq(dhd_pub_t *pub);
 extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
 extern int brcmf_custom_get_mac_address(unsigned char *buf);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index fac8302..2213e4e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -82,10 +82,6 @@ typedef struct dhd_info {
 
 	struct semaphore proto_sem;
 	wait_queue_head_t ioctl_resp_wait;
-	spinlock_t sdlock;
-	/* Thread based operation */
-	bool threads_only;
-	struct semaphore sdsem;
 
 	/* Thread to issue ioctl for multicast */
 	struct task_struct *sysioc_tsk;
@@ -1489,9 +1485,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* Initialize other structure content */
 	init_waitqueue_head(&dhd->ioctl_resp_wait);
 
-	/* Initialize the spinlocks */
-	spin_lock_init(&dhd->sdlock);
-
 	/* Link to info module */
 	dhd->pub.info = dhd;
 
@@ -1515,13 +1508,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		strcpy(brcmf_nv_path, wl_cfg80211_get_nvramname());
 	}
 
-	/* Initialize thread based operation and lock */
-	sema_init(&dhd->sdsem, 1);
-	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0))
-		dhd->threads_only = true;
-	else
-		dhd->threads_only = false;
-
 	if (brcmf_sysioc) {
 		sema_init(&dhd->sysioc_sem, 0);
 		dhd->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, dhd,
@@ -1941,30 +1927,6 @@ void brcmf_os_close_image(void *image)
 		filp_close((struct file *)image, NULL);
 }
 
-void brcmf_os_sdlock(dhd_pub_t *pub)
-{
-	dhd_info_t *dhd;
-
-	dhd = (dhd_info_t *) (pub->info);
-
-	if (dhd->threads_only)
-		down(&dhd->sdsem);
-	else
-		spin_lock_bh(&dhd->sdlock);
-}
-
-void brcmf_os_sdunlock(dhd_pub_t *pub)
-{
-	dhd_info_t *dhd;
-
-	dhd = (dhd_info_t *) (pub->info);
-
-	if (dhd->threads_only)
-		up(&dhd->sdsem);
-	else
-		spin_unlock_bh(&dhd->sdlock);
-}
-
 static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 			    brcmf_event_msg_t *event, void **data)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6f69413..d64ba7b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -597,6 +597,10 @@ typedef struct dhd_bus {
 	struct tasklet_struct tasklet;
 	struct task_struct *dpc_tsk;
 	struct completion dpc_wait;
+
+	bool threads_only;
+	struct semaphore sdsem;
+	spinlock_t sdlock;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -809,13 +813,15 @@ static void brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase);
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
 static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
-static void brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar);
+static void brcmf_sdbrcm_wait_for_event(dhd_bus_t *bus, bool *lockvar);
 static void brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus);
 static void brcmf_sdbrcm_watchdog(unsigned long data);
 static int brcmf_sdbrcm_watchdog_thread(void *data);
 static int brcmf_sdbrcm_dpc_thread(void *data);
 static void brcmf_sdbrcm_dpc_tasklet(unsigned long data);
 static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus);
+static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus);
+static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -1295,9 +1301,9 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 	brcmf_txcomplete(bus->dhd, pkt, ret != 0);
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	if (free_pkt)
 		brcmu_pkt_buf_free_skb(pkt);
@@ -1371,7 +1377,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		}
 	} else {
 		/* Lock: we're about to use shared data/code (and SDIO) */
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 
 		/* Otherwise, send it now */
 		BUS_WAKE(bus);
@@ -1396,7 +1402,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 	}
 
 	return ret;
@@ -1512,7 +1518,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	ASSERT(IS_ALIGNED((unsigned long)frame, 2));
 
 	/* Need to lock here to protect txseq and SDIO tx calls */
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	BUS_WAKE(bus);
 
@@ -1540,7 +1546,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		bus->ctrl_frame_buf = frame;
 		bus->ctrl_frame_len = len;
 
-		brcmf_sdbrcm_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
+		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
 			DHD_INFO(("%s: ctrl_frame_stat == false\n", __func__));
@@ -1614,7 +1620,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	if (ret)
 		bus->dhd->tx_ctlerrs++;
@@ -1638,11 +1644,11 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	/* Wait until control frame is available */
 	timeleft = brcmf_os_ioctl_resp_wait(bus->dhd, &bus->rxlen, &pending);
 
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 	rxlen = bus->rxlen;
 	memcpy(msg, bus->rxctl, min(msglen, rxlen));
 	bus->rxlen = 0;
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	if (rxlen) {
 		DHD_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
@@ -1650,20 +1656,20 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	} else if (timeleft == 0) {
 		DHD_ERROR(("%s: resumed on timeout\n", __func__));
 #ifdef BCMDBG
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_os_sdunlock(bus->dhd);
-#endif				/* BCMDBG */
+		brcmf_sdbrcm_sdunlock(bus);
+#endif				/* DHD_DEBUG */
 	} else if (pending == true) {
 		DHD_CTL(("%s: cancelled\n", __func__));
 		return -ERESTARTSYS;
 	} else {
 		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
 #ifdef BCMDBG
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_os_sdunlock(bus->dhd);
-#endif				/* BCMDBG */
+		brcmf_sdbrcm_sdunlock(bus);
+#endif				/* DHD_DEBUG */
 	}
 
 	if (rxlen)
@@ -2373,7 +2379,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	bool_val = (int_val != 0) ? true : false;
 
 	/* Some ioctls use the bus */
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
 	if (bus->dhd->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
@@ -2786,7 +2792,7 @@ exit:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
 		brcmf_c_preinit_ioctls((dhd_pub_t *) bus->dhd);
@@ -2958,7 +2964,7 @@ brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 	/* Look up var locally; if not found pass to host driver */
 	vi = brcmu_iovar_lookup(dhdsdio_iovars, name);
 	if (vi == NULL) {
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 
 		BUS_WAKE(bus);
 
@@ -2991,7 +2997,7 @@ brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 		goto exit;
 	}
 
@@ -3032,7 +3038,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (enforce_mutex)
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 
 	BUS_WAKE(bus);
 
@@ -3106,7 +3112,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	bus->tx_seq = bus->rx_seq = 0;
 
 	if (enforce_mutex)
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 
 #if defined(OOB_INTR_ONLY)
 	brcmf_sdio_unregister_oob_intr();
@@ -3133,7 +3139,7 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 
 	if (enforce_mutex)
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3233,7 +3239,7 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 
 exit:
 	if (enforce_mutex)
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 
 	return ret;
 }
@@ -3797,9 +3803,9 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 #endif				/* BCMDBG */
 		}
 		if (num) {
-			brcmf_os_sdunlock(bus->dhd);
+			brcmf_sdbrcm_sdunlock(bus);
 			brcmf_rx_frame(bus->dhd, ifidx, save_pfirst, num);
-			brcmf_os_sdlock(bus->dhd);
+			brcmf_sdbrcm_sdlock(bus);
 		}
 
 		bus->rxglomframes++;
@@ -4383,9 +4389,9 @@ deliver:
 		}
 
 		/* Unlock during rx call */
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 		brcmf_rx_frame(bus->dhd, ifidx, pkt, 1);
-		brcmf_os_sdlock(bus->dhd);
+		brcmf_sdbrcm_sdlock(bus);
 	}
 	rxcount = maxframes - rxleft;
 #ifdef BCMDBG
@@ -4495,7 +4501,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
 
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	/* If waiting for HTAVAIL, check status */
 	if (bus->clkstate == CLK_PENDING) {
@@ -4725,7 +4731,7 @@ clkwait:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
 
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	return resched;
 }
@@ -5054,7 +5060,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 	if (bus->sleeping)
 		return false;
 
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	/* Poll period: check device if appropriate. */
 	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
@@ -5131,7 +5137,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 		}
 	}
 
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	return bus->ipend;
 }
@@ -5150,11 +5156,11 @@ static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 		return -ENOTSUPP;
 
 	/* Exclusive bus access */
-	brcmf_os_sdlock(bus->dhd);
+	brcmf_sdbrcm_sdlock(bus);
 
 	/* Don't allow input if dongle is in reset */
 	if (bus->dhd->dongle_reset) {
-		brcmf_os_sdunlock(bus->dhd);
+		brcmf_sdbrcm_sdunlock(bus);
 		return -EPERM;
 	}
 
@@ -5196,7 +5202,7 @@ done:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	brcmf_os_sdunlock(bus->dhd);
+	brcmf_sdbrcm_sdunlock(bus);
 
 	return rv;
 }
@@ -5318,6 +5324,15 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	bus->timer.data = (unsigned long)bus;
 	bus->timer.function = brcmf_sdbrcm_watchdog;
 
+	/* Initialize thread based operation and lock */
+	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)) {
+		bus->threads_only = true;
+		sema_init(&bus->sdsem, 1);
+	} else {
+		bus->threads_only = false;
+		spin_lock_init(&bus->sdlock);
+	}
+
 	if (brcmf_dpc_prio >= 0) {
 		/* Initialize watchdog thread */
 		init_completion(&bus->watchdog_wait);
@@ -6470,12 +6485,12 @@ brcmf_sdbrcm_chip_detach(struct dhd_bus *bus)
 }
 
 static void
-brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
+brcmf_sdbrcm_wait_for_event(dhd_bus_t *bus, bool *lockvar)
 {
-	brcmf_os_sdunlock(dhd);
-	wait_event_interruptible_timeout(dhd->bus->ctrl_wait,
+	brcmf_sdbrcm_sdunlock(bus);
+	wait_event_interruptible_timeout(bus->ctrl_wait,
 					 (*lockvar == false), HZ * 2);
-	brcmf_os_sdlock(dhd);
+	brcmf_sdbrcm_sdlock(bus);
 	return;
 }
 
@@ -6638,3 +6653,19 @@ static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus)
 
 	tasklet_schedule(&bus->tasklet);
 }
+
+static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus)
+{
+	if (bus->threads_only)
+		down(&bus->sdsem);
+	else
+		spin_lock_bh(&bus->sdlock);
+}
+
+static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus)
+{
+	if (bus->threads_only)
+		up(&bus->sdsem);
+	else
+		spin_unlock_bh(&bus->sdlock);
+}
-- 
1.7.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1876 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2IMTMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/10] brcmfmac: convert SDIO dpc implementation to
 workqueue
Date: Thu, 13 Sep 2012 21:12:00 +0200
Message-ID: <1347563526-12513-5-git-send-email-arend@broadcom.com> (sfid-20120913_211229_188484_23B22773)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Switch SDIO dpc implementation from kernel thread to workqueue for
better performance and compatibility.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  185 +++++++++-----------
 1 file changed, 83 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b0794e8..1d80e05 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -495,7 +495,6 @@ struct brcmf_sdio {
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	u32 intstatus;	/* Intstatus bits (events) pending */
-	bool dpc_sched;		/* Indicates DPC schedule (intrpt rcvd) */
 	bool fcstate;		/* State of dongle flow-control */
 
 	uint blocksize;		/* Block size of SDIO transfers */
@@ -569,8 +568,8 @@ struct brcmf_sdio {
 	bool wd_timer_valid;
 	uint save_ms;
 
-	struct task_struct *dpc_tsk;
-	struct completion dpc_wait;
+	struct workqueue_struct *brcmf_wq;
+	struct work_struct datawork;
 	struct list_head dpc_tsklst;
 	spinlock_t dpc_tl_lock;
 
@@ -2183,12 +2182,6 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 		bus->watchdog_tsk = NULL;
 	}
 
-	if (bus->dpc_tsk && bus->dpc_tsk != current) {
-		send_sig(SIGTERM, bus->dpc_tsk, 1);
-		kthread_stop(bus->dpc_tsk);
-		bus->dpc_tsk = NULL;
-	}
-
 	down(&bus->sdsem);
 
 	/* Enable clock for device interrupts */
@@ -2261,15 +2254,31 @@ static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
 }
 #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
-static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
+static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
+{
+	struct list_head *new_hd;
+	unsigned long flags;
+
+	if (in_interrupt())
+		new_hd = kzalloc(sizeof(struct list_head), GFP_ATOMIC);
+	else
+		new_hd = kzalloc(sizeof(struct list_head), GFP_KERNEL);
+	if (new_hd == NULL)
+		return;
+
+	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+	list_add_tail(new_hd, &bus->dpc_tsklst);
+	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+}
+
+static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
 	u32 intstatus, newstatus = 0;
 	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
-	bool resched = false;	/* Flag indicating resched wanted */
-	int err;
+	int err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2454,7 +2463,6 @@ clkwait:
 		if (ret == 0)
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-		brcmf_dbg(INFO, "Return_dpc value is : %d\n", ret);
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -2477,15 +2485,13 @@ clkwait:
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
 		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
-		resched = true;
+		brcmf_sdbrcm_adddpctsk(bus);
 	} else if (bus->intstatus || atomic_read(&bus->ipend) > 0 ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
 		 && data_ok(bus)) || PKT_AVAILABLE()) {
-		resched = true;
+		brcmf_sdbrcm_adddpctsk(bus);
 	}
 
-	bus->dpc_sched = resched;
-
 	/* If we're done for now, turn off clock request. */
 	if ((bus->clkstate != CLK_PENDING)
 	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
@@ -2494,65 +2500,6 @@ clkwait:
 	}
 
 	up(&bus->sdsem);
-
-	return resched;
-}
-
-static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
-{
-	struct list_head *new_hd;
-	unsigned long flags;
-
-	if (in_interrupt())
-		new_hd = kzalloc(sizeof(struct list_head), GFP_ATOMIC);
-	else
-		new_hd = kzalloc(sizeof(struct list_head), GFP_KERNEL);
-	if (new_hd == NULL)
-		return;
-
-	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-	list_add_tail(new_hd, &bus->dpc_tsklst);
-	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-}
-
-static int brcmf_sdbrcm_dpc_thread(void *data)
-{
-	struct brcmf_sdio *bus = (struct brcmf_sdio *) data;
-	struct list_head *cur_hd, *tmp_hd;
-	unsigned long flags;
-
-	allow_signal(SIGTERM);
-	/* Run until signal received */
-	while (1) {
-		if (kthread_should_stop())
-			break;
-
-		if (list_empty(&bus->dpc_tsklst))
-			if (wait_for_completion_interruptible(&bus->dpc_wait))
-				break;
-
-		spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-		list_for_each_safe(cur_hd, tmp_hd, &bus->dpc_tsklst) {
-			spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-
-			if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
-				/* after stopping the bus, exit thread */
-				brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
-				bus->dpc_tsk = NULL;
-				spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-				break;
-			}
-
-			if (brcmf_sdbrcm_dpc(bus))
-				brcmf_sdbrcm_adddpctsk(bus);
-
-			spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-			list_del(cur_hd);
-			kfree(cur_hd);
-		}
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-	}
-	return 0;
 }
 
 static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
@@ -2562,6 +2509,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	unsigned long flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2600,13 +2548,15 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
 		qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
-	/* Schedule DPC if needed to send queued packet(s) */
-	if (!bus->dpc_sched) {
-		bus->dpc_sched = true;
-		if (bus->dpc_tsk) {
-			brcmf_sdbrcm_adddpctsk(bus);
-			complete(&bus->dpc_wait);
-		}
+
+	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+	if (list_empty(&bus->dpc_tsklst)) {
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+
+		brcmf_sdbrcm_adddpctsk(bus);
+		queue_work(bus->brcmf_wq, &bus->datawork);
+	} else {
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 
 	return ret;
@@ -2802,6 +2752,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	unsigned long flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2885,9 +2836,15 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
-	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) &&
+	    list_empty(&bus->dpc_tsklst)) {
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
+	} else {
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 
 	up(&bus->sdsem);
@@ -3698,11 +3655,8 @@ void brcmf_sdbrcm_isr(void *arg)
 	if (!bus->intr)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
-	bus->dpc_sched = true;
-	if (bus->dpc_tsk) {
-		brcmf_sdbrcm_adddpctsk(bus);
-		complete(&bus->dpc_wait);
-	}
+	brcmf_sdbrcm_adddpctsk(bus);
+	queue_work(bus->brcmf_wq, &bus->datawork);
 }
 
 static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
@@ -3710,6 +3664,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 #ifdef DEBUG
 	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
 #endif	/* DEBUG */
+	unsigned long flags;
 
 	brcmf_dbg(TIMER, "Enter\n");
 
@@ -3726,14 +3681,20 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		if (!bus->intr ||
 		    (bus->sdcnt.intrcount == bus->sdcnt.lastintrs)) {
 
-			if (!bus->dpc_sched) {
+			spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+			if (list_empty(&bus->dpc_tsklst)) {
 				u8 devpend;
+				spin_unlock_irqrestore(&bus->dpc_tl_lock,
+						       flags);
 				devpend = brcmf_sdio_regrb(bus->sdiodev,
 							   SDIO_CCCR_INTx,
 							   NULL);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
 					       INTR_STATUS_FUNC2);
+			} else {
+				spin_unlock_irqrestore(&bus->dpc_tl_lock,
+						       flags);
 			}
 
 			/* If there is something, make like the ISR and
@@ -3742,11 +3703,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->sdcnt.pollcnt++;
 				atomic_set(&bus->ipend, 1);
 
-				bus->dpc_sched = true;
-				if (bus->dpc_tsk) {
-					brcmf_sdbrcm_adddpctsk(bus);
-					complete(&bus->dpc_wait);
-				}
+				brcmf_sdbrcm_adddpctsk(bus);
+				queue_work(bus->brcmf_wq, &bus->datawork);
 			}
 		}
 
@@ -3800,6 +3758,26 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 	return false;
 }
 
+static void brcmf_sdio_dataworker(struct work_struct *work)
+{
+	struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
+					      datawork);
+	struct list_head *cur_hd, *tmp_hd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+	list_for_each_safe(cur_hd, tmp_hd, &bus->dpc_tsklst) {
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+
+		brcmf_sdbrcm_dpc(bus);
+
+		spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+		list_del(cur_hd);
+		kfree(cur_hd);
+	}
+	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+}
+
 static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -4012,6 +3990,9 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 		/* De-register interrupt handler */
 		brcmf_sdio_intr_unregister(bus->sdiodev);
 
+		cancel_work_sync(&bus->datawork);
+		destroy_workqueue(bus->brcmf_wq);
+
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
 			brcmf_sdbrcm_release_dongle(bus);
@@ -4064,6 +4045,13 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	init_waitqueue_head(&bus->ctrl_wait);
 	init_waitqueue_head(&bus->dcmd_resp_wait);
 
+	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
+	if (bus->brcmf_wq == NULL) {
+		brcmf_dbg(ERROR, "insufficient memory to create txworkqueue\n");
+		goto fail;
+	}
+	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
+
 	/* Set up the watchdog timer */
 	init_timer(&bus->timer);
 	bus->timer.data = (unsigned long)bus;
@@ -4081,15 +4069,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		bus->watchdog_tsk = NULL;
 	}
 	/* Initialize DPC thread */
-	init_completion(&bus->dpc_wait);
 	INIT_LIST_HEAD(&bus->dpc_tsklst);
 	spin_lock_init(&bus->dpc_tl_lock);
-	bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
-				   bus, "brcmf_dpc");
-	if (IS_ERR(bus->dpc_tsk)) {
-		pr_warn("brcmf_dpc thread failed to start\n");
-		bus->dpc_tsk = NULL;
-	}
 
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
-- 
1.7.9.5



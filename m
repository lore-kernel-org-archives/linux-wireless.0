Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:1712 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbbBFRgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:36:54 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: make sdio suspend wait for threads to freeze
Date: Fri, 6 Feb 2015 18:36:45 +0100
Message-ID: <1423244207-9707-5-git-send-email-arend@broadcom.com> (sfid-20150206_183715_623788_E4180085)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Borrowed the idea of the PM freezer to make sdio suspend wait for
watchdog and DPC thread to freeze at a safe point in their thread
routine. The suspend takes 20-25 msec.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 125 ++++++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   |  90 ++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h   |  32 ++++--
 3 files changed, 184 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 1f7e2f2..c438ccd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -58,6 +58,14 @@
 #define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
 #define BRCMF_DEFAULT_RXGLOM_SIZE	32  /* max rx frames in glom chain */
 
+struct brcmf_sdiod_freezer {
+	atomic_t freezing;
+	atomic_t thread_count;
+	u32 frozen_count;
+	wait_queue_head_t thread_freeze;
+	struct completion resumed;
+};
+
 static int brcmf_sdiod_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
 module_param_named(txglomsz, brcmf_sdiod_txglomsz, int, 0);
 MODULE_PARM_DESC(txglomsz, "maximum tx packet chain size [SDIO]");
@@ -895,6 +903,87 @@ static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->txglomsz = brcmf_sdiod_txglomsz;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
+{
+	sdiodev->freezer = kzalloc(sizeof(*sdiodev->freezer), GFP_KERNEL);
+	if (!sdiodev->freezer)
+		return -ENOMEM;
+	atomic_set(&sdiodev->freezer->thread_count, 0);
+	atomic_set(&sdiodev->freezer->freezing, 0);
+	init_waitqueue_head(&sdiodev->freezer->thread_freeze);
+	init_completion(&sdiodev->freezer->resumed);
+	return 0;
+}
+
+static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
+{
+	if (sdiodev->freezer) {
+		WARN_ON(atomic_read(&sdiodev->freezer->freezing));
+		kfree(sdiodev->freezer);
+	}
+}
+
+static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
+{
+	atomic_t *expect = &sdiodev->freezer->thread_count;
+	int res = 0;
+
+	sdiodev->freezer->frozen_count = 0;
+	reinit_completion(&sdiodev->freezer->resumed);
+	atomic_set(&sdiodev->freezer->freezing, 1);
+	brcmf_sdio_trigger_dpc(sdiodev->bus);
+	wait_event(sdiodev->freezer->thread_freeze,
+		   atomic_read(expect) == sdiodev->freezer->frozen_count);
+	sdio_claim_host(sdiodev->func[1]);
+	res = brcmf_sdio_sleep(sdiodev->bus, true);
+	sdio_release_host(sdiodev->func[1]);
+	return res;
+}
+
+static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
+{
+	sdio_claim_host(sdiodev->func[1]);
+	brcmf_sdio_sleep(sdiodev->bus, false);
+	sdio_release_host(sdiodev->func[1]);
+	atomic_set(&sdiodev->freezer->freezing, 0);
+	complete_all(&sdiodev->freezer->resumed);
+}
+
+bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev)
+{
+	return atomic_read(&sdiodev->freezer->freezing);
+}
+
+void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
+{
+	if (!brcmf_sdiod_freezing(sdiodev))
+		return;
+	sdiodev->freezer->frozen_count++;
+	wake_up(&sdiodev->freezer->thread_freeze);
+	wait_for_completion(&sdiodev->freezer->resumed);
+}
+
+void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev)
+{
+	atomic_inc(&sdiodev->freezer->thread_count);
+}
+
+void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev)
+{
+	atomic_dec(&sdiodev->freezer->thread_count);
+}
+#else
+static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
+{
+	return 0;
+}
+
+static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
+{
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
 	if (sdiodev->bus) {
@@ -902,6 +991,8 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 		sdiodev->bus = NULL;
 	}
 
+	brcmf_sdiod_freezer_detach(sdiodev);
+
 	/* Disable Function 2 */
 	sdio_claim_host(sdiodev->func[2]);
 	sdio_disable_func(sdiodev->func[2]);
@@ -973,6 +1064,10 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 	 */
 	brcmf_sdiod_sgtable_alloc(sdiodev);
 
+	ret = brcmf_sdiod_freezer_attach(sdiodev);
+	if (ret)
+		goto out;
+
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdio_probe(sdiodev);
 	if (!sdiodev->bus) {
@@ -1069,9 +1164,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 #endif
 
 	brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DOWN);
-	sdiodev->sleeping = false;
-	atomic_set(&sdiodev->suspend, false);
-	init_waitqueue_head(&sdiodev->idle_wait);
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
 	err = brcmf_sdiod_probe(sdiodev);
@@ -1133,24 +1225,22 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 #ifdef CONFIG_PM_SLEEP
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
+	struct sdio_func *func;
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
 	mmc_pm_flag_t sdio_flags;
 
-	brcmf_dbg(SDIO, "Enter\n");
+	func = container_of(dev, struct sdio_func, dev);
+	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
+	if (func->num != SDIO_FUNC_1)
+		return 0;
+
 
 	bus_if = dev_get_drvdata(dev);
 	sdiodev = bus_if->bus_priv.sdio;
 
-	/* wait for watchdog to go idle */
-	if (wait_event_timeout(sdiodev->idle_wait, sdiodev->sleeping,
-			       msecs_to_jiffies(3 * BRCMF_WD_POLL_MS)) == 0) {
-		brcmf_err("bus still active\n");
-		return -EBUSY;
-	}
-	/* disable watchdog */
+	brcmf_sdiod_freezer_on(sdiodev);
 	brcmf_sdio_wd_timer(sdiodev->bus, 0);
-	atomic_set(&sdiodev->suspend, true);
 
 	if (sdiodev->wowl_enabled) {
 		sdio_flags = MMC_PM_KEEP_POWER;
@@ -1168,12 +1258,13 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct sdio_func *func = container_of(dev, struct sdio_func, dev);
 
-	brcmf_dbg(SDIO, "Enter\n");
-	if (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)
-		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
-	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
-	atomic_set(&sdiodev->suspend, false);
+	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
+	if (func->num != SDIO_FUNC_2)
+		return 0;
+
+	brcmf_sdiod_freezer_off(sdiodev);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 6ba79d2..ea403d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -515,6 +515,7 @@ struct brcmf_sdio {
 	bool txoff;		/* Transmit flow-controlled */
 	struct brcmf_sdio_count sdcnt;
 	bool sr_enabled; /* SaveRestore enabled */
+	bool sleeping;
 
 	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
 	bool txglom;		/* host tx glomming enable flag */
@@ -1013,12 +1014,12 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 
 	brcmf_dbg(SDIO, "Enter: request %s currently %s\n",
 		  (sleep ? "SLEEP" : "WAKE"),
-		  (bus->sdiodev->sleeping ? "SLEEP" : "WAKE"));
+		  (bus->sleeping ? "SLEEP" : "WAKE"));
 
 	/* If SR is enabled control bus state with KSO */
 	if (bus->sr_enabled) {
 		/* Done if we're already in the requested state */
-		if (sleep == bus->sdiodev->sleeping)
+		if (sleep == bus->sleeping)
 			goto end;
 
 		/* Going to sleep */
@@ -1065,9 +1066,7 @@ end:
 	} else {
 		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
 	}
-	bus->sdiodev->sleeping = sleep;
-	if (sleep)
-		wake_up(&bus->sdiodev->idle_wait);
+	bus->sleeping = sleep;
 	brcmf_dbg(SDIO, "new state %s\n",
 		  (sleep ? "SLEEP" : "WAKE"));
 done:
@@ -2603,21 +2602,6 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	return ret;
 }
 
-static int brcmf_sdio_pm_resume_wait(struct brcmf_sdio_dev *sdiodev)
-{
-#ifdef CONFIG_PM_SLEEP
-	int retry;
-
-	/* Wait for possible resume to complete */
-	retry = 0;
-	while ((atomic_read(&sdiodev->suspend)) && (retry++ != 50))
-		msleep(20);
-	if (atomic_read(&sdiodev->suspend))
-		return -EIO;
-#endif
-	return 0;
-}
-
 static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
 	u32 newstatus = 0;
@@ -2628,9 +2612,6 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (brcmf_sdio_pm_resume_wait(bus->sdiodev))
-		return;
-
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* If waiting for HTAVAIL, check status */
@@ -2862,11 +2843,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 		qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
 
-	if (atomic_read(&bus->dpc_tskcnt) == 0) {
-		atomic_inc(&bus->dpc_tskcnt);
-		queue_work(bus->brcmf_wq, &bus->datawork);
-	}
-
+	brcmf_sdio_trigger_dpc(bus);
 	return ret;
 }
 
@@ -2964,11 +2941,8 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	bus->ctrl_frame_buf = msg;
 	bus->ctrl_frame_len = msglen;
 	bus->ctrl_frame_stat = true;
-	if (atomic_read(&bus->dpc_tskcnt) == 0) {
-		atomic_inc(&bus->dpc_tskcnt);
-		queue_work(bus->brcmf_wq, &bus->datawork);
-	}
 
+	brcmf_sdio_trigger_dpc(bus);
 	wait_event_interruptible_timeout(bus->ctrl_wait, !bus->ctrl_frame_stat,
 					 msecs_to_jiffies(CTL_DONE_TIMEOUT));
 
@@ -3548,6 +3522,14 @@ done:
 	return err;
 }
 
+void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus)
+{
+	if (atomic_read(&bus->dpc_tskcnt) == 0) {
+		atomic_inc(&bus->dpc_tskcnt);
+		queue_work(bus->brcmf_wq, &bus->datawork);
+	}
+}
+
 void brcmf_sdio_isr(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3602,9 +3584,8 @@ static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 							    SDIO_CCCR_INTx,
 							    NULL);
 				sdio_release_host(bus->sdiodev->func[1]);
-				intstatus =
-				    devpend & (INTR_STATUS_FUNC1 |
-					       INTR_STATUS_FUNC2);
+				intstatus = devpend & (INTR_STATUS_FUNC1 |
+						       INTR_STATUS_FUNC2);
 			}
 
 			/* If there is something, make like the ISR and
@@ -3667,6 +3648,11 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 		atomic_set(&bus->dpc_tskcnt, 0);
 		brcmf_sdio_dpc(bus);
 	}
+	if (brcmf_sdiod_freezing(bus->sdiodev)) {
+		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DOWN);
+		brcmf_sdiod_try_freeze(bus->sdiodev);
+		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
+	}
 }
 
 static void
@@ -3944,13 +3930,19 @@ static int
 brcmf_sdio_watchdog_thread(void *data)
 {
 	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
+	int wait;
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
+	brcmf_sdiod_freezer_count(bus->sdiodev);
 	while (1) {
 		if (kthread_should_stop())
 			break;
-		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
+		brcmf_sdiod_freezer_uncount(bus->sdiodev);
+		wait = wait_for_completion_interruptible(&bus->watchdog_wait);
+		brcmf_sdiod_freezer_count(bus->sdiodev);
+		brcmf_sdiod_try_freeze(bus->sdiodev);
+		if (!wait) {
 			brcmf_sdio_bus_watchdog(bus);
 			/* Count the tick for reference */
 			bus->sdcnt.tickcnt++;
@@ -4089,6 +4081,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
+	struct workqueue_struct *wq;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -4117,12 +4110,16 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 			bus->sgentry_align = sdiodev->pdata->sd_sgentry_align;
 	}
 
-	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
-	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
-	if (bus->brcmf_wq == NULL) {
+	/* single-threaded workqueue */
+	wq = alloc_ordered_workqueue("brcmf_wq/%s", WQ_MEM_RECLAIM,
+				     dev_name(&sdiodev->func[1]->dev));
+	if (!wq) {
 		brcmf_err("insufficient memory to create txworkqueue\n");
 		goto fail;
 	}
+	brcmf_sdiod_freezer_count(sdiodev);
+	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
+	bus->brcmf_wq = wq;
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdio_probe_attach(bus))) {
@@ -4143,7 +4140,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Initialize watchdog thread */
 	init_completion(&bus->watchdog_wait);
 	bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
-					bus, "brcmf_watchdog");
+					bus, "brcmf_wdog/%s",
+					dev_name(&sdiodev->func[1]->dev));
 	if (IS_ERR(bus->watchdog_tsk)) {
 		pr_warn("brcmf_watchdog thread failed to start\n");
 		bus->watchdog_tsk = NULL;
@@ -4303,3 +4301,15 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 		bus->save_ms = wdtick;
 	}
 }
+
+int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
+{
+	int ret;
+
+	sdio_claim_host(bus->sdiodev->func[1]);
+	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
+	sdio_release_host(bus->sdiodev->func[1]);
+
+	return ret;
+}
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index a6cdc60..7328478 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -175,15 +175,13 @@ struct brcmf_sdreg {
 };
 
 struct brcmf_sdio;
+struct brcmf_sdiod_freezer;
 
 struct brcmf_sdio_dev {
 	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_sdio *bus;
-	atomic_t suspend;		/* suspend flag */
-	bool sleeping;
-	wait_queue_head_t idle_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
 	struct brcmfmac_sdio_platform_data *pdata;
@@ -201,6 +199,7 @@ struct brcmf_sdio_dev {
 	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	bool wowl_enabled;
 	enum brcmf_sdiod_state state;
+	struct brcmf_sdiod_freezer *freezer;
 };
 
 /* sdio core registers */
@@ -343,6 +342,28 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 /* Issue an abort to the specified function */
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
+void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
+			      enum brcmf_sdiod_state state);
+#ifdef CONFIG_PM_SLEEP
+bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev);
+#else
+static inline bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev)
+{
+	return false;
+}
+static inline void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
+{
+}
+static inline void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev)
+{
+}
+static inline void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev)
+{
+}
+#endif /* CONFIG_PM_SLEEP */
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdio_remove(struct brcmf_sdio *bus);
@@ -350,8 +371,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
-
-void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
-			      enum brcmf_sdiod_state state);
+int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep);
+void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus);
 
 #endif /* BRCMFMAC_SDIO_H */
-- 
1.9.1


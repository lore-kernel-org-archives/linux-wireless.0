Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3179 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1HLTFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:05:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 01/14] staging: brcm80211: use wait queues instead of
 semaphores in wl_cfg80211.c
Date: Fri, 12 Aug 2011 21:05:33 +0200
Message-ID: <1313175933-4323-1-git-send-email-arend@broadcom.com> (sfid-20110812_210611_718286_314EDE7B)
In-Reply-To: <1313156101-16817-2-git-send-email-arend@broadcom.com>
References: <1313156101-16817-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wl_cfg80211.c two semaphores were used to trigger a task to process
an event. The wait queues are better suited for that purpose. This also
removes checkpatch warning on sema_init() calls in this source file.

Reviewed-by: Rafal Milecki <zajec5@gmail.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Greg,

This patch replaces the original submitted [01/14] patch identified by:

Message-ID: <1313156101-16817-2-git-send-email-arend@broadcom.com>

Gr. AvS
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   49 +++++++++++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    5 +-
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index bc1e1a9..833defb 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3162,7 +3162,7 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 
 static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	sema_init(&cfg_priv->event_sync, 0);
+	init_waitqueue_head(&cfg_priv->event_waitq);
 	cfg_priv->event_tsk = kthread_run(brcmf_event_handler, cfg_priv,
 					  "wl_event_handler");
 	if (IS_ERR(cfg_priv->event_tsk)) {
@@ -3224,7 +3224,7 @@ static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
 {
 	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
 		WL_SCAN("wake up iscan\n");
-		up(&iscan->sync);
+		wake_up(&iscan->waitq);
 		return 0;
 	}
 
@@ -3330,13 +3330,19 @@ static s32 brcmf_iscan_thread(void *data)
 			(struct brcmf_cfg80211_iscan_ctrl *)data;
 	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
 	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
+	DECLARE_WAITQUEUE(wait, current);
 	u32 status;
 	int err = 0;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	allow_signal(SIGTERM);
 	status = BRCMF_SCAN_RESULTS_PARTIAL;
-	while (likely(!down_interruptible(&iscan->sync))) {
+	add_wait_queue(&iscan->waitq, &wait);
+	while (1) {
+		prepare_to_wait(&iscan->waitq, &wait, TASK_INTERRUPTIBLE);
+
+		schedule();
+
 		if (kthread_should_stop())
 			break;
 		if (iscan->timer_on) {
@@ -3353,6 +3359,7 @@ static s32 brcmf_iscan_thread(void *data)
 		rtnl_unlock();
 		el->handler[status](cfg_priv);
 	}
+	finish_wait(&iscan->waitq, &wait);
 	if (iscan->timer_on) {
 		del_timer_sync(&iscan->timer);
 		iscan->timer_on = 0;
@@ -3380,7 +3387,7 @@ static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 	if (cfg_priv->iscan_on && !iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
-		sema_init(&iscan->sync, 0);
+		init_waitqueue_head(&iscan->waitq);
 		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
 		if (IS_ERR(iscan->tsk)) {
 			WL_ERR("Could not create iscan thread\n");
@@ -3528,7 +3535,7 @@ void brcmf_cfg80211_detach(void)
 
 static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	up(&cfg_priv->event_sync);
+	wake_up(&cfg_priv->event_waitq);
 }
 
 static s32 brcmf_event_handler(void *data)
@@ -3537,27 +3544,40 @@ static s32 brcmf_event_handler(void *data)
 			(struct brcmf_cfg80211_priv *)data;
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
 	struct brcmf_cfg80211_event_q *e;
+	DECLARE_WAITQUEUE(wait, current);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	allow_signal(SIGTERM);
-	while (likely(!down_interruptible(&cfg_priv->event_sync))) {
+	add_wait_queue(&cfg_priv->event_waitq, &wait);
+	while (1) {
+		prepare_to_wait(&cfg_priv->event_waitq, &wait,
+				TASK_INTERRUPTIBLE);
+
+		schedule();
+
 		if (kthread_should_stop())
 			break;
+
 		e = brcmf_deq_event(cfg_priv);
 		if (unlikely(!e)) {
 			WL_ERR("event queue empty...\n");
-			BUG();
+			continue;
 		}
-		WL_INFO("event type (%d)\n", e->etype);
-		if (cfg_priv->el.handler[e->etype])
-			cfg_priv->el.handler[e->etype](cfg_priv,
-						       cfg_to_ndev(cfg_priv),
-						       &e->emsg, e->edata);
-		else
-			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
 
-		brcmf_put_event(e);
+		do {
+			WL_INFO("event type (%d)\n", e->etype);
+			if (cfg_priv->el.handler[e->etype])
+				cfg_priv->el.handler[e->etype](cfg_priv,
+					cfg_to_ndev(cfg_priv),
+					&e->emsg, e->edata);
+			else
+				WL_INFO("Unknown Event (%d): ignoring\n",
+					e->etype);
+			brcmf_put_event(e);
+			e = brcmf_deq_event(cfg_priv);
+		} while (e != NULL);
 	}
+	finish_wait(&cfg_priv->event_waitq, &wait);
 	WL_INFO("was terminated\n");
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index ff5c19a..049138b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -249,7 +249,7 @@ struct brcmf_cfg80211_iscan_ctrl {
 	u32 timer_on;
 	s32 state;
 	struct task_struct *tsk;
-	struct semaphore sync;
+	wait_queue_head_t waitq;
 	struct brcmf_cfg80211_iscan_eloop el;
 	void *data;
 	s8 ioctl_buf[BRCMF_C_IOCTL_SMLEN];
@@ -295,13 +295,12 @@ struct brcmf_cfg80211_priv {
 						 cfg80211 layer */
 	struct brcmf_cfg80211_ie ie;	/* information element object for
 					 internal purpose */
-	struct semaphore event_sync;	/* for synchronization of main event
-					 thread */
 	struct brcmf_cfg80211_profile *profile;	/* holding dongle profile */
 	struct brcmf_cfg80211_iscan_ctrl *iscan;	/* iscan controller */
 	struct brcmf_cfg80211_connect_info conn_info; /* association info */
 	struct brcmf_cfg80211_pmk_list *pmk_list;	/* wpa2 pmk list */
 	struct task_struct *event_tsk;	/* task of main event handler thread */
+	wait_queue_head_t event_waitq;	/* wait queue for main event handling */
 	unsigned long status;		/* current dongle status */
 	void *pub;
 	u32 channel;		/* current channel */
-- 
1.7.4.1



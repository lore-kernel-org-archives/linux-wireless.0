Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2425 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/19] staging: brcm80211: remove event handler
 thread from fullmac
Date: Thu, 22 Sep 2011 17:07:44 -0700
Message-ID: <1316736476-23725-8-git-send-email-frankyl@broadcom.com> (sfid-20110923_020840_744533_9F99E24F)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use work queue to defer cfg80211 event handle jobs

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   85 +++++-----------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    3 +-
 2 files changed, 21 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 5e86e21..2dd28a2 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3248,69 +3248,30 @@ static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
 	kfree(e);
 }
 
-static s32 brcmf_event_handler(void *data)
+static void brcmf_cfg80211_event_handler(struct work_struct *work)
 {
 	struct brcmf_cfg80211_priv *cfg_priv =
-			(struct brcmf_cfg80211_priv *)data;
-	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
+			container_of(work, struct brcmf_cfg80211_priv,
+				     event_work);
 	struct brcmf_cfg80211_event_q *e;
-	DECLARE_WAITQUEUE(wait, current);
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-	allow_signal(SIGTERM);
-	add_wait_queue(&cfg_priv->event_waitq, &wait);
-	while (1) {
-		prepare_to_wait(&cfg_priv->event_waitq, &wait,
-				TASK_INTERRUPTIBLE);
-
-		schedule();
-
-		if (kthread_should_stop())
-			break;
-
-		e = brcmf_deq_event(cfg_priv);
-		if (unlikely(!e)) {
-			WL_ERR("event queue empty...\n");
-			continue;
-		}
-
-		do {
-			WL_INFO("event type (%d)\n", e->etype);
-			if (cfg_priv->el.handler[e->etype])
-				cfg_priv->el.handler[e->etype](cfg_priv,
-					cfg_to_ndev(cfg_priv),
-					&e->emsg, e->edata);
-			else
-				WL_INFO("Unknown Event (%d): ignoring\n",
-					e->etype);
-			brcmf_put_event(e);
-		} while ((e = brcmf_deq_event(cfg_priv)));
+	e = brcmf_deq_event(cfg_priv);
+	if (unlikely(!e)) {
+		WL_ERR("event queue empty...\n");
+		return;
 	}
-	finish_wait(&cfg_priv->event_waitq, &wait);
-	WL_INFO("was terminated\n");
-	return 0;
-}
 
-static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	init_waitqueue_head(&cfg_priv->event_waitq);
-	cfg_priv->event_tsk = kthread_run(brcmf_event_handler, cfg_priv,
-					  "wl_event_handler");
-	if (IS_ERR(cfg_priv->event_tsk)) {
-		cfg_priv->event_tsk = NULL;
-		WL_ERR("failed to create event thread\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
+	do {
+		WL_INFO("event type (%d)\n", e->etype);
+		if (cfg_priv->el.handler[e->etype])
+			cfg_priv->el.handler[e->etype](cfg_priv,
+						       cfg_to_ndev(cfg_priv),
+						       &e->emsg, e->edata);
+		else
+			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
+		brcmf_put_event(e);
+	} while ((e = brcmf_deq_event(cfg_priv)));
 
-static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	if (cfg_priv->event_tsk) {
-		send_sig(SIGTERM, cfg_priv->event_tsk, 1);
-		kthread_stop(cfg_priv->event_tsk);
-		cfg_priv->event_tsk = NULL;
-	}
 }
 
 static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
@@ -3352,8 +3313,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	err = brcmf_init_priv_mem(cfg_priv);
 	if (unlikely(err))
 		return err;
-	if (unlikely(brcmf_create_event_handler(cfg_priv)))
-		return -ENOMEM;
+	INIT_WORK(&cfg_priv->event_work, brcmf_cfg80211_event_handler);
 	brcmf_init_eloop_handler(&cfg_priv->el);
 	mutex_init(&cfg_priv->usr_sync);
 	err = brcmf_init_iscan(cfg_priv);
@@ -3368,7 +3328,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 
 static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	brcmf_destroy_event_handler(cfg_priv);
+	cancel_work_sync(&cfg_priv->event_work);
 	cfg_priv->dongle_up = false;	/* dongle down */
 	brcmf_flush_eq(cfg_priv);
 	brcmf_link_down(cfg_priv);
@@ -3438,11 +3398,6 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg_dev)
 	kfree(cfg_dev);
 }
 
-static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	wake_up(&cfg_priv->event_waitq);
-}
-
 void
 brcmf_cfg80211_event(struct net_device *ndev,
 		  const struct brcmf_event_msg *e, void *data)
@@ -3451,7 +3406,7 @@ brcmf_cfg80211_event(struct net_device *ndev,
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
 	if (likely(!brcmf_enq_event(cfg_priv, event_type, e)))
-		brcmf_wakeup_event(cfg_priv);
+		schedule_work(&cfg_priv->event_work);
 }
 
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index d27d4e6..79806c0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -298,8 +298,7 @@ struct brcmf_cfg80211_priv {
 	struct brcmf_cfg80211_iscan_ctrl *iscan;	/* iscan controller */
 	struct brcmf_cfg80211_connect_info conn_info; /* association info */
 	struct brcmf_cfg80211_pmk_list *pmk_list;	/* wpa2 pmk list */
-	struct task_struct *event_tsk;	/* task of main event handler thread */
-	wait_queue_head_t event_waitq;	/* wait queue for main event handling */
+	struct work_struct event_work;	/* event handler work struct */
 	unsigned long status;		/* current dongle status */
 	void *pub;
 	u32 channel;		/* current channel */
-- 
1.7.1



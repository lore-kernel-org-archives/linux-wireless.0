Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1060 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1ILKPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/20] staging: brcm80211: stop using kthread for iscan
 status check in fullmac
Date: Mon, 12 Sep 2011 12:14:45 +0200
Message-ID: <1315822504-24210-2-git-send-email-rvossen@broadcom.com> (sfid-20110912_121528_910023_0F2316C4)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use work queue instead.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Howard Harte <hharte@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   76 ++++++---------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    3 +-
 2 files changed, 23 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index db51c46..c8e47ff 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -271,7 +271,6 @@ static s32 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar,
 static void brcmf_iscan_timer(unsigned long data);
 static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_iscan_thread(void *data);
 static s32 brcmf_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
 				 s32 buflen);
@@ -3151,18 +3150,15 @@ static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 	struct brcmf_ssid ssid;
 
-	if (cfg_priv->iscan_on && iscan->tsk) {
+	if (cfg_priv->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
-		send_sig(SIGTERM, iscan->tsk, 1);
 
-		/*
-		 * The iscan task may want to acquire the rtnl_lock
-		 * so release it here upon stopping the task.
-		 */
-		rtnl_unlock();
-		kthread_stop(iscan->tsk);
-		rtnl_lock();
-		iscan->tsk = NULL;
+		if (iscan->timer_on) {
+			del_timer_sync(&iscan->timer);
+			iscan->timer_on = 0;
+		}
+
+		cancel_work_sync(&iscan->work);
 
 		/* Abort iscan running in FW */
 		memset(&ssid, 0, sizeof(ssid));
@@ -3195,7 +3191,7 @@ static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
 {
 	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
 		WL_SCAN("wake up iscan\n");
-		wake_up(&iscan->waitq);
+		schedule_work(&iscan->work);
 		return 0;
 	}
 
@@ -3294,50 +3290,28 @@ static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
-static s32 brcmf_iscan_thread(void *data)
+static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
 {
-	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
 	struct brcmf_cfg80211_iscan_ctrl *iscan =
-			(struct brcmf_cfg80211_iscan_ctrl *)data;
+			container_of(work, struct brcmf_cfg80211_iscan_ctrl,
+				     work);
 	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
 	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
-	DECLARE_WAITQUEUE(wait, current);
-	u32 status;
-	int err = 0;
-
-	sched_setscheduler(current, SCHED_FIFO, &param);
-	allow_signal(SIGTERM);
-	status = BRCMF_SCAN_RESULTS_PARTIAL;
-	add_wait_queue(&iscan->waitq, &wait);
-	while (1) {
-		prepare_to_wait(&iscan->waitq, &wait, TASK_INTERRUPTIBLE);
-
-		schedule();
+	u32 status = BRCMF_SCAN_RESULTS_PARTIAL;
 
-		if (kthread_should_stop())
-			break;
-		if (iscan->timer_on) {
-			del_timer_sync(&iscan->timer);
-			iscan->timer_on = 0;
-		}
-		rtnl_lock();
-		err = brcmf_get_iscan_results(iscan, &status,
-					      &cfg_priv->bss_list);
-		if (unlikely(err)) {
-			status = BRCMF_SCAN_RESULTS_ABORTED;
-			WL_ERR("Abort iscan\n");
-		}
-		rtnl_unlock();
-		el->handler[status](cfg_priv);
-	}
-	finish_wait(&iscan->waitq, &wait);
 	if (iscan->timer_on) {
 		del_timer_sync(&iscan->timer);
 		iscan->timer_on = 0;
 	}
-	WL_SCAN("ISCAN thread terminated\n");
 
-	return 0;
+	rtnl_lock();
+	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
+		status = BRCMF_SCAN_RESULTS_ABORTED;
+		WL_ERR("Abort iscan\n");
+	}
+	rtnl_unlock();
+
+	el->handler[status](cfg_priv);
 }
 
 static void brcmf_iscan_timer(unsigned long data)
@@ -3356,15 +3330,9 @@ static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 
-	if (cfg_priv->iscan_on && !iscan->tsk) {
+	if (cfg_priv->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
-		init_waitqueue_head(&iscan->waitq);
-		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
-		if (IS_ERR(iscan->tsk)) {
-			WL_ERR("Could not create iscan thread\n");
-			iscan->tsk = NULL;
-			return -ENOMEM;
-		}
+		INIT_WORK(&iscan->work, brcmf_cfg80211_iscan_handler);
 	}
 
 	return 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 0542bac..98cd47d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -248,8 +248,7 @@ struct brcmf_cfg80211_iscan_ctrl {
 	u32 timer_ms;
 	u32 timer_on;
 	s32 state;
-	struct task_struct *tsk;
-	wait_queue_head_t waitq;
+	struct work_struct work;
 	struct brcmf_cfg80211_iscan_eloop el;
 	void *data;
 	s8 ioctl_buf[BRCMF_C_IOCTL_SMLEN];
-- 
1.7.4.1



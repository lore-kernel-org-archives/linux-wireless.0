Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXLJR3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:29:40 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 26/48] libertas: clean up lbs_thread() to make it slightly more readable
Message-Id: <E1J1kpV-0006mD-D9@shinybook.infradead.org> (sfid-20071210_172947_623129_E5A06ABE)
Date: Mon, 10 Dec 2007 10:46:01 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 17:42:59 +0000

No semantic changes.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   92 +++++++++++++--------------------
 1 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 500357b..f595664 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -795,70 +795,60 @@ static int lbs_thread(void *data)
 	init_waitqueue_entry(&wait, current);
 
 	set_freezable();
+
 	for (;;) {
-		lbs_deb_thread( "main-thread 111: intcounter=%d "
-		       "currenttxskb=%p dnld_sent=%d\n",
-		       adapter->intcounter,
-		       adapter->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread( "main-thread 111: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
+				adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
 
 		add_wait_queue(&priv->waitq, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock_irq(&adapter->driver_lock);
+
 		if ((adapter->psstate == PS_STATE_SLEEP) ||
-		    (!adapter->intcounter
-		     && (priv->dnld_sent || adapter->cur_cmd ||
-			 list_empty(&adapter->cmdpendingq)))) {
-			lbs_deb_thread(
-			       "main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
-			       adapter->connect_status, adapter->intcounter,
-			       adapter->psmode, adapter->psstate);
+		    (!adapter->intcounter && (priv->dnld_sent || adapter->cur_cmd || list_empty(&adapter->cmdpendingq)))) {
+			lbs_deb_thread("main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
+				       adapter->connect_status, adapter->intcounter,
+				       adapter->psmode, adapter->psstate);
 			spin_unlock_irq(&adapter->driver_lock);
 			schedule();
 		} else
 			spin_unlock_irq(&adapter->driver_lock);
 
-		lbs_deb_thread(
-		       "main-thread 222 (waking up): intcounter=%d currenttxskb=%p "
-		       "dnld_sent=%d\n", adapter->intcounter,
-		       adapter->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("main-thread 222 (waking up): intcounter=%d currenttxskb=%p dnld_sent=%d\n",
+			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&priv->waitq, &wait);
 		try_to_freeze();
 
-		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p "
-		       "dnld_sent=%d\n",
-		       adapter->intcounter,
-		       adapter->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
+			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
 
-		if (kthread_should_stop()
-		    || adapter->surpriseremoved) {
-			lbs_deb_thread(
-			       "main-thread: break from main thread: surpriseremoved=0x%x\n",
-			       adapter->surpriseremoved);
+		if (kthread_should_stop() || adapter->surpriseremoved) {
+			lbs_deb_thread("main-thread: break from main thread: surpriseremoved=0x%x\n",
+				       adapter->surpriseremoved);
 			break;
 		}
 
 
 		spin_lock_irq(&adapter->driver_lock);
+
 		if (adapter->intcounter) {
 			u8 int_status;
+
 			adapter->intcounter = 0;
 			int_status = priv->hw_get_int_status(priv, &ireg);
 
 			if (int_status) {
-				lbs_deb_thread(
-				       "main-thread: reading HOST_INT_STATUS_REG failed\n");
+				lbs_deb_thread("main-thread: reading HOST_INT_STATUS_REG failed\n");
 				spin_unlock_irq(&adapter->driver_lock);
 				continue;
 			}
 			adapter->hisregcpy |= ireg;
 		}
 
-		lbs_deb_thread("main-thread 444: intcounter=%d currenttxskb=%p "
-		       "dnld_sent=%d\n",
-		       adapter->intcounter,
-		       adapter->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("main-thread 444: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
+			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
 
 		/* command response? */
 		if (adapter->hisregcpy & MRVDRV_CMD_UPLD_RDY) {
@@ -877,8 +867,7 @@ static int lbs_thread(void *data)
 			adapter->hisregcpy &= ~MRVDRV_CARDEVENT;
 
 			if (priv->hw_read_event_cause(priv)) {
-				lbs_pr_alert(
-				       "main-thread: hw_read_event_cause failed\n");
+				lbs_pr_alert("main-thread: hw_read_event_cause failed\n");
 				spin_unlock_irq(&adapter->driver_lock);
 				continue;
 			}
@@ -888,30 +877,21 @@ static int lbs_thread(void *data)
 			spin_unlock_irq(&adapter->driver_lock);
 
 		/* Check if we need to confirm Sleep Request received previously */
-		if (adapter->psstate == PS_STATE_PRE_SLEEP) {
-			if (!priv->dnld_sent && !adapter->cur_cmd) {
-				if (adapter->connect_status ==
-				    LBS_CONNECTED) {
-					lbs_deb_thread(
-					       "main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p "
-					       "dnld_sent=%d cur_cmd=%p, confirm now\n",
-					       adapter->intcounter,
-					       adapter->currenttxskb,
-					       priv->dnld_sent,
-					       adapter->cur_cmd);
-
-					lbs_ps_confirm_sleep(priv,
-						       (u16) adapter->psmode);
-				} else {
-					/* workaround for firmware sending
-					 * deauth/linkloss event immediately
-					 * after sleep request, remove this
-					 * after firmware fixes it
-					 */
-					adapter->psstate = PS_STATE_AWAKE;
-					lbs_pr_alert(
-					       "main-thread: ignore PS_SleepConfirm in non-connected state\n");
-				}
+		if (adapter->psstate == PS_STATE_PRE_SLEEP &&
+		    !priv->dnld_sent && !adapter->cur_cmd) {
+			if (adapter->connect_status == LBS_CONNECTED) {
+				lbs_deb_thread("main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
+					       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent, adapter->cur_cmd);
+
+				lbs_ps_confirm_sleep(priv, (u16) adapter->psmode);
+			} else {
+				/* workaround for firmware sending
+				 * deauth/linkloss event immediately
+				 * after sleep request; remove this
+				 * after firmware fixes it
+				 */
+				adapter->psstate = PS_STATE_AWAKE;
+				lbs_pr_alert("main-thread: ignore PS_SleepConfirm in non-connected state\n");
 			}
 		}
 
-- 
1.5.3.4


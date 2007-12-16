Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXLPW6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:16 -0500
Subject: [PATCH 97/48] libertas: don't exit worker thread until kthread_stop() is called
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Ri-00037c-8o@shinybook.infradead.org> (sfid-20071216_225826_727995_841B3CCB)
Date: Sun, 16 Dec 2007 17:58:54 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 13 Dec 2007 21:48:00 -0500

The kthread code can't cope with a thread exiting of its own accord and
then someone calling kthread_stop() for it. When the thread detects that
it needs to die, make it wait for kthread_stop() to be called.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 5d2bf53..b51513f 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -662,8 +662,10 @@ static int lbs_thread(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock_irq(&priv->driver_lock);
 
-		if (priv->surpriseremoved)
+		if (kthread_should_stop())
 			shouldsleep = 0;	/* Bye */
+		else if (priv->surpriseremoved)
+			shouldsleep = 1;	/* We need to wait until we're _told_ to die */
 		else if (priv->psstate == PS_STATE_SLEEP)
 			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
 		else if (priv->intcounter)
@@ -699,12 +701,15 @@ static int lbs_thread(void *data)
 		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
 			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
-		if (kthread_should_stop() || priv->surpriseremoved) {
-			lbs_deb_thread("main-thread: break from main thread: surpriseremoved=0x%x\n",
-				       priv->surpriseremoved);
+		if (kthread_should_stop()) {
+			lbs_deb_thread("main-thread: break from main thread\n");
 			break;
 		}
 
+		if (priv->surpriseremoved) {
+			lbs_deb_thread("adapter removed; waiting to die...\n");
+			continue;
+		}
 
 		spin_lock_irq(&priv->driver_lock);
 
-- 
1.5.3.4


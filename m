Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3020 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/22] brcm80211: smac: decreased timer callback irq
 level
Date: Wed, 12 Oct 2011 20:51:12 +0200
Message-ID: <1318445492-24207-3-git-send-email-arend@broadcom.com> (sfid-20111012_205234_028257_E8FA65D0)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Timer functions were called at soft-irq level, leading to the limitation
that mutexes could not be used. Lifted this limitation by migrating to
work queues.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   40 ++++++++-----------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |   12 +++--
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index b665aaf..6ce773a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1409,18 +1409,22 @@ void brcms_down(struct brcms_info *wl)
 /*
 * precondition: perimeter lock is not acquired
  */
-void brcms_timer(struct brcms_timer *t)
+static void _brcms_timer(struct work_struct *work)
 {
+	struct brcms_timer *t = container_of(work, struct brcms_timer,
+					     dly_wrk.work);
+
 	spin_lock_bh(&t->wl->lock);
 
 	if (t->set) {
 		if (t->periodic) {
-			t->timer.expires = jiffies + t->ms * HZ / 1000;
 			atomic_inc(&t->wl->callbacks);
-			add_timer(&t->timer);
-			t->set = true;
-		} else
+			ieee80211_queue_delayed_work(t->wl->pub->ieee_hw,
+						     &t->dly_wrk,
+						     msecs_to_jiffies(t->ms));
+		} else {
 			t->set = false;
+		}
 
 		t->fn(t->arg);
 	}
@@ -1431,14 +1435,6 @@ void brcms_timer(struct brcms_timer *t)
 }
 
 /*
- * is called by the kernel from software irq context
- */
-static void _brcms_timer(unsigned long data)
-{
-	brcms_timer((struct brcms_timer *) data);
-}
-
-/*
  * Adds a timer to the list. Caller supplies a timer function.
  * Is called from wlc.
  *
@@ -1454,9 +1450,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 	if (!t)
 		return NULL;
 
-	init_timer(&t->timer);
-	t->timer.data = (unsigned long) t;
-	t->timer.function = _brcms_timer;
+	INIT_DELAYED_WORK(&t->dly_wrk, _brcms_timer);
 	t->wl = wl;
 	t->fn = fn;
 	t->arg = arg;
@@ -1478,22 +1472,22 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
  *
  * precondition: perimeter lock has been acquired
  */
-void brcms_add_timer(struct brcms_timer *t, uint ms,
-		     int periodic)
+void brcms_add_timer(struct brcms_timer *t, uint ms, int periodic)
 {
+	struct ieee80211_hw *hw = t->wl->pub->ieee_hw;
+
 #ifdef BCMDBG
 	if (t->set)
-		wiphy_err(t->wl->wiphy, "%s: Already set. Name: %s, per %d\n",
+		wiphy_err(hw->wiphy, "%s: Already set. Name: %s, per %d\n",
 			  __func__, t->name, periodic);
-
 #endif
 	t->ms = ms;
 	t->periodic = (bool) periodic;
 	t->set = true;
-	t->timer.expires = jiffies + ms * HZ / 1000;
 
 	atomic_inc(&t->wl->callbacks);
-	add_timer(&t->timer);
+
+	ieee80211_queue_delayed_work(hw, &t->dly_wrk, msecs_to_jiffies(ms));
 }
 
 /*
@@ -1505,7 +1499,7 @@ bool brcms_del_timer(struct brcms_timer *t)
 {
 	if (t->set) {
 		t->set = false;
-		if (!del_timer(&t->timer))
+		if (!cancel_delayed_work(&t->dly_wrk))
 			return false;
 
 		atomic_dec(&t->wl->callbacks);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 91e5f2a..177f0e4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -19,6 +19,8 @@
 
 #include <linux/timer.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
 #include "ucode_loader.h"
 /*
  * Starting index for 5G rates in the
@@ -30,14 +32,14 @@
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
 struct brcms_timer {
-	struct timer_list timer;
+	struct delayed_work dly_wrk;
 	struct brcms_info *wl;
-	void (*fn) (void *);
-	void *arg;		/* argument to fn */
+	void (*fn) (void *);	/* function called upon expiration */
+	void *arg;		/* fixed argument provided to called function */
 	uint ms;
 	bool periodic;
-	bool set;
-	struct brcms_timer *next;
+	bool set;		/* indicates if timer is active */
+	struct brcms_timer *next;	/* for freeing on unload */
 #ifdef BCMDBG
 	char *name;		/* Description of the timer */
 #endif
-- 
1.7.4.1



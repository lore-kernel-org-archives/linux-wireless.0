Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60431 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1DBXBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 19:01:04 -0400
Received: by wwa36 with SMTP id 36so5272412wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Apr 2011 16:01:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: avoid premature elp entrance
Date: Sun,  3 Apr 2011 02:01:59 +0300
Message-Id: <1301785319-18777-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The elp_work is being enqueued on wl1271_ps_elp_sleep, but doesn't get
cancelled on wl1271_ps_elp_wakeup. This might cause immediate entrance
to elp when the wl->mutex is being released, rather than using the delayed
enqueueing optimization.

Cancel elp_work on wakeup request, and add a new WL1271_FLAG_ELP_REQUESTED
flag to further synchronize the elp actions.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/ps.c     |   30 ++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index b8deada..cf1cdb5 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -43,6 +43,10 @@ void wl1271_elp_work(struct work_struct *work)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
+	/* our work might already being cancelled */
+	if (unlikely(!test_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
+		goto out;
+
 	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags) ||
 	    (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
 	     !test_bit(WL1271_FLAG_IDLE, &wl->flags)))
@@ -61,12 +65,16 @@ out:
 /* Routines to toggle sleep mode while in ELP */
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
-	if (test_bit(WL1271_FLAG_PSM, &wl->flags) ||
-	    test_bit(WL1271_FLAG_IDLE, &wl->flags)) {
-		cancel_delayed_work(&wl->elp_work);
-		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
-					     msecs_to_jiffies(ELP_ENTRY_DELAY));
-	}
+	/* we shouldn't see consequtive sleep requests */
+	if (WARN_ON(test_and_set_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
+		return;
+
+	if (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
+	    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
+		return;
+
+	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
+				     msecs_to_jiffies(ELP_ENTRY_DELAY));
 }
 
 int wl1271_ps_elp_wakeup(struct wl1271 *wl)
@@ -77,6 +85,16 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 	u32 start_time = jiffies;
 	bool pending = false;
 
+	/*
+	 * we might try waking up although we didn't go to sleep
+	 * before (e.g. on boot)
+	 */
+	if (!test_and_clear_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags))
+		return 0;
+
+	/* don't cancel_sync as it might contend for a mutex and deadlock */
+	cancel_delayed_work(&wl->elp_work);
+
 	if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
 		return 0;
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb2b79f..b760143 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -346,6 +346,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_TX_QUEUE_STOPPED,
 	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
+	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_PSM,
 	WL1271_FLAG_PSM_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
-- 
1.7.0.4


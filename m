Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46196 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2EOOJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:12 -0400
Received: by wibhj8 with SMTP id hj8so2859247wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>,
	"bartosz.markowski" <bartosz.markowski@tieto.com>
Subject: [PATCH 04/10] wlcore: fixes for connection_loss_work
Date: Tue, 15 May 2012 17:08:54 +0300
Message-Id: <1337090940-13750-4-git-send-email-arik@wizery.com> (sfid-20120515_160918_933395_0F8C5A15)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't use cancel_delayed_work_sync() from functions that take the
wl->mutex, since connection_loss_work also takes the mutex. This might
result in a deadlock. Restructure the code so the work is synchronously
canceled before taking the mutex.
Avoid a bug where we would indefinitely delay the connection loss
indication by re-queuing the connection loss work on consecutive beacon
loss events.

Cc: bartosz.markowski <bartosz.markowski@tieto.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/event.c |   15 ++++++++++++---
 drivers/net/wireless/ti/wlcore/main.c  |   10 +++++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 28e2a63..4ed83579 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -148,15 +148,24 @@ static int wl1271_event_process(struct wl1271 *wl)
 		int delay = wl->conf.conn.synch_fail_thold *
 					wl->conf.conn.bss_lose_timeout;
 		wl1271_info("Beacon loss detected.");
-		cancel_delayed_work_sync(&wl->connection_loss_work);
+
+		/*
+		 * if the work is already queued, it should take place. We
+		 * don't want to delay the connection loss indication
+		 * any more.
+		 */
 		ieee80211_queue_delayed_work(wl->hw, &wl->connection_loss_work,
-		      msecs_to_jiffies(delay));
+					     msecs_to_jiffies(delay));
 	}
 
 	if (vector & REGAINED_BSS_EVENT_ID) {
 		/* TODO: check for multi-role */
 		wl1271_info("Beacon regained.");
-		cancel_delayed_work_sync(&wl->connection_loss_work);
+		cancel_delayed_work(&wl->connection_loss_work);
+
+		/* sanity check - we can't lose and gain the beacon together */
+		WARN(vector & BSS_LOSE_EVENT_ID,
+		     "Concurrent beacon loss and gain from FW");
 	}
 
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 659634b..35f6bc1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3708,9 +3708,6 @@ sta_not_found:
 			do_join = true;
 			set_assoc = true;
 
-			/* Cancel connection_loss_work */
-			cancel_delayed_work_sync(&wl->connection_loss_work);
-
 			/*
 			 * use basic rates from AP, and determine lowest rate
 			 * to use with control frames.
@@ -3960,6 +3957,13 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed 0x%x",
 		     (int)changed);
 
+	/*
+	 * make sure to cancel pending disconnections if our association
+	 * state changed
+	 */
+	if (!is_ap && (changed & BSS_CHANGED_ASSOC))
+		cancel_delayed_work_sync(&wl->connection_loss_work);
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
-- 
1.7.9.5


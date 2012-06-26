Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41843 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab2FZUDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:16 -0400
Received: by bkcjk13 with SMTP id jk13so357837bkc.40
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:13 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 4/5] wlcore: queue recovery in case of bus errors during cmd_remove_peer
Date: Tue, 26 Jun 2012 23:02:59 +0300
Message-Id: <1340740980-22284-5-git-send-email-coelho@ti.com> (sfid-20120626_220324_781153_84412CCB)
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Following the addition of propagating errors from the bus ops
there's a need to distinguish between bus errors (including timeout)
and a legitimate timeout occuring in cmd_wait_for_event_or_timeout.
In case of real bus errors we need to queue recovery even in cases
where a timeout on a response from the FW to a command is acceptable.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 84dd808..ef13938 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -133,24 +133,27 @@ fail:
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
  */
-static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl, u32 mask)
+static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
+						u32 mask, bool *timeout)
 {
 	u32 *events_vector;
 	u32 event;
-	unsigned long timeout;
+	unsigned long timeout_time;
 	int ret = 0;
 
+	*timeout = false;
+
 	events_vector = kmalloc(sizeof(*events_vector), GFP_KERNEL | GFP_DMA);
 	if (!events_vector)
 		return -ENOMEM;
 
-	timeout = jiffies + msecs_to_jiffies(WL1271_EVENT_TIMEOUT);
+	timeout_time = jiffies + msecs_to_jiffies(WL1271_EVENT_TIMEOUT);
 
 	do {
-		if (time_after(jiffies, timeout)) {
+		if (time_after(jiffies, timeout_time)) {
 			wl1271_debug(DEBUG_CMD, "timeout waiting for event %d",
 				     (int)mask);
-			ret = -ETIMEDOUT;
+			*timeout = true;
 			goto out;
 		}
 
@@ -180,9 +183,10 @@ out:
 static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 {
 	int ret;
+	bool timeout = false;
 
-	ret = wl1271_cmd_wait_for_event_or_timeout(wl, mask);
-	if (ret != 0) {
+	ret = wl1271_cmd_wait_for_event_or_timeout(wl, mask, &timeout);
+	if (ret != 0 || timeout) {
 		wl12xx_queue_recovery_work(wl);
 		return ret;
 	}
@@ -1435,6 +1439,7 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid)
 {
 	struct wl12xx_cmd_remove_peer *cmd;
 	int ret;
+	bool timeout = false;
 
 	wl1271_debug(DEBUG_CMD, "cmd remove peer %d", (int)hlid);
 
@@ -1455,12 +1460,16 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid)
 		goto out_free;
 	}
 
+	ret = wl1271_cmd_wait_for_event_or_timeout(wl,
+					   PEER_REMOVE_COMPLETE_EVENT_ID,
+					   &timeout);
 	/*
 	 * We are ok with a timeout here. The event is sometimes not sent
-	 * due to a firmware bug.
+	 * due to a firmware bug. In case of another error (like SDIO timeout)
+	 * queue a recovery.
 	 */
-	wl1271_cmd_wait_for_event_or_timeout(wl,
-					     PEER_REMOVE_COMPLETE_EVENT_ID);
+	if (ret)
+		wl12xx_queue_recovery_work(wl);
 
 out_free:
 	kfree(cmd);
-- 
1.7.10


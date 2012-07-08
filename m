Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47109 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab2GHHXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:45 -0400
Received: by lbok6 with SMTP id k6so15107472lbo.4
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:43 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 2/8] wlcore: change the wait for event mechanism
Date: Sun,  8 Jul 2012 10:23:25 +0300
Message-Id: <1341732211-25871-3-git-send-email-coelho@ti.com> (sfid-20120708_092355_452430_30C17E68)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yoni Divinsky <yoni.divinsky@ti.com>

wlcore needs to wait for certain events for example
for roc complete event. Usually the events are received
from the FW very fast, therefore wlcore can poll with
a short delay and if after a second the event was
not received yet poll with a long (1-5 msec) delay.

This implementation is similar to the sending of
commands to the FW.

Empirically the change reduced the wait for roc event
from ~10-40msec to 100s of usecs.

[replace udelay/msleep with usleep_range - Arik]

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 087cb01..a23949c 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -39,6 +39,7 @@
 #include "hw_ops.h"
 
 #define WL1271_CMD_FAST_POLL_COUNT       50
+#define WL1271_WAIT_EVENT_FAST_POLL_COUNT 20
 
 /*
  * send command to firmware
@@ -138,6 +139,7 @@ static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 	u32 *events_vector;
 	u32 event;
 	unsigned long timeout_time;
+	u16 poll_count = 0;
 	int ret = 0;
 
 	*timeout = false;
@@ -156,7 +158,11 @@ static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 			goto out;
 		}
 
-		msleep(1);
+		poll_count++;
+		if (poll_count < WL1271_WAIT_EVENT_FAST_POLL_COUNT)
+			usleep_range(50, 51);
+		else
+			usleep_range(1000, 5000);
 
 		/* read from both event fields */
 		ret = wlcore_read(wl, wl->mbox_ptr[0], events_vector,
-- 
1.7.10


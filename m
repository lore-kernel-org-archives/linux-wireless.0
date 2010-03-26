Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24408 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0CZKyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:14 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/24] wl1271: wait for join command complete event
Date: Fri, 26 Mar 2010 12:53:20 +0200
Message-Id: <1269600813-32145-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Poll for join command completion instead of waiting blindly for 10 msecs.
There is a timeout of 100 msecs, if the command doesn't complete by then, we
return an error code.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    3 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   38 +++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    1 +
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 4195298..2c7e561 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -410,7 +410,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
-		PS_REPORT_EVENT_ID;
+		PS_REPORT_EVENT_ID |
+		JOIN_EVENT_COMPLETE_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index efd94f2..e677f97 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -34,6 +34,7 @@
 #include "wl1271_acx.h"
 #include "wl12xx_80211.h"
 #include "wl1271_cmd.h"
+#include "wl1271_event.h"
 
 /*
  * send command to firmware
@@ -248,6 +249,35 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	return ret;
 }
 
+/*
+ * Poll the mailbox event field until any of the bits in the mask is set or a
+ * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
+ */
+static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
+{
+	u32 events_vector, event;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(WL1271_EVENT_TIMEOUT);
+
+	do {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+
+		msleep(1);
+
+		/* read from both event fields */
+		wl1271_read(wl, wl->mbox_ptr[0], &events_vector,
+			    sizeof(events_vector), false);
+		event = events_vector & mask;
+		wl1271_read(wl, wl->mbox_ptr[1], &events_vector,
+			    sizeof(events_vector), false);
+		event |= events_vector & mask;
+	} while (!event);
+
+	return 0;
+}
+
 int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 {
 	static bool do_cal = true;
@@ -318,11 +348,9 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 		goto out_free;
 	}
 
-	/*
-	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
-	 * simplify locking we just sleep instead, for now
-	 */
-	msleep(10);
+	ret = wl1271_cmd_wait_for_event(wl, JOIN_EVENT_COMPLETE_ID);
+	if (ret < 0)
+		wl1271_error("cmd join event completion error");
 
 out_free:
 	kfree(join);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 6324bbf..bdd7a3d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -123,6 +123,7 @@ enum cmd_templ {
 /* unit ms */
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_MAX_SIZE  252
+#define WL1271_EVENT_TIMEOUT       100
 
 struct wl1271_cmd_header {
 	__le16 id;
-- 
1.6.3.3


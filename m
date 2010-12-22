Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0LVO2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:07 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so5082982wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:07 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 05/18] wl1271: AP mode - workaround for FW bug on station remove
Date: Wed, 22 Dec 2010 16:27:24 +0200
Message-Id: <1293028057-6212-6-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes an event indicating station removal is not sent up by
firmware. We work around this by always indicating success in when
a wait for the event timeouts.

Temporary workaround until a FW fix is introduced.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index aab1b77..0a1eb0e 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -222,7 +222,7 @@ int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
  */
-static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
+static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl, u32 mask)
 {
 	u32 events_vector, event;
 	unsigned long timeout;
@@ -231,7 +231,8 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 
 	do {
 		if (time_after(jiffies, timeout)) {
-			ieee80211_queue_work(wl->hw, &wl->recovery_work);
+			wl1271_debug(DEBUG_CMD, "timeout waiting for event %d",
+				     (int)mask);
 			return -ETIMEDOUT;
 		}
 
@@ -249,6 +250,19 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 	return 0;
 }
 
+static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
+{
+	int ret;
+
+	ret = wl1271_cmd_wait_for_event_or_timeout(wl, mask);
+	if (ret != 0) {
+		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+		return ret;
+	}
+
+	return 0;
+}
+
 int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 {
 	struct wl1271_cmd_join *join;
@@ -1108,9 +1122,11 @@ int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, STA_REMOVE_COMPLETE_EVENT_ID);
-	if (ret < 0)
-		wl1271_error("cmd remove sta event completion error");
+	/*
+	 * We are ok with a timeout here. The event is sometimes not sent
+	 * due to a firmware bug.
+	 */
+	wl1271_cmd_wait_for_event_or_timeout(wl, STA_REMOVE_COMPLETE_EVENT_ID);
 
 out_free:
 	kfree(cmd);
-- 
1.7.1


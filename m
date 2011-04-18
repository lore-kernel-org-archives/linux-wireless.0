Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52497 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1DRLP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:15:57 -0400
Received: by wwk4 with SMTP id 4so1665679wwk.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:15:56 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/10] wl12xx: schedule recovery on command timeout
Date: Mon, 18 Apr 2011 14:15:23 +0300
Message-Id: <1303125329-27214-4-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use a long timeout (2 seconds) when sending commands to the FW.
When a command times out, it means the FW is stuck, and we should
commence recovery.

This should make recovery times shorter as we'll recover on the first
timeout indication.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..8090026 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -76,7 +76,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
 			ret = -ETIMEDOUT;
-			goto out;
+			goto fail;
 		}
 
 		poll_count++;
@@ -96,14 +96,17 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	status = le16_to_cpu(cmd->status);
 	if (status != CMD_STATUS_SUCCESS) {
 		wl1271_error("command execute failure %d", status);
-		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 		ret = -EIO;
+		goto fail;
 	}
 
 	wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
 		       WL1271_ACX_INTR_CMD_COMPLETE);
+	return 0;
 
-out:
+fail:
+	WARN_ON(1);
+	ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	return ret;
 }
 
-- 
1.7.1


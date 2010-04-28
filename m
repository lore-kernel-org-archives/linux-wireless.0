Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23823 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0D1Guj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 02:50:39 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/4] wl1271: Improve command polling
Date: Wed, 28 Apr 2010 09:49:59 +0300
Message-Id: <1272437402-28801-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
References: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In testing I noticed that the wl1271 commands fall into two categories. In the
first category are "fast" commands, these mostly take only 0 or 1 polls to
complete, but occasionally upto 50 (giving a 0.5ms execution time.) In the
second category, the command completion takes well more than 0.5ms (from
1.5ms upwards.)

This patch fixes command polling such that it is optimal for the fast commands,
but also allows sleep for the longer ones.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 6b5ba8e..61fb774 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -37,7 +37,7 @@
 #include "wl1271_cmd.h"
 #include "wl1271_event.h"
 
-#define WL1271_CMD_POLL_COUNT       5
+#define WL1271_CMD_FAST_POLL_COUNT       50
 
 /*
  * send command to firmware
@@ -77,11 +77,11 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 			goto out;
 		}
 
-		udelay(10);
 		poll_count++;
-		if (poll_count == WL1271_CMD_POLL_COUNT)
-			wl1271_info("cmd polling took over %d cycles",
-				    poll_count);
+		if (poll_count < WL1271_CMD_FAST_POLL_COUNT)
+			udelay(10);
+		else
+			msleep(1);
 
 		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
-- 
1.6.3.3


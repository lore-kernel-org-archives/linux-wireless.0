Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30727 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0CZKyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:24 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Subject: [PATCH 24/24] wl1271: Fix msleep() delay while waiting for completion
Date: Fri, 26 Mar 2010 12:53:33 +0200
Message-Id: <1269600813-32145-25-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>

After last transmission, the device goes to sleep earlier
than the configured dynamic power save timeout. If timeout
is set to 400ms, device enters into sleep mode at around
330ms since from last TX.

This patch removes the msleep(1), which causes the delay
after ELP wakeup. Replaced with udelay(10), the variation
is around 7-10ms.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0cb4cbb..f11f9f4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -36,6 +36,8 @@
 #include "wl1271_cmd.h"
 #include "wl1271_event.h"
 
+#define WL1271_CMD_POLL_COUNT       5
+
 /*
  * send command to firmware
  *
@@ -52,6 +54,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	u32 intr;
 	int ret = 0;
 	u16 status;
+	u16 poll_count = 0;
 
 	cmd = buf;
 	cmd->id = cpu_to_le16(id);
@@ -73,7 +76,11 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 			goto out;
 		}
 
-		msleep(1);
+		udelay(10);
+		poll_count++;
+		if (poll_count == WL1271_CMD_POLL_COUNT)
+			wl1271_info("cmd polling took over %d cycles",
+				    poll_count);
 
 		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
-- 
1.6.3.3


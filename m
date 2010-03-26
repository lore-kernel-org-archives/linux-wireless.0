Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30670 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0CZKx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:53:58 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/24] wl1271: wait for disconnect command complete event
Date: Fri, 26 Mar 2010 12:53:21 +0200
Message-Id: <1269600813-32145-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wait for the DISCONNECT_EVENT_COMPLETE_ID event after sending a disconnect
command.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    5 +++--
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 2c7e561..7acef88 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -1,7 +1,7 @@
 /*
  * This file is part of wl1271
  *
- * Copyright (C) 2008-2009 Nokia Corporation
+ * Copyright (C) 2008-2010 Nokia Corporation
  *
  * Contact: Luciano Coelho <luciano.coelho@nokia.com>
  *
@@ -411,7 +411,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
 		PS_REPORT_EVENT_ID |
-		JOIN_EVENT_COMPLETE_ID;
+		JOIN_EVENT_COMPLETE_ID |
+		DISCONNECT_EVENT_COMPLETE_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index e677f97..0aa2422 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -1,7 +1,7 @@
 /*
  * This file is part of wl1271
  *
- * Copyright (C) 2009 Nokia Corporation
+ * Copyright (C) 2009-2010 Nokia Corporation
  *
  * Contact: Luciano Coelho <luciano.coelho@nokia.com>
  *
@@ -942,6 +942,10 @@ int wl1271_cmd_disconnect(struct wl1271 *wl)
 		goto out_free;
 	}
 
+	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
+	if (ret < 0)
+		wl1271_error("cmd disconnect event completion error");
+
 out_free:
 	kfree(cmd);
 
-- 
1.6.3.3


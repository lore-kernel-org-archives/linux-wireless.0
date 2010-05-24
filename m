Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58391 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0EXISb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:31 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/6] wl1271: Prevent dropping of TX frames in joins
Date: Mon, 24 May 2010 11:18:15 +0300
Message-Id: <1274689100-14785-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271 uses a session counter in CMD_JOIN and TX frame descriptors. This
counter is used to determine which frames to drop when the CMD_JOIN is
executed.

The driver executes CMD_JOIN multiple times upon association and sometimes
disassociation, and we don't want any frames to get lost.

Fix this by incrementing the session counter only when leaving idle (not every
CMD_JOIN as before.) Also, remove the TX flush flag from the CMD_JOIN options.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    6 ------
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 19393e2..5a3ff93 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -329,12 +329,6 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->channel = wl->channel;
 	join->ssid_len = wl->ssid_len;
 	memcpy(join->ssid, wl->ssid, wl->ssid_len);
-	join->ctrl = WL1271_JOIN_CMD_CTRL_TX_FLUSH;
-
-	/* increment the session counter */
-	wl->session_counter++;
-	if (wl->session_counter >= SESSION_COUNTER_MAX)
-		wl->session_counter = 0;
 
 	join->ctrl |= wl->session_counter << WL1271_JOIN_CMD_TX_SESSION_OFFSET;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 933e432..1407cdb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1128,6 +1128,11 @@ static int wl1271_dummy_join(struct wl1271 *wl)
 
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
+	/* increment the session counter */
+	wl->session_counter++;
+	if (wl->session_counter >= SESSION_COUNTER_MAX)
+		wl->session_counter = 0;
+
 	/* pass through frames from all BSS */
 	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30665 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0CZKx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:53:57 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/24] wl1271: Fix memory leak in cmd_data_path
Date: Fri, 26 Mar 2010 12:53:17 +0200
Message-Id: <1269600813-32145-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Fix a trivial memory leak in cmd_data_path.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index dbed060..efd94f2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -454,7 +454,7 @@ int wl1271_cmd_data_path(struct wl1271 *wl, bool enable)
 	if (ret < 0) {
 		wl1271_error("tx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", cmd->channel);
-		return ret;
+		goto out;
 	}
 
 	wl1271_debug(DEBUG_BOOT, "tx %s cmd channel %d",
-- 
1.6.3.3


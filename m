Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65347 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab3EGMlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:41:23 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so563572wgh.12
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 05:41:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] wl12xx/wl18xx: scan all 5ghz channels
Date: Tue,  7 May 2013 15:41:09 +0300
Message-Id: <1367930469-29826-3-git-send-email-eliad@wizery.com> (sfid-20130507_144126_898149_987D3867)
In-Reply-To: <1367930469-29826-1-git-send-email-eliad@wizery.com>
References: <1367930469-29826-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to a typo, the current code copies only sizeof(cmd->channels_2)
bytes, which is smaller than the correct sizeof(cmd->channels_5)
size, resulting in a partial scan (some channels are skipped).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/scan.c | 2 +-
 drivers/net/wireless/ti/wl18xx/scan.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index affdb3e..4a0bbb1 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -310,7 +310,7 @@ static void wl12xx_adjust_channels(struct wl1271_cmd_sched_scan_config *cmd,
 	memcpy(cmd->channels_2, cmd_channels->channels_2,
 	       sizeof(cmd->channels_2));
 	memcpy(cmd->channels_5, cmd_channels->channels_5,
-	       sizeof(cmd->channels_2));
+	       sizeof(cmd->channels_5));
 	/* channels_4 are not supported, so no need to copy them */
 }
 
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index 09d9445..2b642f8 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -34,7 +34,7 @@ static void wl18xx_adjust_channels(struct wl18xx_cmd_scan_params *cmd,
 	memcpy(cmd->channels_2, cmd_channels->channels_2,
 	       sizeof(cmd->channels_2));
 	memcpy(cmd->channels_5, cmd_channels->channels_5,
-	       sizeof(cmd->channels_2));
+	       sizeof(cmd->channels_5));
 	/* channels_4 are not supported, so no need to copy them */
 }
 
-- 
1.8.1.2


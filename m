Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19201 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143Ab0HMJrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 05:47:51 -0400
From: ext-yuri.kululin@nokia.com
To: kvalo@adurom.com
Cc: linux-wireless@vger.kernel.org, ameya.palande@nokia.com,
	ext-yuri.kululin@nokia.com
Subject: [PATCH 1/1] wl1251: fix trigger scan timeout usage
Date: Fri, 13 Aug 2010 13:46:12 +0400
Message-Id: <8ca8a9b93496d16bc8b5956c3a7976c08b95282c.1281691901.git.ext-yuri.kululin@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yuri Kululin <ext-yuri.kululin@nokia.com>

Use appropriate command (CMD_TRIGGER_SCAN_TO) instead of scan command
(CMD_SCAN) to configure trigger scan timeout.

This was broken in commit 3a98c30f3e8bb1f32b5bcb74a39647b3670de275.

Cc: stable@kernel.org
Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index a37b30c..ce3722f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -484,7 +484,7 @@ int wl1251_cmd_trigger_scan_to(struct wl1251 *wl, u32 timeout)
 
 	cmd->timeout = timeout;
 
-	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
+	ret = wl1251_cmd_send(wl, CMD_TRIGGER_SCAN_TO, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl1251_error("cmd trigger scan to failed: %d", ret);
 		goto out;
-- 
1.7.1.1


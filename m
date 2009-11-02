Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16450 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZKBSWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:24 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 5/6] wl1271: Correct endianness-handling of command status
Date: Mon,  2 Nov 2009 20:22:12 +0200
Message-Id: <1257186133-18367-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
References: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Correct the endianness-handling of the firmware command result status handling
code.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 46e5ea4..8acee5c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -48,6 +48,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	unsigned long timeout;
 	u32 intr;
 	int ret = 0;
+	u16 status;
 
 	cmd = buf;
 	cmd->id = cpu_to_le16(id);
@@ -78,8 +79,9 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	wl1271_spi_read(wl, wl->cmd_box_addr, cmd,
 			sizeof(struct wl1271_cmd_header), false);
 
-	if (cmd->status != CMD_STATUS_SUCCESS) {
-		wl1271_error("command execute failure %d", cmd->status);
+	status = le16_to_cpu(cmd->status);
+	if (status != CMD_STATUS_SUCCESS) {
+		wl1271_error("command execute failure %d", status);
 		ret = -EIO;
 	}
 
-- 
1.5.6.5


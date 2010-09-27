Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17077 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab0I0IjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:17 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8d5dM026506
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:39:16 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 02/25] wl1271: Implement CMD_SET_STA_STATE to indicate connection completion to FW
Date: Mon, 27 Sep 2010 11:37:26 +0300
Message-Id: <1285576669-8070-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Implement the command function to send CMD_SET_STA_STATE to the firmware. This
is used to indicate that association (and the related EAP negotiation) are
complete.

This is used to tune WLAN-BT coexistense priority towards BT, improving BT
A2DP and SCO performance.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   10 ++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index ce503dd..a338b1c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -746,3 +746,31 @@ out_free:
 out:
 	return ret;
 }
+
+int wl1271_cmd_set_sta_state(struct wl1271 *wl)
+{
+	struct wl1271_cmd_set_sta_state *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd set sta state");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->state = WL1271_CMD_STA_STATE_CONNECTED;
+
+	ret = wl1271_cmd_send(wl, CMD_SET_STA_STATE, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send set STA state command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index af577ee..ce0476c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -55,6 +55,7 @@ int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16);
 int wl1271_cmd_disconnect(struct wl1271 *wl);
+int wl1271_cmd_set_sta_state(struct wl1271 *wl);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -469,4 +470,13 @@ struct wl1271_cmd_disconnect {
 	u8  padding;
 } __packed;
 
+#define WL1271_CMD_STA_STATE_CONNECTED  1
+
+struct wl1271_cmd_set_sta_state {
+	struct wl1271_cmd_header header;
+
+	u8 state;
+	u8 padding[3];
+} __attribute__ ((packed));
+
 #endif /* __WL1271_CMD_H__ */
-- 
1.6.3.3


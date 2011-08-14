Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1HNKRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:36 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 17/40] wl12xx: add ROC/CROC commands
Date: Sun, 14 Aug 2011 13:17:16 +0300
Message-Id: <1313317059-16567-18-git-send-email-eliad@wizery.com> (sfid-20110814_121742_171966_F1E601A8)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add structs and functions to support the ROC/CROC commands.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: bail out on invalid band

 drivers/net/wireless/wl12xx/cmd.c |   73 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h |   16 ++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e29343e..1b04102 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1478,6 +1478,79 @@ int wl12xx_cmd_stop_fwlog(struct wl1271 *wl)
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
+
+static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
+{
+	struct wl12xx_cmd_roc *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, role_id);
+
+	if (WARN_ON(role_id == WL12XX_INVALID_ROLE_ID))
+		return -EINVAL;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = role_id;
+	cmd->channel = wl->channel;
+	switch (wl->band) {
+	case IEEE80211_BAND_2GHZ:
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		cmd->band = RADIO_BAND_5GHZ;
+		break;
+	default:
+		wl1271_error("roc - unknown band: %d", (int)wl->band);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+
+	ret = wl1271_cmd_send(wl, CMD_REMAIN_ON_CHANNEL, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send ROC command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+static int wl12xx_cmd_croc(struct wl1271 *wl, u8 role_id)
+{
+	struct wl12xx_cmd_croc *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd croc (%d)", role_id);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	cmd->role_id = role_id;
+
+	ret = wl1271_cmd_send(wl, CMD_CANCEL_REMAIN_ON_CHANNEL, cmd,
+			      sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send ROC command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 6950759..80b02ed 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -562,12 +562,28 @@ struct wl12xx_cmd_set_peer_state {
 
 	u8 hlid;
 	u8 state;
 	u8 padding[2];
 } __packed;
 
+struct wl12xx_cmd_roc {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 channel;
+	u8 band;
+	u8 padding;
+};
+
+struct wl12xx_cmd_croc {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 padding[3];
+};
+
 enum wl12xx_ssid_type {
 	WL12XX_SSID_TYPE_PUBLIC = 0,
 	WL12XX_SSID_TYPE_HIDDEN = 1,
 	WL12XX_SSID_TYPE_ANY = 2,
 };
 
-- 
1.7.6.401.g6a319


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1HIJOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 17/40] wl12xx: add ROC/CROC commands
Date: Tue,  9 Aug 2011 12:13:30 +0300
Message-Id: <1312881233-9366-18-git-send-email-eliad@wizery.com> (sfid-20110809_111456_472317_599A547B)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add structs and functions to support the ROC/CROC commands.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   72 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h |    9 +++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 94942c1..3091351 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1478,6 +1478,78 @@ int wl12xx_cmd_stop_fwlog(struct wl1271 *wl)
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
+
+static int wl1271_cmd_roc(struct wl1271 *wl, u8 role_id)
+{
+	struct wl1271_cmd_roc *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, wl->band);
+
+	if (WARN_ON(role_id == WL1271_INVALID_ROLE_ID))
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
+		wl1271_warning("roc - unknown band: %d", (int)wl->band);
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
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
+static int wl1271_cmd_croc(struct wl1271 *wl, u8 role_id)
+{
+	struct wl1271_cmd_header *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd croc");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
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
index 3734244..0ba4537 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -570,12 +570,21 @@ struct wl1271_cmd_set_peer_state {
 
 	u8 hlid;
 	u8 state;
 	u8 padding[2];
 } __packed;
 
+struct wl1271_cmd_roc {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 channel;
+	u8 band;
+	u8 padding;
+};
+
 enum wl1271_ssid_type {
 	WL1271_SSID_TYPE_PUBLIC = 0,
 	WL1271_SSID_TYPE_HIDDEN = 1,
 	WL1271_SSID_TYPE_ANY = 2,
 };
 
-- 
1.7.6.401.g6a319


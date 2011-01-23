Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59784 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1AWVDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 16:03:18 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so3406598fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 13:03:17 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 5/6] wl12xx: AP mode - support hidden SSID
Date: Sun, 23 Jan 2011 23:02:58 +0200
Message-Id: <1295816579-28925-6-git-send-email-arik@wizery.com>
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Detect whether our SSID is hidden by comparing beacon data with
the SSID in bss_conf.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e28d9ca..7a6f39e 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -966,16 +966,6 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd start bss");
 
-	/*
-	 * FIXME: We currently do not support hidden SSID. The real SSID
-	 * should be fetched from mac80211 first.
-	 */
-	if (wl->ssid_len == 0) {
-		wl1271_warning("Hidden SSID currently not supported for AP");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
@@ -993,9 +983,16 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 	cmd->dtim_interval = bss_conf->dtim_period;
 	cmd->beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	cmd->channel = wl->channel;
-	cmd->ssid_len = wl->ssid_len;
-	cmd->ssid_type = SSID_TYPE_PUBLIC;
-	memcpy(cmd->ssid, wl->ssid, wl->ssid_len);
+
+	/* We use a visible SSID if the beacon SSID matches bss_conf */
+	if (wl->ssid_len > 0 && wl->ssid_len == bss_conf->ssid_len &&
+	    !memcmp(wl->ssid, bss_conf->ssid, wl->ssid_len))
+		cmd->ssid_type = SSID_TYPE_PUBLIC;
+	else
+		cmd->ssid_type = SSID_TYPE_HIDDEN;
+
+	cmd->ssid_len = bss_conf->ssid_len;
+	memcpy(cmd->ssid, bss_conf->ssid, bss_conf->ssid_len);
 
 	switch (wl->band) {
 	case IEEE80211_BAND_2GHZ:
-- 
1.7.1


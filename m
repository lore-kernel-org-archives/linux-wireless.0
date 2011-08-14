Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1HNKRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:44 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 21/40] wl12xx: fix session counter
Date: Sun, 14 Aug 2011 13:17:20 +0300
Message-Id: <1313317059-16567-22-git-send-email-eliad@wizery.com> (sfid-20110814_121748_380013_5FA67601)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Increment the session counter on every
wl12xx_cmd_role_start_sta() command.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: fix commit msg

 drivers/net/wireless/wl12xx/cmd.c  |   12 +++++++++++-
 drivers/net/wireless/wl12xx/main.c |    6 +-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index c620a9d..7c5d738 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -455,12 +455,22 @@ static void wl12xx_free_link(struct wl1271 *wl, u8 *hlid)
 		return;
 
 	__clear_bit(*hlid, wl->links_map);
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
+static int wl12xx_get_new_session_id(struct wl1271 *wl)
+{
+	if (wl->session_counter >= SESSION_COUNTER_MAX)
+		wl->session_counter = 0;
+
+	wl->session_counter++;
+
+	return wl->session_counter;
+}
+
 int wl12xx_cmd_role_start_dev(struct wl1271 *wl)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -577,13 +587,13 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl)
 	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
 		if (ret)
 			goto out_free;
 	}
 	cmd->sta.hlid = wl->sta_hlid;
-	cmd->sta.session = wl->session_counter;
+	cmd->sta.session = wl12xx_get_new_session_id(wl);
 	cmd->sta.remote_rates = cpu_to_le32(wl->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
 		     wl->basic_rate_set, wl->rate_set);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1774a66..157c462 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2184,17 +2184,12 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
 			ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			goto out;
 		set_bit(WL1271_FLAG_IDLE, &wl->flags);
 	} else {
-		/* increment the session counter */
-		wl->session_counter++;
-		if (wl->session_counter >= SESSION_COUNTER_MAX)
-			wl->session_counter = 0;
-
 		/* The current firmware only supports sched_scan in idle */
 		if (wl->sched_scanning) {
 			wl1271_scan_sched_scan_stop(wl);
 			ieee80211_sched_scan_stopped(wl->hw);
 		}
 
@@ -4450,12 +4445,13 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_last_seq_lsb = 0;
 	wl->role_id = WL12XX_INVALID_ROLE_ID;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
+	wl->session_counter = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
 	/* The system link is always allocated */
-- 
1.7.6.401.g6a319


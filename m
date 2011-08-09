Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1HIJOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:11 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 21/40] wl12xx: fix session counter
Date: Tue,  9 Aug 2011 12:13:34 +0300
Message-Id: <1312881233-9366-22-git-send-email-eliad@wizery.com> (sfid-20110809_111540_082462_B602C5CC)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Increment the session counter on every join command.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   12 +++++++++++-
 drivers/net/wireless/wl12xx/main.c |    1 +
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 918c46b..3bbee10 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -455,12 +455,22 @@ static void wl1271_free_link(struct wl1271 *wl, u8 *hlid)
 		return;
 
 	__clear_bit(*hlid, wl->links_map);
 	*hlid = WL1271_INVALID_LINK_ID;
 }
 
+static int wl1271_get_new_session_id(struct wl1271 *wl)
+{
+	if (wl->session_counter >= SESSION_COUNTER_MAX)
+		wl->session_counter = 0;
+
+	wl->session_counter++;
+
+	return wl->session_counter;
+}
+
 int wl1271_cmd_role_start_dev(struct wl1271 *wl)
 {
 	struct wl1271_cmd_role_start *cmd;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -577,13 +587,13 @@ int wl1271_cmd_role_start_sta(struct wl1271 *wl)
 	if (wl->sta_hlid == WL1271_INVALID_LINK_ID) {
 		ret = wl1271_allocate_link(wl, &wl->sta_hlid);
 		if (ret)
 			goto out_free;
 	}
 	cmd->sta.hlid = wl->sta_hlid;
-	cmd->sta.session = wl->session_counter;
+	cmd->sta.session = wl1271_get_new_session_id(wl);
 	cmd->sta.remote_rates = cpu_to_le32(wl->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
 		     wl->basic_rate_set, wl->rate_set);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9fed917..ea4e89f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4414,12 +4414,13 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_last_seq_lsb = 0;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
 	wl->system_hlid = WL1271_SYSTEM_HLID;
 	wl->sta_hlid = WL1271_INVALID_LINK_ID;
 	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
 	wl->dev_hlid = WL1271_INVALID_LINK_ID;
+	wl->session_counter = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
 	memset(wl->links_map, 0, sizeof(wl->links_map));
-- 
1.7.6.401.g6a319


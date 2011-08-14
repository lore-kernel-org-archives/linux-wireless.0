Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1HNKRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:49 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4061056wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:49 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 24/40] wl12xx: call wl12xx_cmd_set_peer_state() in AP mode
Date: Sun, 14 Aug 2011 13:17:23 +0300
Message-Id: <1313317059-16567-25-git-send-email-eliad@wizery.com> (sfid-20110814_121754_618849_09D3FB11)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After adding a station, call wl12xx_cmd_set_peer_state().
This is required for 11n support.

Change wl12xx_cmd_set_peer_state() prototype to get hlid
as param.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |    6 +++---
 drivers/net/wireless/wl12xx/cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/main.c |    6 +++++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 025fb14..d655e62 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1318,26 +1318,26 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 
 out:
 	kfree(cmd);
 	return ret;
 }
 
-int wl12xx_cmd_set_peer_state(struct wl1271 *wl)
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid)
 {
 	struct wl12xx_cmd_set_peer_state *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd set peer state (hlid=%d)", wl->sta_hlid);
+	wl1271_debug(DEBUG_CMD, "cmd set peer state (hlid=%d)", hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	cmd->hlid = wl->sta_hlid;
+	cmd->hlid = hlid;
 	cmd->state = WL1271_CMD_STA_STATE_CONNECTED;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PEER_STATE, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to send set peer state command");
 		goto out_free;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 8b32a57..740d27e 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -67,13 +67,13 @@ int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid);
 int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			   u8 key_size, const u8 *key, const u8 *addr,
 			   u32 tx_seq_32, u16 tx_seq_16);
 int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
-int wl12xx_cmd_set_peer_state(struct wl1271 *wl);
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid);
 int wl12xx_roc(struct wl1271 *wl, u8 role_id);
 int wl12xx_croc(struct wl1271 *wl, u8 role_id);
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
 int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bf9b27d..9b0df66 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -392,13 +392,13 @@ static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 	if (operstate != IF_OPER_UP)
 		return 0;
 
 	if (test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags))
 		return 0;
 
-	ret = wl12xx_cmd_set_peer_state(wl);
+	ret = wl12xx_cmd_set_peer_state(wl, wl->sta_hlid);
 	if (ret < 0)
 		return ret;
 
 	wl12xx_croc(wl, wl->role_id);
 
 	wl1271_info("Association completed.");
@@ -3673,12 +3673,16 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 		goto out_free_sta;
 
 	ret = wl12xx_cmd_add_peer(wl, sta, hlid);
 	if (ret < 0)
 		goto out_sleep;
 
+	ret = wl12xx_cmd_set_peer_state(wl, hlid);
+	if (ret < 0)
+		goto out_sleep;
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out_free_sta:
 	if (ret < 0)
 		wl1271_free_sta(wl, hlid);
-- 
1.7.6.401.g6a319


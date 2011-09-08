Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50035 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359Ab1IHKBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 06:01:37 -0400
Received: by mail-ww0-f46.google.com with SMTP id 7so409808wwg.27
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 03:01:35 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Shahar Levi <shahar_levi@ti.com>
Subject: [PATCH] wl12xx: Add support for HW channel switch
Date: Thu,  8 Sep 2011 13:01:33 +0300
Message-Id: <1315476093-27583-1-git-send-email-shahar_levi@ti.com> (sfid-20110908_120140_998671_4F3083F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WL12xx FW supports HW channel switch mechanism.
Add HW channel switch support via channel_switch ops.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- That patches have a runtime dependency on commit
 "[PATCH] mac80211: Update device channel in case of HW channel
 switch supported"

 drivers/net/wireless/wl12xx/boot.c   |    3 +-
 drivers/net/wireless/wl12xx/cmd.c    |   58 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h    |   20 ++++++++++++
 drivers/net/wireless/wl12xx/event.c  |   15 +++++++++
 drivers/net/wireless/wl12xx/main.c   |   40 +++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 6 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 6d5664b..9b40027 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -503,7 +503,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
 		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
 		INACTIVE_STA_EVENT_ID |
-		MAX_TX_RETRY_EVENT_ID;
+		MAX_TX_RETRY_EVENT_ID |
+		CHANNEL_SWITCH_COMPLETE_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 817bc18..a94bb3a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1688,3 +1688,61 @@ int wl12xx_croc(struct wl1271 *wl, u8 role_id)
 out:
 	return ret;
 }
+
+int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct ieee80211_channel_switch *ch_switch)
+{
+	struct wl12xx_cmd_channel_switch *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "cmd channel switch");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->channel = ch_switch->channel->hw_value;
+	cmd->switch_time = ch_switch->count;
+	cmd->tx_suspend = ch_switch->block_tx;
+	cmd->flush = 0;
+
+	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send channel switch command");
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
+int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_stop_channel_switch *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "cmd stop channel switch");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_CHANNEL_SWICTH, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to stop channel switch command");
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
index 22c2f37..8eff809 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -79,6 +79,9 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
+int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct ieee80211_channel_switch *ch_switch);
+int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -670,4 +673,21 @@ struct wl12xx_cmd_stop_fwlog {
 	struct wl1271_cmd_header header;
 } __packed;
 
+struct wl12xx_cmd_channel_switch {
+	struct wl1271_cmd_header header;
+
+	/* The new serving channel */
+	u8 channel;
+	/* Relative time of the serving channel switch in TBTT units */
+	u8 switch_time;
+	/* 1: Suspend TX till switch time; 0: Do not suspend TX */
+	u8 tx_suspend;
+	/* 1: Flush TX at switch time; 0: Do not flush */
+	u8 flush;
+} __packed;
+
+struct wl12xx_cmd_stop_channel_switch {
+	struct wl1271_cmd_header header;
+} __packed;
+
 #endif /* __WL1271_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 0bd7b02..d173971 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -291,6 +291,21 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_stop_ba_event(wl, mbox->rx_ba_allowed);
 	}
 
+	if ((vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID) && !is_ap) {
+		wl1271_debug(DEBUG_EVENT, "CHANNEL_SWITCH_COMPLETE_EVENT_ID. "
+					  "status = 0x%x",
+					  mbox->channel_switch_status);
+		/*
+		 * That event uses for two cases:
+		 * 1) channel switch complete with status=0
+		 * 2) channel switch failed status=1
+		 */
+		if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags) &&
+		    (wl->vif))
+			ieee80211_chswitch_done(wl->vif,
+				mbox->channel_switch_status ? false : true);
+	}
+
 	if ((vector & DUMMY_PACKET_EVENT_ID)) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
 		if (wl->vif)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..cfdb719 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2183,6 +2183,11 @@ static int wl1271_unjoin(struct wl1271 *wl)
 {
 	int ret;
 
+	if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags)) {
+		wl12xx_cmd_stop_channel_switch(wl);
+		ieee80211_chswitch_done(wl->vif, false);
+	}
+
 	/* to stop listening to a channel, we disconnect */
 	ret = wl12xx_cmd_role_stop_sta(wl);
 	if (ret < 0)
@@ -3950,6 +3955,40 @@ out:
 	return ret;
 }
 
+static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
+				     struct ieee80211_channel_switch *ch_switch)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		mutex_unlock(&wl->mutex);
+		ieee80211_chswitch_done(wl->vif, false);
+		return;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* send all pending packets */
+	wl1271_tx_work_locked(wl);
+
+	ret = wl12xx_cmd_channel_switch(wl, ch_switch);
+
+	if (!ret)
+		set_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -4231,6 +4270,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.sta_remove = wl1271_op_sta_remove,
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
+	.channel_switch = wl12xx_op_channel_switch,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb2753c..8f9cb95 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -348,6 +348,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RX_STREAMING_STARTED,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
+	WL1271_FLAG_CS_PROGRESS,
 };
 
 struct wl1271_link {
-- 
1.7.1


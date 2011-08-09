Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1HIJNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:51 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/40] wl12xx: add device role commands
Date: Tue,  9 Aug 2011 12:13:23 +0300
Message-Id: <1312881233-9366-11-git-send-email-eliad@wizery.com> (sfid-20110809_111356_594154_1DC608F9)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device role is a special role used for rx and tx frames
prior to association (as the STA role can get packets only
from its associated bssid)

Since this role is required for the sta association process,
we enable it when a new sta interface is created.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   91 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |   15 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 3 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 99d81b6..94942c1 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -455,12 +455,103 @@ static void wl1271_free_link(struct wl1271 *wl, u8 *hlid)
 		return;
 
 	__clear_bit(*hlid, wl->links_map);
 	*hlid = WL1271_INVALID_LINK_ID;
 }
 
+int wl1271_cmd_role_start_dev(struct wl1271 *wl)
+{
+	struct wl1271_cmd_role_start *cmd;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wl->dev_role_id);
+
+	cmd->role_id = wl->dev_role_id;
+	if (wl->band == IEEE80211_BAND_5GHZ)
+		cmd->band |= WL1271_BAND_5GHZ;
+	cmd->channel = wl->channel;
+
+	if (wl->dev_hlid == WL1271_INVALID_LINK_ID) {
+		ret = wl1271_allocate_link(wl, &wl->dev_hlid);
+		if (ret)
+			goto out_free;
+	}
+	cmd->device.hlid = wl->dev_hlid;
+	cmd->device.session = wl->session_counter;
+
+	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d",
+		     cmd->role_id, cmd->device.hlid, cmd->device.session);
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role enable");
+		goto err_hlid;
+	}
+
+	goto out_free;
+
+err_hlid:
+	/* clear links on error */
+	__clear_bit(wl->dev_hlid, wl->links_map);
+	wl->dev_hlid = WL1271_INVALID_LINK_ID;
+
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+int wl1271_cmd_role_stop_dev(struct wl1271 *wl)
+{
+	struct wl1271_cmd_role_stop *cmd;
+	int ret;
+
+	if (WARN_ON(wl->dev_hlid == WL1271_INVALID_LINK_ID))
+		return -EINVAL;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd role stop dev");
+
+	cmd->role_id = wl->dev_role_id;
+	cmd->disc_type = WL1271_DISC_IMMEDIATE;
+	cmd->reason = cpu_to_le16(1); /* STATUS_UNSPECIFIED */
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role stop");
+		goto out_free;
+	}
+
+	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
+	if (ret < 0) {
+		wl1271_error("cmd role stop dev event completion error");
+		goto out_free;
+	}
+
+	wl1271_free_link(wl, &wl->dev_hlid);
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
 int wl1271_cmd_role_start_sta(struct wl1271 *wl)
 {
 	struct wl1271_cmd_role_start *cmd;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ba0470f..d254f2b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1851,12 +1851,20 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			goto power_off;
 
 		ret = wl1271_boot(wl);
 		if (ret < 0)
 			goto power_off;
 
+		if (wl->bss_type == BSS_TYPE_STA_BSS) {
+			ret = wl1271_cmd_role_enable(wl,
+							 WL1271_ROLE_DEVICE,
+							 &wl->dev_role_id);
+			if (ret < 0)
+				goto irq_disable;
+		}
+
 		ret = wl1271_cmd_role_enable(wl, wl1271_get_role_type(wl),
 					     &wl->role_id);
 		if (ret < 0)
 			goto irq_disable;
 
 		ret = wl1271_hw_init(wl);
@@ -1955,18 +1963,21 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 			/*
 			 * do nothing. we are going to power off the chip
 			 * anyway. handle this case when we'll really
 			 * support multi-role...
 			 */
 		}
+		if (wl->bss_type == BSS_TYPE_STA_BSS)
+			wl1271_cmd_role_disable(wl, &wl->dev_role_id);
 		wl1271_cmd_role_disable(wl, &wl->role_id);
 
 		wl1271_ps_elp_sleep(wl);
 	}
 
 	wl->sta_hlid = WL1271_INVALID_LINK_ID;
+	wl->dev_hlid = WL1271_INVALID_LINK_ID;
 
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
@@ -2011,12 +2022,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
+	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 
 	/*
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
@@ -4353,13 +4365,14 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
 	wl->tx_security_seq = 0;
 	wl->tx_security_last_seq_lsb = 0;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
 	wl->sta_hlid = WL1271_INVALID_LINK_ID;
-
+	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
+	wl->dev_hlid = WL1271_INVALID_LINK_ID;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index cc60da6..b47cd06 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -391,12 +391,13 @@ struct wl1271 {
 	u8 bss_type;
 	u8 set_bss_type;
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 ssid_len;
 	int channel;
 	u8 role_id;
+	u8 dev_role_id;
 	u8 sta_hlid;
 	u8 dev_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL1271_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL1271_MAX_ROLES)];
 
-- 
1.7.6.401.g6a319


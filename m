Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47781 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2KVTFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:05:48 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3318461eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:05:47 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/13] wlcore: save session_id per-link
Date: Thu, 22 Nov 2012 14:05:25 +0200
Message-Id: <1353585928-28666-11-git-send-email-eliad@wizery.com> (sfid-20121122_200604_722620_EBFD28F0)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new session_id is generated on link allocation.
it is saved in a global array and used later, on tx.

The new fw api adds new bcast/global_session_id
fields to start_role(ap) command, and a new session_id
field to add_peer command. align the driver with it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |   30 ++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/cmd.h      |    6 +++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 -
 drivers/net/wireless/ti/wlcore/main.c     |    1 +
 drivers/net/wireless/ti/wlcore/tx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 --
 7 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index b2ebe39..1735a53 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -266,6 +266,16 @@ out:
 	return ret;
 }
 
+static int wlcore_get_new_session_id(struct wl1271 *wl, u8 hlid)
+{
+	if (wl->session_ids[hlid] >= SESSION_COUNTER_MAX)
+		wl->session_ids[hlid] = 0;
+
+	wl->session_ids[hlid]++;
+
+	return wl->session_ids[hlid];
+}
+
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 {
 	unsigned long flags;
@@ -273,6 +283,8 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	if (link >= WL12XX_MAX_LINKS)
 		return -EBUSY;
 
+	wl->session_ids[link] = wlcore_get_new_session_id(wl, link);
+
 	/* these bits are used by op_tx */
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	__set_bit(link, wl->links_map);
@@ -304,17 +316,6 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
-static int wl12xx_get_new_session_id(struct wl1271 *wl,
-				     struct wl12xx_vif *wlvif)
-{
-	if (wlvif->session_counter >= SESSION_COUNTER_MAX)
-		wlvif->session_counter = 0;
-
-	wlvif->session_counter++;
-
-	return wlvif->session_counter;
-}
-
 static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
 {
 	switch (nl_channel_type) {
@@ -359,7 +360,7 @@ static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 			goto out_free;
 	}
 	cmd->device.hlid = wlvif->dev_hlid;
-	cmd->device.session = wl12xx_get_new_session_id(wl, wlvif);
+	cmd->device.session = wl->session_ids[wlvif->dev_hlid];
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d",
 		     cmd->role_id, cmd->device.hlid, cmd->device.session);
@@ -460,7 +461,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			goto out_free;
 	}
 	cmd->sta.hlid = wlvif->sta.hlid;
-	cmd->sta.session = wl12xx_get_new_session_id(wl, wlvif);
+	cmd->sta.session = wl->session_ids[wlvif->sta.hlid];
 	/*
 	 * We don't have the correct remote rates in this stage, and there
 	 * is no way to update them later, so use our supported rates instead.
@@ -564,6 +565,8 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
 	cmd->ap.global_hlid = wlvif->ap.global_hlid;
 	cmd->ap.broadcast_hlid = wlvif->ap.bcast_hlid;
+	cmd->ap.global_session_id = wl->session_ids[wlvif->ap.global_hlid];
+	cmd->ap.bcast_session_id = wl->session_ids[wlvif->ap.bcast_hlid];
 	cmd->ap.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ap.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
@@ -1419,6 +1422,7 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	cmd->hlid = hlid;
 	cmd->sp_len = sta->max_sp;
 	cmd->wmm = sta->wme ? 1 : 0;
+	cmd->session_id = wl->session_ids[hlid];
 
 	for (i = 0; i < NUM_ACCESS_CATEGORIES_COPY; i++)
 		if (sta->wme && (sta->uapsd_queues & BIT(i)))
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 2070a10..c9f8268 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -362,7 +362,9 @@ struct wl12xx_cmd_role_start {
 			 */
 			u8 wmm;
 
-			u8 padding_1[3];
+			u8 bcast_session_id;
+			u8 global_session_id;
+			u8 padding_1[1];
 		} __packed ap;
 	};
 } __packed;
@@ -582,7 +584,7 @@ struct wl12xx_cmd_add_peer {
 	u8 bss_index;
 	u8 sp_len;
 	u8 wmm;
-	u8 padding1;
+	u8 session_id;
 } __packed;
 
 struct wl12xx_cmd_remove_peer {
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index c86bb00..f0f88e6 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -589,7 +589,6 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		VIF_STATE_PRINT_INT(beacon_int);
 		VIF_STATE_PRINT_INT(default_key);
 		VIF_STATE_PRINT_INT(aid);
-		VIF_STATE_PRINT_INT(session_counter);
 		VIF_STATE_PRINT_INT(psm_entry_retry);
 		VIF_STATE_PRINT_INT(power_level);
 		VIF_STATE_PRINT_INT(rssi_thold);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5924309..d53bb8b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1871,6 +1871,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
+	memset(wl->session_ids, 0, sizeof(wl->session_ids));
 	wl->active_sta_count = 0;
 
 	/* The system link is always allocated */
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 2844f30..68f73f9 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -294,7 +294,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
 	} else if (wlvif) {
 		/* configure the tx attributes */
-		tx_attr = wlvif->session_counter <<
+		tx_attr = wl->session_ids[hlid] <<
 			  TX_HW_ATTR_OFST_SESSION_COUNTER;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index d47eb6c..e9254b7 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -215,6 +215,8 @@ struct wl1271 {
 	unsigned long klv_templates_map[
 			BITS_TO_LONGS(WLCORE_MAX_KLV_TEMPLATES)];
 
+	u8 session_ids[WL12XX_MAX_LINKS];
+
 	struct list_head wlvif_list;
 
 	u8 sta_count;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 8478bbc..6be1e8e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -396,9 +396,6 @@ struct wl12xx_vif {
 	/* Our association ID */
 	u16 aid;
 
-	/* Session counter for the chipset */
-	int session_counter;
-
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
 
-- 
1.7.6.401.g6a319


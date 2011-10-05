Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241Ab1JEJ4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:14 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:13 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/29] wl12xx: move session_counter into wlvif
Date: Wed,  5 Oct 2011 11:55:55 +0200
Message-Id: <1317808566-18857-19-git-send-email-eliad@wizery.com> (sfid-20111005_115619_047054_2A5D0B54)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move session_counter into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |   15 ++++++++-------
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/main.c    |    2 --
 drivers/net/wireless/wl12xx/tx.c      |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx.h  |    9 +++++----
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e6e3717..c827759 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -454,14 +454,15 @@ static void wl12xx_free_link(struct wl1271 *wl, u8 *hlid)
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
-static int wl12xx_get_new_session_id(struct wl1271 *wl)
+static int wl12xx_get_new_session_id(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif)
 {
-	if (wl->session_counter >= SESSION_COUNTER_MAX)
-		wl->session_counter = 0;
+	if (wlvif->session_counter >= SESSION_COUNTER_MAX)
+		wlvif->session_counter = 0;
 
-	wl->session_counter++;
+	wlvif->session_counter++;
 
-	return wl->session_counter;
+	return wlvif->session_counter;
 }
 
 int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
@@ -488,7 +489,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			goto out_free;
 	}
 	cmd->device.hlid = wl->dev_hlid;
-	cmd->device.session = wl->session_counter;
+	cmd->device.session = wlvif->session_counter;
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d",
 		     cmd->role_id, cmd->device.hlid, cmd->device.session);
@@ -587,7 +588,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			goto out_free;
 	}
 	cmd->sta.hlid = wlvif->sta.hlid;
-	cmd->sta.session = wl12xx_get_new_session_id(wl);
+	cmd->sta.session = wl12xx_get_new_session_id(wl, wlvif);
 	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3309fea..d8d8568 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -348,7 +348,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed);
 	DRIVER_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	DRIVER_STATE_PRINT_INT(rx_counter);
-	DRIVER_STATE_PRINT_INT(session_counter);
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f1358b3..8743885 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2128,7 +2128,6 @@ deinit:
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
-	wl->session_counter = 0;
 	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
 	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wl->vif = NULL;
@@ -4855,7 +4854,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
-	wl->session_counter = 0;
 	wl->active_sta_count = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 53c6451..da8427f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -321,15 +321,15 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 		 * FW expects the dummy packet to have an invalid session id -
 		 * any session id that is different than the one set in the join
 		 */
-		tx_attr = ((~wl->session_counter) <<
+		tx_attr = (SESSION_COUNTER_INVALID <<
 			   TX_HW_ATTR_OFST_SESSION_COUNTER) &
 			   TX_HW_ATTR_SESSION_COUNTER;
 
 		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
 	} else {
 		/* configure the tx attributes */
-		tx_attr =
-			wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+		tx_attr = wlvif->session_counter <<
+			  TX_HW_ATTR_OFST_SESSION_COUNTER;
 	}
 
 	desc->hlid = hlid;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 91d666f..10b45f7 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -428,9 +428,6 @@ struct wl1271 {
 	/* Time-offset between host and chipset clocks */
 	s64 time_offset;
 
-	/* Session counter for the chipset */
-	int session_counter;
-
 	/* Frames scheduled for transmission, not handled yet */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 	int tx_queue_count[NUM_TX_QUEUES];
@@ -649,6 +646,9 @@ struct wl12xx_vif {
 
 	/* Our association ID */
 	u16 aid;
+
+	/* Session counter for the chipset */
+	int session_counter;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
@@ -670,7 +670,8 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
-#define SESSION_COUNTER_MAX 7 /* maximum value for the session counter */
+#define SESSION_COUNTER_MAX 6 /* maximum value for the session counter */
+#define SESSION_COUNTER_INVALID 7 /* used with dummy_packet */
 
 #define WL1271_DEFAULT_POWER_LEVEL 0
 
-- 
1.7.6.401.g6a319


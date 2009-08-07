Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45698 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbZHGKer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:47 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 15/23] wl1251: add channel to wl1251_cmd_join() parameters
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:34 +0300
Message-ID: <20090807103434.31717.15352.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Because join channel tunes to a channel, better to make it more obvious
by adding a parameter for it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c  |   10 +++++-----
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_main.c |   10 +++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index e276cb5..4e796db 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -251,8 +251,8 @@ out:
 	return ret;
 }
 
-int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
-		    u8 dtim_interval)
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
+		    u16 beacon_interval, u8 dtim_interval)
 {
 	unsigned long timeout;
 	struct cmd_join *join;
@@ -273,9 +273,9 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
 	if (ret < 0)
 		goto out;
 
-	wl1251_debug(DEBUG_CMD, "cmd join%s %d %d",
+	wl1251_debug(DEBUG_CMD, "cmd join%s ch %d %d/%d",
 		     bss_type == BSS_TYPE_IBSS ? " ibss" : "",
-		     beacon_interval, dtim_interval);
+		     channel, beacon_interval, dtim_interval);
 
 	/* Reverse order BSSID */
 	bssid = (u8 *) &join->bssid_lsb;
@@ -291,7 +291,7 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
 	join->beacon_interval = beacon_interval;
 	join->dtim_interval = dtim_interval;
 	join->bss_type = bss_type;
-	join->channel = wl->channel;
+	join->channel = channel;
 	join->ctrl = JOIN_CMD_CTRL_TX_FLUSH;
 
 	ret = wl1251_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index ffeabf2..dff798a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -36,8 +36,8 @@ int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len);
 int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
 int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
-int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
-		    u8 dtim_interval);
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
+		    u16 beacon_interval, u8 dtim_interval);
 int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
 int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 2514c94..5e90459 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -324,7 +324,7 @@ static void wl1251_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
+	ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel, wl->beacon_int,
 				   wl->dtim_period);
 	if (ret < 0)
 		goto out_sleep;
@@ -565,8 +565,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (channel != wl->channel) {
-		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-					   wl->dtim_period);
+		ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel,
+				      wl->beacon_int, wl->dtim_period);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1123,7 +1123,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl1251_cmd_join(wl, wl->bss_type,
+			ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel,
 					      wl->beacon_int,
 					      wl->dtim_period);
 			if (ret < 0)
@@ -1152,7 +1152,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-				      wl->dtim_period);
+				      wl->channel, wl->dtim_period);
 
 		if (ret < 0)
 			goto out;


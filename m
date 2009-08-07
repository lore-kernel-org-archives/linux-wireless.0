Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53614 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbZHGKej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:39 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 13/23] wl1251: remove wait parameter from wl1251_cmd_join()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:19 +0300
Message-ID: <20090807103419.31717.63860.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

We should wait everytime for the join command to finish, not waiting for
it might create problems.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c  |   10 ++++------
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1251_main.c |    8 ++++----
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 9cd46ce..e276cb5 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -252,7 +252,7 @@ out:
 }
 
 int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
-		    u8 dtim_interval, bool wait)
+		    u8 dtim_interval)
 {
 	unsigned long timeout;
 	struct cmd_join *join;
@@ -273,10 +273,9 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
 	if (ret < 0)
 		goto out;
 
-	wl1251_debug(DEBUG_CMD, "cmd join%s %d %d%s",
+	wl1251_debug(DEBUG_CMD, "cmd join%s %d %d",
 		     bss_type == BSS_TYPE_IBSS ? " ibss" : "",
-		     beacon_interval, dtim_interval,
-		     wait ? " wait" : "");
+		     beacon_interval, dtim_interval);
 
 	/* Reverse order BSSID */
 	bssid = (u8 *) &join->bssid_lsb;
@@ -307,8 +306,7 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
 	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
 	 * simplify locking we just sleep instead, for now
 	 */
-	if (wait)
-		msleep(10);
+	msleep(10);
 
 out:
 	kfree(join);
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index f9177d6..ffeabf2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -37,7 +37,7 @@ int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
 int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
 int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
-		    u8 dtim_interval, bool wait);
+		    u8 dtim_interval);
 int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
 int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 7014233..d031692 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -325,7 +325,7 @@ static void wl1251_filter_work(struct work_struct *work)
 		goto out;
 
 	ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-				   wl->dtim_period, false);
+				   wl->dtim_period);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -565,7 +565,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (channel != wl->channel) {
 		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-					   wl->dtim_period, false);
+					   wl->dtim_period);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1124,7 +1124,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (wl->bss_type != BSS_TYPE_IBSS) {
 			ret = wl1251_cmd_join(wl, wl->bss_type,
 					      wl->beacon_int,
-					      wl->dtim_period, true);
+					      wl->dtim_period);
 			if (ret < 0)
 				goto out_sleep;
 			wl1251_warning("Set ctsprotect failed %d", ret);
@@ -1151,7 +1151,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-				      wl->dtim_period, false);
+				      wl->dtim_period);
 
 		if (ret < 0)
 			goto out;


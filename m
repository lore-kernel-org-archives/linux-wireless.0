Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45668 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbZHGKem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:42 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 11/23] wl1251: reorder wl1251_cmd_join() arguments
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:05 +0300
Message-ID: <20090807103404.31717.55173.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

It's more common to have beacon interval before dtim period. Also use
bool instead of u8.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c  |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_main.c |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 53f5da6..50daa9b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -251,8 +251,8 @@ out:
 	return ret;
 }
 
-int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait)
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
+		    u8 dtim_interval, bool wait)
 {
 	unsigned long timeout;
 	struct cmd_join *join;
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index 64f228d..f9177d6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -36,8 +36,8 @@ int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len);
 int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
 int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
-int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait);
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
+		    u8 dtim_interval, bool wait);
 int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
 int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 8c88fe2..47b82fa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -325,7 +325,7 @@ static void wl1251_filter_work(struct work_struct *work)
 		goto out;
 
 	/* FIXME: replace the magic numbers with proper definitions */
-	ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -565,7 +565,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (channel != wl->channel) {
 		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1113,7 +1113,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl1251_cmd_join(wl, wl->bss_type, 5, 100, 1);
+			ret = wl1251_cmd_join(wl, wl->bss_type, 100, 5, true);
 			if (ret < 0)
 				goto out_sleep;
 			wl1251_warning("Set ctsprotect failed %d", ret);
@@ -1139,7 +1139,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
-		ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
 
 		if (ret < 0)
 			goto out;


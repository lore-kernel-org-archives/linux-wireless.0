Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19772 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbZHGKey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:54 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 16/23] wl1251: create wl1251_join()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:42 +0300
Message-ID: <20090807103441.31717.80626.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Better to use wl1251_cmd_join() only for sending the command and move
the logic to wl1251_join().

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c  |   17 -----------
 drivers/net/wireless/wl12xx/wl1251_main.c |   45 +++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 4e796db..d7800a3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -254,7 +254,6 @@ out:
 int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 		    u16 beacon_interval, u8 dtim_interval)
 {
-	unsigned long timeout;
 	struct cmd_join *join;
 	int ret, i;
 	u8 *bssid;
@@ -265,14 +264,6 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 		goto out;
 	}
 
-	/* FIXME: this should be in main.c */
-	ret = wl1251_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
-				     DEFAULT_HW_GEN_MODULATION_TYPE,
-				     wl->tx_mgmt_frm_rate,
-				     wl->tx_mgmt_frm_mod);
-	if (ret < 0)
-		goto out;
-
 	wl1251_debug(DEBUG_CMD, "cmd join%s ch %d %d/%d",
 		     bss_type == BSS_TYPE_IBSS ? " ibss" : "",
 		     channel, beacon_interval, dtim_interval);
@@ -300,14 +291,6 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 		goto out;
 	}
 
-	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
-
-	/*
-	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
-	 * simplify locking we just sleep instead, for now
-	 */
-	msleep(10);
-
 out:
 	kfree(join);
 	return ret;
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 5e90459..e575b78 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -309,6 +309,34 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static int wl1251_join(struct wl1251 *wl, u8 bss_type, u8 channel,
+		       u16 beacon_interval, u8 dtim_period)
+{
+	int ret;
+
+	ret = wl1251_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
+				     DEFAULT_HW_GEN_MODULATION_TYPE,
+				     wl->tx_mgmt_frm_rate,
+				     wl->tx_mgmt_frm_mod);
+	if (ret < 0)
+		goto out;
+
+
+	ret = wl1251_cmd_join(wl, bss_type, channel, beacon_interval,
+			      dtim_period);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * FIXME: we should wait for JOIN_EVENT_COMPLETE_ID but to simplify
+	 * locking we just sleep instead, for now
+	 */
+	msleep(10);
+
+out:
+	return ret;
+}
+
 static void wl1251_filter_work(struct work_struct *work)
 {
 	struct wl1251 *wl =
@@ -324,8 +352,8 @@ static void wl1251_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel, wl->beacon_int,
-				   wl->dtim_period);
+	ret = wl1251_join(wl, wl->bss_type, wl->channel, wl->beacon_int,
+			  wl->dtim_period);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -565,8 +593,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (channel != wl->channel) {
-		ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel,
-				      wl->beacon_int, wl->dtim_period);
+		ret = wl1251_join(wl, wl->bss_type, wl->channel,
+				  wl->beacon_int, wl->dtim_period);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1123,9 +1151,8 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl1251_cmd_join(wl, wl->bss_type, wl->channel,
-					      wl->beacon_int,
-					      wl->dtim_period);
+			ret = wl1251_join(wl, wl->bss_type, wl->channel,
+					  wl->beacon_int, wl->dtim_period);
 			if (ret < 0)
 				goto out_sleep;
 			wl1251_warning("Set ctsprotect failed %d", ret);
@@ -1151,8 +1178,8 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
-		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
-				      wl->channel, wl->dtim_period);
+		ret = wl1251_join(wl, wl->bss_type, wl->beacon_int,
+				  wl->channel, wl->dtim_period);
 
 		if (ret < 0)
 			goto out;


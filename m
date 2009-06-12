Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63972 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbZFLLQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:43 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 21/33] wl12xx: check if elp wakeup failed
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:32 +0300
Message-ID: <20090612111631.8877.58486.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Check the return call from wl12xx_ps_elp_wakeup() and bail out if it
fails. This shouldn't happen, but if does there's a fundamental low
level issue.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/debugfs.c   |    7 +++
 drivers/net/wireless/wl12xx/main.c      |   66 +++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/wl1251.c    |    6 ++-
 drivers/net/wireless/wl12xx/wl1251_tx.c |    4 +-
 4 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3cc5460..94ad994 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -95,9 +95,13 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 
 static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
 {
+	int ret;
+
 	mutex_lock(&wl->mutex);
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	if (wl->state == WL12XX_STATE_ON &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
@@ -108,6 +112,7 @@ static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
 
 	wl12xx_ps_elp_sleep(wl);
 
+out:
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 894d5cc..245544e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -239,14 +239,18 @@ static void wl12xx_filter_work(struct work_struct *work)
 	if (wl->state == WL12XX_STATE_OFF)
 		goto out;
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
 	if (ret < 0)
-		goto out;
+		goto out_sleep;
 
-out:
+out_sleep:
 	wl12xx_ps_elp_sleep(wl);
+
+out:
 	mutex_unlock(&wl->mutex);
 }
 
@@ -524,20 +528,22 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	if (channel != wl->channel) {
 		/* FIXME: use beacon interval provided by mac80211 */
 		ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 
 		wl->channel = channel;
 	}
 
 	ret = wl12xx_build_null_data(wl);
 	if (ret < 0)
-		goto out;
+		goto out_sleep;
 
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
 		wl12xx_info("psm enabled");
@@ -568,9 +574,12 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->power_level = conf->power_level;
 	}
 
-out:
+out_sleep:
 	wl12xx_ps_elp_sleep(wl);
+
+out:
 	mutex_unlock(&wl->mutex);
+
 	return ret;
 }
 
@@ -708,7 +717,9 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
 
 	switch (cmd) {
 	case SET_KEY:
@@ -725,7 +736,7 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	ret = wl12xx_set_key_type(wl, wl_cmd, cmd, key, addr);
 	if (ret < 0) {
 		wl12xx_error("Set KEY type failed");
-		goto out_unlock;
+		goto out_sleep;
 	}
 
 	if (wl_cmd->key_type != KEY_WEP_DEFAULT)
@@ -756,11 +767,13 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	ret = wl12xx_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
 	if (ret < 0) {
 		wl12xx_warning("could not set keys");
-		goto out_unlock;
+		goto out_sleep;
 	}
 
-out_unlock:
+out_sleep:
 	wl12xx_ps_elp_sleep(wl);
+
+out_unlock:
 	mutex_unlock(&wl->mutex);
 
 out:
@@ -955,11 +968,16 @@ static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&wl->mutex);
-	wl12xx_ps_elp_wakeup(wl);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
 
 	wl12xx_ps_elp_sleep(wl);
+
+out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
@@ -972,15 +990,17 @@ static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&wl->mutex);
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
-
 	if (ret < 0)
 		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
 
 	wl12xx_ps_elp_sleep(wl);
 
+out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
@@ -1000,7 +1020,9 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
@@ -1008,18 +1030,18 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			ret = wl12xx_build_ps_poll(wl, wl->aid);
 			if (ret < 0)
-				goto out;
+				goto out_sleep;
 
 			ret = wl12xx_acx_aid(wl, wl->aid);
 			if (ret < 0)
-				goto out;
+				goto out_sleep;
 
 			/* If we want to go in PSM but we're not there yet */
 			if (wl->psm_requested && !wl->psm) {
 				mode = STATION_POWER_SAVE_MODE;
 				ret = wl12xx_ps_set_mode(wl, mode);
 				if (ret < 0)
-					goto out;
+					goto out_sleep;
 			}
 		}
 	}
@@ -1030,7 +1052,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl12xx_acx_slot(wl, SLOT_TIME_LONG);
 		if (ret < 0) {
 			wl12xx_warning("Set slot time failed %d", ret);
-			goto out;
+			goto out_sleep;
 		}
 	}
 
@@ -1048,7 +1070,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_DISABLE);
 		if (ret < 0) {
 			wl12xx_warning("Set ctsprotect failed %d", ret);
-			goto out;
+			goto out_sleep;
 		}
 	}
 
@@ -1090,8 +1112,10 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 	}
 
-out:
+out_sleep:
 	wl12xx_ps_elp_sleep(wl);
+
+out:
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index 903624a..5f6e75c 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -401,6 +401,7 @@ static void wl1251_irq_work(struct work_struct *work)
 	u32 intr;
 	struct wl12xx *wl =
 		container_of(work, struct wl12xx, irq_work);
+	int ret;
 
 	mutex_lock(&wl->mutex);
 
@@ -409,7 +410,9 @@ static void wl1251_irq_work(struct work_struct *work)
 	if (wl->state == WL12XX_STATE_OFF)
 		goto out;
 
-	wl12xx_ps_elp_wakeup(wl);
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1251_ACX_INTR_ALL);
 
@@ -489,6 +492,7 @@ static void wl1251_irq_work(struct work_struct *work)
 
 out_sleep:
 	wl12xx_ps_elp_sleep(wl);
+
 out:
 	mutex_unlock(&wl->mutex);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index c42c43d..10023fc 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -311,7 +311,9 @@ void wl1251_tx_work(struct work_struct *work)
 
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
-			wl12xx_ps_elp_wakeup(wl);
+			ret = wl12xx_ps_elp_wakeup(wl);
+			if (ret < 0)
+				goto out;
 			woken_up = true;
 		}
 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64858 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbZFLLQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:41 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 20/33] wl12xx: optimise elp wakeup and sleep calls
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:26 +0300
Message-ID: <20090612111626.8877.77842.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The wakeup call was done too deep in code path, it's better to wakeup
chip from higher levels. This will also reduce wakeup calls significantly.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/cmd.c     |   13 -------------
 drivers/net/wireless/wl12xx/debugfs.c |    5 +++++
 drivers/net/wireless/wl12xx/main.c    |   20 ++++++++++++++++++++
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 04e8401..fb4e996 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -32,8 +32,6 @@ int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
 
 	WARN_ON(len % 4 != 0);
 
-	wl12xx_ps_elp_wakeup(wl);
-
 	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
 
 	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
@@ -57,8 +55,6 @@ int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
 			   wl->chip.intr_cmd_complete);
 
 out:
-	wl12xx_ps_elp_sleep(wl);
-
 	return ret;
 }
 
@@ -91,13 +87,8 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 		 * The answer would be a wl12xx_command, where the
 		 * parameter array contains the actual answer.
 		 */
-
-		wl12xx_ps_elp_wakeup(wl);
-
 		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
-		wl12xx_ps_elp_sleep(wl);
-
 		cmd_answer = buf;
 
 		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
@@ -134,13 +125,9 @@ int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len)
 		goto out;
 	}
 
-	wl12xx_ps_elp_wakeup(wl);
-
 	/* the interrogate command got in, we can read the answer */
 	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
 
-	wl12xx_ps_elp_sleep(wl);
-
 	acx = buf;
 	if (acx->cmd.status != CMD_STATUS_SUCCESS)
 		wl12xx_error("INTERROGATE command error: %d",
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index cdb368c..3cc5460 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -27,6 +27,7 @@
 
 #include "wl12xx.h"
 #include "acx.h"
+#include "ps.h"
 
 /* ms */
 #define WL12XX_DEBUGFS_STATS_LIFETIME 1000
@@ -96,6 +97,8 @@ static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
 {
 	mutex_lock(&wl->mutex);
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	if (wl->state == WL12XX_STATE_ON &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
 		       msecs_to_jiffies(WL12XX_DEBUGFS_STATS_LIFETIME))) {
@@ -103,6 +106,8 @@ static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
 		wl->stats.fw_stats_update = jiffies;
 	}
 
+	wl12xx_ps_elp_sleep(wl);
+
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7ec1749..894d5cc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -239,11 +239,14 @@ static void wl12xx_filter_work(struct work_struct *work)
 	if (wl->state == WL12XX_STATE_OFF)
 		goto out;
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
 	if (ret < 0)
 		goto out;
 
 out:
+	wl12xx_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -521,6 +524,8 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	if (channel != wl->channel) {
 		/* FIXME: use beacon interval provided by mac80211 */
 		ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
@@ -564,6 +569,7 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 out:
+	wl12xx_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 	return ret;
 }
@@ -702,6 +708,8 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	switch (cmd) {
 	case SET_KEY:
 		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
@@ -752,6 +760,7 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 out_unlock:
+	wl12xx_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 
 out:
@@ -946,7 +955,11 @@ static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&wl->mutex);
+	wl12xx_ps_elp_wakeup(wl);
+
 	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+
+	wl12xx_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 
 	return ret;
@@ -959,11 +972,15 @@ static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&wl->mutex);
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
 
 	if (ret < 0)
 		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
 
+	wl12xx_ps_elp_sleep(wl);
+
 	mutex_unlock(&wl->mutex);
 
 	return ret;
@@ -983,6 +1000,8 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	wl12xx_ps_elp_wakeup(wl);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
@@ -1072,6 +1091,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 out:
+	wl12xx_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 }
 


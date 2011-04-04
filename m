Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42079 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1DDIEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 04:04:20 -0400
Received: by ewy4 with SMTP id 4so1633522ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 01:04:18 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH 1/2] wl1251: Prepare for idle mode support
Date: Mon,  4 Apr 2011 11:04:57 +0300
Message-Id: <1301904298-4725-1-git-send-email-jhnikula@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFC for WL1251 idle mode support brought a few issues that are worth to
update before adding the idle mode support.

Since the idle mode can reuse the code that is now used in Power Save Mode
(PSM), the flag psm in struct wl1251 is changed to variable station_mode
to be able to distinguish between PSM and idle modes.

As the station mode is different than the power power save mode command
that is sent to chip, the enum wl1251_cmd_ps_mod values are used only when
communicating with the chip and new enum wl1251_station_mode values are used
inside the driver.

Confusing comment about psm and elp relation is removed since the PSM is
actually activated by putting the chip into Entreme Low Power (ELP) mode.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
---
v2:
- Since the enum wl1251_cmd_ps_mod values are sent to chip they are kept in
  cmd.h but prefixed with CHIP_.
---
 drivers/net/wireless/wl1251/cmd.h    |    4 ++--
 drivers/net/wireless/wl1251/event.c  |    6 ++++--
 drivers/net/wireless/wl1251/main.c   |    6 +++---
 drivers/net/wireless/wl1251/ps.c     |   14 ++++++--------
 drivers/net/wireless/wl1251/ps.h     |    2 +-
 drivers/net/wireless/wl1251/wl1251.h |    8 ++++++--
 6 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl1251/cmd.h b/drivers/net/wireless/wl1251/cmd.h
index e5c74c6..79ca527 100644
--- a/drivers/net/wireless/wl1251/cmd.h
+++ b/drivers/net/wireless/wl1251/cmd.h
@@ -313,8 +313,8 @@ struct wl1251_cmd_vbm_update {
 } __packed;
 
 enum wl1251_cmd_ps_mode {
-	STATION_ACTIVE_MODE,
-	STATION_POWER_SAVE_MODE
+	CHIP_ACTIVE_MODE,
+	CHIP_POWER_SAVE_MODE
 };
 
 struct wl1251_cmd_ps_params {
diff --git a/drivers/net/wireless/wl1251/event.c b/drivers/net/wireless/wl1251/event.c
index dfc4579..9f15cca 100644
--- a/drivers/net/wireless/wl1251/event.c
+++ b/drivers/net/wireless/wl1251/event.c
@@ -68,14 +68,16 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 	if (vector & BSS_LOSE_EVENT_ID) {
 		wl1251_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
-		if (wl->psm_requested && wl->psm) {
+		if (wl->psm_requested &&
+		    wl->station_mode != STATION_ACTIVE_MODE) {
 			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
 			if (ret < 0)
 				return ret;
 		}
 	}
 
-	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
+	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID &&
+	    wl->station_mode != STATION_ACTIVE_MODE) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 12c9e63..04a0549 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -497,7 +497,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->rx_last_id = 0;
 	wl->next_tx_complete = 0;
 	wl->elp = false;
-	wl->psm = 0;
+	wl->station_mode = STATION_ACTIVE_MODE;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->rssi_thold = 0;
@@ -632,7 +632,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 
 		wl->psm_requested = false;
 
-		if (wl->psm) {
+		if (wl->station_mode != STATION_ACTIVE_MODE) {
 			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
 			if (ret < 0)
 				goto out_sleep;
@@ -1384,7 +1384,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
 	wl->elp = false;
-	wl->psm = 0;
+	wl->station_mode = STATION_ACTIVE_MODE;
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/wl1251/ps.c
index 9cc5147..97a5b8c 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -39,7 +39,7 @@ void wl1251_elp_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->elp || !wl->psm)
+	if (wl->elp || wl->station_mode == STATION_ACTIVE_MODE)
 		goto out;
 
 	wl1251_debug(DEBUG_PSM, "chip to elp");
@@ -57,7 +57,7 @@ void wl1251_ps_elp_sleep(struct wl1251 *wl)
 {
 	unsigned long delay;
 
-	if (wl->psm) {
+	if (wl->station_mode != STATION_ACTIVE_MODE) {
 		delay = msecs_to_jiffies(ELP_ENTRY_DELAY);
 		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work, delay);
 	}
@@ -104,7 +104,7 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 	return 0;
 }
 
-int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
+int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_station_mode mode)
 {
 	int ret;
 
@@ -128,15 +128,13 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		ret = wl1251_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
+		ret = wl1251_cmd_ps_mode(wl, CHIP_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
 
 		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_ELP);
 		if (ret < 0)
 			return ret;
-
-		wl->psm = 1;
 		break;
 	case STATION_ACTIVE_MODE:
 	default:
@@ -163,13 +161,13 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		ret = wl1251_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		ret = wl1251_cmd_ps_mode(wl, CHIP_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
 
-		wl->psm = 0;
 		break;
 	}
+	wl->station_mode = mode;
 
 	return ret;
 }
diff --git a/drivers/net/wireless/wl1251/ps.h b/drivers/net/wireless/wl1251/ps.h
index 55c3dda..75efad2 100644
--- a/drivers/net/wireless/wl1251/ps.h
+++ b/drivers/net/wireless/wl1251/ps.h
@@ -26,7 +26,7 @@
 #include "wl1251.h"
 #include "acx.h"
 
-int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode);
+int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_station_mode mode);
 void wl1251_ps_elp_sleep(struct wl1251 *wl);
 int wl1251_ps_elp_wakeup(struct wl1251 *wl);
 void wl1251_elp_work(struct work_struct *work);
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index bb23cd5..bf245a8 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -129,6 +129,11 @@ enum wl1251_partition_type {
 	PART_TABLE_LEN
 };
 
+enum wl1251_station_mode {
+	STATION_ACTIVE_MODE,
+	STATION_POWER_SAVE_MODE,
+};
+
 struct wl1251_partition {
 	u32 size;
 	u32 start;
@@ -358,8 +363,7 @@ struct wl1251 {
 
 	struct delayed_work elp_work;
 
-	/* we can be in psm, but not in elp, we have to differentiate */
-	bool psm;
+	enum wl1251_station_mode station_mode;
 
 	/* PSM mode requested */
 	bool psm_requested;
-- 
1.7.4.1


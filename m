Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53550 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbZHGKeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:24 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 12/23] wl1251: use beacon interval and dtim period provided by
	mac80211
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:12 +0300
Message-ID: <20090807103412.31717.70774.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1251 was using hardcoded beacon intervals and dtim periods, use the ones
provided by mac80211 instead.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    6 ++++++
 drivers/net/wireless/wl12xx/wl1251_cmd.c  |    5 ++++-
 drivers/net/wireless/wl12xx/wl1251_main.c |   26 ++++++++++++++++++++------
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 44c5001..86d2abe 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -360,6 +360,9 @@ struct wl1251 {
 	/* PSM mode requested */
 	bool psm_requested;
 
+	u16 beacon_int;
+	u8 dtim_period;
+
 	/* in dBm */
 	int power_level;
 
@@ -392,6 +395,9 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 
 #define WL1251_TX_QUEUE_MAX_LENGTH 20
 
+#define WL1251_DEFAULT_BEACON_INT 100
+#define WL1251_DEFAULT_DTIM_PERIOD 1
+
 #define CHIP_ID_1251_PG10	           (0x7010101)
 #define CHIP_ID_1251_PG11	           (0x7020101)
 #define CHIP_ID_1251_PG12	           (0x7030101)
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 50daa9b..9cd46ce 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -273,7 +273,10 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u16 beacon_interval,
 	if (ret < 0)
 		goto out;
 
-	wl1251_debug(DEBUG_CMD, "cmd join");
+	wl1251_debug(DEBUG_CMD, "cmd join%s %d %d%s",
+		     bss_type == BSS_TYPE_IBSS ? " ibss" : "",
+		     beacon_interval, dtim_interval,
+		     wait ? " wait" : "");
 
 	/* Reverse order BSSID */
 	bssid = (u8 *) &join->bssid_lsb;
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 47b82fa..7014233 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -324,8 +324,8 @@ static void wl1251_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	/* FIXME: replace the magic numbers with proper definitions */
-	ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
+	ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
+				   wl->dtim_period, false);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -564,8 +564,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (channel != wl->channel) {
-		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
+		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
+					   wl->dtim_period, false);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1057,6 +1057,11 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			wl->beacon_int = bss_conf->beacon_int;
+			wl->dtim_period = bss_conf->dtim_period;
+
+			/* FIXME: call join */
+
 			wl->aid = bss_conf->aid;
 
 			ret = wl1251_build_ps_poll(wl, wl->aid);
@@ -1074,6 +1079,10 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 				if (ret < 0)
 					goto out_sleep;
 			}
+		} else {
+			/* use defaults when not associated */
+			wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
+			wl->dtim_period = WL1251_DEFAULT_DTIM_PERIOD;
 		}
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -1113,7 +1122,9 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl1251_cmd_join(wl, wl->bss_type, 100, 5, true);
+			ret = wl1251_cmd_join(wl, wl->bss_type,
+					      wl->beacon_int,
+					      wl->dtim_period, true);
 			if (ret < 0)
 				goto out_sleep;
 			wl1251_warning("Set ctsprotect failed %d", ret);
@@ -1139,7 +1150,8 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
-		ret = wl1251_cmd_join(wl, wl->bss_type, 100, 1, false);
+		ret = wl1251_cmd_join(wl, wl->bss_type, wl->beacon_int,
+				      wl->dtim_period, false);
 
 		if (ret < 0)
 			goto out;
@@ -1329,6 +1341,8 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
+	wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
+	wl->dtim_period = WL1251_DEFAULT_DTIM_PERIOD;
 
 	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
 		wl->tx_frames[i] = NULL;


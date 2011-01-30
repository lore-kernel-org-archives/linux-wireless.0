Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:58588 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1A3TLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:43 -0500
Message-ID: <4D45B7DC.3060303@davizone.at>
Date: Sun, 30 Jan 2011 20:11:24 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary
 for packet injection
References: <4D45A79A.1030102@davizone.at>
In-Reply-To: <4D45A79A.1030102@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If necessary enable the tx path in monitor mode for packet injection using
the JOIN command with BSS_TYPE_STA_BSS and zero BSSID.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/main.c   |    5 +++++
 drivers/net/wireless/wl1251/tx.c     |   17 +++++++++++++++++
 drivers/net/wireless/wl1251/wl1251.h |    1 +
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index c931a3a..bb2d40d 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -480,6 +480,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->rssi_thold = 0;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->monitor_present = false;
+	wl->joined = false;
 
 	wl1251_debugfs_reset(wl);
 
@@ -536,6 +537,7 @@ static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 	wl1251_debug(DEBUG_MAC80211, "mac80211 remove interface");
 	wl->vif = NULL;
+	memset(wl->bssid, 0, ETH_ALEN);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -618,6 +620,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * at firmware level.
 		 */
 		if (wl->vif == NULL) {
+			wl->joined = false;
 			ret = wl1251_cmd_data_path_rx(wl, wl->channel, 1);
 		} else {
 			ret = wl1251_join(wl, wl->bss_type, wl->channel,
@@ -1588,7 +1591,9 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->monitor_present = false;
+	wl->joined = false;
 	wl->scanning = false;
+	wl->bss_type = MAX_BSS_TYPE;
 	wl->default_key = 0;
 	wl->listen_int = 1;
 	wl->rx_counter = 0;
diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/wl1251/tx.c
index 3cc82fd..1de4ccb 100644
--- a/drivers/net/wireless/wl1251/tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -28,6 +28,7 @@
 #include "tx.h"
 #include "ps.h"
 #include "io.h"
+#include "event.h"
 
 static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
 {
@@ -298,6 +299,22 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
 		}
 	}
 
+	/* Enable tx path in monitor mode for packet injection */
+	if ((wl->vif == NULL) && !wl->joined) {
+		ret = wl1251_cmd_join(wl, BSS_TYPE_STA_BSS, wl->channel,
+				      wl->beacon_int, wl->dtim_period);
+		if (ret < 0)
+			wl1251_warning("join failed");
+		else {
+			ret = wl1251_event_wait(wl, JOIN_EVENT_COMPLETE_ID,
+						100);
+			if (ret < 0)
+				wl1251_warning("join timeout");
+			else
+				wl->joined = true;
+		}
+	}
+
 	ret = wl1251_tx_path_status(wl);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index 184ceff..fddafe2 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -303,6 +303,7 @@ struct wl1251 {
 	u8 listen_int;
 	int channel;
 	bool monitor_present;
+	bool joined;
 
 	void *target_mem_map;
 	struct acx_data_path_params_resp *data_path;
-- 
1.7.0.4



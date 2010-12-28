Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47335 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0L1RhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:16 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4468650ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 07/18] wl1271: AP specific RX filter configuration
Date: Tue, 28 Dec 2010 19:36:37 +0200
Message-Id: <1293557808-27068-8-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set filters according to the mode of operation.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c   |    4 ++--
 drivers/net/wireless/wl12xx/main.c   |    7 +++----
 drivers/net/wireless/wl12xx/rx.c     |   11 +++++++++++
 drivers/net/wireless/wl12xx/rx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |   13 +++++++++++--
 5 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index bb4f283..b2f0f64 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -29,6 +29,7 @@
 #include "boot.h"
 #include "io.h"
 #include "event.h"
+#include "rx.h"
 
 static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
@@ -599,8 +600,7 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_boot_enable_interrupts(wl);
 
 	/* set the wl1271 default filters */
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl1271_set_default_filters(wl);
 
 	wl1271_event_mbox_config(wl);
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 67f6db4..d1075a5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1227,8 +1227,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 
 static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 {
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl1271_set_default_filters(wl);
 
 	/* combine requested filters with current filter config */
 	filters = wl->filters | filters;
@@ -2758,8 +2757,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
 	wl->rx_counter = 0;
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl->rx_config = WL1271_DEFAULT_STA_RX_CONFIG;
+	wl->rx_filter = WL1271_DEFAULT_STA_RX_FILTER;
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 682304c..6668133 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -201,3 +201,14 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS,
 			cpu_to_le32(wl->rx_counter));
 }
+
+void wl1271_set_default_filters(struct wl1271 *wl)
+{
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		wl->rx_config = WL1271_DEFAULT_AP_RX_CONFIG;
+		wl->rx_filter = WL1271_DEFAULT_AP_RX_FILTER;
+	} else {
+		wl->rx_config = WL1271_DEFAULT_STA_RX_CONFIG;
+		wl->rx_filter = WL1271_DEFAULT_STA_RX_FILTER;
+	}
+}
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 3abb26f..f695553 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -117,5 +117,6 @@ struct wl1271_rx_descriptor {
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
+void wl1271_set_default_filters(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index aba8f47..136e87b 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -103,15 +103,24 @@ extern u32 wl12xx_debug_level;
 				       true);				\
 	} while (0)
 
-#define WL1271_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
+#define WL1271_DEFAULT_STA_RX_CONFIG (CFG_UNI_FILTER_EN |	\
 				  CFG_BSSID_FILTER_EN | \
 				  CFG_MC_FILTER_EN)
 
-#define WL1271_DEFAULT_RX_FILTER (CFG_RX_RCTS_ACK | CFG_RX_PRSP_EN |  \
+#define WL1271_DEFAULT_STA_RX_FILTER (CFG_RX_RCTS_ACK | CFG_RX_PRSP_EN |  \
 				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN |   \
 				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
 				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
 
+#define WL1271_DEFAULT_AP_RX_CONFIG  0
+
+#define WL1271_DEFAULT_AP_RX_FILTER  (CFG_RX_RCTS_ACK | CFG_RX_PREQ_EN | \
+				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN | \
+				  CFG_RX_CTL_EN | CFG_RX_AUTH_EN | \
+				  CFG_RX_ASSOC_EN)
+
+
+
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
-- 
1.7.1


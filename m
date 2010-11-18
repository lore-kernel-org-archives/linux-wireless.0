Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0KRLct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:32:49 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:32:48 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/18] wl1271: AP specific RX filter configuration
Date: Thu, 18 Nov 2010 13:32:20 +0200
Message-Id: <1290079951-16793-8-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set filters according to the mode of operation.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c   |    3 +--
 drivers/net/wireless/wl12xx/boot.h   |    3 +++
 drivers/net/wireless/wl12xx/main.c   |   18 ++++++++++++++----
 drivers/net/wireless/wl12xx/wl12xx.h |   13 +++++++++++--
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index a2b496b..f9e0c41 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -584,8 +584,7 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_boot_enable_interrupts(wl);
 
 	/* set the wl1271 default filters */
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl1271_set_default_filters(wl);
 
 	wl1271_event_mbox_config(wl);
 
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index c7d7719..7ac6c4a 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -68,4 +68,7 @@ struct wl1271_static_data {
 #define FREF_CLK_POLARITY_BITS 0xfffff8ff
 #define CLK_REQ_OUTN_SEL       0x700
 
+/* Functions from wl1271_main.c */
+void wl1271_set_default_filters(struct wl1271 *wl);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1c6f399..e6682f2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1205,10 +1205,20 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&wl->recovery_work);
 }
 
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
+
 static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 {
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl1271_set_default_filters(wl);
 
 	/* combine requested filters with current filter config */
 	filters = wl->filters | filters;
@@ -2727,8 +2737,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
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
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 69720c0..cbad378 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -102,15 +102,24 @@ enum {
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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0LVO2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:13 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so5082982wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:13 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 07/18] wl1271: AP specific RX filter configuration
Date: Wed, 22 Dec 2010 16:27:26 +0200
Message-Id: <1293028057-6212-8-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
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
index bb4f283..f0c35f2 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -599,8 +599,7 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_boot_enable_interrupts(wl);
 
 	/* set the wl1271 default filters */
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl1271_set_default_filters(wl);
 
 	wl1271_event_mbox_config(wl);
 
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index d67dcff..5f19a40 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -69,4 +69,7 @@ struct wl1271_static_data {
 #define FREF_CLK_POLARITY_BITS 0xfffff8ff
 #define CLK_REQ_OUTN_SEL       0x700
 
+/* Functions from wl1271_main.c */
+void wl1271_set_default_filters(struct wl1271 *wl);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 5354190..05adde6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1225,10 +1225,20 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
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
@@ -2776,8 +2786,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
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


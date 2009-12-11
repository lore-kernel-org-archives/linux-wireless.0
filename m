Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50900 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbZLKLml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:41 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/31] wl1271: Use slow rates for association messages
Date: Fri, 11 Dec 2009 13:41:10 +0200
Message-Id: <1260531682-4695-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

While not associated, default the data rates to 1 and 2mbps, so that only
those rates will be used for association related message transfer. Once
associated, configure the full rate-set supported by the AP.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 --
 drivers/net/wireless/wl12xx/wl1271_conf.h |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++++++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 8dfc9ec..4b5ddba 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -107,8 +107,6 @@ enum {
 				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
 				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
 
-#define WL1271_DEFAULT_BASIC_RATE_SET (CONF_TX_RATE_MASK_ALL)
-
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 #define WL1271_NVS_LEN  468
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index c87ae56..5d1b5b6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -258,7 +258,8 @@ struct conf_rx_settings {
 #define CONF_TX_MAX_RATE_CLASSES       8
 
 #define CONF_TX_RATE_MASK_UNSPECIFIED  0
-#define CONF_TX_RATE_MASK_ALL          0x1eff
+#define CONF_TX_RATE_MASK_BASIC        (CONF_HW_BIT_RATE_1MBPS | \
+					CONF_HW_BIT_RATE_2MBPS)
 #define CONF_TX_RATE_RETRY_LIMIT       10
 
 struct conf_tx_rate_class {
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 7bfd6c6..c67889d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -284,7 +284,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl, WL1271_DEFAULT_BASIC_RATE_SET);
+	ret = wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_BASIC);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index bd1a491..d229e57 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1180,6 +1180,11 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_unjoin_channel(wl);
 		else
 			wl1271_join_channel(wl, channel);
+
+		if (conf->flags & IEEE80211_CONF_IDLE) {
+			wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+			wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_BASIC);
+		}
 	}
 
 	/* if the channel changes while joined, join again */
@@ -1568,7 +1573,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		} else {
 			/* use defaults when not associated */
-			wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 			wl->aid = 0;
 		}
 
@@ -1897,7 +1901,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
-	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
+	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->joined = false;
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56816 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1DGMwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 08:52:35 -0400
Received: by wwa36 with SMTP id 36so2992837wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 05:52:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: configure rates when working in ibss mode
Date: Thu,  7 Apr 2011 15:52:05 +0300
Message-Id: <1302180725-8796-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When working in ibss mode, we don't configure rate policy per station
(as we use the same link for multiple stations), so currently the
1mb/s rate is being used.

Instead, configure the firmware to use the whole 11b rates by default.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |    7 +++++++
 drivers/net/wireless/wl12xx/main.c |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..8121b57 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -516,6 +516,13 @@ struct conf_rx_settings {
 #define CONF_TX_AP_DEFAULT_MGMT_RATES  (CONF_HW_BIT_RATE_1MBPS | \
 	CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS)
 
+/*
+ * Default rates for working as IBSS. use 11b rates
+ */
+#define CONF_TX_IBSS_DEFAULT_RATES  (CONF_HW_BIT_RATE_1MBPS |       \
+		CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS | \
+		CONF_HW_BIT_RATE_11MBPS);
+
 struct conf_tx_rate_class {
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..ed7914c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2503,6 +2503,24 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		}
 	}
 
+	if (changed & BSS_CHANGED_IBSS) {
+		wl1271_debug(DEBUG_ADHOC, "ibss_joined: %d",
+			     bss_conf->ibss_joined);
+
+		if (bss_conf->ibss_joined) {
+			u32 rates = bss_conf->basic_rates;
+			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
+									 rates);
+			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+
+			/* by default, use 11b rates */
+			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
+			ret = wl1271_acx_sta_rate_policies(wl);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
 	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
 	if (ret < 0)
 		goto out;
-- 
1.7.0.4


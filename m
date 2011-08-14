Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1HNKSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:01 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967085wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:01 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 30/40] wl12xx: AP-mode - configure HT rate support to the FW
Date: Sun, 14 Aug 2011 13:17:29 +0300
Message-Id: <1313317059-16567-31-git-send-email-eliad@wizery.com> (sfid-20110814_121805_968976_D5D76D86)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Unconditionally configure HT rate support to the FW on all ACs
when starting the AP.

When 11n support is disabled by usermode (hostapd), each STA joining
the AP will appear as a non-HT STA. This will stop us from accidentally
transmitting using MCS rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |    5 +++++
 drivers/net/wireless/wl12xx/init.c |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 76b5c62..82f205c 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -438,12 +438,17 @@ struct conf_rx_settings {
 
 #define CONF_TX_OFDM_RATES (CONF_HW_BIT_RATE_6MBPS |             \
 	CONF_HW_BIT_RATE_12MBPS | CONF_HW_BIT_RATE_24MBPS |      \
 	CONF_HW_BIT_RATE_36MBPS | CONF_HW_BIT_RATE_48MBPS |      \
 	CONF_HW_BIT_RATE_54MBPS)
 
+#define CONF_TX_MCS_RATES (CONF_HW_BIT_RATE_MCS_0 |              \
+	CONF_HW_BIT_RATE_MCS_1 | CONF_HW_BIT_RATE_MCS_2 |        \
+	CONF_HW_BIT_RATE_MCS_3 | CONF_HW_BIT_RATE_MCS_4 |        \
+	CONF_HW_BIT_RATE_MCS_5 | CONF_HW_BIT_RATE_MCS_6 |        \
+	CONF_HW_BIT_RATE_MCS_7)
 
 /*
  * Default rates for management traffic when operating in AP mode. This
  * should be configured according to the basic rate set of the AP
  */
 #define CONF_TX_AP_DEFAULT_MGMT_RATES  (CONF_HW_BIT_RATE_1MBPS | \
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index a374c21..b13bebe 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -512,12 +512,15 @@ int wl1271_init_ap_rates(struct wl1271 *wl)
 	 */
 	if ((wl->basic_rate_set & CONF_TX_OFDM_RATES))
 		supported_rates = CONF_TX_OFDM_RATES;
 	else
 		supported_rates = CONF_TX_AP_ENABLED_RATES;
 
+	/* unconditionally enable HT rates */
+	supported_rates |= CONF_TX_MCS_RATES;
+
 	/* configure unicast TX rate classes */
 	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
 		rc.enabled_rates = supported_rates;
 		rc.short_retry_limit = 10;
 		rc.long_retry_limit = 10;
 		rc.aflags = 0;
-- 
1.7.6.401.g6a319


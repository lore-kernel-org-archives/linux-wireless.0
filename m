Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2EJJPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:04 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 15/78] wl18xx: define HW-rate translation elements/tables
Date: Thu, 10 May 2012 12:13:20 +0300
Message-Id: <1336641263-5761-16-git-send-email-arik@wizery.com> (sfid-20120510_111511_058473_E21C2480)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define HW-rate conversion tables for the 18xx chip. Initialize
the appropriate wlcore elements with these tables and values to allow
conversion of HW-rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |  115 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h |   10 ++-
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0a5422c..7dcb832 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -37,6 +37,118 @@
 #define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
 #define WL18XX_TX_HW_BLOCK_SIZE         268
 
+static const u8 wl18xx_rate_to_idx_2ghz[] = {
+	/* MCS rates are used only with 11n */
+	15,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
+	14,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS14 */
+	13,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS13 */
+	12,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS12 */
+	11,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS11 */
+	10,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS10 */
+	9,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS9 */
+	8,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS8 */
+	7,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS7 */
+	6,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS6 */
+	5,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS5 */
+	4,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS4 */
+	3,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS3 */
+	2,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS2 */
+	1,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS1 */
+	0,                             /* WL18XX_CONF_HW_RXTX_RATE_MCS0 */
+
+	11,                            /* WL18XX_CONF_HW_RXTX_RATE_54   */
+	10,                            /* WL18XX_CONF_HW_RXTX_RATE_48   */
+	9,                             /* WL18XX_CONF_HW_RXTX_RATE_36   */
+	8,                             /* WL18XX_CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_22   */
+
+	7,                             /* WL18XX_CONF_HW_RXTX_RATE_18   */
+	6,                             /* WL18XX_CONF_HW_RXTX_RATE_12   */
+	3,                             /* WL18XX_CONF_HW_RXTX_RATE_11   */
+	5,                             /* WL18XX_CONF_HW_RXTX_RATE_9    */
+	4,                             /* WL18XX_CONF_HW_RXTX_RATE_6    */
+	2,                             /* WL18XX_CONF_HW_RXTX_RATE_5_5  */
+	1,                             /* WL18XX_CONF_HW_RXTX_RATE_2    */
+	0                              /* WL18XX_CONF_HW_RXTX_RATE_1    */
+};
+
+static const u8 wl18xx_rate_to_idx_5ghz[] = {
+	/* MCS rates are used only with 11n */
+	15,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
+	14,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS14 */
+	13,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS13 */
+	12,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS12 */
+	11,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS11 */
+	10,                           /* WL18XX_CONF_HW_RXTX_RATE_MCS10 */
+	9,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS9 */
+	8,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS8 */
+	7,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS7 */
+	6,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS6 */
+	5,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS5 */
+	4,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS4 */
+	3,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS3 */
+	2,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS2 */
+	1,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS1 */
+	0,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS0 */
+
+	7,                             /* WL18XX_CONF_HW_RXTX_RATE_54   */
+	6,                             /* WL18XX_CONF_HW_RXTX_RATE_48   */
+	5,                             /* WL18XX_CONF_HW_RXTX_RATE_36   */
+	4,                             /* WL18XX_CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_22   */
+
+	3,                             /* WL18XX_CONF_HW_RXTX_RATE_18   */
+	2,                             /* WL18XX_CONF_HW_RXTX_RATE_12   */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_11   */
+	1,                             /* WL18XX_CONF_HW_RXTX_RATE_9    */
+	0,                             /* WL18XX_CONF_HW_RXTX_RATE_6    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_5_5  */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_2    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL18XX_CONF_HW_RXTX_RATE_1    */
+};
+
+static const u8 *wl18xx_band_rate_to_idx[] = {
+	[IEEE80211_BAND_2GHZ] = wl18xx_rate_to_idx_2ghz,
+	[IEEE80211_BAND_5GHZ] = wl18xx_rate_to_idx_5ghz
+};
+
+enum wl18xx_hw_rates {
+	WL18XX_CONF_HW_RXTX_RATE_MCS15 = 0,
+	WL18XX_CONF_HW_RXTX_RATE_MCS14,
+	WL18XX_CONF_HW_RXTX_RATE_MCS13,
+	WL18XX_CONF_HW_RXTX_RATE_MCS12,
+	WL18XX_CONF_HW_RXTX_RATE_MCS11,
+	WL18XX_CONF_HW_RXTX_RATE_MCS10,
+	WL18XX_CONF_HW_RXTX_RATE_MCS9,
+	WL18XX_CONF_HW_RXTX_RATE_MCS8,
+	WL18XX_CONF_HW_RXTX_RATE_MCS7,
+	WL18XX_CONF_HW_RXTX_RATE_MCS6,
+	WL18XX_CONF_HW_RXTX_RATE_MCS5,
+	WL18XX_CONF_HW_RXTX_RATE_MCS4,
+	WL18XX_CONF_HW_RXTX_RATE_MCS3,
+	WL18XX_CONF_HW_RXTX_RATE_MCS2,
+	WL18XX_CONF_HW_RXTX_RATE_MCS1,
+	WL18XX_CONF_HW_RXTX_RATE_MCS0,
+	WL18XX_CONF_HW_RXTX_RATE_54,
+	WL18XX_CONF_HW_RXTX_RATE_48,
+	WL18XX_CONF_HW_RXTX_RATE_36,
+	WL18XX_CONF_HW_RXTX_RATE_24,
+	WL18XX_CONF_HW_RXTX_RATE_22,
+	WL18XX_CONF_HW_RXTX_RATE_18,
+	WL18XX_CONF_HW_RXTX_RATE_12,
+	WL18XX_CONF_HW_RXTX_RATE_11,
+	WL18XX_CONF_HW_RXTX_RATE_9,
+	WL18XX_CONF_HW_RXTX_RATE_6,
+	WL18XX_CONF_HW_RXTX_RATE_5_5,
+	WL18XX_CONF_HW_RXTX_RATE_2,
+	WL18XX_CONF_HW_RXTX_RATE_1,
+	WL18XX_CONF_HW_RXTX_RATE_MAX,
+};
+
 static struct wl18xx_conf wl18xx_default_conf = {
 	.phy = {
 		.phy_standalone			= 0x00,
@@ -363,6 +475,9 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->num_tx_desc = 32;
 	wl->normal_tx_spare = WL18XX_TX_HW_BLOCK_SPARE;
 	wl->gem_tx_spare = WL18XX_TX_HW_GEM_BLOCK_SPARE;
+	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
+	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
+	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index fef0db4..0798c1e 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -45,7 +45,15 @@ enum {
 	CONF_HW_BIT_RATE_MCS_4   = BIT(17),
 	CONF_HW_BIT_RATE_MCS_5   = BIT(18),
 	CONF_HW_BIT_RATE_MCS_6   = BIT(19),
-	CONF_HW_BIT_RATE_MCS_7   = BIT(20)
+	CONF_HW_BIT_RATE_MCS_7   = BIT(20),
+	CONF_HW_BIT_RATE_MCS_8   = BIT(21),
+	CONF_HW_BIT_RATE_MCS_9   = BIT(22),
+	CONF_HW_BIT_RATE_MCS_10  = BIT(23),
+	CONF_HW_BIT_RATE_MCS_11  = BIT(24),
+	CONF_HW_BIT_RATE_MCS_12  = BIT(25),
+	CONF_HW_BIT_RATE_MCS_13  = BIT(26),
+	CONF_HW_BIT_RATE_MCS_14  = BIT(27),
+	CONF_HW_BIT_RATE_MCS_15  = BIT(28),
 };
 
 enum {
-- 
1.7.9.5


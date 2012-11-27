Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2K0GpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:11 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2666942wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:10 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Yair Shapira <yair.shapira@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/20] wl18xx: support 2nd set of mac/phy tx-power params
Date: Tue, 27 Nov 2012 08:44:43 +0200
Message-Id: <1353998701-18171-3-git-send-email-arik@wizery.com> (sfid-20121127_074610_220651_1D6A727E)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

First set (low, medium and high TX power values) is used
for STA-HP background role. The 2nd set is used for other roles.

Update other mac/phy parameters according to new FW.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |   10 +++++++---
 drivers/net/wireless/ti/wl18xx/main.c |   35 +++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index f020c1c..4e1313b 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,7 +23,7 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0004)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0005)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
@@ -78,15 +78,19 @@ struct wl18xx_mac_and_phy_params {
 	u8 board_type;
 	/* enable point saturation */
 	u8 psat;
-	/* low/medium/high Tx power in dBm */
+	/* low/medium/high Tx power in dBm for STA-HP BG */
 	s8 low_power_val;
 	s8 med_power_val;
 	s8 high_power_val;
 	s8 per_sub_band_tx_trace_loss[NUM_OF_TRACE_LOSS_GAPS_TX];
 	s8 per_sub_band_rx_trace_loss[NUM_OF_TRACE_LOSS_GAPS_RX];
 	u8 tx_rf_margin;
+	/* low/medium/high Tx power in dBm for other role */
+	s8 low_power_val_2nd;
+	s8 med_power_val_2nd;
+	s8 high_power_val_2nd;
 
-	u8 padding[4];
+	u8 padding[1];
 } __packed;
 
 enum wl18xx_ht_mode {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 30222cb..617e8d1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -523,14 +523,37 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.enable_clpc			= 0x00,
 		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
 		.rx_profile			= 0x00,
-		.pwr_limit_reference_11_abg	= 0xc8,
-		.pwr_limit_reference_11p	= 0xc8,
+		.pwr_limit_reference_11_abg	= 0x64,
+		.per_chan_pwr_limit_arr_11abg	= {
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
+		.pwr_limit_reference_11p	= 0x64,
+		.per_chan_pwr_limit_arr_11p	= { 0xff, 0xff, 0xff, 0xff,
+						    0xff, 0xff, 0xff },
 		.psat				= 0,
-		.low_power_val			= 0x00,
-		.med_power_val			= 0x0A,
-		.high_power_val			= 0x11,
+		.low_power_val			= 0x08,
+		.med_power_val			= 0x12,
+		.high_power_val			= 0x18,
+		.low_power_val_2nd		= 0x05,
+		.med_power_val_2nd		= 0x0A,
+		.high_power_val_2nd		= 0x14,
 		.external_pa_dc2dc		= 0,
-		.number_of_assembled_ant2_4	= 1,
+		.number_of_assembled_ant2_4	= 2,
 		.number_of_assembled_ant5	= 1,
 		.tx_rf_margin			= 1,
 	},
-- 
1.7.9.5


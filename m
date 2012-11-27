Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2K0GpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:09 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:08 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/20] wl18xx: update default mac/phy parameters
Date: Tue, 27 Nov 2012 08:44:42 +0200
Message-Id: <1353998701-18171-2-git-send-email-arik@wizery.com> (sfid-20121127_074517_986831_641BABD5)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

Update mac/phy paramters according to the default HP SISO boards.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |   17 +++++++++++------
 drivers/net/wireless/ti/wl18xx/main.c |    7 ++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index 4d426cc..f020c1c 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,20 +23,21 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0003)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0004)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
 
 #define NUM_OF_CHANNELS_11_ABG 150
 #define NUM_OF_CHANNELS_11_P 7
-#define WL18XX_NUM_OF_SUB_BANDS 9
 #define SRF_TABLE_LEN 16
 #define PIN_MUXING_SIZE 2
+#define NUM_OF_TRACE_LOSS_GAPS_TX 10
+#define NUM_OF_TRACE_LOSS_GAPS_RX 18
 
 struct wl18xx_mac_and_phy_params {
 	u8 phy_standalone;
-	u8 rdl;
+	u8 spare0;
 	u8 enable_clpc;
 	u8 enable_tx_low_pwr_on_siso_rdl;
 	u8 auto_detect;
@@ -69,8 +70,8 @@ struct wl18xx_mac_and_phy_params {
 	u8 pwr_limit_reference_11_abg;
 	u8 per_chan_pwr_limit_arr_11p[NUM_OF_CHANNELS_11_P];
 	u8 pwr_limit_reference_11p;
-	u8 per_sub_band_tx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
-	u8 per_sub_band_rx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
+	u8 spare1[9];
+	u8 spare2[9];
 	u8 primary_clock_setting_time;
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
@@ -81,7 +82,11 @@ struct wl18xx_mac_and_phy_params {
 	s8 low_power_val;
 	s8 med_power_val;
 	s8 high_power_val;
-	u8 padding[1];
+	s8 per_sub_band_tx_trace_loss[NUM_OF_TRACE_LOSS_GAPS_TX];
+	s8 per_sub_band_rx_trace_loss[NUM_OF_TRACE_LOSS_GAPS_RX];
+	u8 tx_rf_margin;
+
+	u8 padding[4];
 } __packed;
 
 enum wl18xx_ht_mode {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e71e2cf..30222cb 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -508,7 +508,6 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.clock_valid_on_wake_up		= 0x00,
 		.secondary_clock_setting_time	= 0x05,
 		.board_type 			= BOARD_TYPE_HDK_18XX,
-		.rdl				= 0x01,
 		.auto_detect			= 0x00,
 		.dedicated_fem			= FEM_NONE,
 		.low_band_component		= COMPONENT_3_WAY_SWITCH,
@@ -525,13 +524,15 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
 		.rx_profile			= 0x00,
 		.pwr_limit_reference_11_abg	= 0xc8,
+		.pwr_limit_reference_11p	= 0xc8,
 		.psat				= 0,
 		.low_power_val			= 0x00,
-		.med_power_val			= 0x0a,
-		.high_power_val			= 0x1e,
+		.med_power_val			= 0x0A,
+		.high_power_val			= 0x11,
 		.external_pa_dc2dc		= 0,
 		.number_of_assembled_ant2_4	= 1,
 		.number_of_assembled_ant5	= 1,
+		.tx_rf_margin			= 1,
 	},
 };
 
-- 
1.7.9.5


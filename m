Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39359 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IIJYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:24:52 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so2575702wgh.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/13] wl18xx: default config alignment with phy defaults
Date: Mon,  9 Sep 2013 12:24:32 +0300
Message-Id: <1378718684-14430-1-git-send-email-eliad@wizery.com> (sfid-20130909_112456_464557_BA2D01B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Driver default config is aligned with phy default parameters.

Now that RDL1_3 has 2 antennas defined by default we need to explicitly
define ht.mode to HT_MODE_WIDE to have SISO40 as default.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index aef0c91..7302308 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -505,7 +505,7 @@ static struct wlcore_conf wl18xx_conf = {
 
 static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 	.ht = {
-		.mode				= HT_MODE_DEFAULT,
+		.mode				= HT_MODE_WIDE,
 	},
 	.phy = {
 		.phy_standalone			= 0x00,
@@ -516,7 +516,7 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.auto_detect			= 0x00,
 		.dedicated_fem			= FEM_NONE,
 		.low_band_component		= COMPONENT_3_WAY_SWITCH,
-		.low_band_component_type	= 0x04,
+		.low_band_component_type	= 0x05,
 		.high_band_component		= COMPONENT_2_WAY_SWITCH,
 		.high_band_component_type	= 0x09,
 		.tcxo_ldo_voltage		= 0x00,
@@ -556,15 +556,15 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.per_chan_pwr_limit_arr_11p	= { 0xff, 0xff, 0xff, 0xff,
 						    0xff, 0xff, 0xff },
 		.psat				= 0,
-		.low_power_val			= 0x08,
-		.med_power_val			= 0x12,
-		.high_power_val			= 0x18,
-		.low_power_val_2nd		= 0x05,
-		.med_power_val_2nd		= 0x0a,
-		.high_power_val_2nd		= 0x14,
 		.external_pa_dc2dc		= 0,
 		.number_of_assembled_ant2_4	= 2,
 		.number_of_assembled_ant5	= 1,
+		.low_power_val			= 0xff,
+		.med_power_val			= 0xff,
+		.high_power_val			= 0xff,
+		.low_power_val_2nd		= 0xff,
+		.med_power_val_2nd		= 0xff,
+		.high_power_val_2nd		= 0xff,
 		.tx_rf_margin			= 1,
 	},
 };
-- 
1.8.3.rc1.35.g9b79519


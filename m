Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63494 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762362AbZLKLlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:36 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/31] wl1271: update radio and general parameters values
Date: Fri, 11 Dec 2009 13:40:54 +0200
Message-Id: <1260531682-4695-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were some changes in the values we have to use for these settings.  This
patches updates them.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7ab45c4..1d5b73c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -256,7 +256,7 @@ static struct conf_drv_settings default_conf = {
 			.clk_valid_on_wakeup = 0,
 			.dc2dcmode           = 0,
 			.single_dual_band    = CONF_SINGLE_BAND,
-			.tx_bip_fem_autodetect = 0,
+			.tx_bip_fem_autodetect = 1,
 			.tx_bip_fem_manufacturer = 1,
 			.settings = 1,
 			.sr_state = 1,
@@ -274,8 +274,8 @@ static struct conf_drv_settings default_conf = {
 			.sr_sen_prn = 0,
 		},
 		.radioparam = {
-			.rx_trace_loss       = 10,
-			.tx_trace_loss       = 10,
+			.rx_trace_loss       = 0x24,
+			.tx_trace_loss       = 0x0,
 			.rx_rssi_and_proc_compens = {
 				0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
 				0xfc, 0x00, 0x08, 0x10, 0xf0, 0xf8,
@@ -286,13 +286,13 @@ static struct conf_drv_settings default_conf = {
 				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				0x00, 0x00, 0x00 },
-			.tx_ref_pd_voltage   = 0x24e,
-			.tx_ref_power        = 0x78,
+			.tx_ref_pd_voltage   = 0x1a9,
+			.tx_ref_power        = 0x80,
 			.tx_offset_db        = 0x0,
 			.tx_rate_limits_normal = {
-				0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 },
+				0x1d, 0x1f, 0x24, 0x28, 0x28, 0x29 },
 			.tx_rate_limits_degraded = {
-				0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
+				0x19, 0x1f, 0x22, 0x23, 0x27, 0x28 },
 			.tx_channel_limits_11b = {
 				0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
 				0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
@@ -302,10 +302,10 @@ static struct conf_drv_settings default_conf = {
 				0x50, 0x50, 0x50, 0x50, 0x20, 0x50,
 				0x20, 0x50 },
 			.tx_pdv_rate_offsets = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				0x07, 0x08, 0x04, 0x02, 0x02, 0x00 },
 			.tx_ibias            = {
-				0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 },
-			.rx_fem_insertion_loss = 0x14,
+				0x11, 0x11, 0x15, 0x11, 0x15, 0x0f },
+			.rx_fem_insertion_loss = 0x0e,
 			.tx_ref_pd_voltage_5 = {
 				0x0190, 0x01a4, 0x01c3, 0x01d8,
 				0x020a, 0x021c },
-- 
1.6.3.3


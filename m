Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50869 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760919AbZLKLmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:31 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/31] wl1271: added radio parameters configuration values newer firmwares
Date: Fri, 11 Dec 2009 13:40:55 +0200
Message-Id: <1260531682-4695-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new radio parameters for new structures based on firmware revision
6.1.0.0.288.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   13 +++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |   17 +++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_main.c |   10 +++++++++-
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index fe9b187..57c2145 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -273,6 +273,8 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	       CONF_NUMBER_OF_RATE_GROUPS);
 	memcpy(radio_parms->tx_rate_limits_degraded, r->tx_rate_limits_degraded,
 	       CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_rate_limits_extreme, r->tx_rate_limits_extreme,
+	       CONF_NUMBER_OF_RATE_GROUPS);
 
 	memcpy(radio_parms->tx_channel_limits_11b, r->tx_channel_limits_11b,
 	       CONF_NUMBER_OF_CHANNELS_2_4);
@@ -283,6 +285,11 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	memcpy(radio_parms->tx_ibias, r->tx_ibias, CONF_NUMBER_OF_RATE_GROUPS);
 
 	radio_parms->rx_fem_insertion_loss = r->rx_fem_insertion_loss;
+	radio_parms->degraded_low_to_normal_threshold =
+		r->degraded_low_to_normal_threshold;
+	radio_parms->degraded_normal_to_high_threshold =
+		r->degraded_normal_to_high_threshold;
+
 
 	for (i = 0; i < CONF_NUMBER_OF_SUB_BANDS_5; i++)
 		radio_parms->tx_ref_pd_voltage_5[i] =
@@ -295,6 +302,8 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	       r->tx_rate_limits_normal_5, CONF_NUMBER_OF_RATE_GROUPS);
 	memcpy(radio_parms->tx_rate_limits_degraded_5,
 	       r->tx_rate_limits_degraded_5, CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_rate_limits_extreme_5,
+	       r->tx_rate_limits_extreme_5, CONF_NUMBER_OF_RATE_GROUPS);
 	memcpy(radio_parms->tx_channel_limits_ofdm_5,
 	       r->tx_channel_limits_ofdm_5, CONF_NUMBER_OF_CHANNELS_5);
 	memcpy(radio_parms->tx_pdv_rate_offsets_5, r->tx_pdv_rate_offsets_5,
@@ -303,6 +312,10 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	       CONF_NUMBER_OF_RATE_GROUPS);
 	memcpy(radio_parms->rx_fem_insertion_loss_5,
 	       r->rx_fem_insertion_loss_5, CONF_NUMBER_OF_SUB_BANDS_5);
+	radio_parms->degraded_low_to_normal_threshold_5 =
+		r->degraded_low_to_normal_threshold_5;
+	radio_parms->degraded_normal_to_high_threshold_5 =
+		r->degraded_normal_to_high_threshold_5;
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
 		    radio_parms, sizeof(*radio_parms));
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 5e36cd9..a4bd35b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -864,12 +864,13 @@ struct conf_radio_parms {
 	 *
 	 * Range: unknown
 	 */
-	s16 tx_ref_pd_voltage;
-	s8  tx_ref_power;
+	u16 tx_ref_pd_voltage;
+	u8  tx_ref_power;
 	s8  tx_offset_db;
 
 	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_extreme[CONF_NUMBER_OF_RATE_GROUPS];
 
 	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
 	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
@@ -878,17 +879,22 @@ struct conf_radio_parms {
 	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
 	u8  rx_fem_insertion_loss;
 
+	u8  degraded_low_to_normal_threshold;
+	u8  degraded_normal_to_high_threshold;
+
+
 	/*
 	 * Dynamic radio parameters for 5GHz
 	 *
 	 * Range: unknown
 	 */
-	s16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
 	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
 	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_extreme_5[CONF_NUMBER_OF_RATE_GROUPS];
 
 	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
 	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
@@ -896,6 +902,9 @@ struct conf_radio_parms {
 	/* FIXME: this is inconsistent with the types for 2.4GHz */
 	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+
+	u8  degraded_low_to_normal_threshold_5;
+	u8  degraded_normal_to_high_threshold_5;
 };
 
 #define CONF_SR_ERR_TBL_COUNT        3
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 1d5b73c..f1cb7cb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -293,6 +293,8 @@ static struct conf_drv_settings default_conf = {
 				0x1d, 0x1f, 0x24, 0x28, 0x28, 0x29 },
 			.tx_rate_limits_degraded = {
 				0x19, 0x1f, 0x22, 0x23, 0x27, 0x28 },
+			.tx_rate_limits_extreme = {
+				0x19, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
 			.tx_channel_limits_11b = {
 				0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
 				0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
@@ -306,6 +308,8 @@ static struct conf_drv_settings default_conf = {
 			.tx_ibias            = {
 				0x11, 0x11, 0x15, 0x11, 0x15, 0x0f },
 			.rx_fem_insertion_loss = 0x0e,
+			.degraded_low_to_normal_threshold = 0x1e,
+			.degraded_normal_to_high_threshold = 0x2d,
 			.tx_ref_pd_voltage_5 = {
 				0x0190, 0x01a4, 0x01c3, 0x01d8,
 				0x020a, 0x021c },
@@ -317,6 +321,8 @@ static struct conf_drv_settings default_conf = {
 				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
 			.tx_rate_limits_degraded_5 = {
 				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
+			.tx_rate_limits_extreme_5 = {
+				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
 			.tx_channel_limits_ofdm_5 = {
 				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
 				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
@@ -328,7 +334,9 @@ static struct conf_drv_settings default_conf = {
 			.tx_ibias_5          = {
 				0x10, 0x10, 0x10, 0x10, 0x10, 0x10 },
 			.rx_fem_insertion_loss_5 = {
-				0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 }
+				0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 },
+			.degraded_low_to_normal_threshold_5 = 0x00,
+			.degraded_normal_to_high_threshold_5 = 0x00
 		}
 	}
 };
-- 
1.6.3.3


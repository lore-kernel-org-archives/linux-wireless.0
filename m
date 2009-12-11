Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61298 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZLKNlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:16 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 01/31] wl1271: updated radio parameters structure for newer firmwares
Date: Fri, 11 Dec 2009 15:40:40 +0200
Message-Id: <1260538870-32297-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In revision 6.1.0.0.288 the radio parameters structure has changed.  This
patch updates the driver code accordingly.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index b4fa4ac..de23c08 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -458,11 +458,12 @@ struct wl1271_radio_parms_cmd {
 	/* Dynamic radio parameters */
 	/* 2.4GHz */
 	__le16 tx_ref_pd_voltage;
-	s8  tx_ref_power;
+	u8  tx_ref_power;
 	s8  tx_offset_db;
 
 	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_extreme[CONF_NUMBER_OF_RATE_GROUPS];
 
 	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
 	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
@@ -471,15 +472,19 @@ struct wl1271_radio_parms_cmd {
 	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
 	u8  rx_fem_insertion_loss;
 
-	u8 padding2;
+	u8  degraded_low_to_normal_threshold;
+	u8  degraded_normal_to_high_threshold;
+
+	u8  padding1; /* our own padding, not in ref driver */
 
 	/* 5GHz */
 	__le16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
 	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
 	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_extreme_5[CONF_NUMBER_OF_RATE_GROUPS];
 
 	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
 	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
@@ -488,7 +493,10 @@ struct wl1271_radio_parms_cmd {
 	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
 	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
-	u8 padding3[2];
+	u8  degraded_low_to_normal_threshold_5;
+	u8  degraded_normal_to_high_threshold_5;
+
+	u8 padding2[2];
 } __attribute__ ((packed));
 
 struct wl1271_cmd_cal_channel_tune {
-- 
1.6.3.3


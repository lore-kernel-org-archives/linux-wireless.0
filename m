Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63484 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762371AbZLKLle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:34 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/31] wl1271: updated general parameters structure for newer firmwares
Date: Fri, 11 Dec 2009 13:40:53 +0200
Message-Id: <1260531682-4695-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In revision 6.1.0.0.288 the general parameters structure has changed.  This
patch updates the driver code accordingly.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   20 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |   15 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |   17 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   13 +++++++++++++
 4 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 886a9bc..fe9b187 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -209,6 +209,26 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	gen_parms->tx_bip_fem_manufacturer = g->tx_bip_fem_manufacturer;
 	gen_parms->settings = g->settings;
 
+	gen_parms->sr_state = g->sr_state;
+
+	memcpy(gen_parms->srf1,
+	       g->srf1,
+	       CONF_MAX_SMART_REFLEX_PARAMS);
+	memcpy(gen_parms->srf2,
+	       g->srf2,
+	       CONF_MAX_SMART_REFLEX_PARAMS);
+	memcpy(gen_parms->srf3,
+	       g->srf3,
+	       CONF_MAX_SMART_REFLEX_PARAMS);
+	memcpy(gen_parms->sr_debug_table,
+	       g->sr_debug_table,
+	       CONF_MAX_SMART_REFLEX_PARAMS);
+
+	gen_parms->sr_sen_n_p = g->sr_sen_n_p;
+	gen_parms->sr_sen_n_p_gain = g->sr_sen_n_p_gain;
+	gen_parms->sr_sen_nrn = g->sr_sen_nrn;
+	gen_parms->sr_sen_prn = g->sr_sen_prn;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
 	if (ret < 0)
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index de23c08..057f925 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -437,6 +437,21 @@ struct wl1271_general_parms_cmd {
 	u8 tx_bip_fem_autodetect;
 	u8 tx_bip_fem_manufacturer;
 	u8 settings;
+
+	u8 sr_state;
+
+	s8 srf1[CONF_MAX_SMART_REFLEX_PARAMS];
+	s8 srf2[CONF_MAX_SMART_REFLEX_PARAMS];
+	s8 srf3[CONF_MAX_SMART_REFLEX_PARAMS];
+
+	s8 sr_debug_table[CONF_MAX_SMART_REFLEX_PARAMS];
+
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
+
+	u8 padding[3];
 } __attribute__ ((packed));
 
 struct wl1271_radio_parms_cmd {
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 565373e..5e36cd9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -759,6 +759,9 @@ enum single_dual_band_enum {
 	CONF_DUAL_BAND
 };
 
+
+#define CONF_MAX_SMART_REFLEX_PARAMS 16
+
 struct conf_general_parms {
 	/*
 	 * RF Reference Clock type / speed
@@ -815,6 +818,20 @@ struct conf_general_parms {
 	 * Range: Unknown
 	 */
 	u8 settings;
+
+	/* Smart reflex settings */
+	u8 sr_state;
+
+	s8 srf1[CONF_MAX_SMART_REFLEX_PARAMS];
+	s8 srf2[CONF_MAX_SMART_REFLEX_PARAMS];
+	s8 srf3[CONF_MAX_SMART_REFLEX_PARAMS];
+
+	s8 sr_debug_table[CONF_MAX_SMART_REFLEX_PARAMS];
+
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
 };
 
 #define CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE 15
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b62c00f..7ab45c4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -259,6 +259,19 @@ static struct conf_drv_settings default_conf = {
 			.tx_bip_fem_autodetect = 0,
 			.tx_bip_fem_manufacturer = 1,
 			.settings = 1,
+			.sr_state = 1,
+			.srf1 = { 0, 0, 0, 0, 0, 0, 0, 0,
+				  0, 0, 0, 0, 0, 0, 0, 0 },
+			.srf2 = { 0, 0, 0, 0, 0, 0, 0, 0,
+				  0, 0, 0, 0, 0, 0, 0, 0 },
+			.srf3 = { 0, 0, 0, 0, 0, 0, 0, 0,
+				  0, 0, 0, 0, 0, 0, 0, 0 },
+			.sr_debug_table = { 0, 0, 0, 0, 0, 0, 0, 0,
+					    0, 0, 0, 0, 0, 0, 0, 0 },
+			.sr_sen_n_p = 0,
+			.sr_sen_n_p_gain = 0,
+			.sr_sen_nrn = 0,
+			.sr_sen_prn = 0,
 		},
 		.radioparam = {
 			.rx_trace_loss       = 10,
-- 
1.6.3.3


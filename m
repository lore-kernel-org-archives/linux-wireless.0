Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42785 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636Ab2FHGbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:11 -0400
Received: by lagw12 with SMTP id w12so1050260lag.24
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:08 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/5] wl18xx: align wl18xx_conf_phy with FW variant and remove it
Date: Fri,  8 Jun 2012 09:30:53 +0300
Message-Id: <1339137055-30095-4-git-send-email-coelho@ti.com> (sfid-20120608_083117_088127_2CFC2BC8)
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

wl18xx_conf_phy represents part of the FW native wl18xx_mac_and_phy_params
structure. Remove it and replace the phy part of the wl18xx conf with the
FW bound structure. This allows us to set/override all members.

Increment the wlconf version to ensure compatibility with the new
structure

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |   37 ++++++++++++++++++---
 drivers/net/wireless/ti/wl18xx/main.c |   52 ++----------------------------
 drivers/net/wireless/ti/wl18xx/reg.h  |   57 ---------------------------------
 3 files changed, 36 insertions(+), 110 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index 130546a..fac0b7e 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,41 +23,70 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0001)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0002)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
 
-struct wl18xx_conf_phy {
+#define NUM_OF_CHANNELS_11_ABG 150
+#define NUM_OF_CHANNELS_11_P 7
+#define WL18XX_NUM_OF_SUB_BANDS 9
+#define SRF_TABLE_LEN 16
+#define PIN_MUXING_SIZE 2
+
+struct wl18xx_mac_and_phy_params {
 	u8 phy_standalone;
 	u8 rdl;
 	u8 enable_clpc;
 	u8 enable_tx_low_pwr_on_siso_rdl;
 	u8 auto_detect;
 	u8 dedicated_fem;
+
 	u8 low_band_component;
+
+	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
 	u8 low_band_component_type;
+
 	u8 high_band_component;
+
+	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
 	u8 high_band_component_type;
+	u8 number_of_assembled_ant2_4;
+	u8 number_of_assembled_ant5;
+	u8 pin_muxing_platform_options[PIN_MUXING_SIZE];
+	u8 external_pa_dc2dc;
 	u8 tcxo_ldo_voltage;
 	u8 xtal_itrim_val;
 	u8 srf_state;
+	u8 srf1[SRF_TABLE_LEN];
+	u8 srf2[SRF_TABLE_LEN];
+	u8 srf3[SRF_TABLE_LEN];
 	u8 io_configuration;
 	u8 sdio_configuration;
 	u8 settings;
 	u8 rx_profile;
+	u8 per_chan_pwr_limit_arr_11abg[NUM_OF_CHANNELS_11_ABG];
+	u8 pwr_limit_reference_11_abg;
+	u8 per_chan_pwr_limit_arr_11p[NUM_OF_CHANNELS_11_P];
+	u8 pwr_limit_reference_11p;
+	u8 per_sub_band_tx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
+	u8 per_sub_band_rx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
 	u8 primary_clock_setting_time;
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
-	u8 pwr_limit_reference_11_abg;
+	u8 board_type;
+	/* enable point saturation */
 	u8 psat;
+	/* low/medium/high Tx power in dBm */
 	s8 low_power_val;
 	s8 med_power_val;
 	s8 high_power_val;
+	u8 padding[1];
 } __packed;
 
 struct wl18xx_priv_conf {
-	struct wl18xx_conf_phy phy;
+	/* this structure is copied wholesale to FW */
+	struct wl18xx_mac_and_phy_params phy;
 } __packed;
 
 #endif /* __WL18XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c26015b..78b2e54 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -716,63 +716,17 @@ static void wl18xx_pre_upload(struct wl1271 *wl)
 static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
-	struct wl18xx_conf_phy *phy = &priv->conf.phy;
-	struct wl18xx_mac_and_phy_params params;
 	size_t len;
 
-	memset(&params, 0, sizeof(params));
-
-	params.phy_standalone = phy->phy_standalone;
-	params.rdl = phy->rdl;
-	params.enable_clpc = phy->enable_clpc;
-	params.enable_tx_low_pwr_on_siso_rdl =
-		phy->enable_tx_low_pwr_on_siso_rdl;
-	params.auto_detect = phy->auto_detect;
-	params.dedicated_fem = phy->dedicated_fem;
-	params.low_band_component = phy->low_band_component;
-	params.low_band_component_type =
-		phy->low_band_component_type;
-	params.high_band_component = phy->high_band_component;
-	params.high_band_component_type =
-		phy->high_band_component_type;
-	params.number_of_assembled_ant2_4 =
-		n_antennas_2_param;
-	params.number_of_assembled_ant5 =
-		n_antennas_5_param;
-	params.external_pa_dc2dc = dc2dc_param;
-	params.tcxo_ldo_voltage = phy->tcxo_ldo_voltage;
-	params.xtal_itrim_val = phy->xtal_itrim_val;
-	params.srf_state = phy->srf_state;
-	params.io_configuration = phy->io_configuration;
-	params.sdio_configuration = phy->sdio_configuration;
-	params.settings = phy->settings;
-	params.rx_profile = phy->rx_profile;
-	params.primary_clock_setting_time =
-		phy->primary_clock_setting_time;
-	params.clock_valid_on_wake_up =
-		phy->clock_valid_on_wake_up;
-	params.secondary_clock_setting_time =
-		phy->secondary_clock_setting_time;
-	params.pwr_limit_reference_11_abg =
-		phy->pwr_limit_reference_11_abg;
-
-	params.board_type = priv->board_type;
-
-	/* for PG2 only */
-	params.psat = phy->psat;
-	params.low_power_val = phy->low_power_val;
-	params.med_power_val = phy->med_power_val;
-	params.high_power_val = phy->high_power_val;
-
 	/* the parameters struct is smaller for PG1 */
 	if (wl->chip.id == CHIP_ID_185x_PG10)
 		len = offsetof(struct wl18xx_mac_and_phy_params, psat) + 1;
 	else
-		len = sizeof(params);
+		len = sizeof(struct wl18xx_mac_and_phy_params);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
-	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&params,
-		     len, false);
+	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy, len,
+		     false);
 }
 
 static void wl18xx_enable_interrupts(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index a824b26..937b71d 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -164,13 +164,6 @@
  */
 #define WL18XX_SCR_PAD8_PLT	0xBABABEBE
 
-/* TODO: maybe move elsewhere? */
-#define NUM_OF_CHANNELS_11_ABG 150
-#define NUM_OF_CHANNELS_11_P 7
-#define WL18XX_NUM_OF_SUB_BANDS 9
-#define SRF_TABLE_LEN 16
-#define PIN_MUXING_SIZE 2
-
 enum {
 	COMPONENT_NO_SWITCH	= 0x0,
 	COMPONENT_2_WAY_SWITCH	= 0x1,
@@ -195,54 +188,4 @@ enum {
 	NUM_BOARD_TYPES,
 };
 
-struct wl18xx_mac_and_phy_params {
-	u8 phy_standalone;
-	u8 rdl;
-	u8 enable_clpc;
-	u8 enable_tx_low_pwr_on_siso_rdl;
-	u8 auto_detect;
-	u8 dedicated_fem;
-
-	u8 low_band_component;
-
-	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
-	u8 low_band_component_type;
-
-	u8 high_band_component;
-
-	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
-	u8 high_band_component_type;
-	u8 number_of_assembled_ant2_4;
-	u8 number_of_assembled_ant5;
-	u8 pin_muxing_platform_options[PIN_MUXING_SIZE];
-	u8 external_pa_dc2dc;
-	u8 tcxo_ldo_voltage;
-	u8 xtal_itrim_val;
-	u8 srf_state;
-	u8 srf1[SRF_TABLE_LEN];
-	u8 srf2[SRF_TABLE_LEN];
-	u8 srf3[SRF_TABLE_LEN];
-	u8 io_configuration;
-	u8 sdio_configuration;
-	u8 settings;
-	u8 rx_profile;
-	u8 per_chan_pwr_limit_arr_11abg[NUM_OF_CHANNELS_11_ABG];
-	u8 pwr_limit_reference_11_abg;
-	u8 per_chan_pwr_limit_arr_11p[NUM_OF_CHANNELS_11_P];
-	u8 pwr_limit_reference_11p;
-	u8 per_sub_band_tx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
-	u8 per_sub_band_rx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
-	u8 primary_clock_setting_time;
-	u8 clock_valid_on_wake_up;
-	u8 secondary_clock_setting_time;
-	u8 board_type;
-	/* enable point saturation */
-	u8 psat;
-	/* low/medium/high Tx power in dBm */
-	s8 low_power_val;
-	s8 med_power_val;
-	s8 high_power_val;
-	u8 padding[1];
-} __packed;
-
 #endif /* __REG_H__ */
-- 
1.7.10


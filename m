Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60695 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760432Ab2FGJRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:51 -0400
Received: by laai10 with SMTP id i10so267054laa.41
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:35 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/5] wl18xx: FW/PHY arguments added for PG2
Date: Thu,  7 Jun 2012 12:17:23 +0300
Message-Id: <1339060645-3574-4-git-send-email-coelho@ti.com> (sfid-20120607_111753_685544_A636741B)
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

PG2 requires 4 new parameters that to be passed to the PHY.

Use the actual PHY initialization struct size for the mem size of the
PHY_INIT section, to account for additions in params.

[Make sure PG1 still gets the original struct - Arik]

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |    4 ++++
 drivers/net/wireless/ti/wl18xx/main.c |   19 ++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h  |    6 ++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index ffad302..4e0f189 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -44,6 +44,10 @@ struct wl18xx_conf_phy {
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
 	u8 pwr_limit_reference_11_abg;
+	u8 psat;
+	s8 low_power_val;
+	s8 med_power_val;
+	s8 high_power_val;
 };
 
 struct wl18xx_priv_conf {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 57b4a10..bdf4ee1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -511,6 +511,10 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
 		.rx_profile			= 0x00,
 		.pwr_limit_reference_11_abg	= 0xc8,
+		.psat				= 0,
+		.low_power_val			= 0x00,
+		.med_power_val			= 0x0a,
+		.high_power_val			= 0x1e,
 	},
 };
 
@@ -713,6 +717,7 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 	struct wl18xx_priv *priv = wl->priv;
 	struct wl18xx_conf_phy *phy = &priv->conf.phy;
 	struct wl18xx_mac_and_phy_params params;
+	size_t len;
 
 	memset(&params, 0, sizeof(params));
 
@@ -752,9 +757,21 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 
 	params.board_type = priv->board_type;
 
+	/* for PG2 only */
+	params.psat = phy->psat;
+	params.low_power_val = phy->low_power_val;
+	params.med_power_val = phy->med_power_val;
+	params.high_power_val = phy->high_power_val;
+
+	/* the parameters struct is smaller for PG1 */
+	if (wl->chip.id == CHIP_ID_185x_PG10)
+		len = offsetof(struct wl18xx_mac_and_phy_params, psat) + 1;
+	else
+		len = sizeof(params);
+
 	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
 	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&params,
-		     sizeof(params), false);
+		     len, false);
 }
 
 static void wl18xx_enable_interrupts(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index e81f609..a824b26 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -236,6 +236,12 @@ struct wl18xx_mac_and_phy_params {
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
 	u8 board_type;
+	/* enable point saturation */
+	u8 psat;
+	/* low/medium/high Tx power in dBm */
+	s8 low_power_val;
+	s8 med_power_val;
+	s8 high_power_val;
 	u8 padding[1];
 } __packed;
 
-- 
1.7.10


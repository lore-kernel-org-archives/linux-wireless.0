Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33094 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbbCLMJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:09:35 -0400
Received: by widfb4 with SMTP id fb4so3366399wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 05:09:33 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Luciano Coelho <luca@coelho.fi>
Subject: [PATCH v6 2/6] wl12xx: use frequency instead of enumerations for pdata clocks
Date: Thu, 12 Mar 2015 14:09:10 +0200
Message-Id: <1426162154-8716-3-git-send-email-eliad@wizery.com> (sfid-20150312_131009_179230_A2ACA5D2)
In-Reply-To: <1426162154-8716-1-git-send-email-eliad@wizery.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luca@coelho.fi>

Instead of defining an enumeration with the FW specific values for the
different clock rates, use the actual frequency instead.  Also add a
boolean to specify whether the clock is XTAL or not.

Change all board files to reflect this.

Signed-off-by: Luciano Coelho <luca@coelho.fi>
[Eliad - small fixes, update board file changes]
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |  3 +-
 arch/arm/mach-omap2/pdata-quirks.c      | 29 ++++++++--------
 drivers/net/wireless/ti/wl12xx/main.c   | 60 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/ti/wl12xx/wl12xx.h | 28 +++++++++++++++
 include/linux/wl12xx.h                  | 27 ++-------------
 5 files changed, 103 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 916589c..853b941 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1386,7 +1386,8 @@ static const short da850_wl12xx_pins[] __initconst = {
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
 	.irq_trigger		= IRQ_TYPE_EDGE_RISING,
-	.board_ref_clock	= WL12XX_REFCLOCK_38,
+	.ref_clock_freq		= 38400000,
+	.ref_clock_xtal		= false,
 };
 
 static __init int da850_wl12xx_init(void)
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 4449f4c..337cc22 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -39,14 +39,14 @@ static struct twl4030_gpio_platform_data twl_gpio_auxdata;
 
 static struct wl12xx_platform_data wl12xx __initdata;
 
-static void __init __used legacy_init_wl12xx(unsigned ref_clock,
-					     unsigned tcxo_clock,
+static void __init __used legacy_init_wl12xx(u32 ref_clock_freq,
+					     u32 tcxo_clock_freq,
 					     int gpio)
 {
 	int res;
 
-	wl12xx.board_ref_clock = ref_clock;
-	wl12xx.board_tcxo_clock = tcxo_clock;
+	wl12xx.ref_clock_freq = ref_clock_freq;
+	wl12xx.tcxo_clock_freq = tcxo_clock_freq;
 	wl12xx.irq = gpio_to_irq(gpio);
 	wl12xx.irq_trigger = IRQ_TYPE_LEVEL_HIGH;
 
@@ -57,8 +57,8 @@ static void __init __used legacy_init_wl12xx(unsigned ref_clock,
 	}
 }
 #else
-static inline void legacy_init_wl12xx(unsigned ref_clock,
-				      unsigned tcxo_clock,
+static inline void legacy_init_wl12xx(u32 ref_clock_freq,
+				      u32 tcxo_clock_freq,
 				      int gpio)
 {
 }
@@ -130,7 +130,7 @@ static void __init omap3_sbc_t3730_twl_init(void)
 static void __init omap3_sbc_t3730_legacy_init(void)
 {
 	omap3_sbc_t3x_usb_hub_init(167, "sb-t35 usb hub");
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 136);
+	legacy_init_wl12xx(38400000, 0, 136);
 }
 
 static void __init omap3_sbc_t3530_legacy_init(void)
@@ -174,12 +174,12 @@ static void __init omap3_igep0030_rev_g_legacy_init(void)
 
 static void __init omap3_evm_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 149);
+	legacy_init_wl12xx(38400000, 0, 149);
 }
 
 static void __init omap3_zoom_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_26, 0, 162);
+	legacy_init_wl12xx(26000000, 0, 162);
 }
 
 static void am35xx_enable_emac_int(void)
@@ -246,7 +246,7 @@ static void __init omap3_sbc_t3517_legacy_init(void)
 	am35xx_emac_reset();
 	hsmmc2_internal_input_clk();
 	omap3_sbc_t3517_wifi_init();
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 145);
+	legacy_init_wl12xx(38400000, 0, 145);
 }
 
 static void __init am3517_evm_legacy_init(void)
@@ -291,18 +291,17 @@ static void __init omap3_tao3530_legacy_init(void)
 #ifdef CONFIG_ARCH_OMAP4
 static void __init omap4_sdp_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_26,
-			   WL12XX_TCXOCLOCK_26, 53);
+	legacy_init_wl12xx(26000000, 26000000, 53);
 }
 
 static void __init omap4_panda_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 53);
+	legacy_init_wl12xx(38400000, 0, 53);
 }
 
 static void __init var_som_om44_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 41);
+	legacy_init_wl12xx(38400000, 0, 41);
 }
 #endif
 
@@ -317,7 +316,7 @@ static struct iommu_platform_data omap4_iommu_pdata = {
 #ifdef CONFIG_SOC_AM33XX
 static void __init am335x_evmsk_legacy_init(void)
 {
-	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 31);
+	legacy_init_wl12xx(38400000, 0, 31);
 }
 #endif
 
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 144d1f8..b3f751f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1770,6 +1770,40 @@ wl12xx_iface_combinations[] = {
 	},
 };
 
+static const struct wl12xx_clock wl12xx_refclock_table[] = {
+	{ 19200000,	false,	WL12XX_REFCLOCK_19	},
+	{ 26000000,	false,	WL12XX_REFCLOCK_26	},
+	{ 26000000,	true,	WL12XX_REFCLOCK_26_XTAL	},
+	{ 38400000,	false,	WL12XX_REFCLOCK_38	},
+	{ 38400000,	true,	WL12XX_REFCLOCK_38_XTAL	},
+	{ 52000000,	false,	WL12XX_REFCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static const struct wl12xx_clock wl12xx_tcxoclock_table[] = {
+	{ 16368000,	true,	WL12XX_TCXOCLOCK_16_368	},
+	{ 16800000,	true,	WL12XX_TCXOCLOCK_16_8	},
+	{ 19200000,	true,	WL12XX_TCXOCLOCK_19_2	},
+	{ 26000000,	true,	WL12XX_TCXOCLOCK_26	},
+	{ 32736000,	true,	WL12XX_TCXOCLOCK_32_736	},
+	{ 33600000,	true,	WL12XX_TCXOCLOCK_33_6	},
+	{ 38400000,	true,	WL12XX_TCXOCLOCK_38_4	},
+	{ 52000000,	true,	WL12XX_TCXOCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static int wl12xx_get_clock_idx(const struct wl12xx_clock *table,
+				u32 freq, bool xtal)
+{
+	int i;
+
+	for (i = 0; table[i].freq != 0; i++)
+		if ((table[i].freq == freq) && (table[i].xtal == xtal))
+			return table[i].hw_idx;
+
+	return -EINVAL;
+}
+
 static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1799,7 +1833,17 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl12xx_conf_init(wl);
 
 	if (!fref_param) {
-		priv->ref_clock = pdata->board_ref_clock;
+		priv->ref_clock = wl12xx_get_clock_idx(wl12xx_refclock_table,
+						       pdata->ref_clock_freq,
+						       pdata->ref_clock_xtal);
+		if (priv->ref_clock < 0) {
+			wl1271_error("Invalid ref_clock frequency (%d Hz, %s)",
+				     pdata->ref_clock_freq,
+				     pdata->ref_clock_xtal ?
+				     "XTAL" : "not XTAL");
+
+			return priv->ref_clock;
+		}
 	} else {
 		if (!strcmp(fref_param, "19.2"))
 			priv->ref_clock = WL12XX_REFCLOCK_19;
@@ -1817,9 +1861,17 @@ static int wl12xx_setup(struct wl1271 *wl)
 			wl1271_error("Invalid fref parameter %s", fref_param);
 	}
 
-	if (!tcxo_param) {
-		priv->tcxo_clock = pdata->board_tcxo_clock;
-	} else {
+	if (!tcxo_param && pdata->tcxo_clock_freq) {
+		priv->tcxo_clock = wl12xx_get_clock_idx(wl12xx_tcxoclock_table,
+							pdata->tcxo_clock_freq,
+							true);
+		if (priv->tcxo_clock < 0) {
+			wl1271_error("Invalid tcxo_clock frequency (%d Hz)",
+				     pdata->tcxo_clock_freq);
+
+			return priv->tcxo_clock;
+		}
+	} else if (tcxo_param) {
 		if (!strcmp(tcxo_param, "19.2"))
 			priv->tcxo_clock = WL12XX_TCXOCLOCK_19_2;
 		else if (!strcmp(tcxo_param, "26"))
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 75c9265..5952e99a 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -82,6 +82,34 @@ struct wl12xx_priv {
 	struct wl127x_rx_mem_pool_addr *rx_mem_addr;
 };
 
+/* Reference clock values */
+enum {
+	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
+	WL12XX_REFCLOCK_26	= 1, /* 26 MHz */
+	WL12XX_REFCLOCK_38	= 2, /* 38.4 MHz */
+	WL12XX_REFCLOCK_52	= 3, /* 52 MHz */
+	WL12XX_REFCLOCK_38_XTAL = 4, /* 38.4 MHz, XTAL */
+	WL12XX_REFCLOCK_26_XTAL = 5, /* 26 MHz, XTAL */
+};
+
+/* TCXO clock values */
+enum {
+	WL12XX_TCXOCLOCK_19_2	= 0, /* 19.2MHz */
+	WL12XX_TCXOCLOCK_26	= 1, /* 26 MHz */
+	WL12XX_TCXOCLOCK_38_4	= 2, /* 38.4MHz */
+	WL12XX_TCXOCLOCK_52	= 3, /* 52 MHz */
+	WL12XX_TCXOCLOCK_16_368	= 4, /* 16.368 MHz */
+	WL12XX_TCXOCLOCK_32_736	= 5, /* 32.736 MHz */
+	WL12XX_TCXOCLOCK_16_8	= 6, /* 16.8 MHz */
+	WL12XX_TCXOCLOCK_33_6	= 7, /* 33.6 MHz */
+};
+
+struct wl12xx_clock {
+	u32	freq;
+	bool	xtal;
+	u8	hw_idx;
+};
+
 struct wl12xx_fw_packet_counters {
 	/* Cumulative counter of released packets per AC */
 	u8 tx_released_pkts[NUM_TX_QUEUES];
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 3876b67..eea1e6d 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -26,28 +26,6 @@
 
 #include <linux/err.h>
 
-/* Reference clock values */
-enum {
-	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
-	WL12XX_REFCLOCK_26	= 1, /* 26 MHz */
-	WL12XX_REFCLOCK_38	= 2, /* 38.4 MHz */
-	WL12XX_REFCLOCK_52	= 3, /* 52 MHz */
-	WL12XX_REFCLOCK_38_XTAL = 4, /* 38.4 MHz, XTAL */
-	WL12XX_REFCLOCK_26_XTAL = 5, /* 26 MHz, XTAL */
-};
-
-/* TCXO clock values */
-enum {
-	WL12XX_TCXOCLOCK_19_2	= 0, /* 19.2MHz */
-	WL12XX_TCXOCLOCK_26	= 1, /* 26 MHz */
-	WL12XX_TCXOCLOCK_38_4	= 2, /* 38.4MHz */
-	WL12XX_TCXOCLOCK_52	= 3, /* 52 MHz */
-	WL12XX_TCXOCLOCK_16_368	= 4, /* 16.368 MHz */
-	WL12XX_TCXOCLOCK_32_736	= 5, /* 32.736 MHz */
-	WL12XX_TCXOCLOCK_16_8	= 6, /* 16.8 MHz */
-	WL12XX_TCXOCLOCK_33_6	= 7, /* 33.6 MHz */
-};
-
 struct wl1251_platform_data {
 	int power_gpio;
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
@@ -58,8 +36,9 @@ struct wl1251_platform_data {
 struct wl12xx_platform_data {
 	int irq;
 	u32 irq_trigger;
-	int board_ref_clock;
-	int board_tcxo_clock;
+	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
+	u32 ref_clock_freq;	/* in Hertz */
+	u32 tcxo_clock_freq;	/* in Hertz, tcxo is always XTAL */
 	bool pwr_in_suspend;
 };
 
-- 
1.8.5.2.229.g4448466.dirty


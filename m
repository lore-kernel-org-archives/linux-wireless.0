Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39983 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbCLMJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:09:42 -0400
Received: by wivr20 with SMTP id r20so47105924wiv.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 05:09:41 -0700 (PDT)
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
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v6 5/6] ARM: dts: add wl12xx/wl18xx bindings
Date: Thu, 12 Mar 2015 14:09:13 +0200
Message-Id: <1426162154-8716-6-git-send-email-eliad@wizery.com> (sfid-20150312_131005_262828_4FD87D37)
In-Reply-To: <1426162154-8716-1-git-send-email-eliad@wizery.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace all the pdata-quirks for setting wl12xx/wl18xx
platform data with proper DT definitions.

The patch was compile-tested only.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v6: add wl12xx definitions as well

 arch/arm/boot/dts/am335x-evmsk.dts             | 11 ++++
 arch/arm/boot/dts/omap3-cm-t3517.dts           | 10 ++++
 arch/arm/boot/dts/omap3-cm-t3730.dts           | 10 ++++
 arch/arm/boot/dts/omap3-evm-common.dtsi        | 10 ++++
 arch/arm/boot/dts/omap3-igep0020-rev-f.dts     |  9 +++
 arch/arm/boot/dts/omap3-igep0030-rev-g.dts     |  9 +++
 arch/arm/boot/dts/omap3-zoom3.dts              | 10 ++++
 arch/arm/boot/dts/omap4-panda-common.dtsi      | 10 ++++
 arch/arm/boot/dts/omap4-sdp.dts                | 11 ++++
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi | 10 ++++
 arch/arm/mach-omap2/pdata-quirks.c             | 79 --------------------------
 11 files changed, 100 insertions(+), 79 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index df5fee6..87fc7a3 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -15,6 +15,7 @@
 
 #include "am33xx.dtsi"
 #include <dt-bindings/pwm/pwm.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 
 / {
 	model = "TI AM335x EVM-SK";
@@ -647,6 +648,16 @@
 	cap-power-off-card;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc2_pins>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <31 IRQ_TYPE_LEVEL_HIGH>; /* gpio 31 */
+		ref-clock-frequency = <38400000>;
+	};
 };
 
 &mcasp1 {
diff --git a/arch/arm/boot/dts/omap3-cm-t3517.dts b/arch/arm/boot/dts/omap3-cm-t3517.dts
index 0ab748c..f5b5a1d 100644
--- a/arch/arm/boot/dts/omap3-cm-t3517.dts
+++ b/arch/arm/boot/dts/omap3-cm-t3517.dts
@@ -133,6 +133,16 @@
 	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio5>;
+		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>; /* gpio 145 */
+		ref-clock-frequency = <38400000>;
+	};
 };
 
 &dss {
diff --git a/arch/arm/boot/dts/omap3-cm-t3730.dts b/arch/arm/boot/dts/omap3-cm-t3730.dts
index 46eadb2..2294f5b 100644
--- a/arch/arm/boot/dts/omap3-cm-t3730.dts
+++ b/arch/arm/boot/dts/omap3-cm-t3730.dts
@@ -73,6 +73,16 @@
 	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio5>;
+		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>; /* gpio 136 */
+		ref-clock-frequency = <38400000>;
+	};
 };
 
 &dss {
diff --git a/arch/arm/boot/dts/omap3-evm-common.dtsi b/arch/arm/boot/dts/omap3-evm-common.dtsi
index 127f3e7..346552b 100644
--- a/arch/arm/boot/dts/omap3-evm-common.dtsi
+++ b/arch/arm/boot/dts/omap3-evm-common.dtsi
@@ -106,6 +106,16 @@
 	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio5>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>; /* gpio 149 */
+		ref-clock-frequency = <38400000>;
+	};
 };
 
 &twl_gpio {
diff --git a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
index cc8bd0c..72f7cdc 100644
--- a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
+++ b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
@@ -42,4 +42,13 @@
 	vmmc-supply = <&lbep5clwmc_wlen>;
 	bus-width = <4>;
 	non-removable;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1835";
+		reg = <2>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>; /* gpio 177 */
+	};
 };
diff --git a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
index 9326b28..b899e34 100644
--- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
+++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
@@ -64,4 +64,13 @@
 	vmmc-supply = <&lbep5clwmc_wlen>;
 	bus-width = <4>;
 	non-removable;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1835";
+		reg = <2>;
+		interrupt-parent = <&gpio5>;
+		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>; /* gpio 136 */
+	};
 };
diff --git a/arch/arm/boot/dts/omap3-zoom3.dts b/arch/arm/boot/dts/omap3-zoom3.dts
index 6644f51..131448d 100644
--- a/arch/arm/boot/dts/omap3-zoom3.dts
+++ b/arch/arm/boot/dts/omap3-zoom3.dts
@@ -195,6 +195,16 @@
 	cap-power-off-card;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc3_pins &mmc3_2_pins>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <2 IRQ_TYPE_LEVEL_HIGH>; /* gpio 162 */
+		ref-clock-frequency = <26000000>;
+	};
 };
 
 &uart1 {
diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 1505135..1228de5 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -450,6 +450,16 @@
 	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>; /* gpio 53 */
+		ref-clock-frequency = <38400000>;
+	};
 };
 
 &emif1 {
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 3e1da43..8c36f51 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -487,6 +487,17 @@
 	non-removable;
 	bus-width = <4>;
 	cap-power-off-card;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1281";
+		reg = <2>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>; /* gpio 53 */
+		ref-clock-frequency = <26000000>;
+		tcxo-clock-frequency = <26000000>;
+	};
 };
 
 &emif1 {
diff --git a/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi b/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
index cc66af4..9bceeb7 100644
--- a/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
+++ b/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
@@ -65,4 +65,14 @@
 	bus-width = <4>;
 	cap-power-off-card;
 	status = "okay";
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1271";
+		reg = <2>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <9 IRQ_TYPE_LEVEL_HIGH>; /* gpio 41 */
+		ref-clock-frequency = <38400000>;
+	};
 };
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 337cc22..4464e07 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
 #include <linux/ti_wilink_st.h>
-#include <linux/wl12xx.h>
 
 #include <linux/platform_data/pinctrl-single.h>
 #include <linux/platform_data/iommu-omap.h>
@@ -35,35 +34,6 @@ struct pdata_init {
 struct of_dev_auxdata omap_auxdata_lookup[];
 static struct twl4030_gpio_platform_data twl_gpio_auxdata;
 
-#if IS_ENABLED(CONFIG_WL12XX)
-
-static struct wl12xx_platform_data wl12xx __initdata;
-
-static void __init __used legacy_init_wl12xx(u32 ref_clock_freq,
-					     u32 tcxo_clock_freq,
-					     int gpio)
-{
-	int res;
-
-	wl12xx.ref_clock_freq = ref_clock_freq;
-	wl12xx.tcxo_clock_freq = tcxo_clock_freq;
-	wl12xx.irq = gpio_to_irq(gpio);
-	wl12xx.irq_trigger = IRQ_TYPE_LEVEL_HIGH;
-
-	res = wl12xx_set_platform_data(&wl12xx);
-	if (res) {
-		pr_err("error setting wl12xx data: %d\n", res);
-		return;
-	}
-}
-#else
-static inline void legacy_init_wl12xx(u32 ref_clock_freq,
-				      u32 tcxo_clock_freq,
-				      int gpio)
-{
-}
-#endif
-
 #ifdef CONFIG_MACH_NOKIA_N8X0
 static void __init omap2420_n8x0_legacy_init(void)
 {
@@ -130,7 +100,6 @@ static void __init omap3_sbc_t3730_twl_init(void)
 static void __init omap3_sbc_t3730_legacy_init(void)
 {
 	omap3_sbc_t3x_usb_hub_init(167, "sb-t35 usb hub");
-	legacy_init_wl12xx(38400000, 0, 136);
 }
 
 static void __init omap3_sbc_t3530_legacy_init(void)
@@ -160,28 +129,16 @@ static struct platform_device btwilink_device = {
 
 static void __init omap3_igep0020_rev_f_legacy_init(void)
 {
-	legacy_init_wl12xx(0, 0, 177);
 	platform_device_register(&wl18xx_device);
 	platform_device_register(&btwilink_device);
 }
 
 static void __init omap3_igep0030_rev_g_legacy_init(void)
 {
-	legacy_init_wl12xx(0, 0, 136);
 	platform_device_register(&wl18xx_device);
 	platform_device_register(&btwilink_device);
 }
 
-static void __init omap3_evm_legacy_init(void)
-{
-	legacy_init_wl12xx(38400000, 0, 149);
-}
-
-static void __init omap3_zoom_legacy_init(void)
-{
-	legacy_init_wl12xx(26000000, 0, 162);
-}
-
 static void am35xx_enable_emac_int(void)
 {
 	u32 v;
@@ -246,7 +203,6 @@ static void __init omap3_sbc_t3517_legacy_init(void)
 	am35xx_emac_reset();
 	hsmmc2_internal_input_clk();
 	omap3_sbc_t3517_wifi_init();
-	legacy_init_wl12xx(38400000, 0, 145);
 }
 
 static void __init am3517_evm_legacy_init(void)
@@ -288,23 +244,6 @@ static void __init omap3_tao3530_legacy_init(void)
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
-#ifdef CONFIG_ARCH_OMAP4
-static void __init omap4_sdp_legacy_init(void)
-{
-	legacy_init_wl12xx(26000000, 26000000, 53);
-}
-
-static void __init omap4_panda_legacy_init(void)
-{
-	legacy_init_wl12xx(38400000, 0, 53);
-}
-
-static void __init var_som_om44_legacy_init(void)
-{
-	legacy_init_wl12xx(38400000, 0, 41);
-}
-#endif
-
 #if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
 static struct iommu_platform_data omap4_iommu_pdata = {
 	.reset_name = "mmu_cache",
@@ -313,13 +252,6 @@ static struct iommu_platform_data omap4_iommu_pdata = {
 };
 #endif
 
-#ifdef CONFIG_SOC_AM33XX
-static void __init am335x_evmsk_legacy_init(void)
-{
-	legacy_init_wl12xx(38400000, 0, 31);
-}
-#endif
-
 #ifdef CONFIG_SOC_OMAP5
 static void __init omap5_uevm_legacy_init(void)
 {
@@ -419,20 +351,9 @@ static struct pdata_init pdata_quirks[] __initdata = {
 	{ "nokia,omap3-n950", hsmmc2_internal_input_clk, },
 	{ "isee,omap3-igep0020-rev-f", omap3_igep0020_rev_f_legacy_init, },
 	{ "isee,omap3-igep0030-rev-g", omap3_igep0030_rev_g_legacy_init, },
-	{ "ti,omap3-evm-37xx", omap3_evm_legacy_init, },
-	{ "ti,omap3-zoom3", omap3_zoom_legacy_init, },
 	{ "ti,am3517-evm", am3517_evm_legacy_init, },
 	{ "technexion,omap3-tao3530", omap3_tao3530_legacy_init, },
 #endif
-#ifdef CONFIG_ARCH_OMAP4
-	{ "ti,omap4-sdp", omap4_sdp_legacy_init, },
-	{ "ti,omap4-panda", omap4_panda_legacy_init, },
-	{ "variscite,var-dvk-om44", var_som_om44_legacy_init, },
-	{ "variscite,var-stk-om44", var_som_om44_legacy_init, },
-#endif
-#ifdef CONFIG_SOC_AM33XX
-	{ "ti,am335x-evmsk", am335x_evmsk_legacy_init, },
-#endif
 #ifdef CONFIG_SOC_OMAP5
 	{ "ti,omap5-uevm", omap5_uevm_legacy_init, },
 #endif
-- 
1.8.5.2.229.g4448466.dirty


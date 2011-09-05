Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:49248
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918Ab1IEIJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:09:23 -0400
Message-ID: <4E648383.10505@compulab.co.il> (sfid-20110905_100928_313202_18E4D968)
Date: Mon, 05 Sep 2011 11:08:35 +0300
From: Ilya Ledvich <ilya@compulab.co.il>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	linux-wireless@vger.kernel.org,
	Igor Grinberg <grinberg@compulab.co.il>,
	Ido Yariv <ido@wizery.com>
Subject: Re: Problem with wl1271
References: <4E5B9B44.6080508@compulab.co.il>	 <1314627555.2296.353.camel@cumari>  <4E5CF23F.2060806@compulab.co.il> <1314786703.2296.566.camel@cumari>
In-Reply-To: <1314786703.2296.566.camel@cumari>
Content-Type: multipart/mixed;
 boundary="------------060505000807000006000306"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505000807000006000306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/31/2011 01:31 PM, Luciano Coelho wrote:
> Hi Ilya,
>
> On Tue, 2011-08-30 at 17:22 +0300, Ilya Ledvich wrote:
>> On 08/29/2011 05:19 PM, Luciano Coelho wrote:
>>> On Mon, 2011-08-29 at 16:59 +0300, Ilya Ledvich wrote:
>>>> I load the wl12xx_sdio module and then set the interface up; no obvious
>>>> error
>>>> is seen. When I run any other command (e.g. interface down/up, iwlist scan).
>>>> I have "/wl1271: ERROR ELP wakeup timeout!/" error. Then the driver
>>>> tries to
>>>> recover the chip; this eventually leads to the
>>>> "/wl1271: ERROR sdio read failed (-110)/" error. The log file for
>>>> ifconfig wlan0 up - down - up sequence is attached.
>>> This looks like an SDIO power management problem.  Do you have
>>> CONFIG_PM_RUNTIME enabled in your kernel?
>>>
>>> Can you send us your .config and the patch where you modified the
>>> board-cm-t35.c file?
>>>
>> Hi Luciano,
>> Sorry, my mailer converted the previous e-mail to html...
>> I thank you for fast response.
>> The required files are are attached. The CONFIG_PM_RUNTIME is enabled indeed.
>
> This seems to be a problem in your board file.  You have probably not
> configured the interrupt line correctly.  Are you sure all the MUXing is
> correct? Also, please check the regulator settings for your card.
>
> I have attached the patch I use to add this stuff to my beagleboard.
> Take a look at it and see if you find some more information about what
> you need to change in your board file.
>
> I hope this helps.
>
Hi,

First, thank you all for the help.
I moved the evaluation kit from the mmc[0] (OMAP MMC 1 controller) to 
the mmc[1] (OMAP MMC 2 controller) because I had some problem with the 
VMMC1 regulator registration that I didn't manage to fix.
Additionally, I connected the WLAN_EN pin to the GPIO170. The WLAN_IRQ 
pin is still not connected. Is it possible to use the SDIO IRQ instead? 
(The comment line in the struct wl12xx_platform_data defined in the 
include/linux/wl12xx.h: /* SDIO only: IRQ number if WLAN_IRQ line is 
used, 0 for SDIO IRQs */ states it's possible). Otherwise we have to 
make hardware changes (wire up) on the evalkit that is not desired 
because we have no schematics of the evaluation board.
I added the missing code for the fixed regulator including the GPIO170 
in the board file. The patch is attached.
I checked the MUXing as well. Everything excepting the GPIO170 is done 
in the omap_hsmmc_mux() function. The GPIO170 mux configuration is added 
in the patch.
However I still having the same error and the module behaviour is still 
the same.
Do you think connecting the WLAN_IRQ pin to a GPIO most probably fixes 
the problem?
Thank you in advance.
Best regards,
Ilya.




--------------060505000807000006000306
Content-Type: text/x-patch;
 name="0001-arm-omap3-cm-t35-enable-wl1217-wifi-on-the-mmc-1-bus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-arm-omap3-cm-t35-enable-wl1217-wifi-on-the-mmc-1-bus.pa";
 filename*1="tch"

>From 25ed05e06e0712e65fa438899136e43076112625 Mon Sep 17 00:00:00 2001
From: Ilya Ledvich <ilya@compulab.co.il>
Date: Mon, 29 Aug 2011 17:56:27 +0300
Subject: [PATCH] arm: omap3: cm-t35: enable wl1217 wifi on the mmc[1] bus


Signed-off-by: Ilya Ledvich <ilya@compulab.co.il>
---
 arch/arm/mach-omap2/board-cm-t35.c |   56 +++++++++++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 7cb133d..5db178d 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -27,7 +27,9 @@
 #include <linux/i2c/at24.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/mmc/host.h>
+#include <linux/wl12xx.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/tdo24m.h>
@@ -60,6 +62,8 @@
 #define SB_T35_SMSC911X_CS	4
 #define SB_T35_SMSC911X_GPIO	65
 
+#define CM_T35_WLAN_EN_GPIO    (170)
+
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
 #include <linux/smsc911x.h>
 #include <plat/gpmc-smsc911x.h>
@@ -338,6 +342,13 @@ static struct regulator_consumer_supply cm_t35_vmmc1_supply = {
 	.supply			= "vmmc",
 };
 
+static struct regulator_consumer_supply cm_t35_vwlan_supplies[] = {
+	{
+		.supply		= "vmmc",
+		.dev_name	= "omap_hsmmc.1",
+	}
+};
+
 static struct regulator_consumer_supply cm_t35_vsim_supply = {
 	.supply			= "vmmc_aux",
 };
@@ -408,6 +419,32 @@ static struct regulator_init_data cm_t35_vio = {
 	.consumer_supplies	= cm_t35_vio_supplies,
 };
 
+static struct regulator_init_data cm_t35_vmmc2_vwlan = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = 1,
+	.consumer_supplies = cm_t35_vwlan_supplies,
+};
+
+static struct fixed_voltage_config cm_t35_vwlan = {
+	.supply_name		= "vwl1271",
+	.microvolts		= 1800000, /* 1.8V */
+	.gpio			= CM_T35_WLAN_EN_GPIO,
+	.startup_delay		= 70000, /* 70ms */
+	.enable_high		= 1,
+	.enabled_at_boot	= 0,
+	.init_data		= &cm_t35_vmmc2_vwlan,
+};
+
+static struct platform_device cm_t35_vwlan_device = {
+	.name		= "reg-fixed-voltage",
+	.id		= 1,
+	.dev = {
+		.platform_data = &cm_t35_vwlan,
+	},
+};
+
 static struct twl4030_usb_data cm_t35_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
@@ -430,21 +467,24 @@ static struct twl4030_keypad_data cm_t35_kp_data = {
 	.rep		= 1,
 };
 
+struct wl12xx_platform_data cm_t35_wl12xx_data  __initdata = {
+	.board_ref_clock = WL12XX_REFCLOCK_38,
+};
+
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 1,
 		.caps		= MMC_CAP_4_BIT_DATA,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
-
 	},
 	{
+		.name		= "wl1271",
 		.mmc		= 2,
-		.caps		= MMC_CAP_4_BIT_DATA,
-		.transceiver	= 1,
+		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
-		.ocr_mask	= 0x00100000,	/* 3.3V */
+		.nonremovable	= true,
 	},
 	{}	/* Terminator */
 };
@@ -620,6 +660,9 @@ static struct omap_board_mux board_mux[] __initdata = {
 	OMAP3_MUX(SYS_NIRQ, OMAP_MUX_MODE0 | OMAP_WAKEUP_EN | \
 		  OMAP_PIN_INPUT_PULLUP),
 
+	/* WL12XX WLAN_EN */
+	OMAP3_MUX(HDQ_SIO,  OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
+
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 
@@ -676,6 +719,11 @@ static void __init cm_t3x_common_init(void)
 
 	usb_musb_init(NULL);
 	cm_t35_init_usbh();
+
+	if (wl12xx_set_platform_data(&cm_t35_wl12xx_data))
+		pr_err("error setting wl12xx data\n");
+
+	platform_device_register(&cm_t35_vwlan_device);
 }
 
 static void __init cm_t35_init(void)
-- 
1.7.1


--------------060505000807000006000306--

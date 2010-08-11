Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21932 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab0HKJBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 05:01:53 -0400
Message-ID: <4C6266FE.5000904@nokia.com>
Date: Wed, 11 Aug 2010 12:01:50 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v3 9/9] omap: zoom: add mmc3/wl1271 device support
References: <1281478348-24833-1-git-send-email-ohad@wizery.com> <1281478348-24833-10-git-send-email-ohad@wizery.com> <4C626140.3080107@nokia.com>
In-Reply-To: <4C626140.3080107@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2010 11:37 AM, Roger Quadros wrote:
> On 08/11/2010 01:12 AM, ext Ohad Ben-Cohen wrote:
>> Add MMC3 support on ZOOM, which has the wl1271 device hardwired to.
>>
>> The wl1271 is a 4-wire, 1.8V, embedded SDIO WLAN device with an
>> external IRQ line, and power-controlled by a GPIO-based fixed regulator.
>>
>> Signed-off-by: Ohad Ben-Cohen<ohad@wizery.com>
>> ---
>>    arch/arm/mach-omap2/board-zoom-peripherals.c |   34 ++++++++++++++++++++++++++
>>    1 files changed, 34 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
>> index de88635..82776bc 100644
>> --- a/arch/arm/mach-omap2/board-zoom-peripherals.c
>> +++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
>> @@ -17,6 +17,8 @@
>>    #include<linux/i2c/twl.h>
>>    #include<linux/regulator/machine.h>
>>    #include<linux/regulator/fixed.h>
>> +#include<linux/mmc/host.h>
>> +#include<linux/wl12xx.h>
>>
>>    #include<asm/mach-types.h>
>>    #include<asm/mach/arch.h>
>> @@ -29,6 +31,7 @@
>>    #include "hsmmc.h"
>>
>>    #define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
>> +#define OMAP_ZOOM_WLAN_IRQ_GPIO		(162)
>>
>>    /* Zoom2 has Qwerty keyboard*/
>>    static int board_keymap[] = {
>> @@ -185,6 +188,28 @@ static struct platform_device omap_vwlan_device = {
>>    	},
>>    };
>>
>> +struct wl12xx_platform_data omap_zoom_wlan_data = {
>> +	/* ZOOM ref clock is 26 MHz */
>> +	.board_ref_clock = 1,
>> +};
>> +
>> +static struct resource omap_zoom_wl1271_resources[] = {
>> +	{
>> +		.start = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
>> +		.end = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
>> +		.flags = IORESOURCE_IRQ,
>> +	}
>> +};
>> +static struct platform_device omap_zoom_wl1271 = {
>> +	.name		= "wl1271_plat.2",
>> +	.id		= -1,
>> +	.resource	= omap_zoom_wl1271_resources,
>> +	.num_resources	= ARRAY_SIZE(omap_zoom_wl1271_resources),
>> +	.dev = {
>> +		.platform_data =&omap_zoom_wlan_data,
>> +	},
>> +};
>> +
>>    static struct omap2_hsmmc_info mmc[] __initdata = {
>>    	{
>>    		.name		= "external",
>> @@ -202,6 +227,14 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
>>    		.nonremovable	= true,
>>    		.power_saving	= true,
>>    	},
>> +	{
>> +		.name		= "wl1271",
>> +		.mmc		= 3,
>> +		.wires		= 4,
>> +		.gpio_wp	= -EINVAL,
>> +		.gpio_cd	= -EINVAL,
>> +		.ocr_mask	= MMC_VDD_165_195,
>
> Do we really need to specify ocr_mask here?
> It seems to be set in omap_hsmmc_reg_get() by calling mmc_regulator_get_ocrmask().
>
> This should automatically pick the right mask if you have defined the "vmmc"
> regulator output voltage correctly.
>
Also shouldn't .nonremovable be set to true? as this is a non-removable card slot.

regards,
-roger

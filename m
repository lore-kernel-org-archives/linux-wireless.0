Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33903 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0IWMqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
 <20100923114528.GL4580@legolas.emea.dhcp.ti.com> <1285244253.3231.75.camel@chilepepper>
 <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 23 Sep 2010 14:46:33 +0200
Message-ID: <AANLkTikN37=O8rnFkBfuJex25DdNPEieioL5jgenpoYY@mail.gmail.com>
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board file
To: balbi@ti.com
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi Luca,
>
> On Thu, Sep 23, 2010 at 07:17:33AM -0500, Luciano Coelho wrote:
>>
>> On Thu, 2010-09-23 at 13:45 +0200, ext Felipe Balbi wrote:
>>>
>>> On Thu, Sep 23, 2010 at 03:20:03AM -0500, Luciano Coelho wrote:
>>> > static struct mtd_partition omap3beagle_nand_partitions[] = {
>>> >@@ -163,12 +168,25 @@ static void __init beagle_display_init(void)
>>> >
>>> > #include "sdram-micron-mt46h32m32lf-6.h"
>>> >
>>> >+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
>>> >+      .irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
>>>
>>> can you pass IRQ as a struct resource ?
>>
>> Sorry, I don't understand what you mean here.  Can you clarify?
>
> static struct resource wl12xx_resource[] = {
>        {
>                .start  = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
>                .flags  = IORESOURCE_IRQ,
>        },
> };
>
> static struct platform_device wl12xx_platform_device = {
>        .resource       = wl12xx_resource,
>        .num_resources  = ARRAY_SIZE(wl12xx_resource),
>        .....
> };
>
> then on driver you would:
>
> irq = platform_get_irq(pdev, 0);

only problem is that there is no platform device involved here :)

>
> something like that :-)
>
> --
> balbi
>

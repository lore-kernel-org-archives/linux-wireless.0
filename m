Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:37544 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0HKSsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:48:51 -0400
Date: Wed, 11 Aug 2010 21:47:42 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
 board data
Message-ID: <20100811184742.GA21778@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Wed, Aug 11, 2010 at 08:42:18PM +0200, ext DebBarma, Tarun Kanti wrote:
>> @@ -182,10 +186,84 @@ static struct wl1271_if_operations sdio_ops = {
>>  	.disable_irq	= wl1271_sdio_disable_interrupts
>>  };
>>
>> +static int wl1271_plat_probe(struct platform_device *pdev)
>> +{
>> +	struct wl12xx_platform_data *pdata;
>> +	struct platform_driver *pdriver;
>> +	struct wl12xx_plat_instance *pinstance;
>> +
>What about checking for pdev here before extracting pdata?

why ? if probe is called pdev is guaranteed to be valid, no ?

>> +	pdata = pdev->dev.platform_data;
>> +	if (!pdata) {
>> +		wl1271_error("no platform data");
>> +		return -ENODEV;
>> +	}
>> +
>> +	pdriver = container_of(pdev->dev.driver, struct platform_driver,
>> +								driver);

but you shouldn't fiddle with the driver structure here. What are you 
actually trying to achieve here ? What's pinstance supposed to do ? are 
you trying to handle cases where you might have several wl12xx chips on 
the same board ? If that's the case you should have several platform 
devices, one for each chip. They'll only have different ids.

-- 
balbi

DefectiveByDesign.org

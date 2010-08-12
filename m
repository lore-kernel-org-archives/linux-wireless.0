Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64196 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0HLF1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 01:27:52 -0400
Date: Thu, 12 Aug 2010 08:27:33 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
	"ext DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
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
 board 	data
Message-ID: <20100812052733.GB23362@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
 <20100811184742.GA21778@nokia.com>
 <AANLkTikLbiJ8PsUbSnmYrfY6oNW4okejf-UdyQyfYbUz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <AANLkTikLbiJ8PsUbSnmYrfY6oNW4okejf-UdyQyfYbUz@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Aug 11, 2010 at 10:10:38PM +0200, ext Ohad Ben-Cohen wrote:
>Think of several wl1271 devices, each of which is represented by two
>devices; an SDIO function, and a platform device. The SDIO function
>stands for a specific MMC controller the device is hardwired to, and
>the platform device stands for the external irq line that the device
>is hardwired to.
>
>We must couple the SDIO function with the correct platform device,
>otherwise it will start getting the wrong interrupts. So after the
>SDIO function is probed, it registers a platform driver with the
>unique name that represents the platform device that it is coupled
>with. When the platform device is probed, it needs to deliver its
>platform data info to the specific SDIO function that it is bound
>with.
>
>To avoid using some global data structure in that driver, we allocate
>a unique platform driver per each device, which makes it possible for
>the platform driver probe to find the SDIO function context by means
>of container_of.
>
>Alternatively, we can also use some global structure in that file,
>most probably idr, which would also make it possible to reach the SDIO
>function contexts without going through the driver structure. The idr
>indexes would then be the MMC controller index, which should match
>the platform device id.
>
>I'll try this out, it might actually look nicer.

you need no globals and you don't need to fiddle with driver structures 
either.

Just make an sdio driver that platform_device_alloc() and pass in a 
platform_data, builds struct resources etc for each device found on the 
sdio bus. Similarly for the SPI-connected wifi chip.

You should never fiddle with internal structures. If you want to look at 
an example implementation, take a look at drivers/mfd/twl-core.c, there 
we use an i2c driver to instantiate several platform_devices. Nobody 
fiddles with driver structures and all the drivers are logically 
separated into their own source files.

-- 
balbi

DefectiveByDesign.org

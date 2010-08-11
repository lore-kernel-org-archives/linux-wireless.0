Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38114 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0HKSxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:53:53 -0400
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
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
Date: Thu, 12 Aug 2010 00:22:54 +0530
Subject: RE: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
 board data
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC1@dbde02.ent.ti.com>
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
 <20100811184742.GA21778@nokia.com>
In-Reply-To: <20100811184742.GA21778@nokia.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> Sent: Thursday, August 12, 2010 12:18 AM
> To: DebBarma, Tarun Kanti
> Cc: Ohad Ben-Cohen; linux-wireless@vger.kernel.org; linux-
> mmc@vger.kernel.org; linux-omap@vger.kernel.org; Ido Yariv; Mark Brown;
> linux-arm-kernel@lists.infradead.org; Chikkature Rajashekar, Madhusudhan;
> Coelho Luciano (Nokia-MS/Helsinki); akpm@linux-foundation.org; San Mehat;
> Quadros Roger (Nokia-MS/Helsinki); Tony Lindgren; Nicolas Pitre; Pandita,
> Vikram; Kalle Valo
> Subject: Re: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
> board data
> 
> hi,
> 
> On Wed, Aug 11, 2010 at 08:42:18PM +0200, ext DebBarma, Tarun Kanti wrote:
> >> @@ -182,10 +186,84 @@ static struct wl1271_if_operations sdio_ops = {
> >>  	.disable_irq	= wl1271_sdio_disable_interrupts
> >>  };
> >>
> >> +static int wl1271_plat_probe(struct platform_device *pdev)
> >> +{
> >> +	struct wl12xx_platform_data *pdata;
> >> +	struct platform_driver *pdriver;
> >> +	struct wl12xx_plat_instance *pinstance;
> >> +
> >What about checking for pdev here before extracting pdata?
> 
> why ? if probe is called pdev is guaranteed to be valid, no ?
> 
True; however if we go by that argument than we can also assume pdata is valid, so that we would not need the below check.
Still, I would go ahead and find out if there is any scenario where pdev can go wrong during device registration. Thanks.

> >> +	pdata = pdev->dev.platform_data;
> >> +	if (!pdata) {
> >> +		wl1271_error("no platform data");
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	pdriver = container_of(pdev->dev.driver, struct platform_driver,
> >> +								driver);
> 
> but you shouldn't fiddle with the driver structure here. What are you
> actually trying to achieve here ? What's pinstance supposed to do ? are
> you trying to handle cases where you might have several wl12xx chips on
> the same board ? If that's the case you should have several platform
> devices, one for each chip. They'll only have different ids.
> 
> --
> balbi
> 
> DefectiveByDesign.org

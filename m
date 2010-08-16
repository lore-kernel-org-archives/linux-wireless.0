Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57738 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0HPEWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 00:22:23 -0400
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>, San Mehat <san@google.com>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 16 Aug 2010 09:51:04 +0530
Subject: RE: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
	board data
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB032419CAAC@dbde02.ent.ti.com>
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
 <20100811184742.GA21778@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC1@dbde02.ent.ti.com>
 <20100811185724.GD21778@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0324110AC7@dbde02.ent.ti.com>
 <20100811212513.GC827@n2100.arm.linux.org.uk>
In-Reply-To: <20100811212513.GC827@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Thursday, August 12, 2010 2:55 AM
> To: DebBarma, Tarun Kanti
> Cc: felipe.balbi@nokia.com; Ohad Ben-Cohen; Kalle Valo; Pandita, Vikram;
> akpm@linux-foundation.org; Quadros Roger (Nokia-MS/Helsinki); Tony
> Lindgren; linux-wireless@vger.kernel.org; Mark Brown; linux-
> mmc@vger.kernel.org; Nicolas Pitre; San Mehat; Chikkature Rajashekar,
> Madhusudhan; Coelho Luciano (Nokia-MS/Helsinki); linux-
> omap@vger.kernel.org; Ido Yariv; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
> board data
> 
> On Thu, Aug 12, 2010 at 12:57:18AM +0530, DebBarma, Tarun Kanti wrote:
> >
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> > > Sent: Thursday, August 12, 2010 12:27 AM
> > > To: DebBarma, Tarun Kanti
> > > Cc: Balbi Felipe (Nokia-MS/Helsinki); Ohad Ben-Cohen; linux-
> > > wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> > > omap@vger.kernel.org; Ido Yariv; Mark Brown; linux-arm-
> > > kernel@lists.infradead.org; Chikkature Rajashekar, Madhusudhan; Coelho
> > > Luciano (Nokia-MS/Helsinki); akpm@linux-foundation.org; San Mehat;
> Quadros
> > > Roger (Nokia-MS/Helsinki); Tony Lindgren; Nicolas Pitre; Pandita,
> Vikram;
> > > Kalle Valo
> > > Subject: Re: [PATCH v4 3/8] wireless: wl1271: add platform driver to
> get
> > > board data
> > >
> > > Hi,
> > >
> > > On Wed, Aug 11, 2010 at 08:52:54PM +0200, ext DebBarma, Tarun Kanti
> wrote:
> > > >True; however if we go by that argument than we can also assume pdata
> > > >is valid, so that we would not need the below check.
> > >
> > > of course not. You can have devices that just play well with default
> > > values or devices where you don't need the flexibility of platform
> data.
> > > That's why we check.
> > >
> > > platform_device pointers on the other hand, are guaranteed to be
> always
> > > true, if it isn't then you should oops, you deserve to oops because
> > > something is really really wrong.
> > >
> > Sounds perfect!
> > What that means is _probe() function makes sense only for cases where we
> > have valid platform data because we are returning right at the top if
> > pdata is not valid. If this is the case I was curious to know why not
> > framework make another check for valid pdata before calling _probe()
> > instead of coming all the way to _probe() and then returning!
> 
> Platform devices are not for passing platform data around - they're for
> declaring platform hardware devices that we want drivers to handle -
> and it depends on the driver whether having platform data is appropriate
> or not.
> 
> This proposal is, IMHO, abusing the platform device/driver support to
> achieve its own goals.  I've outlined a far simpler and easiler solution
> which avoids this kind of abuse, and given suggestions on how to extend
> it to support multiple instances.

I guess I have not put my question in the right perspective. As you have said, platform devices are not meant for passing data around, it appeared to me contradictory when in the probe() we are just checking the pdata and proceeding/returning based upon its value, as if platform device has no other functions. So, the question should have been what else we could do in probe() with platform device other than manipulation of pdata, other than modification of the framework in the real sense.

Anyways, I will go through the suggestions you mentioned. Thanks for the clarifications.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60665 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbCKKcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 06:32:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Eliad Peller <eliad@wizery.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v5 2/3] wl18xx: add basic device-tree support
Date: Wed, 11 Mar 2015 11:32:14 +0100
Message-ID: <2158874.BdVTdz3Bds@wuerfel> (sfid-20150311_113230_568452_0D5CDC75)
In-Reply-To: <CABxcv=nn9-1a-3809Y1JgC5ExkwHqQmCXRT3tX=h7Z6C7c+m2A@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <2121942.zIG9BfPsTV@wuerfel> <CABxcv=nn9-1a-3809Y1JgC5ExkwHqQmCXRT3tX=h7Z6C7c+m2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 March 2015 11:05:47 Javier Martinez Canillas wrote:
> 
> On Wed, Mar 11, 2015 at 10:51 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 11 March 2015 01:34:19 Javier Martinez Canillas wrote:
> >> > +
> >> > +static struct wl12xx_platform_data *
> >> > +wlcore_get_platform_data(struct device *dev)
> >> > +{
> >> > +       struct wl12xx_platform_data *pdata;
> >> > +
> >> > +       /* first, look for DT data */
> >>
> >> I thought it was the opposite, that platform data should over-rule DT.
> >> That way you can still use the data filled in
> >> arch/arm/mach-omap2/pdata-quirks.c even after the driver supports your
> >> new DT binding.
> >
> > No, the pdata-quirks stuff for this driver must die, it was a hack
> > that only exists because we previously could not attach data to an
> > sdio function.
> >
> 
> Ok sorry, I misunderstood and thought that the output from the
> discussion in patch 3/3 was that the pdata could not still be removed
> due not having a way to configure the clocks for wl12xx.

I think that is still the case, but we should never have both pdata
and DT, and if we ever did, I think the DT should take precedence
so we can be sure that the pdata is not used and can be removed.

	Arnd

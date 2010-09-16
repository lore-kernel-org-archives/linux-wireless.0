Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30787 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab0IPT5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:57:49 -0400
Subject: Re: [PATCH v6 2/7] wl1271: propagate set_power's return value
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <AANLkTimp2JT4XT5EHwKwmMQ+5KYgHTOzpqDwF3UjGDBh@mail.gmail.com>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
	 <1284592929-29616-3-git-send-email-ohad@wizery.com>
	 <1284666018.8951.66.camel@powerslave>
	 <AANLkTimp2JT4XT5EHwKwmMQ+5KYgHTOzpqDwF3UjGDBh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 22:56:51 +0300
Message-ID: <1284667011.8951.73.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 21:53 +0200, ext Ohad Ben-Cohen wrote:
> On Thu, Sep 16, 2010 at 9:40 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> >> +     int ret = wl->if_ops->power(wl, true);
> >
> > I think it look nicer if you keep the "int ret" in one line by itself
> > and then do a ret = wl->if_ops... on another one.
> 
> Fixed.
> 
> >> +static int wl1271_sdio_power_on(struct wl1271 *wl)
> >>  {
> >>       struct sdio_func *func = wl_to_func(wl);
> >>
> >>       sdio_claim_host(func);
> >>       sdio_enable_func(func);
> >>       sdio_release_host(func);
> >> +
> >> +     return 0;
> >>  }
> >
> > You seem to always return 0, so the whole chain to pass the value up
> > seems unnecessary.  Is this just a preparation for a future patch?
> 
> Yes, it's soon going to be:
> 
> static int wl1271_sdio_power_on(struct wl1271 *wl)
> {
>        struct sdio_func *func = wl_to_func(wl);
>        int ret;
> 
>        ret = pm_runtime_get_sync(&func->dev);
>        if (ret)
>                  goto out;
> 
>        sdio_claim_host(func);
>        sdio_enable_func(func);
>        sdio_release_host(func);
> 
> out:
>        return ret;
> }
> 

Ok, that was the only explanation I could think of ;)

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.


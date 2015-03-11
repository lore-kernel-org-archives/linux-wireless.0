Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:65197 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbCKJvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 05:51:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
	Eliad Peller <eliad@wizery.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v5 2/3] wl18xx: add basic device-tree support
Date: Wed, 11 Mar 2015 10:51:21 +0100
Message-ID: <2121942.zIG9BfPsTV@wuerfel> (sfid-20150311_105136_094849_4F7F0B4C)
In-Reply-To: <CABxcv=mygdT2Q+ByVKPx4+o_Oj9KSy=zVX9ng9yN25ivkfSn1A@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <1425915402-10012-2-git-send-email-eliad@wizery.com> <CABxcv=mygdT2Q+ByVKPx4+o_Oj9KSy=zVX9ng9yN25ivkfSn1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 March 2015 01:34:19 Javier Martinez Canillas wrote:
> > +
> > +static struct wl12xx_platform_data *
> > +wlcore_get_platform_data(struct device *dev)
> > +{
> > +       struct wl12xx_platform_data *pdata;
> > +
> > +       /* first, look for DT data */
> 
> I thought it was the opposite, that platform data should over-rule DT.
> That way you can still use the data filled in
> arch/arm/mach-omap2/pdata-quirks.c even after the driver supports your
> new DT binding.

No, the pdata-quirks stuff for this driver must die, it was a hack
that only exists because we previously could not attach data to an
sdio function.

> > +       pdata = wlcore_probe_of(dev);
> > +       if (pdata)
> > +               return pdata;
> > +
> > +       /* if not found - fallback to static platform data */
> > +       pdata = wl12xx_get_platform_data();
> > +       if (!IS_ERR(pdata))
> > +               return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
> > +
> > +       dev_err(dev, "No platform data set\n");
> > +       return NULL;
> > +}
> > +
> > +static void wlcore_del_platform_data(struct wl12xx_platform_data *pdata)
> > +{
> > +       kfree(pdata);
> > +}
> > +
> 
> This function seems to be an unnecessary, why not just call kfree() directly?
> 
> Or better, maybe the resource-managed devm_*() functions can be used
> so the data doesn't have to be explicitly freed?

As I said earlier, I think it would be best not to dynamically allocate anything
here at all. As Eliad explained, the data is used by two different drivers:
wl12xx and wl18xx, and only the latter is converted for now, but after the
conversion, it should not need the platform data structure any more, only
the irq number that gets passed in from DT.

	Arnd

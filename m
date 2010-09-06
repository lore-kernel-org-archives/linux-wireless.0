Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36833 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0IFMHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 08:07:46 -0400
Date: Mon, 6 Sep 2010 13:07:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
	Kalle Valo <kalle.valo@iki.fi>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing
	support
Message-ID: <20100906120716.GE20903@n2100.arm.linux.org.uk>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com> <1283376410-9999-4-git-send-email-ohad@wizery.com> <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 04, 2010 at 02:23:19PM +0200, Michał Mirosław wrote:
> 2010/9/1 Ohad Ben-Cohen <ohad@wizery.com>:
> > Add a simple mechanism to pass platform data to the
> > SDIO instances of wl12xx.
> >
> > This way there is no confusion over who owns the 'embedded data',
> > typechecking is preserved, and no possibility for the wrong driver to
> > pick up the data.
> >
> > Originally proposed by Russell King.
> >
> > Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> > ---
> >  drivers/net/wireless/Makefile                      |    2 +
> >  drivers/net/wireless/wl12xx/Kconfig                |    5 ++-
> >  drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   31 ++++++++++++++++++++
> >  include/linux/wl12xx.h                             |    3 ++
> >  4 files changed, 40 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c
> >
> > diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> > index 5d4ce4d..85af697 100644
> > --- a/drivers/net/wireless/Makefile
> > +++ b/drivers/net/wireless/Makefile
> > @@ -50,5 +50,7 @@ obj-$(CONFIG_ATH_COMMON)      += ath/
> >  obj-$(CONFIG_MAC80211_HWSIM)   += mac80211_hwsim.o
> >
> >  obj-$(CONFIG_WL12XX)   += wl12xx/
> > +# small builtin driver bit
> > +obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx/wl12xx_platform_data.o
> >
> >  obj-$(CONFIG_IWM)      += iwmc3200wifi/
> > diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> > index 2f98058..4a8bb25 100644
> > --- a/drivers/net/wireless/wl12xx/Kconfig
> > +++ b/drivers/net/wireless/wl12xx/Kconfig
> > @@ -74,4 +74,7 @@ config WL1271_SDIO
> >          If you choose to build a module, it'll be called
> >          wl1271_sdio. Say N if unsure.
> >
> > -
> > +config WL12XX_PLATFORM_DATA
> > +       bool
> > +       depends on WL1271_SDIO != n
> > +       default y
> > diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
> > new file mode 100644
> > index 0000000..e00973b
> > --- /dev/null
> > +++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
> > @@ -0,0 +1,31 @@
> > +#include <linux/module.h>
> > +#include <linux/wl12xx.h>
> > +
> > +static struct wl12xx_platform_data *platform_data;
> > +
> > +int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
> > +{
> > +       if (platform_data)
> > +               return -EBUSY;
> > +       if (!data)
> > +               return -EINVAL;
> > +
> > +       platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
> > +       if (!platform_data)
> > +               return -ENOMEM;
> > +
> > +       return 0;
> > +}
> > +
> > +int wl12xx_get_platform_data(struct wl12xx_platform_data *data)
> > +{
> > +       if (!platform_data)
> > +               return -ENODEV;
> > +       if (!data)
> > +               return -EINVAL;
> > +
> > +       memcpy(data, platform_data, sizeof(*data));
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(wl12xx_get_platform_data);
> > diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
> > index 137ac89..3e33ae1 100644
> > --- a/include/linux/wl12xx.h
> > +++ b/include/linux/wl12xx.h
> > @@ -31,4 +31,7 @@ struct wl12xx_platform_data {
> >        bool use_eeprom;
> >  };
> >
> > +int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
> > +int wl12xx_get_platform_data(struct wl12xx_platform_data *data);
> > +
> >  #endif
> 
> Why do you need all that copying? Isn't the data constant?

The first copy is to allow platforms to have their data marked with
__initdata.  The second copy probably isn't necessary, but avoids
problems where the driver may decide to modify the platform data.

We could instead make wl12xx_get_platform_data() return a const pointer
to its own internal storage instead, or ERR pointers for the various
failure cases.

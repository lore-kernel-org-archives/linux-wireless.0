Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49105 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab3FFLsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:48:36 -0400
Message-ID: <1370519207.5502.5.camel@cumari.coelho.fi> (sfid-20130606_134856_787437_6A566BAF)
Subject: Re: [PATCH 1/2] net: wireless: wl1251: Use module_spi_driver macro
From: Luciano Coelho <coelho@ti.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>
Date: Thu, 6 Jun 2013 14:46:47 +0300
In-Reply-To: <CAK9yfHzRHxJuzFW4OvLsQvoxT9LXYzwO+3i5nws8N6hO9HGq-Q@mail.gmail.com>
References: <1369822703-27769-1-git-send-email-sachin.kamat@linaro.org>
	 <CAK9yfHzRHxJuzFW4OvLsQvoxT9LXYzwO+3i5nws8N6hO9HGq-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sachin,

On Thu, 2013-06-06 at 14:48 +0530, Sachin Kamat wrote:
> On 29 May 2013 15:48, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > module_spi_driver() eliminates some boiler plate and makes code
> > simpler.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > ---
> >  drivers/net/wireless/ti/wl1251/spi.c |   24 +-----------------------
> >  1 file changed, 1 insertion(+), 23 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
> > index 4c67c2f..dfd0877 100644
> > --- a/drivers/net/wireless/ti/wl1251/spi.c
> > +++ b/drivers/net/wireless/ti/wl1251/spi.c
> > @@ -329,29 +329,7 @@ static struct spi_driver wl1251_spi_driver = {
> >         .remove         = wl1251_spi_remove,
> >  };
> >
> > -static int __init wl1251_spi_init(void)
> > -{
> > -       int ret;
> > -
> > -       ret = spi_register_driver(&wl1251_spi_driver);
> > -       if (ret < 0) {
> > -               wl1251_error("failed to register spi driver: %d", ret);
> > -               goto out;
> > -       }
> > -
> > -out:
> > -       return ret;
> > -}
> > -
> > -static void __exit wl1251_spi_exit(void)
> > -{
> > -       spi_unregister_driver(&wl1251_spi_driver);
> > -
> > -       wl1251_notice("unloaded");
> > -}
> > -
> > -module_init(wl1251_spi_init);
> > -module_exit(wl1251_spi_exit);
> > +module_spi_driver(wl1251_spi_driver);
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
> > --
> > 1.7.9.5
> >
> 
> Gentle ping on this series John.

This is in my queue.  Haven't had the time to review and apply them yet.
And these are not urgent changes, so they can wait a little while.

--
Luca.


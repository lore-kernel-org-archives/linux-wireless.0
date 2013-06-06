Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52159 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3FFLvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:51:23 -0400
Received: by mail-ob0-f178.google.com with SMTP id fb19so4477068obc.37
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 04:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370519207.5502.5.camel@cumari.coelho.fi>
References: <1369822703-27769-1-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHzRHxJuzFW4OvLsQvoxT9LXYzwO+3i5nws8N6hO9HGq-Q@mail.gmail.com>
	<1370519207.5502.5.camel@cumari.coelho.fi>
Date: Thu, 6 Jun 2013 17:21:22 +0530
Message-ID: <CAK9yfHyg_4nD01SZB34mz0v=oLBZYDJApC7bP36YvpVywOfv0A@mail.gmail.com> (sfid-20130606_135129_312326_7909A5C2)
Subject: Re: [PATCH 1/2] net: wireless: wl1251: Use module_spi_driver macro
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

On 6 June 2013 17:16, Luciano Coelho <coelho@ti.com> wrote:
> Hi Sachin,
>
> On Thu, 2013-06-06 at 14:48 +0530, Sachin Kamat wrote:
>> On 29 May 2013 15:48, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> > module_spi_driver() eliminates some boiler plate and makes code
>> > simpler.
>> >
>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> > ---
>> >  drivers/net/wireless/ti/wl1251/spi.c |   24 +-----------------------
>> >  1 file changed, 1 insertion(+), 23 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
>> > index 4c67c2f..dfd0877 100644
>> > --- a/drivers/net/wireless/ti/wl1251/spi.c
>> > +++ b/drivers/net/wireless/ti/wl1251/spi.c
>> > @@ -329,29 +329,7 @@ static struct spi_driver wl1251_spi_driver = {
>> >         .remove         = wl1251_spi_remove,
>> >  };
>> >
>> > -static int __init wl1251_spi_init(void)
>> > -{
>> > -       int ret;
>> > -
>> > -       ret = spi_register_driver(&wl1251_spi_driver);
>> > -       if (ret < 0) {
>> > -               wl1251_error("failed to register spi driver: %d", ret);
>> > -               goto out;
>> > -       }
>> > -
>> > -out:
>> > -       return ret;
>> > -}
>> > -
>> > -static void __exit wl1251_spi_exit(void)
>> > -{
>> > -       spi_unregister_driver(&wl1251_spi_driver);
>> > -
>> > -       wl1251_notice("unloaded");
>> > -}
>> > -
>> > -module_init(wl1251_spi_init);
>> > -module_exit(wl1251_spi_exit);
>> > +module_spi_driver(wl1251_spi_driver);
>> >
>> >  MODULE_LICENSE("GPL");
>> >  MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
>> > --
>> > 1.7.9.5
>> >
>>
>> Gentle ping on this series John.
>
> This is in my queue.  Haven't had the time to review and apply them yet.
> And these are not urgent changes, so they can wait a little while.

Sure. Thanks.


-- 
With warm regards,
Sachin

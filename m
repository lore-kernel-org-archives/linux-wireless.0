Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44929 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0IPTyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <1284666018.8951.66.camel@powerslave>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
 <1284592929-29616-3-git-send-email-ohad@wizery.com> <1284666018.8951.66.camel@powerslave>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Sep 2010 21:53:39 +0200
Message-ID: <AANLkTimp2JT4XT5EHwKwmMQ+5KYgHTOzpqDwF3UjGDBh@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] wl1271: propagate set_power's return value
To: Luciano Coelho <luciano.coelho@nokia.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 9:40 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
>> +     int ret = wl->if_ops->power(wl, true);
>
> I think it look nicer if you keep the "int ret" in one line by itself
> and then do a ret = wl->if_ops... on another one.

Fixed.

>> +static int wl1271_sdio_power_on(struct wl1271 *wl)
>>  {
>>       struct sdio_func *func = wl_to_func(wl);
>>
>>       sdio_claim_host(func);
>>       sdio_enable_func(func);
>>       sdio_release_host(func);
>> +
>> +     return 0;
>>  }
>
> You seem to always return 0, so the whole chain to pass the value up
> seems unnecessary.  Is this just a preparation for a future patch?

Yes, it's soon going to be:

static int wl1271_sdio_power_on(struct wl1271 *wl)
{
       struct sdio_func *func = wl_to_func(wl);
       int ret;

       ret = pm_runtime_get_sync(&func->dev);
       if (ret)
                 goto out;

       sdio_claim_host(func);
       sdio_enable_func(func);
       sdio_release_host(func);

out:
       return ret;
}


Thanks,
Ohad.

>
> --
> Cheers,
> Luca.
>
>

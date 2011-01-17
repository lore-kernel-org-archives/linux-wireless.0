Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2703 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1AQPIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 10:08:31 -0500
Date: Mon, 17 Jan 2011 10:08:53 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Cc: Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: htc dream wl1251 and MSM_GPIO_TO_INT(29)
Message-ID: <20110117150853.GC20703@hash.localnet>
References: <1295047993.24338.66.camel@gnutoo-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295047993.24338.66.camel@gnutoo-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 15, 2011 at 12:33:13AM +0100, Denis 'GNUtoo' Carikli wrote:
> The problem is the following:
> When I do that:
> modprobe msm_wifi, wich is the old wifi activator from bob copeland
> available here:
> http://bobcopeland.com/srcs/android/msm_wifi.patch
> 
> it freeze the phone, and watch -n 0.1 cat /proc/interupts trough ssh
> seem frozen too
> 
> Here's the code for passing the data :
> 
> static void trout_wl1251_init(void)
> {
>         struct wl12xx_platform_data trout_wl1251_pdata;
>         int ret;
> 
>         trout_wl1251_pdata.irq = MSM_GPIO_TO_INT(29);
>         if (trout_wl1251_pdata.irq < 0)
>                 goto fail_irq;

This can't ever be true, right?

>         trout_wl1251_pdata.use_eeprom = false;
>         ret = wl12xx_set_platform_data(&trout_wl1251_pdata);
>         if (ret < 0)
>                 goto fail_irq;

More often one uses "if (ret)" unless ret > 0 has special meaning.

> fail_irq:
>         printk("trout wifi GPIO failed\n");
>         gpio_free(TROUT_WIFI_IRQ_GPIO);

But you always free a gpio here, shouldn't there be a return in there
before the fail_irq label?

> }
>

> How should I start debugging that issue? do I need a serial cable for my
> device and kgdb(doesn't serial need IRQ?, maybe I should look how msm
> serial works)?

It could be an interrupt storm, but check the above code, and
also make sure you still have the dummy msm_wifi platform device too, and
that the msm_wifi driver is getting a struct wifi_platform_data.

Unfortunately, I don't know of an easy way to debug livelocks due to
interrupt storms other than by disabling everything and then enabling one
thing at a time until it breaks again.

It's obviously going to be a lot of work, but if you can manage to get
a current kernel booting on your hardware and dump the msm_wifi module,
that would be the ideal approach.

-- 
Bob Copeland %% www.bobcopeland.com


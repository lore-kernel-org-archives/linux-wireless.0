Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:57035 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1ATMzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 07:55:52 -0500
Subject: Re: htc dream wl1251 and MSM_GPIO_TO_INT(29)
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110117150853.GC20703@hash.localnet>
References: <1295047993.24338.66.camel@gnutoo-laptop>
	 <20110117150853.GC20703@hash.localnet>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 13:55:15 +0100
Message-ID: <1295528115.2507.9.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > fail_irq:
> >         printk("trout wifi GPIO failed\n");
> >         gpio_free(TROUT_WIFI_IRQ_GPIO);
> 
> But you always free a gpio here, shouldn't there be a return in there
> before the fail_irq label?
I forgot the return, I wrote/copied(from omap3-pandora ) the code when I
was tired,I shouldn't write code when I'm that tired.

> also make sure you still have the dummy msm_wifi platform device too,
yes I have it

>  and
> that the msm_wifi driver is getting a struct wifi_platform_data.
it seem to get it

> Unfortunately, I don't know of an easy way to debug livelocks due to
> interrupt storms other than by disabling everything and then enabling one
> thing at a time until it breaks again.
> 
> It's obviously going to be a lot of work, but if you can manage to get
> a current kernel booting on your hardware and dump the msm_wifi module,
> that would be the ideal approach.
I've an old linux-next kernel booting but with no way to control the
phone, fortunately the gadget driver was merged in linux-next recently.
I'll try to resolve some compilation issues and to make it work first.

Denis.


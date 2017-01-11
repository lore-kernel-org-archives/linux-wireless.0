Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32882 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdAKNeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:34:25 -0500
Message-ID: <1484141660.29931.11.camel@sipsolutions.net> (sfid-20170111_143428_912564_167C32B8)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jan 2017 14:34:20 +0100
In-Reply-To: <2b0df84e78434d11af1089e82485704b@ceva-dsp.com>
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         <1484121737.23671.0.camel@sipsolutions.net>
         <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
         <1484125220.23671.1.camel@sipsolutions.net>
         <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
         <1484128809.23671.11.camel@sipsolutions.net>
         <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com>
         <1484132519.23671.12.camel@sipsolutions.net>
         <1dd6e9f3-5ad2-1138-8017-c0ab208d9f88@gmail.com>
         <927a79f16e8c429da7a0d06f1bfb2567@ceva-dsp.com>
         <1484136355.29931.1.camel@sipsolutions.net>
         <2b0df84e78434d11af1089e82485704b@ceva-dsp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When calling drv_tx() the headroom is not big enough for the driver.

Ok.

> > 
> > Maybe we're adding something else to this skb?
> > 
> > I can't find anything in the ath9k_htc driver that's adding more
> > than
> > 23 bytes (it's advertising 24) but clearly the last 8 bytes here
> > are
> > failing:
> > 
> > > [   83.200346] skbuff: skb_under_panic: text:ffffffffa034c028
> > > len:154
> > > put:8 head:ffff880213422e00 data:ffff880213422dfa tail:0x94
> > > end:0xc0
> > > dev:<NULL>
> > 
> > Maybe mac80211 is putting something else? It'd have to be
> 
> yes mac80211 is adding the security header.
> headroom asked to skb_copy_expand should also take sdata-
> >encrypt_headroom into account.

I suspected that, since it was about the only place that was adding
anything, but I couldn't test it :)

Can you send a patch?

johannes

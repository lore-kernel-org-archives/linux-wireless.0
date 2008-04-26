Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108]:49946 "EHLO
	smtp1.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYDZPSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:18:51 -0400
Message-ID: <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info> (sfid-20080426_171915_716285_C638B5D7)
Date: Sat, 26 Apr 2008 18:18:48 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
	<20080426045909.GA17936@ruslug.rutgers.edu>
In-Reply-To: <20080426045909.GA17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
> Will this really do the trick? It depends who allocates the
> struture -- kernel code using the old kernel headers or compat-wireless
> code using the replacable headers.
>
> In the earlier case then code using it can't be ported unless we
> come up with an backward-compatible solution, this is possible using
> compat.diff, we can add anything there for this effort.
>

Actually it doesn't after all. There's been other changes on 'struct usbnet'
that my trick doesn't account for, it might only work on 2.6.24 but  
that's not helpful at all.

>
> Heh fun, so now all usb wireless devices are named wlan%d, all
> mac80211 devices are named wlan%d, and yet a few PCI ones (prism54,
> etc), still will get their wlan%d. Should we care about just sticking to
> one or not bother for old stuff and just moving forward stick to
> wlan%d for both all fullmac and softmac devices?

I thought all wireless devices should have wlan%d names.

>
>> Also rndis_host should include this patch:
>>   http://marc.info/?l=linux-netdev&m=120626915222918&w=2
>
> drivers/net/usb/rndis_host.c is included as part of compat-wireless.
> I don't provide additional patches but just rely on what is already
> merged. This has the advantage of pushing people to push
> patches directly upstream and getting maintainers to merge them.

Patch was merged into 2.6.25.

  - Jussi



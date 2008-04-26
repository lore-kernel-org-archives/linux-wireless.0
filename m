Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:50417 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYDZE7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 00:59:10 -0400
Date: Sat, 26 Apr 2008 00:59:09 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
Message-ID: <20080426045909.GA17936@ruslug.rutgers.edu> (sfid-20080426_065932_185869_D9CC14BF)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 21, 2008 at 08:04:09PM +0300, Jussi Kivilinna wrote:
> Hello,
> 
> I just checked how rndis_wlan was included in  
> compat-wireless-2008-04-01 and noticed small problem. Patchset that  
> was required for rndis_wlan to work modified 'struct usbnet' in  
> usbnet.h, added 'void *driver_priv' at almost head:
>   http://marc.info/?l=linux-wireless&m=120130189428293&w=2
> 
> Compat-wireless includes new modified usbnet.h but doesn't include not  
> usbnet.c and cdc_ether.c on which rndis_host/rndis_wlan depend on to.  
> Also cdc_ether.c had another update:
>   http://marc.info/?l=linux-wireless&m=120130189928350&w=2

I tend to replace kernel stuff if the structures haven't changed.
Otherwise then you are allocating different sized structures or
accessing items which shouldn't be there and will segfault or get
the wrong data.

> So to have rndis_wlan working, you should include cdc_ether.c and  
> usbnet.c. But this would broke all the rest drivers in  
> 'drivers/net/usb' that depend on usbnet.c. To fix this is ofcourse to  
> move 'void *driver_info' at end of 'struct usbnet'.

Will this really do the trick? It depends who allocates the
struture -- kernel code using the old kernel headers or compat-wireless
code using the replacable headers.

In the earlier case then code using it can't be ported unless we
come up with an backward-compatible solution, this is possible using
compat.diff, we can add anything there for this effort.

> Ok, I haven't tested this myself, but this is how it seems to me. If  
> you add usbnet.c you might want to add this patch too and change flag  
> in rndis_wlan for 'wlanX' device names:
>   http://marc.info/?l=linux-wireless&m=120130189728322&w=2

Heh fun, so now all usb wireless devices are named wlan%d, all
mac80211 devices are named wlan%d, and yet a few PCI ones (prism54,
etc), still will get their wlan%d. Should we care about just sticking to
one or not bother for old stuff and just moving forward stick to
wlan%d for both all fullmac and softmac devices?

> Also rndis_host should include this patch:
>   http://marc.info/?l=linux-netdev&m=120626915222918&w=2

drivers/net/usb/rndis_host.c is included as part of compat-wireless.
I don't provide additional patches but just rely on what is already
merged. This has the advantage of pushing people to push 
patches directly upstream and getting maintainers to merge them.

  Luis

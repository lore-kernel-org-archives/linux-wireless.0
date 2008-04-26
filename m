Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:39449 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYDZS0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 14:26:11 -0400
Received: by an-out-0708.google.com with SMTP id d31so1061790and.103
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2008 11:26:10 -0700 (PDT)
Message-ID: <43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com> (sfid-20080426_202639_392025_7D0A743B)
Date: Sat, 26 Apr 2008 11:26:09 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
	 <20080426045909.GA17936@ruslug.rutgers.edu>
	 <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 26, 2008 at 8:18 AM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
> >
> > Will this really do the trick? It depends who allocates the
> > struture -- kernel code using the old kernel headers or compat-wireless
> > code using the replacable headers.
> >
> > In the earlier case then code using it can't be ported unless we
> > come up with an backward-compatible solution, this is possible using
> > compat.diff, we can add anything there for this effort.
> >
> >
>
>  Actually it doesn't after all. There's been other changes on 'struct
> usbnet'
>  that my trick doesn't account for, it might only work on 2.6.24 but that's
> not helpful at all.

Does the driver rely on all the new stuff? Or just he one you mentioned?

> >
> > Heh fun, so now all usb wireless devices are named wlan%d, all
> > mac80211 devices are named wlan%d, and yet a few PCI ones (prism54,
> > etc), still will get their wlan%d. Should we care about just sticking to
> > one or not bother for old stuff and just moving forward stick to
> > wlan%d for both all fullmac and softmac devices?
> >
>
>  I thought all wireless devices should have wlan%d names.

Well I would agree with this statement now. The arguments I've seen
before against this was:

 * if its not broken don't fix it
 * scripts who rely on device names may be broken

I'm all for just being consistent and sticking wlan%d though. Script
breaking consideration is important though.

> >
> >
> > > Also rndis_host should include this patch:
> > >  http://marc.info/?l=linux-netdev&m=120626915222918&w=2
> > >
> >
> > drivers/net/usb/rndis_host.c is included as part of compat-wireless.
> > I don't provide additional patches but just rely on what is already
> > merged. This has the advantage of pushing people to push
> > patches directly upstream and getting maintainers to merge them.
> >
>
>  Patch was merged into 2.6.25.

Cool, then compat picked it up. If I have time I'll try to test the
driver on 2.6.22 and see if I can backport any changes.

  Luis

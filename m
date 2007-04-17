Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.239]:51226 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161286AbXDQUYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 16:24:15 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1595397nze
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2007 13:24:15 -0700 (PDT)
Message-ID: <43e72e890704171324l12ebf189m5837aae95b7143d1@mail.gmail.com>
Date: Tue, 17 Apr 2007 16:24:14 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: prism54: WPA/RSN support for fullmac cards
Cc: "Stefan Puch" <stefan.puch@mail.uni-oldenburg.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200704171512.32564.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <462336B1.4090006@mail.uni-oldenburg.de>
	 <1176732546.27418.9.camel@localhost.localdomain>
	 <4625130F.4090104@mail.uni-oldenburg.de>
	 <200704171512.32564.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Tuesday 17 April 2007 14:33, Stefan Puch wrote:
> > I thought that at least chunkeey got a working connection.... obviously
> > not.
> >
> > Is there anything else I can do if I'm no Kernel Programmer (perhaps
> > provide more infos, do some other beta testings)?
> >
> > When I looked on the prism54.org homepage or their svn-repository it seems
> > that the driver is not developed any longer.
> > What is about Christian Lamparter (chunkee) or Luis R. Rodriguez (mcgrof)
> > are they still working on it?
> >
> Christian Lamparter now works on the mac80211 softmac driver (p54 in
> wireless-dev) and Luis gave up on getting WPA to work on fullmac IIRC.
> Easiest way to get WPA working right now is to run a softmac driver.

I'm here but am swamped with other work right that prevents me from
working on this at the moment. What I'd suggest is try skipping
DOT11_OID_PSM when in extended mode on the commit. I remember always
seeing issues with setting this specific OID when in extended mode, I
have a hunch this may be the issue.

Also -- I think having both drivers is a good thing, they both do
serve different purposes. Apparently going with a FullMAC design can
save you some power so prism54 should be good for those purposes. We
need to update this on the descriptions when we get a chance.

  Luis

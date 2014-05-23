Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47609 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaEWJxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:53:43 -0400
Message-ID: <1400838810.4358.23.camel@jlt4.sipsolutions.net> (sfid-20140523_115346_664171_DC471673)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 23 May 2014 11:53:30 +0200
In-Reply-To: <CA+BoTQmdLub9wRb03_M5bcFn5ruMcj8k-p-ELWBu516Gh14+sQ@mail.gmail.com> (sfid-20140523_113522_303347_B81D0F77)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	 <1400770484.4174.35.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmdNV3XMmiAmA=bP4ZQ7dRZOwX8=_NYqmZW+orEA=OysA@mail.gmail.com>
	 <1400834656.4358.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnLPEqTnyr98TmDETP_iBOAza_XLZ53Jd+GdG6sRc3=5Q@mail.gmail.com>
	 <1400836074.4358.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmdLub9wRb03_M5bcFn5ruMcj8k-p-ELWBu516Gh14+sQ@mail.gmail.com>
	 (sfid-20140523_113522_303347_B81D0F77)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 11:35 +0200, Michal Kazior wrote:

> > The thing is, I don't see that template based drivers would be able to
> > stop beaconing :-)
> >
> > This whole design that requires it seems a bit fishy to start with, so I
> > can't really imagine anyone writing firmware that supports it. That
> > said, ours only supports a single beacon at a time anyway, so we'll
> > switch immediately and don't have to do that anyway.
> 
> What if you have AP+STA and STA switches too? It might delay your AP
> interface switch, no? We could assume userspace always requests us to
> do The Right Thing, but should we trust it so much?

Most of the time we'd probably have a spare channel context anyway, so
it's not that big of a deal.

If we don't, well, I guess we might have to disconnect the STA or
something.

johannes


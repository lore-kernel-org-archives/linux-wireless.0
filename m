Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAVJ62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:58:28 -0500
Message-ID: <1390384700.4334.24.camel@jlt4.sipsolutions.net> (sfid-20140122_105832_692136_E853D141)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 22 Jan 2014 10:58:20 +0100
In-Reply-To: <CA+BoTQmE3TdT=oQbAjzUi5vGo0FA0opz1S9Z6-9UEQ_miSEpXQ@mail.gmail.com> (sfid-20140122_104043_252086_A2709C95)
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	 <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	 <1390318236.6199.45.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	 <1390381261.4334.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmE3TdT=oQbAjzUi5vGo0FA0opz1S9Z6-9UEQ_miSEpXQ@mail.gmail.com>
	 (sfid-20140122_104043_252086_A2709C95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 10:40 +0100, Michal Kazior wrote:

> > Can't we just prohibit that though? That seems pretty much useless,
> > although if the interfaces actually have different beacon intervals (if
> > such a thing is permitted?) then it would be necessary to do more
> > difficult calculations ...
> 
> Not really sure what extra calculation would be necessary here beyond
> just waiting until last interfaces finishes sending CSA beacons?

If we wanted to enforce that they all switch at (roughly) the same time,
and they have different beacon intervals, we'd have to do some
calculations.

> > Isn't it under RTNL anyway though?
> 
> No, it isn't. This is eventually called from a worker. I don't think
> you can use RTNL in a per-interface worker, can you?

Ah ok. No, you can't.

> > That's true, so maybe you just need to explain this chandef thing
> > better? I don't really see the utility (admittedly without actually
> > checking carefully in the code where you need it)
> 
> Since you can CSA multiple interfaces you can have different chandefs
> for those interfaces. This means you need to know the chandef for the
> final channel switch.
> 
> You could probably cache this to local->csa_chandef when processing
> the channel switch request itself, but that means you explicitly limit
> yourself to single CSA against a given hw/driver.
> 
> At one point I was contemplating having a dedicated structure for
> channel switches, and have a list of channel switch structures in
> ieee80211_local, but perhaps that's just an overkill.

But if we bind all interfaces against a 'pending' chanctx, then that's
all implicit in that chanctx calculating/binding, no?

johannes


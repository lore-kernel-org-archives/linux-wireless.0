Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37043 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbZHYS6l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 14:58:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 11:58:44 -0700
Date: Tue, 25 Aug 2009 11:58:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
Message-ID: <20090825185842.GA7357@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 11:45:12AM -0700, Bob Copeland wrote:
> On Tue, Aug 25, 2009 at 2:25 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
> > This was printing the wrong value on the warning. While at it
> > lets expand this warning to provide a little more useful
> > information for debugging such as the band and hardware rate
> > index when possible and clarify what the warning is actually
> > printing.
> 
> >        rix = sc->rate_idx[sc->curband->band][hw_rix];
> > -       if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
> > +       if (WARN(rix < 0, "invalid driver rate index: %x "
> > +                "(hw_rix: %x band: %s)\n", rix, hw_rix,
> > +                sc->curband->band ? "5 GHz" : "2.4 GHz"))
> 
> rix will always be -1 here so no real need to print it.

OK how about the band info, think that's useful?

> I'm pretty sure band is going to be "the wrong one," because all
> instances of this warning I've seen have been valid rate indexes,
> like 1 mbit rates when scanning 5 ghz, 

I got this on 0x1b which is ATH5K_RATE_CODE_1M, I was suspecting
the same.

> which could indicate some
> race condition with flushing the rx queue on channel changes.

I'll see if I can reproduce somehow.

> I haven't yet seen a hw rate we didn't know about.

So you've seen this lately as well?

  Luis

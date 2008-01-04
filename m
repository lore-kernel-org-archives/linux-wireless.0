Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:40675 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYADAC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 19:02:27 -0500
Received: by py-out-1112.google.com with SMTP id u52so10767880pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 16:02:26 -0800 (PST)
Message-ID: <43e72e890801031602q38a8f57fv3ba56a0f44e7e2c6@mail.gmail.com> (sfid-20080104_000234_131558_01DA3730)
Date: Thu, 3 Jan 2008 19:02:26 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: ath5k oops (recent regression, I think)
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"Andrew Lutomirski" <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <200712261117.33992.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
	 <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
	 <200712261117.33992.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 25, 2007 9:17 PM, bruno randolf <bruno@thinktube.com> wrote:
>
> On Tuesday 25 December 2007 23:23:02 Nick Kossifidis wrote:
> > 2007/12/25, bruno randolf <bruno@thinktube.com>:
> > > hello!
> > >
> > > i'm seeing the same oops, it seems to be a regression from
> > >
> > > commit fd640775bd16e1df50c867cc547af0787f9bd4ab
> > > Author: Johannes Berg <johannes@sipsolutions.net>
> > > Date:   Wed Dec 19 01:31:26 2007 +0100
> > >
> > >     mac80211: dont use interface indices in drivers
> > >
> > > seems ath5k likes to write some rate registers before vif is set up. i
> > > used the following as a stopgap fix. johannes, do you have any advice how
> > > to properly fix that?
> > >
> > > diff --git a/drivers/net/wireless/ath5k/hw.c
> > > b/drivers/net/wireless/ath5k/hw.c index f4478f6..2e9f5c5 100644
> > > --- a/drivers/net/wireless/ath5k/hw.c
> > > +++ b/drivers/net/wireless/ath5k/hw.c
> > > @@ -510,6 +510,11 @@ static inline void
> > > ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
> > >         const struct ath5k_rate_table *rt;
> > >         unsigned int i;
> > >
> > > +       if (sc->vif == NULL) {
> > > +               printk("*** sc->vif NULL\n");
> > > +               return;
> > > +       }
> > > +
> > >         /* Get rate table for the current operating mode */
> > >         rt = ath5k_hw_get_rate_table(ah,
> > >                 driver_mode);
> > >
> > > bruno
> >
> > Seems right as it doesn't break reset, i was just thinking maybe we
> > should pass an "initial" argument on ath5k_hw_reset to also skip some
> > other step (eg. saving/restoring tsf/seqnum etc). What do you think ?
>
> sounds like a good idea.
> or/and maybe we can defer the first reset until the first interface is
> assigned? would that be possible?

NACK for that patch

Although it fixes the oops I do not think its the right solution.

We use ieee80211_generic_frame_duration() to compute what we believe
is the ACK timeout and set it on the rate duration registers, and we
need this value set during reset, as we up the interface. The *real*
problem here is we need mac80211 to provide an exported routine which
drivers can use even if they don't have an up'd interface yet IMHO.
This can be easily fixed by making ieee80211_generic_frame_duration()
not rely on sdata and letting the user pass manually if short preamble
is desired in the calculation as an arg. I have to go now but will try
to address this as soon as I have time unless someone beats me.

  Luis

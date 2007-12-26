Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:37278 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751267AbXLZCRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 21:17:44 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: ath5k oops (recent regression, I think)
Date: Wed, 26 Dec 2007 11:17:33 +0900
Cc: "Andrew Lutomirski" <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com> <200712251804.13693.bruno@thinktube.com> <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
In-Reply-To: <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200712261117.33992.bruno@thinktube.com> (sfid-20071226_021748_497979_879473AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 December 2007 23:23:02 Nick Kossifidis wrote:
> 2007/12/25, bruno randolf <bruno@thinktube.com>:
> > hello!
> >
> > i'm seeing the same oops, it seems to be a regression from
> >
> > commit fd640775bd16e1df50c867cc547af0787f9bd4ab
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Wed Dec 19 01:31:26 2007 +0100
> >
> >     mac80211: dont use interface indices in drivers
> >
> > seems ath5k likes to write some rate registers before vif is set up. i
> > used the following as a stopgap fix. johannes, do you have any advice how
> > to properly fix that?
> >
> > diff --git a/drivers/net/wireless/ath5k/hw.c
> > b/drivers/net/wireless/ath5k/hw.c index f4478f6..2e9f5c5 100644
> > --- a/drivers/net/wireless/ath5k/hw.c
> > +++ b/drivers/net/wireless/ath5k/hw.c
> > @@ -510,6 +510,11 @@ static inline void
> > ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
> >         const struct ath5k_rate_table *rt;
> >         unsigned int i;
> >
> > +       if (sc->vif == NULL) {
> > +               printk("*** sc->vif NULL\n");
> > +               return;
> > +       }
> > +
> >         /* Get rate table for the current operating mode */
> >         rt = ath5k_hw_get_rate_table(ah,
> >                 driver_mode);
> >
> > bruno
>
> Seems right as it doesn't break reset, i was just thinking maybe we
> should pass an "initial" argument on ath5k_hw_reset to also skip some
> other step (eg. saving/restoring tsf/seqnum etc). What do you think ?

sounds like a good idea. 
or/and maybe we can defer the first reset until the first interface is 
assigned? would that be possible?

bruno

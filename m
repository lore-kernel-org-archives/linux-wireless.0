Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab2ECTdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:33:53 -0400
Message-ID: <1336073629.5167.13.camel@jlt3.sipsolutions.net> (sfid-20120503_213401_801305_68E0FF81)
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Timo Lindhorst <tlnd@online.de>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>, Javier Cardona <javier@cozybit.com>
Date: Thu, 03 May 2012 21:33:49 +0200
In-Reply-To: <20120430183454.GE2560@tuxdriver.com>
References: <201203281117.53033.tlnd@online.de>
	 <201203281128.27956.tlnd@online.de>
	 <1332927150.3479.25.camel@jlt3.sipsolutions.net>
	 <201203281547.21550.tlnd@online.de> <20120430183454.GE2560@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-30 at 14:34 -0400, John W. Linville wrote:
> On Wed, Mar 28, 2012 at 03:47:21PM +0200, Timo Lindhorst wrote:
> > > > > +     if (!ack)
> > > > > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > > > > +                     tx_count[i] = txi->control.rates[i].count;
> > > > > +
> > > > > 
> > > > >       ieee80211_tx_info_clear_status(txi);
> > > > >       if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
> > > > >       
> > > > >               txi->flags |= IEEE80211_TX_STAT_ACK;
> > > > > 
> > > > > +
> > > > > +     if (ack) {
> > > > > +             txi->status.rates[0].count = 1;
> > > > > +             txi->status.rates[1].idx = -1;
> > > > > +     } else {
> > > > > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > > > > +                     txi->control.rates[i].count = tx_count[i];
> > > > > +     }
> > > > > +
> > > > > 
> > > > >       ieee80211_tx_status_irqsafe(hw, skb);
> > > > >  
> > > > >  }
> > > > 
> > > > I know: backing up the count values, clearing the status, and restoring
> > > > the values if necessary is kind of ugly. Would it be better to partly
> > > > clear the status manually instead of using
> > > > ieee80211_tx_info_clear_status() ?
> > > 
> > > Yeah just noticed the ieee80211_tx_info_clear_status() in there too...
> > > 
> > > OTOH, what are you using this for?
> > While working on some modifications to the rate control code, I thought it 
> > would be handy to use mac80211_hwsim for debugging and testing. Thereby I 
> > noticed that the tx status does not report any tx attempts, thus the rate 
> > control could not work at all.
> > 
> > > It seems almost like we should always
> > > just set
> > > 	txi->status.rates[0].count = 1;
> > 
> > At least,
> > 	txi->status.rates[1].idx = -1;
> > has to be set too, to indicate that only the first rate was used.
> > 
> > 
> > > since we never attempted multiple transmits? I'm not really sure though,
> > > it's a corner case ... 
> > We would only attempt multiple transmits if the receiver is not responding to 
> > unicast frames -- maybe because it has failed or switched the channel. 
> > Probably not a common use case, but that was what I was testing...
> > 
> > 
> > > I could also imagine this being populated by
> > > userspace (wmediumd) but I guess that isn't there now ...
> > Right, but if you are not using wmediumd but the bare mac80211_hwsim ideal 
> > channel, there would be no rate information and thus no rate adaption through 
> > the rate control algorithm.
> > 
> > Regards
> > Timo
> 
> Johannes, does this satisfy your concerns?

Yeah, it seems that this is all needs to be extended to actually be
useful, but we can leave that for later.

I'm a little confused about this discussion & Javier's patch though --
are they related?

johannes


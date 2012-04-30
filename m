Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43064 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2D3Srq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 14:47:46 -0400
Date: Mon, 30 Apr 2012 14:34:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Timo Lindhorst <tlnd@online.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
Message-ID: <20120430183454.GE2560@tuxdriver.com> (sfid-20120430_204749_251748_7F4BB615)
References: <201203281117.53033.tlnd@online.de>
 <201203281128.27956.tlnd@online.de>
 <1332927150.3479.25.camel@jlt3.sipsolutions.net>
 <201203281547.21550.tlnd@online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201203281547.21550.tlnd@online.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 28, 2012 at 03:47:21PM +0200, Timo Lindhorst wrote:
> > > > +     if (!ack)
> > > > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > > > +                     tx_count[i] = txi->control.rates[i].count;
> > > > +
> > > > 
> > > >       ieee80211_tx_info_clear_status(txi);
> > > >       if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
> > > >       
> > > >               txi->flags |= IEEE80211_TX_STAT_ACK;
> > > > 
> > > > +
> > > > +     if (ack) {
> > > > +             txi->status.rates[0].count = 1;
> > > > +             txi->status.rates[1].idx = -1;
> > > > +     } else {
> > > > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > > > +                     txi->control.rates[i].count = tx_count[i];
> > > > +     }
> > > > +
> > > > 
> > > >       ieee80211_tx_status_irqsafe(hw, skb);
> > > >  
> > > >  }
> > > 
> > > I know: backing up the count values, clearing the status, and restoring
> > > the values if necessary is kind of ugly. Would it be better to partly
> > > clear the status manually instead of using
> > > ieee80211_tx_info_clear_status() ?
> > 
> > Yeah just noticed the ieee80211_tx_info_clear_status() in there too...
> > 
> > OTOH, what are you using this for?
> While working on some modifications to the rate control code, I thought it 
> would be handy to use mac80211_hwsim for debugging and testing. Thereby I 
> noticed that the tx status does not report any tx attempts, thus the rate 
> control could not work at all.
> 
> > It seems almost like we should always
> > just set
> > 	txi->status.rates[0].count = 1;
> 
> At least,
> 	txi->status.rates[1].idx = -1;
> has to be set too, to indicate that only the first rate was used.
> 
> 
> > since we never attempted multiple transmits? I'm not really sure though,
> > it's a corner case ... 
> We would only attempt multiple transmits if the receiver is not responding to 
> unicast frames -- maybe because it has failed or switched the channel. 
> Probably not a common use case, but that was what I was testing...
> 
> 
> > I could also imagine this being populated by
> > userspace (wmediumd) but I guess that isn't there now ...
> Right, but if you are not using wmediumd but the bare mac80211_hwsim ideal 
> channel, there would be no rate information and thus no rate adaption through 
> the rate control algorithm.
> 
> Regards
> Timo

Johannes, does this satisfy your concerns?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

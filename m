Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2C1Jcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:32:33 -0400
Message-ID: <1332927150.3479.25.camel@jlt3.sipsolutions.net> (sfid-20120328_113237_411413_5261E245)
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Timo Lindhorst <tlnd@online.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Wed, 28 Mar 2012 11:32:30 +0200
In-Reply-To: <201203281128.27956.tlnd@online.de>
References: <201203281117.53033.tlnd@online.de>
	 <201203281128.27956.tlnd@online.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 11:28 +0200, Timo Lindhorst wrote:
> Hey,
> 
> > +     if (!ack)
> > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > +                     tx_count[i] = txi->control.rates[i].count;
> > +
> >       ieee80211_tx_info_clear_status(txi);
> >       if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
> >               txi->flags |= IEEE80211_TX_STAT_ACK;
> > +
> > +     if (ack) {
> > +             txi->status.rates[0].count = 1;
> > +             txi->status.rates[1].idx = -1;
> > +     } else {
> > +             for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > +                     txi->control.rates[i].count = tx_count[i];
> > +     }
> > +
> >       ieee80211_tx_status_irqsafe(hw, skb);
> >  }
> 
> I know: backing up the count values, clearing the status, and restoring the
> values if necessary is kind of ugly. Would it be better to partly clear the 
> status manually instead of using ieee80211_tx_info_clear_status() ?

Yeah just noticed the ieee80211_tx_info_clear_status() in there too...

OTOH, what are you using this for? It seems almost like we should always
just set
	txi->status.rates[0].count = 1;

since we never attempted multiple transmits? I'm not really sure though,
it's a corner case ... I could also imagine this being populated by
userspace (wmediumd) but I guess that isn't there now ...

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:41848 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754133Ab0KDJtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 05:49:06 -0400
Subject: Re: [PATCH 3/4] mac80211: don't fragment packets when
 HW-fragmentation is on
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimXwopqOUcBWxwAmEH1tJbtLQisW7dmm+XDWHPe@mail.gmail.com>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
	 <1288821053-19013-4-git-send-email-arik@wizery.com>
	 <1288836908.4083.2.camel@jlt3.sipsolutions.net>
	 <AANLkTimXwopqOUcBWxwAmEH1tJbtLQisW7dmm+XDWHPe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:52:48 +0200
Message-ID: <1288864368.10002.43.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 06:34 +0100, ext Arik Nemtsov wrote:
> On Thu, Nov 4, 2010 at 04:15, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > On Wed, 2010-11-03 at 23:50 +0200, Arik Nemtsov wrote:
> > > If the driver supports hardware TX fragmentation, don't fragment
> > > packets in the stack.
> >
> > I'm not sure why you have three patches? Seems like it could all be a
> > single mac80211 patch.
> 
> Sure. I'll send a v2 with the mac80211 patches bundled into a single one.
> 
> >
> > > @@ -1181,8 +1183,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
> > >       /*
> > >        * Set this flag (used below to indicate "automatic fragmentation"),
> > >        * it will be cleared/left by radiotap as desired.
> > > +      * Only valid when fragmentation is done by the stack.
> > >        */
> > > -     tx->flags |= IEEE80211_TX_FRAGMENTED;
> > > +     if (!(local->hw.flags & IEEE80211_HW_TX_FRAGMENTATION))
> > > +             tx->flags |= IEEE80211_TX_FRAGMENTED;
> >
> > Do we really need the hw flag? Couldn't we go off the callback, like we
> > used to? I'm not really sure which one would perform better though, I
> > guess the flag might ...
> 
> I think the flag may be less confusing for new driver writers.
> Someone can implement the callback as a no-op and have a bug in his
> code as a result.

Well, if someone implements the fragmentation setting function as a
no-op, it is a bug in the driver and it should be fixed.  It's easy to
make that clear in the documentation.  "If the hardware doesn't support
fragmentation, set this function to NULL" or something.

That's how it's done already with other ops, such as hw_scan and so on.
I don't see a need to have another flag.

Performance-wise, if there's an impact it will be almost insignificant,
I believe.

-- 
Cheers,
Luca.


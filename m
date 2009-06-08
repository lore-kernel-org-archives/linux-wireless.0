Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40316 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZFHSQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 14:16:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCH] b43 add harware tkip
Date: Mon, 8 Jun 2009 20:16:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <83a869cd0906071450h24ed4119s44d00db0d97d59e2@mail.gmail.com> <200906081720.59594.mb@bu3sch.de> <83a869cd0906081104m2ecdf049rdcc7694f0974ca28@mail.gmail.com>
In-Reply-To: <83a869cd0906081104m2ecdf049rdcc7694f0974ca28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906082016.29793.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 June 2009 20:04:33 gregor kowski wrote:
> >> +     if (algorithm == B43_SEC_ALGO_TKIP) {
> >> +             /*
> >> +              * We should provide an initial iv32, phase1key pair.
> >> +              * We could start with iv32=0 and compute the corresponding
> >> +              * phase1key, but this mean calling ieee80211_get_tkip_key
> >> +              * with a fake skb (or export other tkip function).
> >> +              * Because we are lazy we hope iv32 won't start with
> >> +              * 0xffff and let's b43_mac_update_tkip_key provide a
> >> +              * correct pair.
> >> +              */
> >> +             rx_tkip_phase1_write(dev, index, 0xffff, (u16*)buf);
> >> +     } else /* clear it */
> >> +             rx_tkip_phase1_write(dev, index, 0, (u16*)buf);
> >
> > Why do you write phase1, if TKIP is not used?
> I clear the value in shared memory.

Yeah, that's what I don't understand here. Does buf contain only zero bytes in this case?

> >> +     /* FIXME : for b43_new_kidx_api, there can be 54 key
> >> +      * instead of 50 in RCMTA and TKIPTSCTTAK.
> >> +      */
> >
> > I don't understand this comment.
> if  b43_new_kidx_api is true :
> - we set max_nr_keys to 58
> - we program B43_MMIO_RCMTA_COUNT to 50
> - in b43_key_write we can allocate key up to index 58 (4 for default,
> 54 for sta)
> 
> But there is only 50 entries for TKIPTSCTTAK, and a comment on bcm-v4
> suggest there is 50 entries for RCMTA. So if there more than 50
> station we will overflow RCMTA and TKIPTSCTTAK.

Yeah well. The key handling is pretty weird.
There are 50 pairwise keys available. max_nr_keys includes pairwise keys, group keys (4)
and another copy of the group keys (4) used with older firmware. So we end up at 58.

To summarize it, in practice we have 50 pairwise keys and 4 group keys. You can ignore
the additional 4 "rx keys" as they are not used in recent fw and are just a copy of the
group keys.

> So the fix will be do to something like
> dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
> if (b43_new_kidx_api())
> dev->max_nr_keys -= 4;

Hm, I don't think this is correct. There are lots of weird assumptions all over the code.
We should probably remove that new_kidx_api crap alltogether.

> >> -             if (algorithm == B43_SEC_ALGO_TKIP) {
> >> -                     /* FIXME: No TKIP hardware encryption for now. */
> >> +             if (algorithm == B43_SEC_ALGO_TKIP &&
> >> +                             (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ||
> >> +                                key->flags & IEEE80211_KEY_FLAG_WMM_STA )) {
> >> +                     /* We support only one rx queue (no QOS) and pairwise key */
> >
> > This comment doesn't really make sense to me, too.
> > What does QoS have to do with the RX queue?
> each QOS queue got it's own tkip counters (iv16, iv32) (check tkip.c
> software implementation for more info).

Yeah, but what does --> ___RX___ <-- (receive) have to do with that?
We do always only have one RX queue.

-- 
Greetings, Michael.

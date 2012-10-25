Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYUQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 16:16:56 -0400
Message-ID: <1351196249.10421.20.camel@jlt4.sipsolutions.net> (sfid-20121025_221659_699877_FCD1BC60)
Subject: Re: [PATCH] wireless: drop invalid mesh address extension frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 25 Oct 2012 22:17:29 +0200
In-Reply-To: <CAPjQAd_J3WEwr=2Fs5us4BvJWKx6HhwnDFSey6S9NP8w6RXsvA@mail.gmail.com> (sfid-20121025_221513_188829_9704476A)
References: <1351195011-30148-1-git-send-email-johannes@sipsolutions.net>
	 <CAPjQAd_J3WEwr=2Fs5us4BvJWKx6HhwnDFSey6S9NP8w6RXsvA@mail.gmail.com>
	 (sfid-20121025_221513_188829_9704476A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 13:14 -0700, Javier Cardona wrote:

> > @@ -373,6 +370,11 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
> >                         /* make sure meshdr->flags is on the linear part */
> >                         if (!pskb_may_pull(skb, hdrlen + 1))
> >                                 return -1;
> > +                       /* reserved */
> > +                       if ((meshdr->flags & MESH_FLAGS_AE) ==
> > +                                               (MESH_FLAGS_AE_A4 |
> > +                                                MESH_FLAGS_AE_A5_A6))
> > +                               return -1;
> 
> You can filter more aggressively:  If we are here we know that it is a
> unicast data frame  (because FromDS == ToDS == 1).  In that case, the
> only valid address extension modes are 0 or MESH_FLAGS_AE_A5_A6 (see
> Table 8-14). IOW, you could do:
> 
> > +                       if ((meshdr->flags & MESH_FLAGS_AE_A4)))
> > +                                   return -1

Ok.

> > @@ -397,6 +399,11 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
> >                         /* make sure meshdr->flags is on the linear part */
> >                         if (!pskb_may_pull(skb, hdrlen + 1))
> >                                 return -1;
> > +                       /* reserved */
> > +                       if ((meshdr->flags & MESH_FLAGS_AE) ==
> > +                                               (MESH_FLAGS_AE_A4 |
> > +                                                MESH_FLAGS_AE_A5_A6))
> > +                               return -1;
> 
> And a similar comment here: only valid address extension modes are 0
> or MESH_FLAGS_AE_A4, i.e.
> 
> > +                       if ((meshdr->flags & MESH_FLAGS_AE_A5_A6)))
> > +                                   return -1

Ok good, I'll make these changes, makes the code formatting nicer too :)

johannes


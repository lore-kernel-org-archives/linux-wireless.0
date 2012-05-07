Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2EGMFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 08:05:16 -0400
Message-ID: <1336392314.4325.26.camel@jlt3.sipsolutions.net> (sfid-20120507_140521_367567_08CA6B43)
Subject: Re: [PATCH] mac80211: support adding IV-room in the skb for CCMP
 keys
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 14:05:14 +0200
In-Reply-To: <CAFED-jku-zGtTvYwGpwCastRJZAfQf9uyJAeqtevGVRn22Qygg@mail.gmail.com> (sfid-20120507_140219_605554_7A5D6519)
References: <1319350901-31178-1-git-send-email-arik@wizery.com>
	 <4EA7DA0F.7050603@sipsolutions.net>
	 <CA+XVXff+4SLy6y2xbDONDOg_j9CNYd1rkLgtdvHEKpprBW5zog@mail.gmail.com>
	 <CAFED-jku-zGtTvYwGpwCastRJZAfQf9uyJAeqtevGVRn22Qygg@mail.gmail.com>
	 (sfid-20120507_140219_605554_7A5D6519)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 14:01 +0200, Janusz Dziedzic wrote:
> 2011/10/26 Arik Nemtsov <arik@wizery.com>:
> > On Wed, Oct 26, 2011 at 11:59, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> On 10/23/2011 8:21 AM, Arik Nemtsov wrote:
> >>>
> >>> Some cards can generate CCMP IVs in HW, but require the space for the IV
> >>> to be pre-allocated in the frame at the correct offset. Add a key flag
> >>> that allows us to achieve this.
> >>
> >> Is it really that expensive to generate the IV and then not use it that this
> >> is worth the extra complexity? This not just makes it more complex but also
> >> more expensive in the other case.
> >>
> >
> > Some of the platforms with this chip are pretty weak (host CPU is the
> > bottleneck).
> >
> > We add another "if" for the other case (for a value that's likely in
> > the cacheline already). I don't think that's too bad.
> >
> 
> Hello,
> Why this is only done for CCMP?
> Our firmware require such IVs allocation for all modes and currently
> we have common code that do that in the driver based on:
> iv_len = tx_info->control.hw_key->iv_len
> icv_len = tx_info->control.hw_key->icv_len
> 
> /* cw1200 driver */
> skb_push(t->skb, iv_len);
> memmove(newhdr, newhdr + iv_len, t->hdrlen);
> skb_put(t->skb, icv_len);
> ....
> 
> Isn't better to handle all modes in mac80211 base on
> IEEE80211_KEY_FLAG_PUT_IV_SPACE or just leave this for the driver?
> 
> I know this is easy to fix in our driver but still we have to remember
> that in case of CCMP mac80211 will already do it for us and will not
> do that in case of other modes.
> So, my proposal is to remove all changes from net/mac80211/wpa.c file
> and remember that driver should care about it - in such case
> PUT_IV_SPACE will be more generic.

I suggest the opposite, make it more generic in mac80211.

johannes


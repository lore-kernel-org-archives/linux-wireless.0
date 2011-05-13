Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab1EMXsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:48:37 -0400
Subject: Re: [PATCH] carl9170: advertise interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <201105140139.34401.chunkeey@googlemail.com> (sfid-20110514_013958_904501_3078CE39)
References: <201105140035.06559.chunkeey@googlemail.com>
	 <1305329300.32461.0.camel@jlt3.sipsolutions.net>
	 <201105140139.34401.chunkeey@googlemail.com>
	 (sfid-20110514_013958_904501_3078CE39)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 01:48:35 +0200
Message-ID: <1305330515.680.4.camel@jlt3.sipsolutions.net> (sfid-20110514_014840_577882_5A57A7A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 01:39 +0200, Christian Lamparter wrote:

> > Cool, thanks! Note that currently it's not yet required, but
> > whatever :-)

> "currently" :D
> 
> "I want to make you aware that I plan to remove the
> WIPHY_FLAG_ENFORCE_COMBINATIONS flag again soon, so that all
> drivers that don't advertise valid combinations will not be able to have
> multiple virtual interfaces."

:P

I think it's a bit of a mess to have drivers advertise no combinations
yet still support them. But of course any userspace application that
makes use of the advertising will just think it's not supported anyway,
so it doesn't matter all that much.

> > > with the standard firmware, iw now displays:
> > > 	[...]
> > >         valid interface combinations:
> > >                  * #{ IBSS, managed, AP, P2P-client, P2P-GO } <= 2,
> > >                    total <= 2, #channels <= 1
> > 
> > Since mac80211 doesn't allow multiple IBSS interfaces, I think you
> > should leave that out. And I should probably make mac80211 complain if
> > it's advertised erroneously.
> what about "valid" configurations like:
> 1 IBSS + 1 AP [STA/P2P make less sense]? 
> (only one IBSS)

In theory mac80211 supports that, yeah. Not sure it makes any sense ...

You could advertise it that way by adding a "one IBSS only"
ieee80211_iface_limit to the combination, so it'll look like this:

	* #{ IBSS } <= 1, #{ managed, AP, P2P-client, P2P-GO } <= 2,
	  total <= 2

Truth though is that due to the channel restriction that will only be
possible if you lock the IBSS to a channel. I guess the question is if
it makes sense to list IBSS at all, or if you want to just remove it and
not have to worry about TSF sync issues and all that. But I can't say I
really care.

johannes


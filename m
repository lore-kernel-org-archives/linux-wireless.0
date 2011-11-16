Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1KPOm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:42:57 -0500
Subject: Re: [PATCH 4/4] mac80211: transmit fragment list to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAOZOX0VkGezQcijrEMiQSiuY=yadgSva7w9-SfrvYYW_UG+0LQ@mail.gmail.com> (sfid-20111116_154033_317943_1E753583)
References: <20111116142854.518391560@sipsolutions.net>
	 <20111116142911.501655161@sipsolutions.net>
	 <CAOZOX0VkGezQcijrEMiQSiuY=yadgSva7w9-SfrvYYW_UG+0LQ@mail.gmail.com>
	 (sfid-20111116_154033_317943_1E753583)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 15:42:52 +0100
Message-ID: <1321454572.4502.3.camel@jlt3.sipsolutions.net> (sfid-20111116_154300_391376_C734BF90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 15:40 +0100, Ivo Van Doorn wrote:

> > +static inline void drv_tx_frags(struct ieee80211_local *local,
> > +                               struct ieee80211_sub_if_data *sdata,
> > +                               struct sta_info *sta,
> > +                               struct sk_buff_head *skbs,
> > +                               void *internal)
> > +{
> > +       local->ops->tx_frags(&local->hw,
> > +                            sdata ? &sdata->vif : NULL,
> > +                            sta ? &sta->sta : NULL,
> > +                            skbs, internal);
> > +}
> 
> Instead of changing every driver and making .tx_frags callback mandatory,
> isn't it easier to have a if-else here?

We certainly can't have the if-else here, if there should be one it
should be in __ieee80211_tx().

> Then it is much easier for the drivers as you can document that either
> .tx or .tx_frags is mandatory but never both.

Maybe that's the better option. Somehow I thought it would be more
efficient this way, but I guess it doesn't actually make much of a
difference and I can get rid of the void *internal parameter.

I'll change.

johannes


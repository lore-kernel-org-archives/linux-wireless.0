Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60087
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S936396AbXLQUHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 15:07:50 -0500
Date: Mon, 17 Dec 2007 12:07:48 -0800 (PST)
Message-Id: <20071217.120748.51571249.davem@davemloft.net> (sfid-20071217_200755_486113_8445E9B8)
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'fixes-jgarzik' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071217193402.GD3121@tuxdriver.com>
References: <20071216043148.GE3096@tuxdriver.com>
	<20071217193402.GD3121@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Dec 2007 14:34:02 -0500

> On Sat, Dec 15, 2007 at 11:31:48PM -0500, John W. Linville wrote:
> 
> > Cyrill Gorcunov (2):
> >       ieee80211_rate: missed unlock
> 
> >  net/mac80211/ieee80211_rate.c                  |    1 +
> 
> > diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
> > index 7254bd6..3260a4a 100644
> > --- a/net/mac80211/ieee80211_rate.c
> > +++ b/net/mac80211/ieee80211_rate.c
> > @@ -33,6 +33,7 @@ int ieee80211_rate_control_register(struct rate_control_ops *ops)
> >  		if (!strcmp(alg->ops->name, ops->name)) {
> >  			/* don't register an algorithm twice */
> >  			WARN_ON(1);
> > +			mutex_unlock(&rate_ctrl_mutex);
> >  			return -EALREADY;
> >  		}
> >  	}
> 
> Crud...there is a one-line fix in here that should have gone to Dave.
> 
> Jeff, (assuming Dave ACKs it) would you mind just taking it your
> way along with the other posted patches?  Since this is intended for
> 2.6.24, there should be no great maintenance hardship if it goes to
> Linus through your tree instead of Dave's.

It's totally fine if Jeff takes this, don't worry so much about
it :-)

And yes the change looks fine to me too :)

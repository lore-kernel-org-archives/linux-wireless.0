Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab1BORKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 12:10:21 -0500
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20110215190657.75006zvz1q691rk8@naisho.dyndns.info>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
	 <20110215190657.75006zvz1q691rk8@naisho.dyndns.info>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 18:10:20 +0100
Message-ID: <1297789820.8664.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 19:06 +0200, Jussi Kivilinna wrote:

> > -static int b43_op_tx(struct ieee80211_hw *hw,
> > +static void b43_op_tx(struct ieee80211_hw *hw,
> >  		     struct sk_buff *skb)
> >  {
> >  	struct b43_wl *wl = hw_to_b43_wl(hw);
> > @@ -3211,14 +3211,11 @@ static int b43_op_tx(struct ieee80211_hw
> >  	if (unlikely(skb->len < 2 + 2 + 6)) {
> >  		/* Too short, this can't be a valid frame. */
> >  		dev_kfree_skb_any(skb);
> > -		return NETDEV_TX_OK;
> >  	}
> 
> Return missing.

Right, thanks.

johannes


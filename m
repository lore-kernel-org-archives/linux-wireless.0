Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41498 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbcHQNSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 09:18:18 -0400
Message-ID: <1471439894.5173.9.camel@sipsolutions.net> (sfid-20160817_151822_163229_6714D766)
Subject: Re: [PATCH] mac80211: Move crypto IV generation to after TXQ
 dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Date: Wed, 17 Aug 2016 15:18:14 +0200
In-Reply-To: <87h9aj5ydx.fsf@toke.dk>
References: <20160817125800.19154-1-toke@toke.dk>
	 <1471439315.5173.7.camel@sipsolutions.net> <87h9aj5ydx.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-17 at 15:16 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > 
> > > 
> > > @@ -1573,6 +1574,7 @@ struct ieee80211_key_conf {
> > >  	u8 iv_len;
> > >  	u8 hw_key_idx;
> > >  	u8 flags;
> > > +	u8 pn_offs;
> > > 
> > This is completely wrong.
> 
> Well, the ieee80211_fast_tx struct is not available in
> ieee80211_tx_dequeue, and I need the offset there. I thought about
> sticking it into ieee80211_tx_info, but that is kinda full, and since
> the ieee80211_key_conf is already available there, carrying it there
> seems to work.

For very limited testing, perhaps. But this isn't static across all
usages of the key, so this is still completely broken.

> What would be a better way to do this?
> 

Some redesign/rearchitecture, probably. Or just do it all in the driver
like iwlmvm?

johannes

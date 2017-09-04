Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45866 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753359AbdIDJdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 05:33:43 -0400
Message-ID: <1504517620.9797.3.camel@sipsolutions.net> (sfid-20170904_113347_061271_8440EE3C)
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Mon, 04 Sep 2017 11:33:40 +0200
In-Reply-To: <87378lvyfz.fsf@toke.dk>
References: <20170622102030.9795-1-johannes@sipsolutions.net>
         <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-08-21 at 15:32 +0200, Toke Høiland-Jørgensen wrote:
> 
> > +			struct ieee80211_vif *vif;
> >  			struct ieee80211_key_conf *hw_key;
> >  			u32 flags;
> > -			/* 4 bytes free */
> > +			codel_time_t enqueue_time;
> 
> A side effect of this is that enqueue_time will be valid in the
> driver; which is good as far as I'm concerned (I've been thinking
> about using it to make decisions about when to stop retrying a
> frame).

Well, I think we need to do a lot more to allow that, but I guess
ultimately it would be possible - though we have this as codel_time_t
so the driver doesn't really know the reference etc. immediately.

> If we want to save the four bytes, is there any reason we can't just
> change the codel code to use skb->tstamp instead?

I didn't really want to go into that.

Any comments on the patch itself? I don't think I even merged this yet.

johannes

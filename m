Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39331 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbYIKRyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:54:51 -0400
Date: Thu, 11 Sep 2008 10:54:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
Message-ID: <20080911175442.GE6049@tesla> (sfid-20080911_195454_468131_34718D63)
References: <20080910220145.707263000@sipsolutions.net> <18632.55008.411078.289830@gargle.gargle.HOWL> <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla> <1221151995.6986.33.camel@johannes.berg> <20080911173335.GD6049@tesla> <1221154777.6986.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221154777.6986.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 10:39:37AM -0700, Johannes Berg wrote:
> On Thu, 2008-09-11 at 10:33 -0700, Luis R. Rodriguez wrote:
> > On Thu, Sep 11, 2008 at 09:53:15AM -0700, Johannes Berg wrote:
> > > On Thu, 2008-09-11 at 09:50 -0700, Luis R. Rodriguez wrote:
> > > > > I had actually tried
> > > > > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
> > 
> > Just a comment so far from the patch.
> > 
> > > +     rcu_read_unlock();
> > > +
> > > +     /* the "!an" here is fine even outside RCU lock */
> > 
> > Why is that? I fail to see that.
> 
> Well take the larger bit of code:
> 
> 	struct something *an = NULL;
> 
> ...
> 
> 	rcu_read_lock();
> 	sta = ieee80211_find_sta(hw, hdr->addr2);
> 	if (sta)
> 		an = (void *) sta->drv_priv;
>  
>  	if (an) {
>  		ath_rx_input(sc, an,
>  			     hw->conf.ht_conf.ht_supported,
>  			     skb, status, &st);
>  	}
> 	rcu_read_unlock();
> 
> 	/* the "!an" here is fine even outside RCU lock */
>  	if (!an || (st != ATH_RX_CONSUMED))
>  		__ieee80211_rx(hw, skb, &rx_status);
> 
> 
> So at this point it's only checking whether above it had a pointer, it's
> not accessing it. Think of the "an" variable, after rcu_read_unlock(),
> as a bool indicating whether or not the code that just happened had
> access to the node or not.

I see now, thanks :)

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbXKKFee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 00:34:34 -0500
Date: Sat, 10 Nov 2007 21:34:33 -0800 (PST)
Message-Id: <20071110.213433.76667260.davem@davemloft.net> (sfid-20071111_053442_316119_BDEE7036)
To: kaber@trash.net
Cc: joe@perches.com, mcgrof@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4734F7B6.7060505@trash.net>
References: <4734E962.3010603@trash.net>
	<1194653320.19522.28.camel@localhost>
	<4734F7B6.7060505@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 10 Nov 2007 01:13:42 +0100

> Joe Perches wrote:
> > On Sat, 2007-11-10 at 00:12 +0100, Patrick McHardy wrote:
> >   
> >> This may cause a use-after-free since __dev_addr_delete frees the address
> >> when all references are gone.
> >>     
> >
> > How about a comment then?  Perhaps:
> >
> > diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
> > index ae35405..63576aa 100644
> > --- a/net/core/dev_mcast.c
> > +++ b/net/core/dev_mcast.c
> > @@ -165,16 +165,23 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
> >  	netif_tx_lock_bh(from);
> >  	netif_tx_lock_bh(to);
> >  
> > +	/*
> > +	  This while loop can't be written as
> > +		for (da = from->mc_list; da; da = da->next)
> > +	  da = from->mc_list and __dev_addr_delete can kfree(from->mc_list)
> > +	  which could cause a use-after-free of da->next
> > +	*/
> >   
> 
> Seems unnecessary to me, we also don't comment each list_for_each_entry_safe
> iteration. I consider the use of a seperate next variable self-explanatory.

Agreed, this comment is pointless.

I'll apply Joe's patch without the comment.

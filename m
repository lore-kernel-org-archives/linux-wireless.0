Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2FYOMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 10:12:19 -0400
Message-ID: <1340633534.27437.2.camel@jlt3.sipsolutions.net> (sfid-20120625_161223_630684_9854B1F4)
Subject: Re: [RFC 06/17] nl80211: prepare for non-netdev wireless devs
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 16:12:14 +0200
In-Reply-To: <CAB3XZEeaG2i0LBOE6Jzsy6ghxpGRcDm3wUwi=+Vcmr9NcX96cw@mail.gmail.com> (sfid-20120625_154644_663761_77F9A61A)
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	 <1340117456-10154-7-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeaG2i0LBOE6Jzsy6ghxpGRcDm3wUwi=+Vcmr9NcX96cw@mail.gmail.com>
	 (sfid-20120625_154644_663761_77F9A61A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 16:46 +0300, Eliad Peller wrote:

> > - * This structure must be allocated by the driver/stack
> > - * that uses the ieee80211_ptr field in struct net_device
> > - * (this is intentional so it can be allocated along with
> > - * the netdev.)
> > + * For netdevs, this structure must be allocated by the driver
> > + * that uses the ieee80211_ptr field in struct net_device (this
> > + * is intentional so it can be allocated along with the netdev.)
> > + * It need not be registered then as netdev registration will
> > + * be intercepted by cfg80211 to see the new wireless device.
> > + *
> it think you meant "it needs to be registered..." ?

Well, I should probably reword this, but I did actually mean that it
need not be registered (with cfg80211) if it has a netdev, because then
it must be registered as a netdev and "netdev registration will be
intercepted ..."

> > +       u32 identifier;

> > +       int devlist_generation, wdev_id;
> 
> it doesn't really matter, but why not define wdev_id with the same
> type as wdev->identifier?

I didn't even notice that, oops.

> > +       if (result)
> > +               return result;
> > +       return ERR_PTR(-ENODEV);
> 
> doesn't it remove the netns checks you've just added? :)

D'oh. Good point!

johannes


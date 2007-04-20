Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46438
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767225AbXDTUcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 16:32:54 -0400
Date: Fri, 20 Apr 2007 13:32:57 -0700 (PDT)
Message-Id: <20070420.133257.32722308.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: shemminger@linux-foundation.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1177098521.5902.20.camel@johannes.berg>
References: <1176825010.3902.28.camel@johannes.berg>
	<20070418140451.075370fc@freekitty>
	<1177098521.5902.20.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 20 Apr 2007 21:48:41 +0200

> I'm not entirely opposed to making cfg80211 hold rtnl for configuration,
> it just seems pointless to block configuration of different devices
> against each other when even a for a single item it shouldn't matter.
> Then again, holding rtnl in cfg80211 would simplify some things because
> we could pass in a netdev pointer instead of the ifindex for example.
> 
> If you think I can justify holding rtnl in cfg80211 I'm certainly
> willing to change that. Global locks are just too suspicious to me ;)

It is true that things like IPSEC configuration via xfrm_user.c
uses it's own mutex, so there is precedence for splitting up
the locking where things are truly seperate.

But changing things like MAC addresse changes, which you mention, do
fall into the existing scope of the RTNL semaphore.

If it simplifies things, all the reason more to use it for cfg80211.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40484
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYEEXO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:14:58 -0400
Date: Mon, 05 May 2008 16:14:58 -0700 (PDT)
Message-Id: <20080505.161458.46071527.davem@davemloft.net> (sfid-20080506_011415_341585_815C6FB8)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210027447.8012.15.camel@johannes.berg>
References: <1210021066.4181.41.camel@johannes.berg>
	<20080505.153730.186617868.davem@davemloft.net>
	<1210027447.8012.15.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 May 2008 00:44:07 +0200

> Right, that makes sense. But will it ever return false? skb_cloned()
> returns true often enough, and we only accept linear skbs, but I think I
> don't understand yet what skb_header_cloned() vs. skb_cloned() refers
> to. Which exactly is the header space I'm allowed to modify when
> skb_header_cloned() returns false?

skb_header_cloned() will return false always if the buffer is not
cloned.

If it is cloned, it makes sure the data reference count allows
for modification of the buffer.

For normal traffic, you should see skb_header_cloned() always return
false unless a network tap like tcpdump is registered.

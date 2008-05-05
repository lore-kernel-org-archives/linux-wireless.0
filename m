Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56435
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYEETuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:50:13 -0400
Date: Mon, 05 May 2008 12:50:13 -0700 (PDT)
Message-Id: <20080505.125013.129139559.davem@davemloft.net> (sfid-20080505_214932_730322_84FBADCE)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210014316.4181.14.camel@johannes.berg>
References: <1210010254.4181.4.camel@johannes.berg>
	<20080505.115855.137964071.davem@davemloft.net>
	<1210014316.4181.14.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 May 2008 21:05:15 +0200

> On Mon, 2008-05-05 at 11:58 -0700, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Mon, 05 May 2008 19:57:34 +0200
> > 
> > > NETIF_F_FRAGLIST I haven't understood, but it seems to apply mostly for
> > > IP fragmentation?
> > 
> > That's right.  It's for cards that can do IP fragmentation in
> > hardware.
> 
> What does "do IP fragmentation in hardware" mean?

My bad, it merely allows for devices that can handle
frag lists in sk_buff as transmit packets.

I guess you could use this, btw, to take on arbitrary things
to the front of frames to handle big headers.  But that's more
expensive than just getting the LL header length right.

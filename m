Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59737
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759989AbYEEUoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 16:44:20 -0400
Date: Mon, 05 May 2008 13:44:20 -0700 (PDT)
Message-Id: <20080505.134420.194001886.davem@davemloft.net> (sfid-20080505_224344_384439_FC9B48F2)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210018214.4181.27.camel@johannes.berg>
References: <1210017456.4181.23.camel@johannes.berg>
	<20080505.130225.159803012.davem@davemloft.net>
	<1210018214.4181.27.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 May 2008 22:10:14 +0200

> So you're saying the check there to see if we can add 802.11 headers
> should depend on skb_header_cloned() and not skb_cloned()?

If you're pushing things in front (adding headers), you should basically
always be OK.

The problem is the skb->data pointer, that has to remain stable
once dev_queue_xmit() gets the frame because taps like AF_PACKET
can have access to the packet (via net/core/dev.c:dev_queue_xmit_nit()).

(If you read the AF_PACKET code, and notice how it munges the
 headers, note that it only does so temporarily and restores the
 skb->data and skb->len state before returning back up to
 it's caller, dev_hard_start_xmit())

I think the AF_PACKET stuff is actually superfluous on the transmit
side, we always give it clones so it can modify skb->data however it
pleases without having to restore anything.  Someone with some time
should look more closely into this :-)  The problem here seems to
be that pt->func is used for both receive and transmit paths, so it
must be mindful to handle both cases properly.

BTW, this gets back to the topic of the pain caused by pretending this
stuff is ethernet when it isn't.  If we really made these wireless
devices look the way they should, tcpdump could see the headers
correctly.  I'm sure you have all sorts of hacks in the 80211 code to
make 802.11 header capture possible via side-band stuff, but it would
have been so much nicer (and transparently solved these header space
issues) if we didn't try to put lipstick on a pig :-)

Anyways, back to the original topic.  I think you can avoid COW'ing
clones if you don't modify skb->data and give the drivers some other
way to know where the wireless headers really start.

Alternatively, you can just clone the packet.  At that point the
skb->data etc. members are your's to modify to your heart's content.
And because nobody can look below the original skb->data value, you
can stick your headers there.


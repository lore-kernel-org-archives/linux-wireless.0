Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:58488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LJSuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 13:50:16 -0500
Date: Mon, 10 Dec 2012 13:50:14 -0500 (EST)
Message-Id: <20121210.135014.574510727443547729.davem@davemloft.net> (sfid-20121210_195020_489583_911075DC)
To: johannes@sipsolutions.net
Cc: eric@regit.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	eric.dumazet@gmail.com
Subject: Re: [PATCH] ipv4: ip_check_defrag must not modify skb before
 unsharing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355165152.8083.4.camel@jlt4.sipsolutions.net>
References: <1355132466.9857.6.camel@jlt4.sipsolutions.net>
	<20121210.134146.1583909966821253233.davem@davemloft.net>
	<1355165152.8083.4.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 10 Dec 2012 19:45:52 +0100

> On Mon, 2012-12-10 at 13:41 -0500, David Miller wrote:
>> So the bug is that ip_check_defrag() has a precondition which is met
>> properly by all callers except AF_PACKET.
>> 
>> If this is the case, remind me why are we changing ip_check_defrag()
>> rather than the violator of the precondition?
> 
> I don't think this is the case.
> 
> If you're referring to my note about af_packet: the kernels where this
> goes into af_packet.c are the kernels that don't even have
> ip_check_defrag() because macvlan didn't exist/didn't have ip defrag
> support and af_packet had this code there -- see commit bc416d9768a.
> 
> If you're not referring to my note about af_packet: both callers (there
> are only two) of ip_check_defrag() have this bug as far as I can tell
> because they're both in the part of the RX path where shared SKBs might
> happen.

You're right, I misinterpreted what's happening here.

My misunderstanding was that this was a situation where normal IPV4
input processing makes sure the SKB is unshared, and we had special
code paths that didn't make sure that was the case.

Rather, here, we have a special entrypoint for macvlan and AF_PACKET
which is supposed to take care of such issues since it is known to
execute in a different kind of environment.

I'm pretty sure I'll apply this, after I check a few more things,
thanks Johannes!

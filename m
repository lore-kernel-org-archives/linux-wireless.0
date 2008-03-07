Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbYCGHEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 02:04:22 -0500
Subject: Re: sending ARP triggers BUG
From: Zhu Yi <yi.zhu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080220.223622.148453409.davem@davemloft.net>
References: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
	 <1203468968.10983.13.camel@johannes.berg>
	 <20080220.223622.148453409.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 15:04:21 +0800
Message-Id: <1204873461.3087.187.camel@debian.sh.intel.com> (sfid-20080307_070427_957702_C45A3828)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-02-20 at 22:36 -0800, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 20 Feb 2008 01:56:08 +0100

> > Interestingly, I'm starting to see skb problems as well, in AP mode
> > only however, namely I get lots of
> >
> > [ 4340.665679] SKB BUG: Invalid truesize (240) len=73, sizeof(sk_buff)=176

OK. I started to see this also after I began to play with the AP mode.

SKB BUG: Invalid truesize (272) len=71, sizeof(sk_buff)=208

I get this for every ping packet from the AP to the client and only
occasionally if I ping AP from client. According to the call trace, it's
from the AP receive path.

Call Trace:
 [<ffffffff804101d0>] ? sock_rfree+0x22/0x51
 [<ffffffff8041394d>] ? skb_release_all+0x86/0xbe
 [<ffffffff80413151>] ? __kfree_skb+0x9/0x6f
 [<ffffffff8041596f>] ? skb_free_datagram+0xc/0x31
 [<ffffffff8047a68d>] ? packet_recvmsg+0x174/0x187
 [<ffffffff8040d807>] ? sock_recvmsg+0xf0/0x10f
 [<ffffffff80370499>] ? n_tty_receive_buf+0xdc8/0xe20
 [<ffffffff802468d2>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8029aa5b>] ? core_sys_select+0x232/0x263
 [<ffffffff80273316>] ? __do_fault+0x38f/0x3da
 [<ffffffff8040e87c>] ? sys_recvfrom+0xbc/0x120
 [<ffffffff8020bfd9>] ? tracesys+0xdc/0xe1


> > Anybody have an idea how to debug that? It looks like 'len' is one too
> > large, but I've also seen messages where it was two too large or one to
> > small.
> 
> The BUG occurs when you use paged SKBs, it's different from
> the other problem the person you are replying to is seeing.
> 
> The easiest thing to do to look for potentially problematic areas
> is to find code that modifies skb->data_len but doesn't make
> similar adjustments to skb->truesize.

>From my search result, most of such code is from tcp/ip and skbuff.c.
None from wireless, mac80211 or drivers. Looks like this is not wireless
specific? Anyone has made any progress on this?

Thanks,
-yi


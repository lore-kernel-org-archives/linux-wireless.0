Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:58909 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbXKUOdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 09:33:44 -0500
Message-ID: <4744419C.6000709@gentoo.org> (sfid-20071121_143347_176989_BB6B1354)
Date: Wed, 21 Nov 2007 14:33:00 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>, jt@hpl.hp.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <474432E8.90304@hotmail.com>
In-Reply-To: <474432E8.90304@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shaddy Baddah wrote:
> Interestingly, after performing the above actions, I am now getting 
> additional log messages:
> 
> SoftMAC: Open Authentication completed with GG:GG:GG:GG:GG:GG
> Kernel unaligned access at TPC[100df410] 
> ieee80211softmac_handle_assoc_response]
> Kernel unaligned access at TPC[100df548] 
> ieee80211softmac_handle_assoc_response]
> ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
> [ieee802]
> Kernel unaligned access at TPC[100ee624] do_rx+0x394/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee62c] do_rx+0x39c/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee638] do_rx+0x3a8/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee668] do_rx+0x3d8/0x5ec [zd1211rw]
> Kernel unaligned access at TPC[100ee670] do_rx+0x3e0/0x5ec [zd1211rw]

One thing I forgot to mention: in 2.6.25 zd1211rw is moving away from 
ieee80211/softmac and changing to mac80211. I'm not sure if mac80211 has 
been tested on architectures with alignment constraints, so we may be 
greeted with new problems.

Or some might go away. Speaking only from memory, I think the code with 
compare_ether_addr problem that David found is not present in the 
mac80211 port.

Daniel

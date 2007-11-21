Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from there.is.no.cabal.ca ([134.117.69.58]:33438 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbXKUSFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 13:05:22 -0500
Date: Wed, 21 Nov 2007 13:05:20 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>, jt@hpl.hp.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071121180520.GC13298@fattire.cabal.ca> (sfid-20071121_180525_723453_CBD33CD1)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <474432E8.90304@hotmail.com> <47443F78.60701@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47443F78.60701@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2007 at 02:23:52PM +0000, Daniel Drake wrote:
> 	network = ieee80211softmac_get_network_by_bssid_locked(mac, 
> resp->header.addr3);
> 
> addr3 is offset 20 bytes in the struct and is 6 bytes long. Because 20 
> is not evenly divisible by 6 does that make it an unaligned access?
> 

Sort of. An "unaligned" access is one where the referenced address is
not aligned to the size of the data type being accessed. For example,
a 4-byte load must be accessed on 4-byte aligned boundaries:
	0xffff0000 0xffff0004 0xffff0008, and so forth.

Obviously a single byte load is always aligned.

Unaligned accesses are universally bad. On some architectures (x86, ppc)
they will be emulated in hardware at a performance cost. On others
(sparc, parisc, ia64) they will trap, giving you the option of software
emulation (very slow) or sending a SIGBUS. On still others (arm, I
think[1]) they'll "align" in hardware, resulting in loads or stores to
the wrong address.

The Linux networking code is a pretty good example of when to use the
support macros (get|put)_unaligned to do the right thing. For something
like a packed structure accessed in a data stream, you're invariably going
to have to use these.

> Is there any documentation I can read on this topic? In my current 
> uneducated state I'm likely to write further code with these problems...
> 

cheers,
	Kyle

1. Just a guess based on <asm-arm/unaligned.h> providing macros that
actually do something, and the lack of an obvious unaligned trap
handler.

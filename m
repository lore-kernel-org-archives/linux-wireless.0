Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:50473 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYFPPY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 11:24:56 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <E1K8GZW-0007vs-I1@hash.localnet> (sfid-20080616_172501_824569_2F00F038)
Date: Mon, 16 Jun 2008 11:24:42 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Attached.  This has two attempts at 'iwlist wlan0 scan' in there
> before I shut it back down again.  I see an awful lot of repetitive
> writes of the same value at the same address, but I don't know what
> this stuff means...

Thanks for the update.  I haven't had a chance to look at this until 
now, as I've been traveling the last couple of weeks.  I'll go through 
it this evening to see if anything jumps out.

FWIW, here's how to read the dump.  Given a line like:

    R 4 48.700287 1 0xdf3f9860 0x9d1a 0x0 0

>From left to right that would be:

Read 4 bytes at time 48.700287 (map id=1) the address 0xdf3f9860, and
receive the value 0x9d1a (the other two 0s are meaningless for now).  
Writes look the same except start with W.

>From the address, you can figure out the register: in this case it is 
0x9860 since the MMIO base address is 0xdf3f0000.  Now you can look in 
reg.h to find the name of that register if we know it (here it is
AR5K_PHY_AGCCTL).

Then you can look at the source for where that register is being used to
get an idea of what is going on.  In the above case, we're reading the
register until the hardware completes AGC calibration and sets 
AR5K_PHY_AGCCTL_CAL (bit 0) low - that eventually happens .02 seconds 
later when the value 0x9d18 is read.

-- 
Bob Copeland %% www.bobcopeland.com



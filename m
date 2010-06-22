Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab0FVQsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 12:48:22 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C198EF0.5080807@gmail.com>
References: <4C198EF0.5080807@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 09:48:13 -0700
Message-ID: <1277225293.25793.2257.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-16 at 19:56 -0700, Richard Farina wrote:
> The repeated line appears ad infinitum filling my dmesg buffer.  This of 
> hangcheck timer seem to trigger with every large file transfer on my 
> intel 5100.  What would you like me to do to provide a more useful 
> output as this is currently extremely easy to reproduce.  Kernel 2.6.34 
> using compat-wireless stable 2.6.35-rc2
> 
> Thanks,
> Rick Farina
> 
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer

First mac80211 runs out of memory ... it cannot even allocate enough
memory for a skb header.

> net_ratelimit: 22 callbacks suppressed
> __alloc_pages_slowpath: 3799 callbacks suppressed
> swapper: page allocation failure. order:1, mode:0x4020
> Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
> Call Trace:
>  <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
>  [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
>  [<ffffffffa04701e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]

Next driver runs out of memory.

Note that the above are all atomic allocations that fail and should be
able to recover. 

Is your system low on memory? Are you running applications that take a
lot of memory? Does your wifi connection drop or otherwise suffer at the
time you see these messages?

Reinette




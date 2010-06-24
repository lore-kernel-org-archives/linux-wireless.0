Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41536 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0FXQMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 12:12:13 -0400
Received: by gxk28 with SMTP id 28so857782gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 09:12:13 -0700 (PDT)
Message-ID: <4C2383E2.8000909@gmail.com>
Date: Thu, 24 Jun 2010 12:12:18 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
References: <4C198EF0.5080807@gmail.com> <1277225293.25793.2257.camel@rchatre-DESK>
In-Reply-To: <1277225293.25793.2257.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> On Wed, 2010-06-16 at 19:56 -0700, Richard Farina wrote:
>   
>> The repeated line appears ad infinitum filling my dmesg buffer.  This of 
>> hangcheck timer seem to trigger with every large file transfer on my 
>> intel 5100.  What would you like me to do to provide a more useful 
>> output as this is currently extremely easy to reproduce.  Kernel 2.6.34 
>> using compat-wireless stable 2.6.35-rc2
>>
>> Thanks,
>> Rick Farina
>>
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>> phy0: failed to reallocate TX buffer
>>     
>
> First mac80211 runs out of memory ... it cannot even allocate enough
> memory for a skb header.
>
>   
>> net_ratelimit: 22 callbacks suppressed
>> __alloc_pages_slowpath: 3799 callbacks suppressed
>> swapper: page allocation failure. order:1, mode:0x4020
>> Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
>> Call Trace:
>>  <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
>>  [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
>>  [<ffffffffa04701e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
>>     
>
> Next driver runs out of memory.
>
> Note that the above are all atomic allocations that fail and should be
> able to recover. 
>
> Is your system low on memory? Are you running applications that take a
> lot of memory? Does your wifi connection drop or otherwise suffer at the
> time you see these messages?
>
>   
I have 4GB of RAM on this system, I often run a VM which wastes like 
half that but that still leaves 2GB for linux and I'm running XFCE4 so 
not exactly a memory hog. It's possible that firefox leaks ram until I'm 
out but that would be a LOT of leak, much more than I usually see.

Yeah, as you may guess these errors cause my wifi connection to slow 
drastically. If I had to guess, since this happens when I make a large 
file transfer it is likely that something related is leaking RAM.  I'm 
using wget or axel to download and NFS to dump the files on a NAS.  I'll 
try to trigger this again and watch memory usage to see if I can find 
something other than the driver that could be leaking.  Failing that, 
what do I need to enable to find a leak in the driver?

Thanks,
Rick Farina

> Reinette
>
>
>
>
>   


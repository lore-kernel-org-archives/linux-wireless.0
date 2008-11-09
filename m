Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc1-s17.bay0.hotmail.com ([65.54.246.89]:36607 "EHLO
	bay0-omc1-s17.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbYKIDG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 22:06:26 -0500
Message-ID: <BAY104-DAV7C39A232BE9A213EB2122991B0@phx.gbl> (sfid-20081109_040640_859978_8238488C)
Message-ID: <491653A6.20705@hotmail.com>
Date: Sun, 09 Nov 2008 14:06:14 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>	 <200810251325.07916.mb@bu3sch.de>	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com> <1226149894.3610.8.camel@johannes.berg>
In-Reply-To: <1226149894.3610.8.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09/11/08 00:11, Johannes Berg wrote:
> On Sat, 2008-11-08 at 23:45 +1100, Shaddy Baddah wrote:
> 
>>> [  179.249516] zd1211rw 4-3:1.0: zd_usb_rfwrite() value 0x01e6666 bits 24
>>> [  179.254524] wlan0: Initial auth_alg=0
>>> [  179.254549] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
>>> [  179.256215] Kernel unaligned access at TPC[10129b94] 
>>> zd_mac_rx+0x174/0x320 [zd1211rw]
>>> [  179.349135] Kernel unaligned access at TPC[10129b9c] 
>>> zd_mac_rx+0x17c/0x320 [zd1211rw]
>>> [  179.442852] Kernel unaligned access at TPC[10129ba0] 
>>> zd_mac_rx+0x180/0x320 [zd1211rw]
>>> [  179.536579] Kernel unaligned access at TPC[10129ba4] 
>>> zd_mac_rx+0x184/0x320 [zd1211rw]
>>> [  179.630306] Kernel unaligned access at TPC[10129ba8] 
>>> zd_mac_rx+0x188/0x320 [zd1211rw]
>> I'm keen on troubleshooting this myself. Could you please tell me how I 
>> can get a disassembly intermixed with source. An objdump -S ./zd1211rw.o 
>> is not doing the job. I'd rather not re-compile the whole kernel if 
>> possible, because it takes long. Should I rm the file, do a build, take 
>> the command line and substitute -g for any -O option?
> 
> I usually just _add_ -g3 to the command line I get with make V=1 M=...

Johannes, thank you for the tip. It's helped me no end.

So, looking into this problem, I was able to come up with a patch 
(attached. Note, it also includes remnants of the patch recommended by 
Sebastian Andrzej Siewior in 
http://marc.info/?l=linux-wireless&m=122493409906326&w=2). The problem 
occurs within compare_ether_addr() and this immediately reminded me that 
the patches recommended to me way back last year 
(http://marc.info/?l=linux-wireless&m=119543627712471&w=2) also dealt 
with this problem.

Looking into how it was solved then, all the compare_ether_addr() calls 
were replaced with memcmp() calls. This is what I have done with my 
patch as well... but this approach did not fill me with confidence. It 
seemed to me like a quick fix that didn't directly address the alignment 
problem. And IMO my subsequent findings confirm this.

I now hit the following kernel errors:

 > [  240.139093] Kernel unaligned access at TPC[100f7f44]
 > sta_info_get+0x24/0x68 [mac80211]
 > [  240.233255] Kernel unaligned access at TPC[100f7f48]
 > sta_info_get+0x28/0x68 [mac80211]
 > [  240.328015] Kernel unaligned access at TPC[100f7f50]
 > sta_info_get+0x30/0x68 [mac80211]
 > [  240.422771] Kernel unaligned access at TPC[100f7f44]
 > sta_info_get+0x24/0x68 [mac80211]
 > [  240.517554] Kernel unaligned access at TPC[100f7f48]
 > sta_info_get+0x28/0x68 [mac80211]

Looking into this, and the underlying problem is again 
compare_ether_addr(). Now, I'm sure that replacing this with a memcmp() 
is now treading on more toes than just zd1211rw users. And for this 
reason, I think a better solution is going to be required.

Does that sound right? I will persist in trying to understand the code 
to try and come up with a fix. But obviously, I hope that I can get help 
with this to make the former an education exercise, not a kernel 
maintenance exercise.

TIA,
Shaddy


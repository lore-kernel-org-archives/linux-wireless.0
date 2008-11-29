Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s25.bay0.hotmail.com ([65.54.246.161]:1721 "EHLO
	bay0-omc2-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYK2M44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 07:56:56 -0500
Message-ID: <BAY104-DAV4CB3E353C627AA7068CC899070@phx.gbl> (sfid-20081129_135700_397877_4AC4B26D)
Message-ID: <49313C0E.9030309@hotmail.com>
Date: Sat, 29 Nov 2008 23:56:46 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl>	 <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>	 <200811282344.29293.mb@bu3sch.de>  <49310454.60906@hotmail.com> <1227952204.3542.3.camel@johannes.berg>
In-Reply-To: <1227952204.3542.3.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 29/11/08 20:50, Johannes Berg wrote:
> On Sat, 2008-11-29 at 19:59 +1100, Shaddy Baddah wrote:
> 
>> net/mac80211/tx.c:1304:		if (memcmp(odev->dev_addr, hdr->addr4, 
>> ETH_ALEN) != 0)
>>
>> I would have thought it would use compare_ether_addr() if we could 
>> safely assume alignment.
> 
> You're looking at the TX path, that's irrelevant :)

Do you mean by that the code that handles TX does not expect alignment?

I suspect I still missing some important point. But here it goes. 
Although the sta_info_get() function seems to be a more general purpose, 
the unaligned access is happening on TX. I found the stack trace:

Nov 22 19:04:43 trad kernel: [ 1459.328317]  [000000001039574c] 
__ieee80211_tx_prepare+0x288/0x3e8 [mac80211]
Nov 22 19:04:43 trad kernel: [ 1459.420571]  [0000000010398174] 
ieee80211_master_start_xmit+0x378/0x4f4 [mac80211]
Nov 22 19:04:43 trad kernel: [ 1459.518716]  [000000000061de88] 
dev_hard_start_xmit+0x210/0x2a0
Nov 22 19:04:43 trad kernel: [ 1459.596342]  [000000000062ff38] 
__qdisc_run+0xe4/0x220
Nov 22 19:04:43 trad kernel: [ 1459.664429]  [0000000000620c94] 
dev_queue_xmit+0x3dc/0x5d0
Nov 22 19:04:43 trad kernel: [ 1459.737359]  [000000001038ba10] 
ieee80211_associated+0x10c/0x154 [mac80211]
Nov 22 19:04:43 trad kernel: [ 1459.827398]  [000000001038dda0] 
ieee80211_sta_work+0xd50/0xe48 [mac80211]
Nov 22 19:04:43 trad kernel: [ 1459.915701]  [000000000045e584] 
run_workqueue+0x98/0x130
Nov 22 19:04:43 trad kernel: [ 1459.985658]  [000000000045ea30] 
worker_thread+0xa4/0xbc
Nov 22 19:04:43 trad kernel: [ 1460.054609]  [0000000000461d5c] 
kthread+0x3c/0x70
Nov 22 19:04:43 trad kernel: [ 1460.117894]  [0000000000426f84] 
kernel_thread+0x30/0x48
Nov 22 19:04:43 trad kernel: [ 1460.186919]  [0000000000461c18] 
kthreadd+0xb0/0x124

> No, the IP stack assumes alignment. Besides, zd1211 actually enforces
> the alignment before passing the skb off to mac80211.

You mean on RX, right? I'm OK on RX I think. The memcmp() is fine in 
filter_ack(), because it is on the raw packet that comes in from over 
USB which will always be unaligned (because of PLCP header, from the 
device itself). And it is before we actually memcpy() aligned into the 
skb buffer to pass to mac80211.

Perhaps I'm second guessing a little too much here, so I'll ask a simple 
question. Why do I get a 80211 packet passed into 
__ieee80211_tx_prepare() which is at an odd address in the skb buffer? I 
would have expected that they would have always been constructed aligned?

Thanks in advance,
Shaddy


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37346 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0LEDaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 22:30:25 -0500
Message-ID: <4CFB0747.2070301@candelatech.com>
Date: Sat, 04 Dec 2010 19:30:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux> <4CF6D8C8.2000308@candelatech.com> <4CF8A6DE.4020804@candelatech.com> <4CFAFBE1.3080505@openwrt.org>
In-Reply-To: <4CFAFBE1.3080505@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/2010 06:41 PM, Felix Fietkau wrote:
> On 2010-12-03 9:14 AM, Ben Greear wrote:
>> On 12/01/2010 03:22 PM, Ben Greear wrote:
>>> On 11/29/2010 04:44 PM, Luis R. Rodriguez wrote:
>>>> On Mon, Nov 29, 2010 at 04:28:51PM -0800, Ben Greear wrote:
>>>
>>>>> BUG: unable to handle kernel NULL pointer dereference at 00000040
>>>>> IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
>>>>> *pde = 00000000
>>>>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>>>>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
>>>>> Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
>>>>>
>>>>> Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
>>>>> EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
>>>>> EIP is at ath_tx_start+0x461/0x5ef [ath9k]
>>>>
>>>> Please use
>>>>
>>>> gdb drivers/net/wireless/ath/ath9k/
>>>> l *(ath_tx_start+0x461)
>>>>
>>>>      Luis
>>>
>>> I managed to hit that ath_tx_start crash again, and this time there were no obvious
>>> DMA or irq errors immediately preceding it.  So, it might be a real bug
>>> after all.  I'll add some extra checks to see if tid->ac is NULL.
>>
>> I've made some small progress on this general issue.
>>
>> First, I added all sorts of debugging to try to figure out ath_tx_start crash.
>> As best as I can tell, 'tid' is not NULL, but also is not a valid pointer,
>> and probably something close to 0x0.  I've added yet more debugging, but haven't
>> hit the problem again.
>>
>> I also tried stopping DMA in a loop up to 5 times if it failed to stop
>> previously in the loop.  This did not appear to help at all.
>>
>> I also managed to make both the ath_tx_start crash and the DMA errors very hard to reproduce
>> (I dare not say fixed, yet).
>>
>> It appears that this small patch (and possibly, the fact that I set debugging to 0x600
>> instead of 0x400) makes the problems go away.  This makes me wonder if a root cause is
>> something to do with repeatedly resetting the hardware too fast, as setting channels rapidly
>> would tend to do that, and channels are set on association by supplicant, it appears.
> Please try this patch while leaving the unnecessary resets in place.
> I found that when ath_drain_all_txq finds tx dma not stopped, it will
> issue a reset at a point in time where it is both useless (since it's
> right before a reset anyway) and dangerous (since the rx dma engine
> isn't even disabled yet), so IMHO the right thing to do is to drop
> this extra reset.

I'll give this a try, not sure if I'll get to it before Monday though...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

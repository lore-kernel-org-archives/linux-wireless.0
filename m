Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60553 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0LAXWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 18:22:53 -0500
Message-ID: <4CF6D8C8.2000308@candelatech.com>
Date: Wed, 01 Dec 2010 15:22:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux>
In-Reply-To: <20101130004424.GC1901@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 04:44 PM, Luis R. Rodriguez wrote:
> On Mon, Nov 29, 2010 at 04:28:51PM -0800, Ben Greear wrote:

>> BUG: unable to handle kernel NULL pointer dereference at 00000040
>> IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
>> *pde = 00000000
>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
>> Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
>>
>> Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
>> EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
>> EIP is at ath_tx_start+0x461/0x5ef [ath9k]
>
> Please use
>
> gdb drivers/net/wireless/ath/ath9k/
> l *(ath_tx_start+0x461)
>
>    Luis

I managed to hit that ath_tx_start crash again, and this time there were no obvious
DMA or irq errors immediately preceding it.  So, it might be a real bug
after all.  I'll add some extra checks to see if tid->ac is NULL.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


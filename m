Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:59859 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3HUQmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 12:42:38 -0400
Message-ID: <5214EE0E.20602@openwrt.org> (sfid-20130821_184241_815604_9FE94D8C)
Date: Wed, 21 Aug 2013 18:42:54 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH v2 3/6] rt2x00: rt2800: serialize shared memory access
References: <1376917878-25094-1-git-send-email-juhosg@openwrt.org> <1376917878-25094-4-git-send-email-juhosg@openwrt.org> <CAGXE3d-q3-HNtdp5jq94nCcLzCW1-oO+HTt+=yOFEE+fL8kbtA@mail.gmail.com>
In-Reply-To: <CAGXE3d-q3-HNtdp5jq94nCcLzCW1-oO+HTt+=yOFEE+fL8kbtA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

> On Mon, Aug 19, 2013 at 3:11 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> The shared memory of the rt2800 devices is accessible
>> through the register offset range between 0x4000 and
>> 0x8000. The size of this range is 16KB only and on
>> devices which have more than 16KB of shared memory either
>> the low or the high part of the memory is accessible at a
>> time.
>>
> 
>> Serialize all accesses to the shared memory by a mutex,
>> in order to avoid concurrent use of that.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> ---
> 
> [...]
> 
> 
>> @@ -993,8 +1001,11 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>>         }
>>
>>         beacon_base = HW_BEACON_BASE(entry->entry_idx);
>> +
>> +       rt2800_shared_mem_lock(rt2x00dev);
>>         rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>>                                    entry->skb->len + padding_len);
>> +       rt2800_shared_mem_unlock(rt2x00dev);
>>
>>         /*
>>          * Enable beaconing again.
> 
> Beacons on PCI devices are updated from pre_tbtt or beacon_done tasklet.
> Looks like this will fail for pci then ...

Hm, you are right:

BUG: sleeping function called from invalid context at kernel/mutex.c:619
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
INFO: lockdep is turned off.
CPU: 0 PID: 0 Comm: swapper Tainted: G           O 3.11.0-rc6-wl #627
Stack : 00000000 00000000 80745dbe 00000045 00000000 80439ca0 803f097c 80723a50
        8043da78 8043d7c7 001f0640 80439ca0 83dfee20 803f0000 00000006 8035c3dc
        00000000 80031558 80745dbc 00000000 803f42b8 80439b9c 80439b9c 803f097c
        c01ba400 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 80439b30
          ...
Call Trace:
[<8000d328>] show_stack+0x64/0x7c
[<80361ca0>] mutex_lock_nested+0x4c/0x484
[<c01ba458>] rt2800_write_beacon+0x300/0x460 [rt2800lib]
[<c016dc24>] rt2x00queue_update_beacon_locked+0xc0/0xe4 [rt2x00lib]
[<8033fa30>] ieee80211_iterate_active_interfaces_atomic+0x180/0x188
[<c01cbb18>] 0xc01cbb18


In an early version of the patch, I have used a spinlock but that was not
suitable for USB devices. I have to rethink that how can I resolve this.

Thank you for the review!

-Gabor

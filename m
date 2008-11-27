Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:30050 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYK0Fez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 00:34:55 -0500
Received: by nf-out-0910.google.com with SMTP id d3so437551nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 21:34:54 -0800 (PST)
Message-ID: <f76a32050811262134m1646ea7cy8ebf58fbed6a2af7@mail.gmail.com> (sfid-20081127_063501_820976_B104ADB3)
Date: Thu, 27 Nov 2008 06:34:53 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <200811262213.03751.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200811242124.16358.chunkeey@web.de>
	 <f76a32050811260538n6f4f03e9qa05dced498e21fd8@mail.gmail.com>
	 <200811262213.03751.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A-ha!
O-kay ;-)

I assume then that the last patch set that removes the problem for me
is perfectly valid, right?
Just that something changes the contents of my RAM. Let me memtest,
maybe recompile my kernel for 486. Other ideas?

Thank you for this!
I very much appreciate the time you people are putting into this thing.

Stefan.


2008/11/26 Christian Lamparter <chunkeey@web.de>:
> On Wednesday 26 November 2008 14:38:59 Stefan Steuerwald wrote:
>> console [netcon0] enabled
>> netconsole: network logging started
>> BUG: unable to handle kernel NULL pointer dereference at 00000038
>> IP: [<d08260fa>] p54_assign_address+0x67/0x14b [p54common]
>> *pde = 00000000
>> Oops: 0000 [#1]
>> last sysfs file: /sys/class/net/lo/operstate
>> Modules linked in: netconsole ipv6 loop evdev ehci_hcd ohci_hcd
>> rtc_cmos rtc_core pcspkr rtc_lib p54pci usbcore via_rhine p54common
>> geode_aes mii [last unloaded: netconsole]
>>
>> Pid: 0, comm: swapper Not tainted (2.6.28-rc6-wl #16)
>> EIP: 0060:[<d08260fa>] EFLAGS: 00010002 CPU: 0
>> EIP is at p54_assign_address+0x67/0x14b [p54common]
>> EAX: cf98b178 EBX: cf86ee40 ECX: 00000000 EDX: 00000000
>> ESI: 000000f8 EDI: 00000000 EBP: 0002027c ESP: c03f9c4c
>>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Process swapper (pid: 0, ti=c03f8000 task=c03c4380 task.ti=c03f8000)
>> Stack:
>>  00000002 ce4d5880 ce4c48b4 cf86e1a0 00000000 00000038 00020200 00000286
>>  cf86ee40 00000004 ce4d58b2 ce4d588c d0826fd7 00000090 014c48d4 ce4c48b4
>>  cf86e1a0 0086ee40 00000004 02000282 ce4c48d4 cf86ef10 cf86ee40 ce4d5880
>> Call Trace:
>>  [<d0826fd7>] p54_tx+0x416/0x482 [p54common]
>>  [<c02fb7c2>] __ieee80211_tx+0x35/0xf8
>>  [<c02fc235>] ieee80211_master_start_xmit+0x2ab/0x396
>>  [<c01048d3>] common_interrupt+0x23/0x30
>>  [<c0297368>] dev_hard_start_xmit+0x16e/0x1c9
>>  [<c02a3518>] __qdisc_run+0xa2/0x15c
>>  [<c0297796>] dev_queue_xmit+0x2f5/0x3c5
>>  [<c02f8608>] ieee80211_invoke_rx_handlers+0x488/0x1486
>>  [<c02d9d14>] bictcp_cong_avoid+0x10/0x160
>>  [<c02bd904>] tcp_ack+0x16f0/0x1850
>>  [<c01170f0>] enqueue_task_fair+0x12a/0x16b
>>  [<c02c0c37>] tcp_current_mss+0x6b/0xe4
>>  [<c02f9b50>] __ieee80211_rx_handle_packet+0x54a/0x56d
>>  [<c02fa1fe>] __ieee80211_rx+0x491/0x4e3
>>  [<c02ec95d>] ieee80211_tasklet_handler+0x60/0xd6
>>  [<c011cfae>] tasklet_action+0x3e/0x64
>>  [<c011d305>] __do_softirq+0x4a/0xbc
>>  [<c011d399>] do_softirq+0x22/0x26
>>  [<c011d44f>] irq_exit+0x25/0x55
>>  [<c0105996>] do_IRQ+0x5a/0x6c
>>  [<c01048d3>] common_interrupt+0x23/0x30
>>  [<c0108743>] default_idle+0x25/0x38
>>  [<c0102926>] cpu_idle+0x41/0x5b
>> Code: 0f 84 01 01 00 00 9c 8f 44 24 1c fa 8b 53 10 31 ff 89 6c 24 18
>> 89 14 24 31 d2 eb 3f 8b 4c 24 10 83 c1 38 89 4c 24 14 8b 4c 24 10 <8b>
>> 41 38 29 e8 85 d2 75 0d 39 f0 72 09 8b 51 04 29 f0 89 6c 24
>> EIP: [<d08260fa>] p54_assign_address+0x67/0x14b [p54common] SS:ESP 0068:c03f9c4c
>> Kernel panic - not syncing: Fatal exception in interrupt
>>
> wt*, this bug is "impossible":
>
> The bug happens when p54_assign_address looks for a free space for a new frame:
> here's the code:
> [...]
> if (!skb)
>        return -EINVAL;   <--- we don't accept "null" skbs
>
> spin_lock_irqsave(&priv->tx_queue.lock, flags); <--- we are under a spin_lock with irq disabled
> left = skb_queue_len(&priv->tx_queue);
> while (left--) {
>                u32 hole_size;
>                info = IEEE80211_SKB_CB(entry);  <--- Here it BUGs,
> [...]
>
> your binary module said that skb->cb is at 0x38,
> so our "entry" is really NULL right when it BUGS.
> And this only happens means that the queue was
> modified "outside" of our driver.
>
> Since we always take the spin_lock_irqsave (of course,
> only of "our" tx_queue). if we need to do anything with the data in the queue,
>
> Of course, since the package as queued while the station was sleeping
> somewhere mac80211, so maybe it still holds a reference to, but then
> other drivers would have already spotted this misbehaviour long time ago...
>
> So? back to square one... I guess.
>
> Regards,
>        Chr
>

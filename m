Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53540 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYEGNBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 09:01:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43 doing tx-status reports with NULL frames?
Date: Wed, 7 May 2008 15:00:31 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1210158511.5642.1.camel@johannes.berg>
In-Reply-To: <1210158511.5642.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805071500.32033.mb@bu3sch.de> (sfid-20080507_150018_586767_9F2BD6EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 May 2008 13:08:31 Johannes Berg wrote:
> This is odd:
> 
> [  847.811157] ------------[ cut here ]------------
> [  847.811168] Badness at drivers/net/wireless/b43/dma.c:1380
> [  847.811174] NIP: f2530de4 LR: f2530dc8 CTR: f252ff70
> [  847.811182] REGS: d191bb20 TRAP: 0700   Not tainted  (2.6.25-wl-06933-g0bacadf-dirty)
> [  847.811188] MSR: 00021032 <ME,IR,DR>  CR: 48242484  XER: 00000000
> [  847.811205] TASK = d1918000[5078] 'wpa_supplicant' THREAD: d191a000
> [  847.811211] GPR00: 00000001 d191bbd0 d1918000 edb89248 00000208 d191bbd8 00000000 000003cc 
> [  847.811230] GPR08: 00000001 00000000 00010004 edb89200 48242488 10083d28 100e0000 100876e9 
> [  847.811249] GPR16: 100876d9 100876b1 22042442 0000008a 00000002 1006071c ed88703c 00000000 
> [  847.811268] GPR24: d191bbd8 f2537d24 ee513120 d191bc28 00000001 0000029e 00000041 ed887000 
> [  847.811288] NIP [f2530de4] b43_dma_handle_txstatus+0xd4/0x2e8 [b43]
> [  847.811336] LR [f2530dc8] b43_dma_handle_txstatus+0xb8/0x2e8 [b43]
> [  847.811354] Call Trace:
> [  847.811358] [d191bbd0] [f2530d74] b43_dma_handle_txstatus+0x64/0x2e8 [b43] (unreliable)
> [  847.811381] [d191bc10] [f252bb70] b43_handle_txstatus+0x8c/0xd4 [b43]
> [  847.811400] [d191bc20] [f25221d4] b43_interrupt_tasklet+0x1c0/0x638 [b43]
> [  847.811420] [d191bc80] [c0034fb8] tasklet_action+0x74/0xec
> [  847.811438] [d191bca0] [c00358c4] __do_softirq+0x8c/0xfc
> [  847.811449] [d191bcd0] [c0006e40] do_softirq+0x58/0x5c
> [  847.811464] [d191bce0] [c0035618] local_bh_enable+0xa8/0xac
> [  847.811475] [d191bcf0] [c027b518] dev_queue_xmit+0xe8/0x3cc
> [  847.811490] [d191bd10] [f26cd30c] packet_sendmsg+0x22c/0x268 [af_packet]
> [  847.811510] [d191bd50] [c026bb3c] sock_sendmsg+0xac/0xe4
> [  847.811525] [d191be30] [c026bed0] sys_sendto+0xbc/0xec
> [  847.811536] [d191bf00] [c026ca20] sys_socketcall+0x12c/0x1dc
> [  847.811547] [d191bf40] [c00124cc] ret_from_syscall+0x0/0x38
> [  847.811564] --- Exception: c01 at 0xfcaf97c
> [  847.811593]     LR = 0x10052ca8
> [  847.811598] Instruction dump:
> [  847.811604] 7fe3fb78 7fc4f378 7f05c378 7c0903a6 4e800421 80610008 88030008 81230000 
> [  847.811624] 2f800000 419e0118 7d200034 5400d97e <0f000000> 38630010 7f64db78 4bffac09 
> 
> 
> That WARN_ON is:
> 
>         if (WARN_ON(!skb))
>                 return;
> 
> This was with dma overflow injection and a few patches, but nothing
> relevant inside b43.

hm, this is interesting.

Is it this one?
1379                 if (meta->is_last_fragment) {
1380                         B43_WARN_ON(!meta->skb);

The "is_last_fragment" actually means "is last s/g fragment".
(not 802.11 fragment).

So basically this assertion checks the presence of the skb buffer
for each s/g fragment. We use two s/g fragments for each TX packet.
One for the header and one for the skb. You already know that.
So, for the first s/g fragment we have meta->skb=NULL and for the
second meta->skb!=NULL.
I'm not sure why this assertion triggers. I can't see where in the TX path
the allocation of the slots or the meta->skb assignment can go wrong.
Allocation basically always allocates the ring descriptors in pairs.
Either both or none (in case of a DMA error, but _not_ an overflow).
The ring suspend (or suspend injection) basically is independent from
the allocation.

Can you add the following assertion into b43_dma_tx() after the
b43_dma_tx_fragment call, please?

WARN_ON(free_slots(ring) & 1);

This shouldn't ever trigger, as we always allocate the slots in pairs.

-- 
Greetings Michael.

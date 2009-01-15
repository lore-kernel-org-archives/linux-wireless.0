Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:59079 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763977AbZAORz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:55:26 -0500
Received: by ug-out-1314.google.com with SMTP id 39so460213ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 09:55:22 -0800 (PST)
Message-ID: <496F7887.8070203@gmail.com> (sfid-20090115_185541_193087_50AE6728)
Date: Thu, 15 Jan 2009 18:55:19 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901131449.41189.chunkeey@web.de> <496CC514.3030307@gmail.com> <200901131906.13096.chunkeey@web.de> <496CE55F.2080506@gmail.com> <496D09F4.40209@gmail.com> <496D163B.5030307@gmail.com>
In-Reply-To: <496D163B.5030307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Artur Skawina wrote:
>>>>> reboots, but locks up after only a few packets go over the hostap driven
>>>>> p54usb device. I need the box to be up, that limits the number of tests i can
> 
>> after switching from SLUB to SLAB and enabling some debugging i finally caught this:
> 
> and slub debugging gave something a bit more useful:
> 
> =============================================================================
> BUG kmalloc-4096: Poison overwritten

tried reproducing (using the old w-t/pending pull) on different machine,
but no oops or crash there...
(similar connectivity issues though, such as connecting only works
exactly once after starting hostapd, to reconnect i have to restart
hostapd)

Upgraded to current wireless-testing/pending on the problematic box
and almost immediately got [1]. No slab corruption this time (at least
not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.

artur


[1]:
BUG: scheduling while atomic: named/2004/0x10000200
Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 videobuf_dma_sg serio_raw budget videobuf_core tveeprom budget_ci budget_core saa7146 ttpci_eeprom ir_common [last unloaded: microcode]
Pid: 2004, comm: named Not tainted 2.6.29-rc1-00271-ge9fa6b0 #45
Call Trace:
 [<c04d4ef7>] schedule+0x2a7/0x320
 [<c03aed74>] __alloc_skb+0x34/0x110
 [<c011f5b3>] __cond_resched+0x13/0x30
 [<c04d501d>] _cond_resched+0x2d/0x40
 [<c016d8c5>] kmem_cache_alloc+0x95/0xc0
 [<c016b8d4>] check_object+0xc4/0x230
 [<c03aed74>] __alloc_skb+0x34/0x110
 [<c02ede91>] p54_alloc_skb+0x71/0xf0
 [<c02ee36f>] p54_set_tim+0x3f/0xa0
 [<c04ae064>] sta_info_set_tim_bit+0x64/0x80
 [<c04c1017>] invoke_tx_handlers+0xd57/0xd80
 [<c016c397>] free_debug_processing+0x197/0x210
 [<c03ae215>] pskb_expand_head+0xf5/0x170
 [<c04bfd94>] __ieee80211_tx_prepare+0x164/0x2f0
 [<c04c1a8d>] ieee80211_skb_resize+0x6d/0xe0
 [<c04c250f>] ieee80211_master_start_xmit+0x23f/0x550
 [<c016d188>] __slab_alloc+0x2b8/0x4f0
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c03b5e7b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c6a4b>] __qdisc_run+0x1ab/0x200
 [<c0136aa1>] __run_hrtimer+0x31/0xf0
 [<c03b6247>] dev_queue_xmit+0x247/0x500
 [<c04c1e56>] ieee80211_subif_start_xmit+0x356/0x7d0
 [<c0466ff7>] packet_rcv_spkt+0x37/0x150
 [<c0466ff7>] packet_rcv_spkt+0x37/0x150
 [<c03b5e7b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c6a4b>] __qdisc_run+0x1ab/0x200
 [<c03b6247>] dev_queue_xmit+0x247/0x500
 [<c03bc1e2>] neigh_resolve_output+0xe2/0x200
 [<c0410080>] ip_finish_output+0x0/0x290
 [<c0410267>] ip_finish_output+0x1e7/0x290
 [<c040f355>] ip_local_out+0x15/0x20
 [<c040f5d2>] ip_push_pending_frames+0x272/0x380
 [<c042bbc6>] udp_push_pending_frames+0x146/0x3a0
 [<c042d52a>] udp_sendmsg+0x2fa/0x6b0
 [<c0433bc7>] inet_sendmsg+0x37/0x70
 [<c03a7b7e>] sock_sendmsg+0xbe/0x100
 [<c0133cd0>] autoremove_wake_function+0x0/0x50
 [<c011c043>] __wake_up_common+0x43/0x70
 [<c024a892>] copy_from_user+0x32/0x130
 [<c024a892>] copy_from_user+0x32/0x130
 [<c03b001e>] verify_iovec+0x2e/0xb0
 [<c03a7d3f>] sys_sendmsg+0x17f/0x290
 [<c017730a>] pipe_write+0x29a/0x570
 [<c013a172>] update_wall_time+0x492/0x8e0
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c011b05d>] sched_slice+0x3d/0x80
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c0136657>] hrtimer_forward+0x147/0x1a0
 [<c01101b0>] lapic_next_event+0x10/0x20
 [<c013ccb3>] clockevents_program_event+0xa3/0x170
 [<c03a9054>] sys_socketcall+0xa4/0x290
 [<c0110920>] smp_apic_timer_interrupt+0x40/0x70
 [<c0103165>] sysenter_do_call+0x12/0x25

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39750 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYLOTvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 14:51:46 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Mon, 15 Dec 2008 20:51:48 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net>
In-Reply-To: <49466F56.6060805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812152051.48349.chunkeey@web.de> (sfid-20081215_205151_271076_83CBDD00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 December 2008 15:53:10 Larry Finger wrote:
> Christian,
> 
> While stressing p54usb with a 'ping -f -i 0.2 AP' to my router as well as
> running normal operations, I encountered the following errors:

> 5 minutes later:
> 
> kernel: swapper: page allocation failure. order:1, mode:0x4020
> kernel: Pid: 0, comm: swapper Not tainted 2.6.28-rc8-wl #52
> kernel: Call Trace:
> kernel:  <IRQ>  [<ffffffff8028074e>] __alloc_pages_internal+0x41c/0x43e
> kernel:  [<ffffffff8029b595>] alloc_pages_current+0xbe/0xc6
> kernel:  [<ffffffff802a2d5a>] new_slab+0xd5/0x28d
> kernel:  [<ffffffff802a1766>] ? unfreeze_slab+0x4c/0xbb
> kernel:  [<ffffffff802a31ad>] __slab_alloc+0x215/0x43e
> kernel:  [<ffffffff803c5be7>] ? dev_alloc_skb+0x16/0x2c
> kernel:  [<ffffffff802a3347>] ? __slab_alloc+0x3af/0x43e
> kernel:  [<ffffffff802a40c0>] __kmalloc_node_track_caller+0x90/0xe4
> kernel:  [<ffffffff803c5be7>] ? dev_alloc_skb+0x16/0x2c
> kernel:  [<ffffffff803c5246>] __alloc_skb+0x6f/0x135
> kernel:  [<ffffffff803c5be7>] dev_alloc_skb+0x16/0x2c
> kernel:  [<ffffffffa06df7f5>] p54u_rx_cb+0xad/0x1c8 [p54usb]
> kernel:  [<ffffffffa00fc062>] usb_hcd_giveback_urb+0x7e/0xb1 [usbcore]
> kernel:  [<ffffffffa0125883>] ehci_urb_done+0xca/0xdf [ehci_hcd]
> kernel:  [<ffffffffa0126895>] qh_completions+0xaa/0x346 [ehci_hcd]
> kernel:  [<ffffffffa0126bff>] ehci_work+0xce/0x80a [ehci_hcd]
> kernel:  [<ffffffffa012ae7d>] ehci_irq+0x1a6/0x1d9 [ehci_hcd]
> kernel:  [<ffffffff80251aea>] ? ktime_get_ts+0x49/0x4e
> kernel:  [<ffffffffa00fbb66>] usb_hcd_irq+0x38/0x94 [usbcore]
> kernel:  [<ffffffff80273ffd>] handle_IRQ_event+0x20/0x55
> kernel:  [<ffffffff80275501>] handle_fasteoi_irq+0x91/0xd1
> kernel:  [<ffffffff8020ed39>] do_IRQ+0xfc/0x173
> kernel:  [<ffffffff8020c54b>] ret_from_intr+0x0/0xf
> kernel:  <EOI>  [<ffffffff80257557>] ? tick_broadcast_oneshot_control+0x1a/0x109
> kernel:  [<ffffffff802135f1>] ? default_idle+0x30/0x4a
> kernel:  [<ffffffff802135ef>] ? default_idle+0x2e/0x4a
> kernel:  [<ffffffff802136ee>] ? c1e_idle+0xd5/0xfc
> kernel:  [<ffffffff80252b32>] ? atomic_notifier_call_chain+0xf/0x11
> kernel:  [<ffffffff8020b171>] ? cpu_idle+0x4f/0x90
> kernel:  [<ffffffff80427e1d>] ? rest_init+0x61/0x63
> kernel: Mem-Info:
> kernel: Node 0 DMA per-cpu:
> kernel: CPU    0: hi:    0, btch:   1 usd:   0
> kernel: CPU    1: hi:    0, btch:   1 usd:   0
> kernel: Node 0 DMA32 per-cpu:
> kernel: CPU    0: hi:  186, btch:  31 usd: 114
> kernel: CPU    1: hi:  186, btch:  31 usd:  91
> kernel: Active_anon:70899 active_file:172447 inactive_anon:19852
> kernel:  inactive_file:188543 unevictable:8 dirty:391 writeback:0 unstable:0
> kernel:  free:25567 slab:261175 mapped:22336 pagetables:2929 bounce:0
> kernel: Node 0 DMA free:3556kB min:4kB low:4kB high:4kB active_anon:0kB
>         inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
>         present:2368kB pages_scanned:0 all_unreclaimable? yes
> kernel: lowmem_reserve[]: 0 2927 2927 2927
> kernel: Node 0 DMA32 free:98712kB min:6916kB low:8644kB high:10372kB
>         active_anon:283596kB inactive_anon:79408kB active_file:689788kB
>         inactive_file:754172kB unevictable:32kB present:2997292kB
>         pages_scanned:0 all_unreclaimable? no
> kernel: lowmem_reserve[]: 0 0 0 0
> kernel: Node 0 DMA: 3*4kB 1*8kB 3*16kB 3*32kB 3*64kB 3*128kB 3*256kB 0*512kB
> 
>         2*1024kB 0*2048kB 0*4096kB = 3556kB
> kernel: Node 0 DMA32: 24463*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 1*256kB
>         1*512kB 0*1024kB 0*2048kB 0*4096kB = 98620kB
> kernel: 361741 total pagecache pages
> kernel: 587 pages in swap cache
> kernel: Swap cache stats: add 1474, delete 887, find 41242/41313
> kernel: Free swap  = 2100784kB
> kernel: Total swap = 2104444kB
> kernel: 769872 pages RAM
> kernel: 20217 pages reserved
> kernel: 262368 pages shared
> kernel: 519070 pages non-shared
> 
> These errors continued until I removed p54usb.
> 
> My kernel is wireless-testing 2.6.28-rc8-wl (x86_64) with the "move statistics
> timer update", "update ACK failure counter", "remove free on tx" and "more
> accurate rssi to dBm" p54 patches applied.
> 
> The call that fails in p54u_rx_cb() is in this code block:
> 
>         if (p54_rx(dev, skb)) {
>                 skb = dev_alloc_skb(priv->common.rx_mtu + 32);
>                 if (unlikely(!skb)) {
>                         /* TODO check rx queue length and refill *somewhere* */
>                         return;
>                 }
> 
> If I read this correctly, there are no 8KB DMA32 pages available. Normally, I
> would have suspected a memory management problem in the kernel; however, rtl8187
> passes this ping test successfully. I suspect a memory leak in p54usb.
> 
> I will continue to investigate this problem, but I wanted to give you a warning
> that there is a problem.
> 

Alright, I'll look in that too... just one thing:
> kernel: Node 0 DMA32: 24463*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 1*256kB
>         1*512kB 0*1024kB 0*2048kB 0*4096kB = 98620kB

look at the high 4KB count?! it looks like your memory is highly fragmented...

rx_mtu is usually around 3240 bytes on new firmwares...
but for a quick test it can limited to something much less like the
 RTS/Fragmentation threshold (somewhere around 2356?)...
just add:
priv->rx_mtu = 2356; at line 198 in p54common.c

In the mean time, I've to get rid of my RAM ;-)

Regards,
	Chr

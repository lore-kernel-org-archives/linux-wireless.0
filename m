Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:32777 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYLQWd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 17:33:56 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb problems
Date: Wed, 17 Dec 2008 23:33:56 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4949753B.9000505@lwfinger.net>
In-Reply-To: <4949753B.9000505@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200812172333.56596.chunkeey@web.de> (sfid-20081217_233402_237988_DC703363)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 December 2008 22:55:07 Larry Finger wrote:
> Christian,
>=20
> As you may have seen, one of my failed p54usb runs hit a WARN_ON in m=
ac80211 due
> to a faulty pkt_type in the skb. Johannes thinks this is most likely =
caused by
> memory corruption. When I looked at the RX callback, I don't see any =
locking. Is
> that correct?
>=20
> On a different run, I had a failure to allocate a new skb because the=
re was not
> a free memory chunk of order(1). When I hit that, I remembered your s=
uggestion
> for reducing rx_mtu to keep the skb of order(0). What is your reactio=
n to the
> following patch? On my x86_64 system, the message that prints is "p54=
:
> Calculated rx_mtu of 3240 reduced to 2356".
>=20
> I have not hit the frame control patch you sent, at least not yet.
>=20
> Larry
>=20
well for USB devices its AFAIK not necessary, see URB.txt

http://ww2.cs.fsu.edu/~rosentha/linux/2.6.26.5/docs/usb/callbacks.txt

"Calling conventions
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

All callbacks are mutually exclusive. There's no need for locking
against other USB callbacks. All callbacks are called from a task
context. You may sleep. However, it is important that all sleeps have a
small fixed upper limit in time. In particular you must not call out to
user space and await results."

Also, I "kind" of getting near to your memory problem,
however no matter what I do, my r8169 dies first

swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Tainted: P           2.6.28-rc8-wl #3
Call Trace:
<IRQ>  [<ffffffff80271579>] __alloc_pages_internal+0x3e6/0x406
[<ffffffff80290f6d>] __slab_alloc+0x175/0x4b1
[<ffffffff804dd28d>] __netdev_alloc_skb+0x15/0x2f
[<ffffffff804dd28d>] __netdev_alloc_skb+0x15/0x2f
[<ffffffff80292194>] __kmalloc_track_caller+0x8f/0xb7
[<ffffffff804dc8f2>] __alloc_skb+0x61/0x123
[<ffffffff804dd28d>] __netdev_alloc_skb+0x15/0x2f
[<ffffffffa0cee301>] rtl8169_rx_fill+0xa6/0x195 [r8169]
[<ffffffffa0cee7b3>] rtl8169_rx_interrupt+0x3c3/0x420 [r8169]
[<ffffffffa0cefe6d>] rtl8169_poll+0x3b/0x1f6 [r8169]
[<ffffffff80248dbe>] ktime_get+0xc/0x41
[<ffffffff8024ec08>] tick_dev_program_event+0x2d/0x95
[<ffffffff804e0260>] net_rx_action+0x71/0x134
[<ffffffff80238dbf>] __do_softirq+0x7c/0x135
[<ffffffff8020c59c>] call_softirq+0x1c/0x28
[<ffffffff8020d40c>] do_softirq+0x2c/0x68
[<ffffffff80238af3>] irq_exit+0x3f/0x85
[<ffffffff8020d63c>] do_IRQ+0xc5/0xe5
[<ffffffff8020b856>] ret_from_intr+0x0/0xa
<EOI>  [<ffffffff80415d08>] acpi_idle_enter_simple+0x1c7/0x237
[<ffffffff80415cfe>] acpi_idle_enter_simple+0x1bd/0x237
[<ffffffff804c6c54>] menu_select+0x3f/0x8a
[<ffffffff804c6101>] cpuidle_idle_call+0x8b/0xca
[<ffffffff8020a56f>] cpu_idle+0x4a/0x8b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 165
CPU    1: hi:  186, btch:  31 usd: 185
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  92
CPU    1: hi:  186, btch:  31 usd: 181
Active_anon:90564 active_file:19488 inactive_anon:68064
inactive_file:786743 unevictable:463 dirty:92730 writeback:4633 unstabl=
e:0
free:5154 slab:24600 mapped:19736 pagetables:5202 bounce:0
DMA free:9160kB min:16kB low:20kB high:24kB active_anon:0kB inactive_an=
on:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8232kB=
 pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2999 4009 4009
DMA32 free:9708kB min:6056kB low:7568kB high:9084kB active_anon:215640k=
B inactive_anon:59596kB active_file:54844kB inactive_file:2577912kB une=
victable:32kB present:3071904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:1748kB min:2036kB low:2544kB high:3052kB active_anon:146616=
kB inactive_anon:212660kB active_file:23108kB inactive_file:569060kB un=
evictable:1820kB present:1034240kB pages_scanned:0 all_unreclaimable? n=
o
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 4*8kB 6*16kB 4*32kB 5*64kB 3*128kB 4*256kB 2*512kB 2*1024kB =
2*2048kB 0*4096kB =3D 9160kB
DMA32: 2151*4kB 32*8kB 28*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*=
1024kB 0*2048kB 0*4096kB =3D 9724kB
Normal: 359*4kB 6*8kB 11*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1=
024kB 0*2048kB 0*4096kB =3D 1756kB
807996 total pagecache pages
1040 pages in swap cache
Swap cache stats: add 2982, delete 1942, find 32868/32970
=46ree swap  =3D 1039948kB
Total swap =3D 1048568kB
1310720 pages RAM
300051 pages reserved
203244 pages shared
881094 pages non-shared

>Index: wireless-testing/drivers/net/wireless/p54/p54common.c
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
>+++ wireless-testing/drivers/net/wireless/p54/p54common.c
>@@ -195,6 +195,11 @@ int p54_parse_firmware(struct ieee80211_
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
else
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0priv->rx_mtu =3D (size_t)
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A00x620 - priv->tx_hdr_le=
n;
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
if (priv->rx_mtu > 2356 && PAGE_SIZE =3D=3D 4096) {
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0printk(KERN_INFO "p54: Calculated rx_mtu of %d"
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 " reduced to 2356\n", priv->rx_mtu=
);
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0priv->rx_mtu =3D 2356;
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
}
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
break;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
}
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case BR_CODE_EXPOSED_I=
=46:

hmm, I wonder why it's a "order:1" allocation, even on x86-64 the skb_s=
hared_struct is less than 300 bytes
and the maximum rx_mtu size about 3240 so there should be room left....=
 of course, it's not really a big
deal for p54, since we don't have to support frames larger RTS or Fragm=
entation threshold anyway...
but what about 11n devices? aren't they suffer from the same problems u=
nder load?

So, maybe there's another way to solve this in a workqueue:
We could queue all the urb's that need a new skb in p54u_rx_cb instead.
(see struct urb 's "struct list_head urb_list" entry, which should be a=
vailable for this purpose)
Then we schedule a "p54usb-work", where we refill everything under "GFP=
_KERNEL".

The only trouble is that we can't always use mac80211's workqueue for t=
his.

This would also solve the "FIXME" in p54u_rx_cb about refilling.

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

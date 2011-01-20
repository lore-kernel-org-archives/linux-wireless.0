Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54902 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab1ATK22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 05:28:28 -0500
Received: by bwz15 with SMTP id 15so384783bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 02:28:26 -0800 (PST)
Message-ID: <4D380E46.6070906@gmail.com>
Date: Thu, 20 Jan 2011 11:28:22 +0100
From: Helge Lenz <helge.lenz@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: carl9170 802.11n-AP
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas <messier31@...> writes:

 >
 > Today I tried a different wifi card on the client side, instead of 
the Intel
 > 5100, but the problem remains the same. The carl9170 driver on my server
 > crashes at some point randomly (only in 802.11n mode). The traceback 
shows
 > the error at tx.c but everytime in a different line. So I guess there 
must
 > be a race condition somewhere.
 >
 > Here you can find the error report of some crashes:
 > http://www.mikrocontroller.net/attachment/95144/bugreport.txt
 >
 > Server hardware is a Seagate Dockstar with OpenWrt running on it. I 
heard
 > from another user with Debian, who has the same problem.
 >
 > Regards,
 >
 > Thomas
 >
 > --
 > To unsubscribe from this list: send the line "unsubscribe 
linux-wireless" in
 > the body of a message to majordomo@...
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 >
 >

Any news about this issue? I have the same problem on a Seagate Goflex 
Net running debian (Linux debian 2.6.35.4 #9 PREEMPT Tue Jan 18 13:03:42 
UTC 2011 armv5tel GNU/Linux). The kernel and the wireless drivers 
(compat-wireless-v2.6.37-4) are compiled natively on the box and when I 
try to transmit some data I get the following errors in dmesg:

------------[ cut here ]------------
[ 1015.070483] WARNING: at 
/usr/src/compat-wireless-2.6.37-4/drivers/net/wireless/ath/carl9170/tx.c:1239 
carl9170_op_tx+0x628/0x858 [carl9170]()
[ 1015.083442] Modules linked in:
[ 1015.086361] usb 1-1.2: restart device (5)
[ 1015.090604]  carl9170 mac80211 ath cfg80211 compat ipv6 hmac 
sha1_generic sata_mv mv_cesa [last unloaded: compat]
[ 1015.101057] [<c003058c>] (unwind_backtrace+0x0/0xf0) from 
[<c003d6c4>] (warn_slowpath_common+0x4c/0x64)
[ 1015.110504] [<c003d6c4>] (warn_slowpath_common+0x4c/0x64) from 
[<c003d6f4>] (warn_slowpath_null+0x18/0x1c)
[ 1015.120248] [<c003d6f4>] (warn_slowpath_null+0x18/0x1c) from 
[<bf1841c4>] (carl9170_op_tx+0x628/0x858 [carl9170])
[ 1015.130702] [<bf1841c4>] (carl9170_op_tx+0x628/0x858 [carl9170]) from 
[<bf153b8c>] (__ieee80211_tx+0x14c/0x1c8 [mac80211])
[ 1015.141928] [<bf153b8c>] (__ieee80211_tx+0x14c/0x1c8 [mac80211]) from 
[<bf153cf4>] (ieee80211_tx+0xec/0x29c [mac80211])
[ 1015.152885] [<bf153cf4>] (ieee80211_tx+0xec/0x29c [mac80211]) from 
[<bf1549e0>] (ieee80211_tx_pending+0x138/0x2a8 [mac80211])
[ 1015.164325] [<bf1549e0>] (ieee80211_tx_pending+0x138/0x2a8 
[mac80211]) from [<c00426d0>] (tasklet_action+0x84/0xe4)
[ 1015.174835] [<c00426d0>] (tasklet_action+0x84/0xe4) from [<c0042d14>] 
(__do_softirq+0x8c/0x124)
[ 1015.183594] [<c0042d14>] (__do_softirq+0x8c/0x124) from [<c0042df4>] 
(irq_exit+0x48/0xa0)
[ 1015.191832] [<c0042df4>] (irq_exit+0x48/0xa0) from [<c002b070>] 
(asm_do_IRQ+0x70/0x8c)
[ 1015.199799] [<c002b070>] (asm_do_IRQ+0x70/0x8c) from [<c03b15a8>] 
(__irq_svc+0x48/0xa8)
[ 1015.207855] Exception stack(0xc04d7f48 to 0xc04d7f90)
[ 1015.212943] 7f40:                   000f1d68 000003e8 000f1d68 
20000013 c04dd8d8 c04dd8d8
[ 1015.221175] 7f60: c05a6960 c04da330 00024068 56251311 00023f30 
00000000 3b0add45 c04d7f90
[ 1015.229394] 7f80: c005cecc c0034608 20000013 ffffffff
[ 1015.234490] [<c03b15a8>] (__irq_svc+0x48/0xa8) from [<c0034608>] 
(kirkwood_enter_idle+0x64/0x90)
[ 1015.243342] [<c0034608>] (kirkwood_enter_idle+0x64/0x90) from 
[<c02de684>] (cpuidle_idle_call+0xb0/0x110)
[ 1015.252976] [<c02de684>] (cpuidle_idle_call+0xb0/0x110) from 
[<c002c9e0>] (cpu_idle+0x60/0xb8)
[ 1015.261649] [<c002c9e0>] (cpu_idle+0x60/0xb8) from [<c0008988>] 
(start_kernel+0x280/0x2e0)
[ 1015.269965] [<c0008988>] (start_kernel+0x280/0x2e0) from [<00008034>] 
(0x8034)
[ 1015.277231] ---[ end trace 2ef0e9214ceebf4c ]---

[ 1515.714312] ------------[ cut here ]------------
[ 1515.719006] WARNING: at 
/usr/src/compat-wireless-2.6.37-4/drivers/net/wireless/ath/carl9170/tx.c:300 
carl9170_tx_status+0x230/0x3e4 [carl9170]()
[ 1515.732047] Modules linked in: carl9170 mac80211 ath cfg80211 compat 
ipv6 hmac sha1_generic sata_mv mv_cesa [last unloaded: compat]
[ 1515.744065] [<c003058c>] (unwind_backtrace+0x0/0xf0) from 
[<c003d6c4>] (warn_slowpath_common+0x4c/0x64)
[ 1515.753525] [<c003d6c4>] (warn_slowpath_common+0x4c/0x64) from 
[<c003d6f4>] (warn_slowpath_null+0x18/0x1c)
[ 1515.763263] [<c003d6f4>] (warn_slowpath_null+0x18/0x1c) from 
[<bf183388>] (carl9170_tx_status+0x230/0x3e4 [carl9170])
[ 1515.773980] [<bf183388>] (carl9170_tx_status+0x230/0x3e4 [carl9170]) 
from [<bf184320>] (carl9170_op_tx+0x784/0x858 [carl9170])
[ 1515.785557] [<bf184320>] (carl9170_op_tx+0x784/0x858 [carl9170]) from 
[<bf153b8c>] (__ieee80211_tx+0x14c/0x1c8 [mac80211])
[ 1515.797154] [<bf153b8c>] (__ieee80211_tx+0x14c/0x1c8 [mac80211]) from 
[<bf153cf4>] (ieee80211_tx+0xec/0x29c [mac80211])
[ 1515.808120] [<bf153cf4>] (ieee80211_tx+0xec/0x29c [mac80211]) from 
[<bf15406c>] (ieee80211_xmit+0x1c8/0x1fc [mac80211])
[ 1515.819079] [<bf15406c>] (ieee80211_xmit+0x1c8/0x1fc [mac80211]) from 
[<bf15538c>] (ieee80211_subif_start_xmit+0x804/0x83c [mac80211])
[ 1515.831306] [<bf15538c>] (ieee80211_subif_start_xmit+0x804/0x83c 
[mac80211]) from [<c0315020>] (dev_hard_start_xmit+0x2a0/0x3ac)
[ 1515.842948] [<c0315020>] (dev_hard_start_xmit+0x2a0/0x3ac) from 
[<c03273d8>] (sch_direct_xmit+0x80/0x204)
[ 1515.852580] [<c03273d8>] (sch_direct_xmit+0x80/0x204) from 
[<c03155d0>] (dev_queue_xmit+0x368/0x5b0)
[ 1515.861785] [<c03155d0>] (dev_queue_xmit+0x368/0x5b0) from 
[<c035ecf0>] (arp_process+0x32c/0x6f8)
[ 1515.870722] [<c035ecf0>] (arp_process+0x32c/0x6f8) from [<c0313fd0>] 
(__netif_receive_skb+0x474/0x4cc)
[ 1515.880134] [<c0313fd0>] (__netif_receive_skb+0x474/0x4cc) from 
[<bf14ef58>] (ieee80211_deliver_skb+0x130/0x168 [mac80211])
[ 1515.891445] [<bf14ef58>] (ieee80211_deliver_skb+0x130/0x168 
[mac80211]) from [<bf150614>] (ieee80211_rx_handlers+0x1308/0x18b0 
[mac80211])
[ 1515.904526] [<bf150614>] (ieee80211_rx_handlers+0x1308/0x18b0 
[mac80211]) from [<bf1514c8>] 
(ieee80211_prepare_and_rx_handle+0x90c/0x960 [mac80211])
[ 1515.918092] [<bf1514c8>] (ieee80211_prepare_and_rx_handle+0x90c/0x960 
[mac80211]) from [<bf151d88>] (ieee80211_rx+0x86c/0x924 [mac80211])
[ 1515.930594] [<bf151d88>] (ieee80211_rx+0x86c/0x924 [mac80211]) from 
[<bf185100>] (__carl9170_rx+0x808/0x860 [carl9170])
[ 1515.941482] [<bf185100>] (__carl9170_rx+0x808/0x860 [carl9170]) from 
[<bf185328>] (carl9170_rx_stream+0x1d0/0x334 [carl9170])
[ 1515.952890] [<bf185328>] (carl9170_rx_stream+0x1d0/0x334 [carl9170]) 
from [<bf17d61c>] (carl9170_usb_tasklet+0x68/0xcc [carl9170])
[ 1515.964720] [<bf17d61c>] (carl9170_usb_tasklet+0x68/0xcc [carl9170]) 
from [<c00425f0>] (tasklet_hi_action+0x88/0xe4)
[ 1515.975565] [<c00425f0>] (tasklet_hi_action+0x88/0xe4) from 
[<c0042d14>] (__do_softirq+0x8c/0x124)
[ 1515.984582] [<c0042d14>] (__do_softirq+0x8c/0x124) from [<c0042df4>] 
(irq_exit+0x48/0xa0)
[ 1515.992821] [<c0042df4>] (irq_exit+0x48/0xa0) from [<c002b070>] 
(asm_do_IRQ+0x70/0x8c)
[ 1516.000943] [<c002b070>] (asm_do_IRQ+0x70/0x8c) from [<c03b15a8>] 
(__irq_svc+0x48/0xa8)
[ 1516.008990] Exception stack(0xc04d7f48 to 0xc04d7f90)
[ 1516.014083] 7f40:                   0009c1d3 000003e8 0009c1d3 
20000013 c04dd868 c04dd878
[ 1516.022312] 7f60: c05a6960 c04da330 00024068 56251311 00023f30 
00000000 261d2322 c04d7f90
[ 1516.030531] 7f80: c005cecc c0034608 20000013 ffffffff
[ 1516.035628] [<c03b15a8>] (__irq_svc+0x48/0xa8) from [<c0034608>] 
(kirkwood_enter_idle+0x64/0x90)
[ 1516.044480] [<c0034608>] (kirkwood_enter_idle+0x64/0x90) from 
[<c02de684>] (cpuidle_idle_call+0xb0/0x110)
[ 1516.054112] [<c02de684>] (cpuidle_idle_call+0xb0/0x110) from 
[<c002c9e0>] (cpu_idle+0x60/0xb8)
[ 1516.062786] [<c002c9e0>] (cpu_idle+0x60/0xb8) from [<c0008988>] 
(start_kernel+0x280/0x2e0)
[ 1516.071111] [<c0008988>] (start_kernel+0x280/0x2e0) from [<00008034>] 
(0x8034)
[ 1516.078367] ---[ end trace 2ef0e9214ceebf4d ]---

If I can do anything to debug the error any further I am more then 
willing to help.

Thanks, Helge.


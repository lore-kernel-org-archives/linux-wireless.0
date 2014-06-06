Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.teufel.de ([81.17.209.37]:63747 "EHLO
	mail-out.teufel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaFFOED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 10:04:03 -0400
Received: from local.teufel.de ([192.168.181.16])
	by mail-out.teufel.de (Kerio Connect 8.0.1)
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for linux-wireless@vger.kernel.org;
	Fri, 6 Jun 2014 15:58:24 +0200
Received: from localhost ([127.0.0.1])
	by local.teufel.de
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128 bits))
	for linux-wireless@vger.kernel.org;
	Fri, 6 Jun 2014 15:58:49 +0200
Message-ID: <5391C919.1040300@teufel.de> (sfid-20140606_160417_140069_202782F4)
Date: Fri, 06 Jun 2014 15:58:49 +0200
From: Michael Hirsch <hirsch@teufel.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mwifiex sdio as AP  multicast transmit queue 1 timed out
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have an issue with mwifiex (sdio, SD8787) in AP mode. It does not send 
out multicast packages. Also, after a while I see a "transmit queue 1 
timed out".

- Kernel Version is: 3.15.0-rc5
- Firmware is 14.66.9.p96 (I also tried with others, no change)
- Platform is a TI AM335x

Steps to reproduce:

1. create bridge & ap:

brctl addbr br0
brctl addif br0 eth0
iw phy phy0 interface add ap0 type __ap
brctl addif br0 ap0
ifconfig br0 up
ifconfig eth0 up
hostapd /etc/hostapd.conf
dhclient br0

2. Connect a STA to the AP

3. start iperf:

e.g. iperf -c 239.255.255.239 -u -T 32 -i 1 -l 1 -b 1K -t 1000

output:
------------------------------------------------------------
Client connecting to 239.255.255.239, UDP port 5001
Sending 12 byte datagrams
Setting multicast TTL to 32
UDP buffer size:  160 KByte (default)
------------------------------------------------------------
[  3] local 192.168.44.137 port 49883 connected with 239.255.255.239 
port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec   132 Bytes  1.06 Kbits/sec
[  3]  1.0- 2.0 sec   120 Bytes   960 bits/sec
[  3]  2.0- 3.0 sec   132 Bytes  1.06 Kbits/sec
[  3]  3.0- 4.0 sec   120 Bytes   960 bits/sec
[  3]  4.0- 5.0 sec   132 Bytes  1.06 Kbits/sec
[  3]  5.0- 6.0 sec   120 Bytes   960 bits/sec
[  3]  6.0- 7.0 sec   120 Bytes   960 bits/sec
[  3]  7.0- 8.0 sec   132 Bytes  1.06 Kbits/sec
[  3]  8.0- 9.0 sec   120 Bytes   960 bits/sec
[  3]  9.0-10.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 10.0-11.0 sec   120 Bytes   960 bits/sec
[  3] 11.0-12.0 sec   120 Bytes   960 bits/sec
[  3] 12.0-13.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 13.0-14.0 sec   120 Bytes   960 bits/sec
[  3] 14.0-15.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 15.0-16.0 sec   120 Bytes   960 bits/sec
[  3] 16.0-17.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 17.0-18.0 sec   120 Bytes   960 bits/sec
[  3] 18.0-19.0 sec   120 Bytes   960 bits/sec
[  3] 19.0-20.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 20.0-21.0 sec   120 Bytes   960 bits/sec
[  563.011794] ------------[ cut here ]------------
[  563.016736] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 
dev_watchdog+0x280/0x28c()
[  563.025740] NETDEV WATCHDOG: ap0 (mwifiex_sdio): transmit queue 1 
timed out
[  563.033061] Modules linked in: bridge stp llc mwifiex_sdio mwifiex 
snd_soc_s800 snd_soc_davinci_mcasp snd_soc_tas5086 snd_soc_cs4271 
snd_soc_ak5386 snd_soc_ak4104 snd_soc_ap
[  563.051522] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc5 #5
[  563.057973] [<c001473c>] (unwind_backtrace) from [<c00122a4>] 
(show_stack+0x10/0x14)
[  563.066127] [<c00122a4>] (show_stack) from [<c003ada0>] 
(warn_slowpath_common+0x6c/0x84)
[  563.074632] [<c003ada0>] (warn_slowpath_common) from [<c003ade8>] 
(warn_slowpath_fmt+0x30/0x40)
[  563.083774] [<c003ade8>] (warn_slowpath_fmt) from [<c0448f88>] 
(dev_watchdog+0x280/0x28c)
[  563.092378] [<c0448f88>] (dev_watchdog) from [<c00440d4>] 
(call_timer_fn+0x6c/0xe4)
[  563.100422] [<c00440d4>] (call_timer_fn) from [<c0044668>] 
(run_timer_softirq+0x1c8/0x26c)
[  563.109129] [<c0044668>] (run_timer_softirq) from [<c003eb60>] 
(__do_softirq+0x12c/0x2b0)
[  563.117727] [<c003eb60>] (__do_softirq) from [<c003efe8>] 
(irq_exit+0xc8/0x104)
[  563.125413] [<c003efe8>] (irq_exit) from [<c000f8a4>] 
(handle_IRQ+0x58/0xb8)
[  563.132828] [<c000f8a4>] (handle_IRQ) from [<c0008684>] 
(omap3_intc_handle_irq+0x8c/0x9c)
[  563.141384] [<c0008684>] (omap3_intc_handle_irq) from [<c0012dc4>] 
(__irq_svc+0x44/0x78)
[  563.149875] Exception stack(0xc0747f58 to 0xc0747fa0)
[  563.155195] 7f40: 
    00000001 00000001
[  563.163783] 7f60: 00000000 c0750fa8 c074e0d0 00000000 c0746000 
00000000 c079c420 c07a921a
[  563.172372] 7f80: c0746000 ffffffed 00000000 c0747fa0 c006c198 
c000f9ec 20000013 ffffffff
[  563.180931] [<c0012dc4>] (__irq_svc) from [<c000f9ec>] 
(arch_cpu_idle+0x24/0x30)
[  563.188710] [<c000f9ec>] (arch_cpu_idle) from [<c0064f20>] 
(cpu_startup_entry+0x114/0x21c)
[  563.197397] [<c0064f20>] (cpu_startup_entry) from [<c070fa20>] 
(start_kernel+0x304/0x310)
[  563.205979] ---[ end trace 260fa0c259770f88 ]---
[  563.210825] mwifiex_sdio mmc0:0001:1: 26320 : Tx timeout(#1), 
bss_type-num = 1-0
[  3] 21.0-22.0 sec   108 Bytes   864 bits/sec
[  3] 22.0-23.0 sec   144 Bytes  1.15 Kbits/sec
[  3] 23.0-24.0 sec   120 Bytes   960 bits/sec
[  3] 24.0-25.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 25.0-26.0 sec   120 Bytes   960 bits/sec
[  3] 26.0-27.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 27.0-28.0 sec   120 Bytes   960 bits/sec
[  3] 28.0-29.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 29.0-30.0 sec   120 Bytes   960 bits/sec
[  3] 30.0-31.0 sec   120 Bytes   960 bits/sec
[  573.011824] mwifiex_sdio mmc0:0001:1: 27301 : Tx timeout(#2), 
bss_type-num = 1-0
[  3] 31.0-32.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 32.0-33.0 sec   120 Bytes   960 bits/sec
[  3] 33.0-34.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 34.0-35.0 sec   120 Bytes   960 bits/sec
[  3] 35.0-36.0 sec   120 Bytes   960 bits/sec
[  3] 36.0-37.0 sec   132 Bytes  1.06 Kbits/sec
[  3] 37.0-38.0 sec   120 Bytes   960 bits/sec
[  3]  0.0-39.0 sec  4.76 KBytes  1000 bits/sec


- On STA side I can't see any multicast incoming. (wireshark, tcpdump, 
iperf -s)

- I'm not sure if it's related to 
https://bugzilla.kernel.org/show_bug.cgi?id=70191.

- Apart from that the SD8787 as AP works fine.

Any Idea how to fix that? I can open a bug at bugzilla.kernel.org if needed.

Best regards

Michael




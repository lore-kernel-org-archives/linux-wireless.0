Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:57177 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZDOTpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 15:45:35 -0400
Received: from web.de
	by fmmailgate05.web.de (Postfix) with SMTP id 81C7D5B40F24
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 21:45:33 +0200 (CEST)
Date: Wed, 15 Apr 2009 21:45:33 +0200
Message-Id: <563898303@web.de> (sfid-20090415_214540_287943_204809A3)
MIME-Version: 1.0
From: Kai Olbrich <kai.o@web.de>
To: linux-wireless@vger.kernel.org
Subject: Kernel Panic in 2.6.28/.29 (mac80211 bug?)
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I bought a Rev.C beagleboard [bb] (http://www.beagleboard.org) and comp=
iled an open embedded kernel.
This is not the vanilla 2.6 kernel, I know. There are some patches for =
the TI OMAP platform applied, but the wireless driver code should not b=
e patched at all.

There is a rt73 based WLAN stick (dlink dwl-g122, HW-rev. C1 ) plugged
in on an usb hub which is connected to the EHCI port on the bb (This
hardware is for a bb based mobile robot).

=46inally i got the WLAN with the rt73usb driver working with WPA and
wpa_supplicant (ping ok :). I tried to transfer a "big" file (some MB's=
)
with scp from my workstation to the bb's tmp directory. After some
seconds (I did some dmesg and pings over the serial console in parallel=
) the
kernel crashed. I also tried a 2.6.29 kernel (bitbake -p linux-
omap-2.6.29.bb) -> This also crashed.

Attached please see the output from the kernel for 2.6.28 and 2.6.29...=
 I
hope somebody can help or point out for any workaround. Please just ask
if more informations should be provided.

I'm a little bit hopeless because the legacy driver rt73.ko (CVS-Code f=
rom rt2x00.serialmonkey.com) also didn't work reliable. I cross compile=
d this driver for arm
with the omap-cross compiler. I also got it to work with WPA-PSK. But t=
he IP connection died after some time.
Data transfer just stopped and ping didn't work anymore (iwlist wlan0 s=
canning still gave outputs %-)

I don't know what to do. Please give any hints.



Now the kernel output:

2.6.28:

Unable to handle kernel paging request at virtual address b7400000
pgd =3D c0004000
[b7400000] *pgd=3D00000000
Internal error: Oops: 5 [#1]
Modules linked in:
CPU: 0 Not tainted (2.6.28-omap1 #4)
PC is at skb_release_data+0xa0/0xc4
LR is at __kfree_skb+0x20/0xb8
pc : [<c0330f64>] lr : [<c0330c30>] psr: a0000113
sp : c051bd28 ip : c051bd48 fp : c051bd44
r10: 00000000 r9 : cf9f41c0 r8 : cfbd8032
r7 : 00000002 r6 : 00000000 r5 : cfbd2160 r4 : cfbd2160
r3 : 00000000 r2 : cfbd89c0 r1 : 000000b4 r0 : b7400000
=46lags: NzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment kernel
Control: 10c5387d Table: 8edc4018 DAC: 00000017
Process swapper (pid: 0, stack limit =3D 0xc051a2e8)
Stack: (0xc051bd28 to 0xc051c000)
bd20: c0330ac0 cfbd2160 cf9f4884 00000000
c051bd5c c051bd48
bd40: c0330c30 c0330ed0 00000000 cfbd8036 c051bd6c c051bd60
c0330d10 c0330c1c
bd60: c051bdfc c051bd70 c03dcfa0 c0330cd4 cfa75260 00000000
c051bd94 c051bd88
bd80: cfbd803c cf9f4884 cfbd2160 cfbd8038 cfbd803a cfbd8036
cfbd2160 00000000
bda0: cf9f41c0 00000000 00000000 00000000 c051be48 cf9c1180
00000000 00000002
bdc0: 00000000 0000000e 00000000 00000000 c051be24 00000018
cfbd8032 c051be48
bde0: 00000000 00000000 c051be48 cf9f41c0 c051be44 c051be00
c03dd7c4 c03dc9bc
be00: c051be24 c051be10 c006e0f8 00000000 cf9c1180 cfbd2160
00003d22 cfbd2160
be20: cf9f41c0 c051be48 cf9f42a0 cf9f4294 00000000 0000000a
c051be94 c051be48
be40: c03cd698 c03dd288 00000000 00000000 00000000 0000096c
ffffffc6 00000000
be60: 0000003b 00000001 00000000 00000000 c051beb4 00000000
c055e560 c055e604
be80: 00000000 c055e5f0 c051beb4 c051be98 c00692ac c03cd618
00000100 00000014
bea0: c051a000 00000001 c051beec c051beb8 c00698c0 c0069240
cf9db660 00000000
bec0: c051beec 0000004d 00000000 c051e0e4 c003ae4c c05573c8
411fc083 0000001f
bee0: c051bf04 c051bef0 c00699a4 c0069868 0000004d 0000004d
c051bf1c c051bf08
bf00: c003906c c0069968 ffffffff d8200000 c051bf8c c051bf20
c0039a30 c003900c
bf20: 32fa4e8b a0000013 009959d0 00000000 c0045054 c051a000
c051e0e4 c003ae4c
bf40: c05573c8 411fc083 0000001f c051bf8c c051bf90 c051bf68
c003ae1c c0045150
bf60: 60000013 ffffffff c0045054 c051a000 c051e0e4 c003ae4c
c05573c8 0000001f
bf80: c051bfb4 c051bf90 c003ae1c c0045060 c0556f68 c056fa14
c0556f68 c002df00
bfa0: c051df78 8002c100 c051bfc4 c051bfb8 c03e97ec c003add8
c051bff4 c051bfc8
bfc0: c0008974 c03e97a4 c0008468 00000000 00000000 c002df00
00000000 10c5387d
bfe0: c0557434 c002e304 00000000 c051bff8 80008034 c0008714
00000000 00000000
Backtrace:
[<c0330ec4>] (skb_release_data+0x0/0xc4) from [<c0330c30>]
(__kfree_skb+0x20/0xb8)
r6:00000000 r5:cf9f4884 r4:cfbd2160
[<c0330c10>] (__kfree_skb+0x0/0xb8) from [<c0330d10>] (kfree_skb
+0x48/0x4c)
r4:cfbd8036
[<c0330cc8>] (kfree_skb+0x0/0x4c) from [<c03dcfa0>]
(__ieee80211_rx_handle_packet+0x5f0/0x618)
[<c03dc9b0>] (__ieee80211_rx_handle_packet+0x0/0x618) from
[<c03dd7c4>] (__ieee80211_rx+0x548/0x5ac)
[<c03dd27c>] (__ieee80211_rx+0x0/0x5ac) from [<c03cd698>]
(ieee80211_tasklet_handler+0x8c/0x114)
[<c03cd60c>] (ieee80211_tasklet_handler+0x0/0x114) from
[<c00692ac>] (tasklet_action+0x78/0xb8)
r8:c055e5f0 r7:00000000 r6:c055e604 r5:c055e560 r4:00000000
[<c0069234>] (tasklet_action+0x0/0xb8) from [<c00698c0>]
(__do_softirq+0x64/0x100)
r7:00000001 r6:c051a000 r5:00000014 r4:00000100
[<c006985c>] (__do_softirq+0x0/0x100) from [<c00699a4>] (irq_exit
+0x48/0x88)
[<c006995c>] (irq_exit+0x0/0x88) from [<c003906c>]
(__exception_text_start+0x6c/0x88)
r4:0000004d
[<c0039000>] (__exception_text_start+0x0/0x88) from [<c0039a30>]
(__irq_svc+0x30/0x80)
Exception stack(0xc051bf20 to 0xc051bf68)
bf20: 32fa4e8b a0000013 009959d0 00000000 c0045054 c051a000
c051e0e4 c003ae4c
bf40: c05573c8 411fc083 0000001f c051bf8c c051bf90 c051bf68
c003ae1c c0045150
bf60: 60000013 ffffffff
r5:d8200000 r4:ffffffff
[<c0045054>] (omap3_pm_idle+0x0/0x130) from [<c003ae1c>] (cpu_idle
+0x50/0x80)
[<c003adcc>] (cpu_idle+0x0/0x80) from [<c03e97ec>] (rest_init
+0x54/0x68)
r8:8002c100 r7:c051df78 r6:c002df00 r5:c0556f68 r4:c056fa14
[<c03e9798>] (rest_init+0x0/0x68) from [<c0008974>] (start_kernel
+0x26c/0x2d4)
[<c0008708>] (start_kernel+0x0/0x2d4) from [<80008034>]
(0x80008034)
r6:c002e304 r5:c0557434 r4:10c5387d
Code: e3500000 0a000006 e3a03000 e5823014 (e5904000)
Kernel panic - not syncing: Fatal exception in interrupt


2.6.29:

root@beagleboard:~# [ 130.690216] Unable to handle kernel paging
request at virtual address 1a000000
[ 130.697540] pgd =3D c0004000
[ 130.700256] [1a000000] *pgd=3D00000000
[ 130.704010] Internal error: Oops: 5 [#1]
[ 130.707977] Modules linked in:
[ 130.711059] CPU: 0 Not tainted (2.6.29-omap1 #1)
[ 130.716064] PC is at skb_release_data+0xa0/0xc4
[ 130.720611] LR is at __kfree_skb+0x20/0xb8
[ 130.724731] pc : [<c0358638>] lr : [<c0358484>] psr:
20000113
[ 130.724761] sp : c0555d38 ip : c0555d58 fp : c0555d54
[ 130.736297] r10: 00000000 r9 : cfb441a0 r8 : cfcaa02e
[ 130.741546] r7 : 00000006 r6 : 00000000 r5 : cfd0ed60 r4 :
cfd0ed60
[ 130.748107] r3 : 00000000 r2 : cfcaa9c0 r1 : 0000002d r0 :
1a000000
[ 130.754669] Flags: nzCv IRQs on FIQs on Mode SVC_32 ISA ARM
Segment kernel
[ 130.762023] Control: 10c5387d Table: 8fd78019 DAC: 00000017
[ 130.767791] Process swapper (pid: 0, stack limit =3D 0xc05542e8)
[ 130.773681] Stack: (0xc0555d38 to 0xc0556000)
[ 130.778045]
5d20: c035732c
cfd0ed60
[ 130.786437] 5d40: cfb44800 00000000 c0555d6c c0555d58 c0358484
c03585a4 5de57b23 cfcaa038
[ 130.794799] 5d60: c0555d7c c0555d70 c0358564 c0358470 c0555e0c
c0555d80 c040a7d4 c0358528
[ 130.803192] 5d80: c0555dac c0555d90 c02c1d98 c02c3660 cfcaa038
cfb44800 cfd0ed60 cfcaa034
[ 130.811553] 5da0: cfcaa036 cfcaa032 c02d2768 cfd0ed60 00000000
cfb441a0 00000000 00000000
[ 130.819946] 5dc0: 00000000 c0555e50 cfb87180 00000006 00000000
00000004 00000000 00000000
[ 130.828308] 5de0: ffc01180 00000018 cfcaa02e 00000000 cfb442a4
00000000 c0555e50 cfb441a0
[ 130.836700] 5e00: c0555e4c c0555e10 c040b074 c040a1c8 00001da0
00000800 cfb87180 cfd0ed60
[ 130.845062] 5e20: 00000000 cfd0ed60 cfb441a0 c0555e50 cfb442a4
cfb44298 00000000 0000000a
[ 130.853454] 5e40: c0555e9c c0555e50 c03fad3c c040aadc 00000000
00000000 00000000 0000096c
[ 130.861816] 5e60: ffffffc2 00000000 0000002e 00000001 00000000
00000008 c02d71a4 00000000
[ 130.870208] 5e80: c05984a0 c059853c 00000000 c0598528 c0555ebc
c0555ea0 c0062da0 c03facbc
[ 130.878601] 5ea0: 00000100 00000014 c0554000 00000001 c0555ef4
c0555ec0 c00633c8 c0062d34
[ 130.886962] 5ec0: c0555eec c0555ed0 c0563930 0000004d 00000000
c0557ffc c003ce4c c05923a8
[ 130.895355] 5ee0: 411fc083 0000001f c0555f04 c0555ef8 c00634a8
c0063370 c0555f1c c0555f08
[ 130.903717] 5f00: c003b05c c0063470 ffffffff d8200000 c0555f8c
c0555f20 c003ba30 c003b00c
[ 130.912109] 5f20: 31d364dc a0000013 0061ca53 00000000 c004738c
c0554000 c0557ffc c003ce4c
[ 130.920471] 5f40: c05923a8 411fc083 0000001f c0555f8c c0555f90
c0555f68 c003ce1c c0047488
[ 130.928863] 5f60: 60000013 ffffffff c004738c c0554000 c0557ffc
c003ce4c c05923a8 0000001f
[ 130.937225] 5f80: c0555fb4 c0555f90 c003ce1c c0047398 c0591f64
c05cba54 c0591f64 c002eea4
[ 130.945617] 5fa0: c0557e90 8002cd8c c0555fc4 c0555fb8 c04104f0
c003cdd8 c0555ff4 c0555fc8
[ 130.953979] 5fc0: c0008950 c04104a4 c0008468 00000000 00000000
c002eea4 00000000 10c5387d
[ 130.962371] 5fe0: c0592414 c002f2a8 00000000 c0555ff8 80008034
c0008714 00000000 00000000
[ 130.970733] Backtrace:
[ 130.973205] [<c0358598>] (skb_release_data+0x0/0xc4) from
[<c0358484>] (__kfree_skb+0x20/0xb8)
[ 130.981903] r6:00000000 r5:cfb44800 r4:cfd0ed60
[ 130.986572] [<c0358464>] (__kfree_skb+0x0/0xb8) from
[<c0358564>] (kfree_skb+0x48/0x4c)
[ 130.994659] r4:cfcaa038
[ 130.997192] [<c035851c>] (kfree_skb+0x0/0x4c) from [<c040a7d4>]
(__ieee80211_rx_handle_packet+0x618/0x640)
[ 131.006958] [<c040a1bc>] (__ieee80211_rx_handle_packet
+0x0/0x640) from [<c040b074>] (__ieee80211_rx+0x5a4/0x608)
[ 131.017211] [<c040aad0>] (__ieee80211_rx+0x0/0x608) from
[<c03fad3c>] (ieee80211_tasklet_handler+0x8c/0x120)
[ 131.027160] [<c03facb0>] (ieee80211_tasklet_handler+0x0/0x120)
from [<c0062da0>] (tasklet_action+0x78/0xb8)
[ 131.036987] r8:c0598528 r7:00000000 r6:c059853c r5:c05984a0
r4:00000000
[ 131.043762] [<c0062d28>] (tasklet_action+0x0/0xb8) from
[<c00633c8>] (__do_softirq+0x64/0x100)
[ 131.052459] r7:00000001 r6:c0554000 r5:00000014 r4:00000100
[ 131.058197] [<c0063364>] (__do_softirq+0x0/0x100) from
[<c00634a8>] (irq_exit+0x44/0x88)
[ 131.066345] [<c0063464>] (irq_exit+0x0/0x88) from [<c003b05c>]
(__exception_text_start+0x5c/0x70)
[ 131.075317] [<c003b000>] (__exception_text_start+0x0/0x70) from
[<c003ba30>] (__irq_svc+0x30/0x80)
[ 131.084350] Exception stack(0xc0555f20 to 0xc0555f68)
[ 131.089416] 5f20: 31d364dc a0000013 0061ca53 00000000 c004738c
c0554000 c0557ffc c003ce4c
[ 131.097808] 5f40: c05923a8 411fc083 0000001f c0555f8c c0555f90
c0555f68 c003ce1c c0047488
[ 131.106170] 5f60: 60000013 ffffffff
[ 131.114562] r5:d8200000 r4:ffffffff
[ 131.118164] [<c004738c>] (omap3_pm_idle+0x0/0x130) from
[<c003ce1c>] (cpu_idle+0x50/0x80)
[ 131.126434] [<c003cdcc>] (cpu_idle+0x0/0x80) from [<c04104f0>]
(rest_init+0x58/0x6c)
[ 131.134277] r8:8002cd8c r7:c0557e90 r6:c002eea4 r5:c0591f64
r4:c05cba54
[ 131.141052] [<c0410498>] (rest_init+0x0/0x6c) from [<c0008950>]
(start_kernel+0x248/0x2a4)
[ 131.149383] [<c0008708>] (start_kernel+0x0/0x2a4) from
[<80008034>] (0x80008034)
[ 131.156860] r6:c002f2a8 r5:c0592414 r4:10c5387d
[ 131.161529] Code: e3500000 0a000006 e3a03000 e5823014 (e5904000)
[ 131.168457] Kernel panic - not syncing: Fatal exception in
interrupt

thanks and greets,

Kai

______________________________________________________
GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

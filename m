Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37366 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750952AbYEXLfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 07:35:47 -0400
Message-ID: <4837FD8D.2010000@gmx.de> (sfid-20080524_133600_777248_960C9920)
Date: Sat, 24 May 2008 13:35:41 +0200
From: Thomas Kunze <thommycheck@gmx.de>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: hostap oops
References: <48374F39.40904@gmx.de> <20080524061628.GE4932@jm.kir.nu>
In-Reply-To: <20080524061628.GE4932@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some logs:

a) patch applied:

<card not inserted>
root@collie:~$ cat /proc/interrupts
           CPU0
  1:          0      GPIO-l  ACIN
 12:          0          SC  LCD
 17:        178          SC  sa11x0-uart
 26:       3138          SC  ost0
 41:          3      GPIO-h  CO
 43:          0      GPIO-h  PCMCIA0 CD
 44:          0      GPIO-h  UCB1x00
 47:          0      GPIO-h  Cover and Battery
 65:          0  LOCOMO-key  locomokbd
Err:          0
<insert card>
root@collie:~$ pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
hostap_cs: setting Vcc=33 (constant)
Checking CFTABLE_ENTRY 0x01 (default 0x01)
IO window settings: cfg->io.nwin=1 dflt.io.nwin=1
io->flags = 0x0046, io.base=0x0000, len=64
hostap_cs: Registered netdevice wifi0
hostap_hw.c: INTERRUPT BEFORE DEVICE INIT!
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
hostap_cs: index 0x01: , irq 35, io 0xc4820000-0xc482003f
prism2_hw_init: initialized in 190 ms
wifi0: NIC: id=0x800c v1.0.0
wifi0: PRI: id=0x15 v1.1.1
wifi0: STA: id=0x1f v1.8.4
wifi0: registered netdevice wlan0
prism2_download: dl_cmd=5 start_addr=0x003f0c01 num_areas=3
prism2_hw_init: initialized in 80 ms
prism2_hw_init: initialized in 30 ms
wifi0: NIC: id=0x800c v1.0.0
wifi0: PRI: id=0x15 v1.1.1
wifi0: STA: id=0x1f v1.7.4

root@collie:~$ cat /proc/interrupts
           CPU0
  1:          0      GPIO-l  ACIN
 12:          0          SC  LCD
 17:        311          SC  sa11x0-uart
 26:       3548          SC  ost0
 35:         98      GPIO-h  pcmcia0.0
 41:          3      GPIO-h  CO
 43:          0      GPIO-h  PCMCIA0 CD
 44:          0      GPIO-h  UCB1x00
 47:          0      GPIO-h  Cover and Battery
 65:          0  LOCOMO-key  locomokbd
Err:          0

b) patch not applied:
<card not inserted>
root@collie:~$ cat /proc/interrupts
Node totlen on flash (0xffffffff) != totlen from node ref (0x00000044)
           CPU0
  1:          0      GPIO-l  ACIN
 12:          0          SC  LCD
 17:        170          SC  sa11x0-uart
 26:       2888          SC  ost0
 41:          3      GPIO-h  CO
 43:          0      GPIO-h  PCMCIA0 CD
 44:          0      GPIO-h  UCB1x00
 47:          0      GPIO-h  Cover and Battery
 65:          0  LOCOMO-key  locomokbd
Err:          0
<card inserted>
root@collie:~$ pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
hostap_cs: setting Vcc=33 (constant)
Checking CFTABLE_ENTRY 0x01 (default 0x01)
IO window settings: cfg->io.nwin=1 dflt.io.nwin=1
io->flags = 0x0046, io.base=0x0000, len=64
hostap_cs: Registered netdevice wifi0
Unable to handle kernel NULL pointer dereference at virtual address 00000028
pgd = c0004000
[00000028] *pgd=00000000
Internal error: Oops: c3e2b017 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.26-rc3-00529-g95be721-dirty #62)
PC is at prism2_interrupt+0x64/0x8ec
LR is at kobject_put+0x48/0x5c
pc : [<c01dfc90>]    lr : [<c01850f8>]    psr: 20000093
sp : c3c79a28  ip : c3c799d0  fp : c3c79a64
r10: c3ec8544  r9 : 000000a0  r8 : 00000001
r7 : c01dfc2c  r6 : c3ec8000  r5 : 00008a32  r4 : c3ec8000
r3 : 00000004  r2 : 00000000  r1 : c01851c4  r0 : 00000001
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c3e2b17f  Table: c3e2b17f  DAC: 00000017
Process pccardd (pid: 72, stack limit = 0xc3c78260)
Stack: (0xc3c79a28 to 0xc3c7a000)
9a20:                   c3c79a7c c3c79a38 c3ec85b8 c3c79a78 c3c79a44 20000013
9a40: c3e65580 00000023 c01dfc2c 00000001 000000a0 c3ec8000 c3c79a94 c3c79a68
9a60: c0065d48 c01dfc38 c3e65a00 00000080 c3e4703c c3c4b804 c3e47000 c3f0e6e0
9a80: c3ec8544 00000023 c3c79ac0 c3c79a98 c01fcc40 c0065c90 c3ec8000 00000000
9aa0: 00000000 c3ec8544 c3e47000 c3ec8000 c3de0a00 c3c79d9c c3c79ac4 c01de5d4
9ac0: c01fcb98 c02be758 c3f0e660 00000000 00016401 76656401 73650076 616c702f
9ae0: 000493e0 000802c8 30783131 002dc6c0 002dc6c0 000186a0 49544300 613d4e4f
9b00: 44006464 41505645 2f3d4854 69766564 2f736563 74616c70 6d726f00 3161732f
9b20: 2d307831 636d6370 302f6169 5300302e 59534255 4d455453 00000000 00616963
9b40: 00000000 42564544 00000000 69636d63 4f530146 00000000 00000040 45440030
9b60: 45434956 3d4f4e5f 4d003030 4c41444f 3d534149 636d6370 6d3a6169 34373230
9b80: 31363163 36306632 30306e66 306e6670 32617030 31463138 70443543 34453662
9ba0: 38343034 43637037 39343039 70393341 41373564 39313636 45530034 4d554e51
9bc0: 3538333d 00000000 00000000 00000000 00000001 000000ff 0000ffff 00000000
9be0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9c00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9c20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9c40: 00000000 c3c79c00 00000000 00000021 00000021 00000021 c4814fff c4815000
9c60: 00000000 c0374a6c c4814000 c0007120 28000000 c0007120 000000a3 28000000
9c80: c3c4b804 00000000 00000021 00000000 00000021 c3dc17a0 c3dc17a0 c3c79cb8
9ca0: c3c79cac c0027efc c0027bb0 c3c79cdc c3c79cbc c01f9060 c0027eb4 c02a8c34
9cc0: 000000fc 00000007 00000000 c3c4b804 c3c79d0c 761901c1 3619d535 ff460536
9ce0: 0000ffff 00000007 00000007 c3c4b8dc 00000007 00000007 c3c4b8dc c3c4b804
9d00: 0000007e c3e65614 c3e65600 c01f942c c3dc17a0 00000000 c3c00480 c3dc17a0
9d20: a0000013 c3dc17a0 c3c79d54 c3c79d38 c0089f80 00000000 0000001b 00000110
9d40: 00000000 00000087 40000e1b c3c79d0e c3c79cd4 c0089f08 00000002 c3c79d1a
9d60: 00000110 00000000 00000000 00000000 00000000 c3e47000 c3e47094 c0389500
9d80: c03894e8 00000000 00000000 80000013 c3c79dd8 c3c79da0 c01fb534 c01ddca8
9da0: c3e47001 000003e0 00000001 00000000 00000000 00000000 c01c4500 c3e47094
9dc0: c01c47e4 c0389500 c3c79e0c c3c79df8 c3c79ddc c01c46cc c01fb438 00000000
9de0: c01c47e4 c3e47094 c3c79e0c c3c79e08 c3c79dfc c01c47f4 c01c45fc c3c79e34
9e00: c3c79e0c c01c3a34 c01c47f0 c3c9ed00 c3c9ed1c c3ca2630 c3e47094 c3e47094
9e20: c3e471ac c3e47190 c3c79e50 c3c79e38 c01c4878 c01c39e4 c038b564 c3e47094
9e40: 00000000 c3c79e68 c3c79e54 c01c3860 c01c482c c3e47094 c3e47000 c3c79e9c
9e60: c3c79e6c c01c280c c01c383c c03780b0 c3e4716c c3e47094 c3e47000 c3e47000
9e80: c3c4b804 c3c4ba04 c3c79fac 80000013 c3c79eb0 c3c79ea0 c01c2964 c01c24dc
9ea0: c3c4b9f4 c3c79ed8 c3c79eb4 c01fb884 c01c2954 00000001 c3c4b804 00000001
9ec0: 00000000 c3c4b950 c3c4b9e0 c3c79f40 c3c79edc c01fb9f0 c01fb704 c3c4b804
9ee0: 0000000a c038b430 c3c79fac c038b42c c3c79f18 c3c4bb08 c3c79f18 c3c79f08
9f00: c0185248 c0185f7c 00000004 c3c79f28 c3c79f1c c01c1e58 c018523c c3c79f40
9f20: 00000010 00000004 c3c4b804 c3c4b804 00000004 c3c79f5c c3c79f44 c01fbec4
9f40: c01fb97c c3c4b804 c3c4b804 00000000 c3c79f7c c3c79f60 c01f6fe8 c01fbe58
9f60: c3c4b804 00000000 c3c4b804 c3c78000 c3c79f94 c3c79f80 c01f74e0 c01f6f34
9f80: 00000080 00000000 c3c79fd8 c3c79f98 c01f7b0c c01f73f0 00000000 c3c52100
9fa0: c0034b88 c3c4b9d8 c3c4b9d8 000010c1 c3c78000 c3c4b804 c01f7954 00000000
9fc0: 00000000 00000000 00000000 c3c79ff4 c3c79fdc c004e9d8 c01f7960 00000000
9fe0: 00000000 00000000 00000000 c3c79ff8 c003cce4 c004e988 00000000 00000000
Backtrace:
[<c01dfc2c>] (prism2_interrupt+0x0/0x8ec) from [<c0065d48>] (request_irq+0xc4/0xfc)
[<c0065c84>] (request_irq+0x0/0xfc) from [<c01fcc40>] (pcmcia_request_irq+0xb4/0x134)
[<c01fcb8c>] (pcmcia_request_irq+0x0/0x134) from [<c01de5d4>] (hostap_cs_probe+0x938/0xe58)
[<c01ddc9c>] (hostap_cs_probe+0x0/0xe58) from [<c01fb534>] (pcmcia_device_probe+0x108/0x19c)
[<c01fb42c>] (pcmcia_device_probe+0x0/0x19c) from [<c01c46cc>] (driver_probe_device+0xdc/0x190)
 r7:c3c79e0c r6:c0389500 r5:c01c47e4 r4:c3e47094
[<c01c45f0>] (driver_probe_device+0x0/0x190) from [<c01c47f4>] (__device_attach+0x10/0x14)
 r7:c3c79e0c r6:c3e47094 r5:c01c47e4 r4:00000000
[<c01c47e4>] (__device_attach+0x0/0x14) from [<c01c3a34>] (bus_for_each_drv+0x5c/0x9c)
[<c01c39d8>] (bus_for_each_drv+0x0/0x9c) from [<c01c4878>] (device_attach+0x58/0x70)
 r7:c3e47190 r6:c3e471ac r5:c3e47094 r4:c3e47094
[<c01c4820>] (device_attach+0x0/0x70) from [<c01c3860>] (bus_attach_device+0x30/0x64)
 r6:00000000 r5:c3e47094 r4:c038b564
[<c01c3830>] (bus_attach_device+0x0/0x64) from [<c01c280c>] (device_add+0x33c/0x478)
 r5:c3e47000 r4:c3e47094
[<c01c24d0>] (device_add+0x0/0x478) from [<c01c2964>] (device_register+0x1c/0x20)
[<c01c2948>] (device_register+0x0/0x20) from [<c01fb884>] (pcmcia_device_add+0x18c/0x238)
 r4:c3c4b9f4
[<c01fb6f8>] (pcmcia_device_add+0x0/0x238) from [<c01fb9f0>] (pcmcia_card_add+0x80/0xb0)
[<c01fb970>] (pcmcia_card_add+0x0/0xb0) from [<c01fbec4>] (ds_event+0x78/0x8c)
 r7:00000004 r6:c3c4b804 r5:c3c4b804 r4:00000004
[<c01fbe4c>] (ds_event+0x0/0x8c) from [<c01f6fe8>] (send_event+0xc0/0xe0)
 r6:00000000 r5:c3c4b804 r4:c3c4b804
[<c01f6f28>] (send_event+0x0/0xe0) from [<c01f74e0>] (socket_insert+0xfc/0x124)
 r7:c3c78000 r6:c3c4b804 r5:00000000 r4:c3c4b804
[<c01f73e4>] (socket_insert+0x0/0x124) from [<c01f7b0c>] (pccardd+0x1b8/0x278)
 r5:00000000 r4:00000080
[<c01f7954>] (pccardd+0x0/0x278) from [<c004e9d8>] (kthread+0x5c/0x90)
[<c004e97c>] (kthread+0x0/0x90) from [<c003cce4>] (do_exit+0x0/0x618)
 r6:00000000 r5:00000000 r4:00000000
Code: ea000201 e59a4014 e59f580c e5942020 (e1d232b8)
---[ end trace b64dce6271085dd2 ]---



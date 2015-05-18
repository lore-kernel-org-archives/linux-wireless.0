Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35141 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbbERSi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 14:38:59 -0400
Received: by labbd9 with SMTP id bd9so233157153lab.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 11:38:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555A05DC.8080704@lwfinger.net>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
	<5557844B.4040108@lwfinger.net>
	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>
	<55586D8D.7040407@gmail.com>
	<CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com>
	<CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
	<555A05DC.8080704@lwfinger.net>
Date: Mon, 18 May 2015 21:38:57 +0300
Message-ID: <CAJ=9CzY3E0Y3++g6sWEmgBQ70YmJEJaUdunN9AS4obLT4-WaBQ@mail.gmail.com> (sfid-20150518_203904_323969_0C312165)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <aspriel@gmail.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 May 2015 at 18:31, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/17/2015 02:22 PM, Haggai Eran wrote:
>>
>> I added some debugging prints, trying to see more details about the
>> packet that fails the r8712_validate_recv_frame. I noticed I'm getting
>> many packets where recv_decache returns _FAIL. However, the last two
>> packets before the crash fail for different reasons. The first has the
>> ver field set to 3 (instead of zero). The second (the one that get's
>> freed and cause the crash apparently) has an unknown type (12). If I'm
>> not mistaken, 12 = WIFI_CTRL_TYPE | WIFI_DATA_TYPE. Is that possible?
>>
>> It could be that the packet headers are garbled though.
>
>
> I think the headers are garbled. Did you log the address of the skb at
> precvframe->u.hdr.pkt in r8712_free_recvframe() or orig_prframe->u.hdr.pct
> in recv_func().

I added prints of the skb pointer in every call to recv_func. Here are
the results:

...
[  674.111771] recv_func: pcontext = 96335820, prframe->u.hdr.pkt = 9729fb40
[  674.118782] recv_func: pcontext = 963359b8, prframe->u.hdr.pkt = 9729f6c0
[  674.125777] recv_func: pcontext = 96335930, prframe->u.hdr.pkt = 9729f780
[  674.132769] recv_func: pcontext = 963358a8, prframe->u.hdr.pkt = 973d56c0
[  674.139753] recv_func: pcontext = 96335d70, prframe->u.hdr.pkt = 973d5000
[  674.146922] recv_func: pcontext = 963361b0, prframe->u.hdr.pkt = 973d5000
[  674.153961] recv_func: pcontext = 963360a0, prframe->u.hdr.pkt = 973d5000
[  674.161023] recv_func: pcontext = 96336128, prframe->u.hdr.pkt = 973d5000
[  674.168186] recv_func: pcontext = 96336018, prframe->u.hdr.pkt = 973d5000
[  674.175231] recv_func: pcontext = 96335f90, prframe->u.hdr.pkt = 973d5000
[  674.182141] r8712_validate_recv_frame: ver = 1
[  674.186814] recv_func: pcontext = 96335f08, prframe->u.hdr.pkt = 973d5000
[  674.193811] r8712_validate_recv_frame: ver = 1
[  674.198530] recv_func: pcontext = 963363d0, prframe->u.hdr.pkt = 973d5000
[  674.205434] r8712_validate_recv_frame: ver = 3
[  674.210018] Unable to handle kernel NULL pointer dereference at
virtual address 00000001
[  674.218209] pgd = 80004000
[  674.221025] [00000001] *pgd=00000000
[  674.224752] Internal error: Oops: 5 [#1] ARM
[  674.229028] Modules linked in: rfcomm cfg80211 r8712u(C) btusb
bluetooth bcm2708_rng
[  674.236857] CPU: 0 PID: 530 Comm: kworker/0:1 Tainted: G        WC
    4.0.3 #1
[  674.244247] Hardware name: BCM2708
[  674.247663] task: 962cdee0 ti: 960fc000 task.ti: 960fc000
[  674.253082] PC is at put_page+0xc/0x68
[  674.256853] LR is at skb_release_data+0x6c/0xcc
[  674.261388] pc : [<800933e0>]    lr : [<80433fe4>]    psr: 20000113
[  674.261388] sp : 960fdc18  ip : 960fdc28  fp : 960fdc24
[  674.272856] r10: 84d6cc00  r9 : 0000fff8  r8 : 00002f17
[  674.278079] r7 : 973d5000  r6 : 84dc7620  r5 : 84dc7620  r4 : 00000000
[  674.284602] r3 : 00000037  r2 : 00000000  r1 : 00000001  r0 : 00000001
[  674.291127] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[  674.298432] Control: 00c5387d  Table: 168a4008  DAC: 00000015
[  674.304179] Process kworker/0:1 (pid: 530, stack limit = 0x960fc188)
[  674.310532] Stack: (0x960fdc18 to 0x960fe000)
[  674.314893] dc00:
    960fdc44 960fdc28
[  674.323076] dc20: 80433fe4 800933e0 973d5000 96309010 96308520
96309010 960fdc5c 960fdc48
[  674.331257] dc40: 8043406c 80433f84 00000001 973d5000 960fdc74
960fdc60 8043413c 80434050
[  674.339437] dc60: 40000113 963363d0 960fdc84 960fdc78 80441c08
80434120 960fdcac 960fdc88
[  674.347618] dc80: 7f10ca70 80441bd0 00000000 96308520 963363d0
00000000 96309010 00002f17
[  674.355798] dca0: 960fdce4 960fdcb0 7f10d3f8 7f10ca50 960fdcd4
960fdcc0 80439aac 96308520
[  674.363978] dcc0: 963363d0 9630a520 00002f80 00002f17 0000fff8
84d6cc00 960fdd04 960fdce8
[  674.372157] dce0: 7f10eb84 7f10d36c 000000d2 963363d0 84dc7626
00000018 960fdd54 960fdd08
[  674.380338] dd00: 7f10c65c 7f10eb5c 96308ff0 963090d4 9729f840
9630b520 96309010 973d5000
[  674.388518] dd20: ffff2f00 00000002 808f4590 96309094 808f458c
8093f820 00000000 96a32900
[  674.396698] dd40: 8093f840 40000000 960fdd7c 960fdd58 8001fbbc
7f10c4b8 0000833e 00000000
[  674.404879] dd60: 00000000 00000102 960fc000 8093f840 960fddcc
960fdd80 8001ffc0 8001fb48
[  674.413058] dd80: 8054e348 80052428 00000001 00000001 04208060
0001b61a 00000009 960fc000
[  674.421237] dda0: 00000000 00000000 80920c94 00000000 00000000
00000000 8003555c 00000000
[  674.429416] ddc0: 960fdde4 960fddd0 80020474 8001fea4 00000000
00000000 960fde0c 960fdde8
[  674.437598] dde0: 80057298 800203bc 960fde20 8054e760 60000013
f200b200 960fde54 972ba1e0
[  674.445777] de00: 960fde1c 960fde10 800081e4 80057224 960fde7c
960fde20 800127f8 800081cc
[  674.453957] de20: 8054e75c 00000001 962cdee0 00000000 808f6668
969021e0 97051140 00000000
[  674.462140] de40: 972ba1e0 8003555c 00000000 960fde7c 960fde58
960fde68 8004b37c 8054e760
[  674.470319] de60: 60000013 ffffffff 00000000 808f6668 960fdeac
960fde80 8003e738 8054e73c
[  674.478499] de80: 00000001 00000000 8003e6cc 960fde98 97239140
962cdee0 808f6668 972ba1e0
[  674.486679] dea0: 960fded4 960fdeb0 80549748 8003e6d8 960fded8
960fc000 808f5834 808f5834
[  674.494860] dec0: 808f5864 00000008 960fdeec 960fded8 80549ad8
80549558 962cdee0 971e55a0
[  674.503039] dee0: 960fdf24 960fdef0 80035590 80549aa0 972c4940
971e55a0 800354cc 00000000
[  674.511220] df00: 972c4940 971e55a0 800354cc 00000000 00000000
00000000 960fdfac 960fdf28
[  674.519401] df20: 8003a080 800354d8 00000000 00000000 960fdf4c
971e55a0 00000000 00000001
[  674.527581] df40: dead4ead ffffffff ffffffff 8093fd70 00000000
00000000 80646d2c 960fdf5c
[  674.535759] df60: 960fdf5c 00000000 00000001 dead4ead ffffffff
ffffffff 8093fd70 00000000
[  674.543939] df80: 00000000 80646d2c 960fdf88 960fdf88 972c4940
80039fa0 00000000 00000000
[  674.552118] dfa0: 00000000 960fdfb0 8000e8f0 80039fac 00000000
00000000 00000000 00000000
[  674.560296] dfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  674.568474] dfe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[  674.576643] Backtrace:
[  674.579129] [<800933d4>] (put_page) from [<80433fe4>]
(skb_release_data+0x6c/0xcc)
[  674.586711] [<80433f78>] (skb_release_data) from [<8043406c>]
(skb_release_all+0x28/0x2c)
[  674.594881]  r7:96309010 r6:96308520 r5:96309010 r4:973d5000
[  674.600599] [<80434044>] (skb_release_all) from [<8043413c>]
(consume_skb+0x28/0x5c)
[  674.608338]  r4:973d5000 r3:00000001
[  674.611961] [<80434114>] (consume_skb) from [<80441c08>]
(__dev_kfree_skb_any+0x44/0x48)
[  674.620045]  r4:963363d0 r3:40000113
[  674.623891] [<80441bc4>] (__dev_kfree_skb_any) from [<7f10ca70>]
(r8712_free_recvframe+0x2c/0x94 [r8712u])
[  674.633827] [<7f10ca44>] (r8712_free_recvframe [r8712u]) from
[<7f10d3f8>] (recv_func+0x98/0x6f0 [r8712u])
[  674.643477]  r8:00002f17 r7:96309010 r6:00000000 r5:963363d0
r4:96308520 r3:00000000
[  674.651563] [<7f10d360>] (recv_func [r8712u]) from [<7f10eb84>]
(r8712_recv_entry+0x34/0x78 [r8712u])
[  674.660780]  r10:84d6cc00 r9:0000fff8 r8:00002f17 r7:00002f80
r6:9630a520 r5:963363d0
[  674.668666]  r4:96308520
[  674.671495] [<7f10eb50>] (r8712_recv_entry [r8712u]) from
[<7f10c65c>] (recv_tasklet+0x1b0/0x324 [r8712u])
[  674.681145]  r6:00000018 r5:84dc7626 r4:963363d0 r3:000000d2
[  674.687002] [<7f10c4ac>] (recv_tasklet [r8712u]) from [<8001fbbc>]
(tasklet_hi_action+0x80/0xdc)
[  674.695785]  r10:40000000 r9:8093f840 r8:96a32900 r7:00000000
r6:8093f820 r5:808f458c
[  674.703670]  r4:96309094
[  674.706228] [<8001fb3c>] (tasklet_hi_action) from [<8001ffc0>]
(__do_softirq+0x128/0x290)
[  674.714399]  r8:8093f840 r7:960fc000 r6:00000102 r5:00000000
r4:00000000 r3:0000833e
[  674.722205] [<8001fe98>] (__do_softirq) from [<80020474>]
(irq_exit+0xc4/0x118)
[  674.729509]  r10:00000000 r9:8003555c r8:00000000 r7:00000000
r6:00000000 r5:80920c94
[  674.737392]  r4:00000000
[  674.739968] [<800203b0>] (irq_exit) from [<80057298>]
(__handle_domain_irq+0x80/0xe0)
[  674.747793]  r4:00000000 r3:00000000
[  674.751406] [<80057218>] (__handle_domain_irq) from [<800081e4>]
(asm_do_IRQ+0x24/0x28)
[  674.759404]  r8:972ba1e0 r7:960fde54 r6:f200b200 r5:60000013
r4:8054e760 r3:960fde20
[  674.767228] [<800081c0>] (asm_do_IRQ) from [<800127f8>] (__irq_svc+0x38/0xb0)
[  674.774361] Exception stack(0x960fde20 to 0x960fde68)
[  674.779421] de20: 8054e75c 00000001 962cdee0 00000000 808f6668
969021e0 97051140 00000000
[  674.787600] de40: 972ba1e0 8003555c 00000000 960fde7c 960fde58
960fde68 8004b37c 8054e760
[  674.795771] de60: 60000013 ffffffff
[  674.799294] [<8054e730>] (_raw_spin_unlock_irq) from [<8003e738>]
(finish_task_switch+0x6c/0x108)
[  674.808157]  r4:808f6668 r3:00000000
[  674.811772] [<8003e6cc>] (finish_task_switch) from [<80549748>]
(__schedule+0x1fc/0x548)
[  674.819856]  r7:972ba1e0 r6:808f6668 r5:962cdee0 r4:97239140
[  674.825572] [<8054954c>] (__schedule) from [<80549ad8>] (schedule+0x44/0x9c)
[  674.832615]  r8:00000008 r7:808f5864 r6:808f5834 r5:808f5834
r4:960fc000 r3:960fded8
[  674.840438] [<80549a94>] (schedule) from [<80035590>]
(worker_thread+0xc4/0x4d0)
[  674.847829]  r4:971e55a0 r3:962cdee0
[  674.851442] [<800354cc>] (worker_thread) from [<8003a080>]
(kthread+0xe0/0x100)
[  674.858747]  r10:00000000 r9:00000000 r8:00000000 r7:800354cc
r6:971e55a0 r5:972c4940
[  674.866630]  r4:00000000
[  674.869192] [<80039fa0>] (kthread) from [<8000e8f0>]
(ret_from_fork+0x14/0x24)
[  674.876409]  r7:00000000 r6:00000000 r5:80039fa0 r4:972c4940
[  674.882121] Code: 8009272c e1a0c00d e92dd800 e24cb004 (e5902000)
[  674.888596] ---[ end trace 8b18691702087335 ]---
[  674.893371] Kernel panic - not syncing: Fatal exception in interrupt
[  674.899744] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

The offsets are a little different, I guess because of the added
prints, and debugging features I enabled in the kernel. One thing I
notice is that the skb at 0x973d5000 gets reused a couple of times
before the crash. Also, this time the pointer being dereferenced is
NULL (0x1).

Haggai

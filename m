Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:64891 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZASVxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 16:53:09 -0500
Received: by ewy13 with SMTP id 13so629079ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 13:53:06 -0800 (PST)
Message-ID: <4974F63F.4050302@gmail.com> (sfid-20090119_225316_576193_060BFA66)
Date: Mon, 19 Jan 2009 22:53:03 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901190126.58392.chunkeey@web.de> <4974C32D.4030802@gmail.com> <200901191948.57069.chunkeey@web.de>
In-Reply-To: <200901191948.57069.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 19 January 2009 19:15:09 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Monday 19 January 2009 00:27:02 Artur Skawina wrote:
>>>> Artur Skawina wrote:
>>>>> didn't trigger anything here, just the usual:
>>>>>
>>>>> BUG kmalloc-4096: Poison overwritten
>>>> This is almost 100% reproducible; sometimes the machine freezes in=
stead.
>> Here's an interesting sequence:
>>
>> 1) a TX urb is submitted.
>> 2) p54u_rx_cb() =3D> p54_rx_frame_sent(), which does kfree_skb( the_=
skb_in_(1) ).
>> 3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kab=
oom.
>>
>> IOW the skb is freed before the usb completion runs.
>=20
> Well, the sequence should be:
>=20
> 1) p54_tx gets called
> 1.1) one IRQ urb is submitted
> 1.2) one BULK urb is submitted
> 2) the firmware acks that it got the urbs
> 2.1) p54u_tx_cb is called for the IRQ urb. which frees the small buff=
er
> 2.2) p54u_tx_cb is called for the BULK urb. which only removes the ne=
t2280_tx_hdr from the skb.
> [time passes]
> 3) firmware is finished sending.
> 3.1) p54u_rx_cb gets called
>        =3D> p54_rx_frame_sent passed the feedback to mac80211

That's what one would expect, and is probably why i couldn't see anythi=
ng
wrong in the code despite going over it several times. Until i got a cr=
ash
which left no doubt as to what happened, and made me notice the "wrong"
completion order, log attached [1].
In theory, theory and practice do not differ, in practice...

>> Somehow i don't think this is the reason for the corruption, but it =
certainly
>> seems to be responsible for some, if not all, of the crashes/panics.
> dunno... we should see a bit more fallout, because skb_pull changes s=
kb->data and skb->len.=20

Doing an skb_pull in p54u_tx_cb on skbs that have already been given to=
 mac80211
cannot be good.
We can move the FREE_AFTER_TX(skb) check from the completion to the sub=
mission
path, right? Then find a way to do the pull _before_ giving away the sk=
bs.
I can't shutdown the machine where i can reproduce this today, so it wi=
ll have
to wait until at least tomorrow.

artur

[1]: note there are two issues, first the skb_pull triggers a BUG, whic=
h
 is then interrupted by the SLUB error, then the rest of the first BUG
 follows. i've added '#'-comments explaining some of the numbers.

[...]
TX: LEN=3D   20 SKB=3Dd7eb2b60 HEAD=3Dd78f28c0
TX: DONE=20
TX: LEN=3D   32 SKB=3Dda7c0620 HEAD=3Dde02b3b0
TX: DONE=20
TX: LEN=3D  436 SKB=3Dd7eb2ee0 HEAD=3Ddd4ee180
TXCB: LEN=3D   36 SKB=3Dd7eb2b60 HEAD=3Dd78f28c0
TXCB: LEN=3D   48 SKB=3Dda7c0620 HEAD=3Dde02b3b0
TX: DONE=20
TX: LEN=3D  436 SKB=3Ddd55e2a0 HEAD=3Ddd4ef670
TX: DONE=20
TX: LEN=3D  176 SKB=3Dde01e8c0 HEAD=3Dd9812060
TX: DONE=20
TXCB: LEN=3D  452 SKB=3Dd7eb2ee0 HEAD=3Ddd4ee180
TXCB: LEN=3D  452 SKB=3Ddd55e2a0 HEAD=3Ddd4ef670
TXCB: LEN=3D  192 SKB=3Dde01e8c0 HEAD=3Dd9812060
RXCB: LEN=3D   36 SKB=3Ddd5dfee0 HEAD=3Dd9813090
RXCB: LEN=3D   36 SKB=3Ddd433700 HEAD=3Dd9811030
RXCB: LEN=3D   36 SKB=3Ddfbf3a80 HEAD=3Dd9816120
TX: LEN=3D  160 SKB=3Ddfb2da80 HEAD=3Dd9889030        # (1) urb submiss=
ion, SKB=3Ddfb2da80
TX: DONE=20
TX: LEN=3D  168 SKB=3Dce1388c0 HEAD=3Dd9888000
RXCB: LEN=3D   36 SKB=3Dce138d20 HEAD=3Dd98140c0      # (2) this eventu=
ally calls p54_rx_frame_sent() and skb_kfree on SKB=3Ddfb2da80
TXCB: LEN=3D1802201963 SKB=3Ddfb2da80 HEAD=3D6b6b6b6b # (3) p54u_tx_cb(=
) was called with the now freed and poisoned SKB=3Ddfb2da80
------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:1073!      # BUG() in skb_pull(), =
see stacktrace below, after the SLUB error
invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1.1/ue=
vent
Modules linked in: p54usb p54common<3>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG skbuff_head_cache: Poison overwritten
-----------------------------------------------------------------------=
------

INFO: 0xdfb2dad0-0xdfb2dad0. First byte 0x5b instead of 0x6b           =
 # 0x10 is the amount that was pulled (net2280 rx header)
INFO: Allocated in __alloc_skb+0x34/0x110 age=3D28 cpu=3D0 pid=3D0
INFO: Freed in p54_rx+0x760/0x770 [p54common] age=3D0 cpu=3D0 pid=3D0  =
       # p54_rx+0x760/0x770 is the skb_free in p54_rx_frame_sent() (gcc=
 decided to inline it)
INFO: Slab 0xc13f65a0 objects=3D18 used=3D16 fp=3D0xdfb2da80 flags=3D0x=
400000c2
INFO: Object 0xdfb2da80 @offset=3D2688 fp=3D0xdfb2dee0                 =
     # the freed skb

Bytes b4 0xdfb2da70:  00 00 00 00 0f 23 00 00 ba e7 1b 02 5a 5a 5a 5a .=
=2E...#..=C2=BA=C3=A7..ZZZZ
  Object 0xdfb2da80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2da90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2daa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2dab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2dac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2dad0:  5b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b [=
kkkkkkkkkkkkkkk
  Object 0xdfb2dae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2daf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2db00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2db10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2db20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdfb2db30:  6b 6b 6b a5                                     k=
kk=C2=A5           =20
 Redzone 0xdfb2db34:  bb bb bb bb                                     =C2=
=BB=C2=BB=C2=BB=C2=BB           =20
 Padding 0xdfb2db5c:  5a 5a 5a 5a                                     Z=
ZZZ           =20
Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc1-00222-g27956bf-di=
rty #69
Call Trace:
 [<c016cf1e>] check_bytes_and_report+0xce/0xf0
 [<c016d177>] check_object+0x1e7/0x230
 [<c016e915>] __slab_alloc+0x245/0x4f0
 [<c03afe04>] __alloc_skb+0x34/0x110
 [<c016f0eb>] kmem_cache_alloc+0xbb/0xc0
 [<c03afe04>] __alloc_skb+0x34/0x110
 [<c03afe04>] __alloc_skb+0x34/0x110
 [<c03c5695>] find_skb+0x35/0x90
 [<c03c58ae>] netpoll_send_udp+0x2e/0x200
 [<e31371ad>] write_msg+0x9d/0xe0 [netconsole]
 [<e3137110>] write_msg+0x0/0xe0 [netconsole]
 [<c0122533>] __call_console_drivers+0x43/0x50
 [<c01228f7>] release_console_sem+0x87/0x1c0
 [<c0122ec7>] vprintk+0x227/0x2d0
 [<e3137110>] write_msg+0x0/0xe0 [netconsole]
 [<c04dcb00>] printk+0x17/0x1f
 [<c0142ea4>] print_modules+0x74/0xb0
 [<c01051ba>] show_registers+0x1a/0x200
 [<c0138647>] atomic_notifier_call_chain+0x17/0x20
 [<c0138740>] notify_die+0x30/0x40
 [<c0105df6>] __die+0xa6/0x100
 [<c0106070>] die+0x40/0x80
 [<c0103f60>] do_invalid_op+0x0/0xa0
 [<c0103fe1>] do_invalid_op+0x81/0xa0
 [<c03aced8>] skb_pull+0x18/0x40
 [<e3137110>] write_msg+0x0/0xe0 [netconsole]
 [<c0122533>] __call_console_drivers+0x43/0x50
 [<c013ad72>] update_wall_time+0x492/0x8e0
 [<c04de722>] error_code+0x6a/0x70
 [<c016007b>] sys_mincore+0x26b/0x350
 [<c03aced8>] skb_pull+0x18/0x40
 [<e1f1d815>] p54u_tx_cb+0x95/0x120 [p54usb]
 [<c0341489>] usb_hcd_giveback_urb+0x49/0xe0
 [<c034fe4f>] uhci_giveback_urb+0x5f/0x1f0
 [<c034fe6f>] uhci_giveback_urb+0x7f/0x1f0
 [<c035043f>] uhci_scan_schedule+0x33f/0xa40
 [<c035278d>] uhci_irq+0x7d/0x140
 [<c0341125>] usb_hcd_irq+0x25/0x60
 [<c0146de8>] handle_IRQ_event+0x28/0x50
 [<c0148000>] handle_level_irq+0x0/0xb0
 [<c014804b>] handle_level_irq+0x4b/0xb0
 <IRQ>  [<c0103707>] common_interrupt+0x27/0x2c
 [<c0122dbc>] vprintk+0x11c/0x2d0
 [<c034301f>] usb_alloc_urb+0xf/0x30
 [<c034301f>] usb_alloc_urb+0xf/0x30
 [<c04dcb00>] printk+0x17/0x1f
 [<e1f1d212>] p54u_tx_net2280+0x52/0x320 [p54usb]
 [<e1d4845d>] p54_tx+0x51d/0x820 [p54common]
 [<c04ca789>] __ieee80211_tx+0x49/0x130
 [<c04cb61d>] ieee80211_master_start_xmit+0x28d/0x610
 [<c0137401>] __run_hrtimer+0x31/0xf0
 [<c013e894>] tick_program_event+0x14/0x20
 [<c013b311>] getnstimeofday+0x51/0x120
 [<c03b702b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c883b>] __qdisc_run+0x1ab/0x200
 [<c03b4dd1>] net_tx_action+0x81/0xb0
 [<c0126f07>] __do_softirq+0x57/0xf0
 [<c0126eb0>] __do_softirq+0x0/0xf0
 <IRQ>  [<c0137c38>] ktime_get+0x18/0x40
 [<c0148000>] handle_level_irq+0x0/0xb0
 [<c0126c65>] irq_exit+0x55/0x70
 [<c0104f1b>] do_IRQ+0x9b/0x120
 [<c0103707>] common_interrupt+0x27/0x2c
 [<c0108392>] default_idle+0x42/0x50
 [<c0102139>] cpu_idle+0x39/0x80
=46IX skbuff_head_cache: Restoring 0xdfb2dad0-0xdfb2dad0=3D0x6b

=46IX skbuff_head_cache: Marking all objects used
 netconsole budget saa7134_empress saa6752hs saa7134 serio_raw budget_c=
i videobuf_dma_sg budget_core saa7146 ttpci_eeprom videobuf_core tveepr=
om ir_common [last unloaded: p54common]

Pid: 0, comm: swapper Tainted: G        W  (2.6.29-rc1-00222-g27956bf-d=
irty #69)   =20
EIP: 0060:[<c03aced8>] EFLAGS: 00010087 CPU: 0
EIP is at skb_pull+0x18/0x40
EAX: 6b6b6b5b EBX: 6b6b6b6b ECX: dfb2da80 EDX: 00000010
ESI: dfb2da80 EDI: d744bdd0 EBP: d744b1f0 ESP: c0690ef0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=3Dc0690000 task=3Dc05fc300 task.ti=3Dc06460=
00)
Stack:
 d980a370 e1f1d815 e1f1f440 6b6b6b6b dfb2da80 6b6b6b6b d744bf74 0000008=
6
 d980a370 00000000 df9fb180 d980a370 c0341489 c034fe4f 00000046 df965de=
0
 df9fb180 df994900 dfa46a68 c034fe6f df9948bc df99491c 00a464d8 df9fb24=
c
Call Trace:
 [<e1f1d815>] p54u_tx_cb+0x95/0x120 [p54usb]                           =
    # this is the skb_pull in p54u_tx_cb
 [<c0341489>] usb_hcd_giveback_urb+0x49/0xe0
 [<c034fe4f>] uhci_giveback_urb+0x5f/0x1f0
 [<c034fe6f>] uhci_giveback_urb+0x7f/0x1f0
 [<c035043f>] uhci_scan_schedule+0x33f/0xa40
 [<c035278d>] uhci_irq+0x7d/0x140
 [<c0341125>] usb_hcd_irq+0x25/0x60
 [<c0146de8>] handle_IRQ_event+0x28/0x50
 [<c0148000>] handle_level_irq+0x0/0xb0
 [<c014804b>] handle_level_irq+0x4b/0xb0
 <IRQ> <0> [<c0103707>] common_interrupt+0x27/0x2c
 [<c0122dbc>] vprintk+0x11c/0x2d0
 [<c034301f>] usb_alloc_urb+0xf/0x30
 [<c034301f>] usb_alloc_urb+0xf/0x30
 [<c04dcb00>] printk+0x17/0x1f
 [<e1f1d212>] p54u_tx_net2280+0x52/0x320 [p54usb]
 [<e1d4845d>] p54_tx+0x51d/0x820 [p54common]
 [<c04ca789>] __ieee80211_tx+0x49/0x130
 [<c04cb61d>] ieee80211_master_start_xmit+0x28d/0x610
 [<c0137401>] __run_hrtimer+0x31/0xf0
 [<c013e894>] tick_program_event+0x14/0x20
 [<c013b311>] getnstimeofday+0x51/0x120
 [<c03b702b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c883b>] __qdisc_run+0x1ab/0x200
 [<c03b4dd1>] net_tx_action+0x81/0xb0
 [<c0126f07>] __do_softirq+0x57/0xf0
 [<c0126eb0>] __do_softirq+0x0/0xf0
 <IRQ> <0> [<c0137c38>] ktime_get+0x18/0x40
 [<c0148000>] handle_level_irq+0x0/0xb0
 [<c0126c65>] irq_exit+0x55/0x70
 [<c0104f1b>] do_IRQ+0x9b/0x120
 [<c0103707>] common_interrupt+0x27/0x2c
 [<c0108392>] default_idle+0x42/0x50
 [<c0102139>] cpu_idle+0x39/0x80
Code: 83 c4 0c c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 53 89 c1=
 8b 58 50 31 c0 39 d3 72 24 89 d8 29 d0 3b 41 54 89 41 50 73 08 <0f> 0b=
 eb fe 8d 74 26 00 8b 99 a8 00 00 00 89 d0 01 d8 89 81 a8=20
EIP: [<c03aced8>] skb_pull+0x18/0x40 SS:ESP 0068:c0690ef0
---[ end trace bba3fc5c928ed0e0 ]---
Kernel panic - not syncing: Fatal exception in interrupt



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

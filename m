Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:46896 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1JTEeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 00:34:01 -0400
Date: Thu, 20 Oct 2011 13:33:30 +0900 (JST)
Message-Id: <20111020.133330.1806352362145479789.teika@lavabit.com> (sfid-20111020_063405_738370_AA7B2A7E)
To: linux-wireless@vger.kernel.org
Subject: My unsupported Buffalo's WLI-UC-GNHP almost works with rt2800usb
 in 3.0.4.
From: Teika Kazura <teika@lavabit.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Oct_20_13_33_30_2011_839)--"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

----Next_Part(Thu_Oct_20_13_33_30_2011_839)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, linux-wireless list.

My WiFi usb stick[1] is not registered in rt2800usb.c of kernel 3.0.4,
but I here report that it works fairly well. There's also problems
stated later.

I'm not sure if you welcome this kind of report. If not, sorry, and
I wonder if you could write so at linux-wireless website.

[1] 
Vendor: Buffalo
Model: WLI-UC-GNHP
id: 0x0411, 0x0158

At least I can stably connect to an AP. When the module detects the
device, dmesg says:

  phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 3070, rf: 0005, rev: 0201.

Both patching the source and using sysfs "new_id" file [2] work.
(OTOH with the linux 2.6.39.3, new_id doesn't work[3], while patching
 makes the driver support it.)

[2] echo "411 158" > /sys/bus/usb/drivers/rt2800usb/new_id 
[3] Once, the kernel hanged immediately after touching "new_id"
file. Another try resulted in stack trace, and modprobe -r rt2800usb
never terminated, although the kernel itself continued running.

Next let's see the problems:

1.
Sometimes, not always, the PC hangs, showing stack trace (thrown to
VT12) when you unplug the device. Sometimes only stack trace is shown
in dmesg, and kernel continues running.

I've attached a stack trace at the end of this message.

2.
It's not really a problem for me, but warnings flood dmesg, like this:

  phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5

The last number changes each time. It's only when the card is
connected to an AP.

If there's something I can do, please ask me. I'm subscribing this ML.
I've also tried compat-wireless-3.1-rc8-1, but it is quite unstable,
breaking at many stages. I'm not sure if I can keep up with changes in
RC based versions.

Thanks a lot for developing wireless drivers.
Teika (Teika kazura)

----Next_Part(Thu_Oct_20_13_33_30_2011_839)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="stack.txt"

usb 1-1: USB disconnect, device number 3
BUG: unable to handle kernel paging request at ffff8800623c9428
IP: [<ffffffff8133486f>] usb_disconnect+0xcf/0x130
PGD 164c063 PUD 57fac067 PMD 0 
Oops: 0002 [#1] 
CPU 0 
Modules linked in: radeon ttm drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last unloaded: rt2x00lib]

Pid: 365, comm: khubd Not tainted 3.0.4 #1 Hewlett-Packard HP Compaq 6715s (RK219AV)/30C2
RIP: 0010:[<ffffffff8133486f>]  [<ffffffff8133486f>] usb_disconnect+0xcf/0x130
RSP: 0018:ffff880057b6fd30  EFLAGS: 00010206
RAX: 0000000054c82000 RBX: ffff880054c83000 RCX: ffff880054c830a0
RDX: ffff880057a39000 RSI: ffffffff8123e490 RDI: ffff88005508f8d0
RBP: ffff880054c83088 R08: ffff8800578029c0 R09: ffffffff8123f3a9
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88005508fc20
R13: ffff880057a39000 R14: ffff880054c830e8 R15: 000000000000001f
FS:  00007fd52b96c700(0000) GS:ffffffff8165b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8800623c9428 CR3: 0000000055594000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 365, threadinfo ffff880057b6e000, task ffff88005796a6f0)
Stack:
0000000000000000 000000005508f800 0000000000000001 ffff88005506d400
0000000000000001 0000000000000100 0000000000000000 ffff88005508f800
0000000000000000 ffffffff813359f3 ffff88005796a728 ffff88005796a940
Call Trace:
[<ffffffff813359f3>] ? hub_thread+0x673/0x12e0
[<ffffffff81047680>] ? wake_up_bit+0x40/0x40
[<ffffffff81335380>] ? hub_probe+0x850/0x850
[<ffffffff810472a6>] ? kthread+0x96/0xa0
[<ffffffff814c4994>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81047210>] ? kthreadd+0xd0/0xd0
[<ffffffff814c4990>] ? gs_change+0xb/0xb
Code: 48 89 df e8 c4 21 00 00 48 8d 7b 48 e8 9b be 00 00 4c 89 f7 e8 b3 df 18 00 48 89 ef e8 cb f2 fa ff 8b 03 85 c0 7e 0e 48 8b 53 40 <0f> b3 42 28 c7 03 ff ff ff ff fa 49 c7 04 24 00 00 00 00 fb 48 
RIP  [<ffffffff8133486f>] usb_disconnect+0xcf/0x130
RSP <ffff880057b6fd30>
CR2: ffff8800623c9428
---[ end trace 4d74f468484de6cd ]---

----Next_Part(Thu_Oct_20_13_33_30_2011_839)----


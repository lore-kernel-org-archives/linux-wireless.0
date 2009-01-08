Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:62228 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZAHA7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 19:59:04 -0500
Received: by bwz10 with SMTP id 10so6403611bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 16:59:00 -0800 (PST)
Message-ID: <45e8e6c40901071658j6a22fcc7gedcc41d73a61ff2a@mail.gmail.com> (sfid-20090108_015911_831675_14261A9C)
Date: Wed, 7 Jan 2009 16:58:59 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: libertas: BUG: unable to handle paging request
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.  I noticed that the libertas driver causes a kernel oops in
more recent wireless-testing kernels (I am bisecting right now to
narrow this down).  To reproduce, load the driver and run iwconfig,
causing lbs_get_freq() to be called.

So far I know that this problem doesn't exist at the 2.6.28-rc2 tag
(commit 0173a3265b228da319ceb9c1ec6a5682fd1b2d92)  but I have seen it
in -rc7 and up through today's wireless-testing.  It seems that
there's a regression somewhere after -rc2.  I've reproduced this with
the USB hardware as well as an SDIO board.

[  118.571205] BUG: unable to handle kernel paging request at 00001e01
[  118.578500] IP: [<c81fddda>] lbs_get_freq+0x1a/0x160 [libertas]
[  118.585417] *pde = 00000000
[  118.588877] Oops: 0000 [#1]
[  118.592092] last sysfs file: /sys/block/ram9/range
[  118.592385] Modules linked in: usb8xxx libertas lib80211
[  118.592385]
[  118.592385] Pid: 2317, comm: iwconfig Not tainted (2.6.28-wl #65) Uknown
[  118.592385] EIP: 0060:[<c81fddda>] EFLAGS: 00010293 CPU: 0
[  118.592385] EIP is at lbs_get_freq+0x1a/0x160 [libertas]
[  118.592385] EAX: 00000000 EBX: 00000000 ECX: c6891ef8 EDX: c6891e98
[  118.592385] ESI: c6891ef8 EDI: c6891ef8 EBP: c7295000 ESP: c6891e10
[  118.592385]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  118.592385] Process iwconfig (pid: 2317, ti=c6890000 task=c7349880
task.ti=c6890000)
[  118.592385] Stack:
[  118.592385]  c8201b4b c6891ef8 00000010 ffffffa1 00008b05 c038aa20
00000000 c03c691c
[  118.592385]  00000000 c04bc7e0 c0301287 b7f01d70 c68ce000 c6895000
c04c8260 00000c04
[  118.592385]  c68c7b7c 00000000 c7295000 c6891ee8 c0300325 c6891ee8
c7295000 c6891ee8
[  118.592385] Call Trace:
[  118.592385]  [<c8201b4b>] lbs_get_name+0x2b/0xb0 [libertas]
[  118.592385]  [<c038aa20>] ioctl_standard_call+0x60/0x3a0
[  118.592385]  [<c0301287>] netif_receive_skb+0x1d7/0x3e0
[  118.592385]  [<c0300325>] __dev_get_by_name+0x75/0x90
[  118.592385]  [<c0300325>] __dev_get_by_name+0x75/0x90
[  118.592385]  [<c038a687>] wext_handle_ioctl+0x157/0x230
[  118.592385]  [<c81fddc0>] lbs_get_freq+0x0/0x160 [libertas]
[  118.592385]  [<c03034c4>] dev_ioctl+0x304/0x4f0
[  118.592385]  [<c02ffdd2>] net_rx_action+0x92/0x140
[  118.592385]  [<c027ca89>] pty_write+0x39/0x60
[  118.592385]  [<c02f4280>] sock_ioctl+0x0/0x260
[  118.592385]  [<c017e27f>] vfs_ioctl+0x1f/0x70
[  118.592385]  [<c017e65b>] do_vfs_ioctl+0x24b/0x490
[  118.592385]  [<c011654e>] update_curr+0x13e/0x190
[  118.592385]  [<c0117fab>] set_next_entity+0x2b/0x70
[  118.592385]  [<c0397c64>] schedule+0x1b4/0x350
[  118.592385]  [<c017e906>] sys_ioctl+0x66/0x70
[  118.592385]  [<c0103cd2>] syscall_call+0x7/0xb
[  118.592385] Code: e9 38 ff ff ff 8d b6 00 00 00 00 8d bf 00 00 00
00 56 89 ce 53 83 ec 0c 8b 98 a4 01 00 00 a1 80 19 22 c8 83 e0 21 83
f8 21 74 42 <0f> b6 8b 01 1e 00 00 31 d2 89 d8 e8 a6 fe ff ff 85 c0 0f
84 cd
[  118.592385] EIP: [<c81fddda>] lbs_get_freq+0x1a/0x160 [libertas]
SS:ESP 0068:c6891e10
[  118.594153] ---[ end trace f426cd49b2b378f4 ]---

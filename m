Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45023 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965391AbeE2SCH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 14:02:07 -0400
Received: by mail-lf0-f68.google.com with SMTP id g25-v6so133587lfb.11
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2018 11:02:06 -0700 (PDT)
MIME-Version: 1.0
From: shankarapailoor <shankarapailoor@gmail.com>
Date: Tue, 29 May 2018 11:02:05 -0700
Message-ID: <CAB+yDaYDNEZJCNpu1gOyvvKwmvy-AFc3Ox=E=FNJMioFOMHoyw@mail.gmail.com> (sfid-20180529_200415_504551_6FD0BC83)
Subject: General Protection Fault in klist_iter_exit.c
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was fuzzing Linux 4.17-rc4 and encountered the following GPF bug:

CPU: 0 PID: 36 Comm: kworker/0:1 Not tainted 4.17.0-rc4+ #1Hardware
name: Google Google Compute Engine/Google Compute Engine, BIOS Google
01/01/2011Workqueue: events netlink_sock_destruct_workRIP:
0010:klist_iter_exit+0x26/0x90 lib/klist.c:314RSP:
0018:ffff880103f57c30 EFLAGS: 00010202RAX: dffffc0000000000 RBX:
0000000000000000 RCX: ffffffff8490f6d5RDX: 0000000000000001 RSI:
0000000000000008 RDI: 0000000000000000RBP: ffff880103f57c48 R08:
fffffbfff0c133d9 R09: 0000000000000001R10: ffff880103f57c78 R11:
ffffffff86099ec7 R12: 0000000000000008R13: ffffffff854a2ba0 R14:
0000000000000000 R15: ffff880103ec9400FS: 0000000000000000(0000)
GS:ffff880104e00000(0000) knlGS:0000000000000000CS: 0010 DS: 0000 ES:
0000 CR0: 0000000080050033CR2: 000000002031d000 CR3: 0000000005a22003
CR4: 00000000001606f0DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000600Call Trace: class_dev_iter_exit+0x15/0x20
drivers/base/class.c:323 nfc_device_iter_exit net/nfc/nfc.h:133
[inline] nfc_genl_dump_devices_done+0x34/0x50 net/nfc/netlink.c:666
genl_lock_done+0x89/0xd0 net/netlink/genetlink.c:493
netlink_sock_destruct+0x98/0x2a0 net/netlink/af_netlink.c:397
__sk_destruct+0x53/0x5e0 net/core/sock.c:1566 sk_destruct+0x47/0x80
net/core/sock.c:1601 __sk_free+0xf1/0x2b0 net/core/sock.c:1612
sk_free+0x2a/0x40 net/core/sock.c:1623
netlink_sock_destruct_work+0x19/0x20 net/netlink/af_netlink.c:419
process_one_work+0x827/0x1550 kernel/workqueue.c:2145
worker_thread+0xd2/0xcc0 kernel/workqueue.c:2279 kthread+0x33c/0x400
kernel/kthread.c:238 ret_from_fork+0x3a/0x50
arch/x86/entry/entry_64.S:412Code: 5d c3 0f 1f 00 55 48 89 e5 41 55 41
54 53 48 89 fb 4c 8d 63 08 e8 4b 62 cf fc 4c 89 e2 48 b8 00 00 00 00
00 fc ff df 48 c1 ea 03 <80> 3c 02 00 75 43 4c 8b 6b 08 4d 85 ed 74 2e
e8 26 62 cf fc 31 RIP: klist_iter_exit+0x26/0x90 lib/klist.c:314 RSP:
ffff880103f57c30---[ end trace 69831a3bb9e34eca ]---Kernel panic - not
syncing: Fatal exceptionDumping ftrace buffer: (ftrace buffer
empty)Kernel Offset: disabledRebooting in 86400 seconds..

This bug happened twice in a 24 hour fuzzing campaign but I was unable
to find a reproducer.
-- 
Regards,
Shankara Pailoor

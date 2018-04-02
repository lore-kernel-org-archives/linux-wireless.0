Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f199.google.com ([209.85.223.199]:35537 "EHLO
        mail-io0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbeDBGBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Apr 2018 02:01:04 -0400
Received: by mail-io0-f199.google.com with SMTP id h132so9802231ioe.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2018 23:01:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 01 Apr 2018 23:01:03 -0700
Message-ID: <000000000000a010b80568d75018@google.com> (sfid-20180402_080139_221496_EEEB068D)
Subject: WARNING in add_uevent_var
From: syzbot <syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com>
To: davem@davemloft.net, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

syzbot hit the following crash on upstream commit
10b84daddbec72c6b440216a69de9a9605127f7a (Sat Mar 31 17:59:00 2018 +0000)
Merge branch 'perf-urgent-for-linus' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
syzbot dashboard link:  
https://syzkaller.appspot.com/bug?extid=230d9e642a85d3fec29c

So far this crash happened 5 times on net-next, upstream.
C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6614377067184128
syzkaller reproducer:  
https://syzkaller.appspot.com/x/repro.syz?id=6535492073947136
Raw console output:  
https://syzkaller.appspot.com/x/log.txt?id=6339348970602496
Kernel config:  
https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
compiler: gcc (GCC) 7.1.1 20170620

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for  
details.
If you forward the report, please keep this part and the footer.

------------[ cut here ]------------
add_uevent_var: buffer size too small
WARNING: CPU: 0 PID: 4431 at lib/kobject_uevent.c:594  
add_uevent_var+0x2aa/0x2d0 lib/kobject_uevent.c:594
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 4431 Comm: syzkaller678536 Not tainted 4.16.0-rc7+ #374
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
  panic+0x1e4/0x41c kernel/panic.c:183
  __warn+0x1dc/0x200 kernel/panic.c:547
  report_bug+0x1f4/0x2b0 lib/bug.c:186
  fixup_bug.part.10+0x37/0x80 arch/x86/kernel/traps.c:178
  fixup_bug arch/x86/kernel/traps.c:247 [inline]
  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
RIP: 0010:add_uevent_var+0x2aa/0x2d0 lib/kobject_uevent.c:594
RSP: 0018:ffff8801adba6810 EFLAGS: 00010286
RAX: dffffc0000000008 RBX: ffff8801ad7a6d40 RCX: ffffffff815b193e
RDX: 0000000000000000 RSI: 1ffff10035b74cb2 RDI: 1ffff10035b74c87
RBP: ffff8801adba68d8 R08: 1ffff10035b74c49 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: 1ffff10035b74d03
R13: ffff8801ad7a6e58 R14: 00000000000003e6 R15: 0000000000000438
  rfkill_dev_uevent+0x31/0x170 net/rfkill/core.c:813
  dev_uevent+0x2b6/0x7e0 drivers/base/core.c:913
  kobject_uevent_env+0x3fe/0xd30 lib/kobject_uevent.c:476
  kobject_uevent+0x1f/0x30 lib/kobject_uevent.c:565
  device_add+0xd04/0x1650 drivers/base/core.c:1834
  rfkill_register+0x254/0xd60 net/rfkill/core.c:1019
  wiphy_register+0x19d1/0x2050 net/wireless/core.c:872
  ieee80211_register_hw+0x1162/0x3100 net/mac80211/main.c:1041
  mac80211_hwsim_new_radio+0x1d06/0x2fb0  
drivers/net/wireless/mac80211_hwsim.c:2757
  hwsim_new_radio_nl+0x67a/0x8c0 drivers/net/wireless/mac80211_hwsim.c:3214
  genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
  genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624
  netlink_rcv_skb+0x14b/0x380 net/netlink/af_netlink.c:2447
  genl_rcv+0x28/0x40 net/netlink/genetlink.c:635
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x4c4/0x6b0 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0xa4a/0xe60 net/netlink/af_netlink.c:1900
  sock_sendmsg_nosec net/socket.c:630 [inline]
  sock_sendmsg+0xca/0x110 net/socket.c:640
  ___sys_sendmsg+0x767/0x8b0 net/socket.c:2046
  __sys_sendmsg+0xe5/0x210 net/socket.c:2080
  SYSC_sendmsg net/socket.c:2091 [inline]
  SyS_sendmsg+0x2d/0x50 net/socket.c:2087
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x43fda9
RSP: 002b:00007ffde548edb8 EFLAGS: 00000213 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fda9
RDX: 0000000000000000 RSI: 0000000020b3dfc8 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000213 R12: 00000000004016d0
R13: 0000000000401760 R14: 0000000000000000 R15: 0000000000000000
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.

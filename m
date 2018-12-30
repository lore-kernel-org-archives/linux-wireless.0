Return-Path: <SRS0=Iw3I=PH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF429C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 03:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC1EE21019
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 03:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbeL3DlE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Dec 2018 22:41:04 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:38863 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbeL3DlE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Dec 2018 22:41:04 -0500
Received: by mail-io1-f70.google.com with SMTP id q18so8187333ioj.5
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2018 19:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cDxP990uHMGkalxhsJspzFhheNpjaTLD2b03JnGVTAg=;
        b=cDgfu7km/tNYGwaJmVm35vgo4BS7+y2aaO2I3fHaP6XeHJ+PPeIDLet2sx5JqcV0Sx
         qDnSMi3QYF8/VHosG54nD60oJdYQwrWXg3U5Zd7+zsJCgCmZiOewLtzXzu48AJ1Q+tPd
         yGv8T7mKs/gPJqCsDgps183+OJFCoI70FbmmFClSOpWZj8laIdptVpsullyhh7x3BO70
         TspW3w6czX2ah+9ph4aAl+1gcEiLJsiMJv3ynZXcFWmgI7nnbQUTiEXFoPM26WWXrU3H
         MvckeJg87X5N7RxpDdPO/5DeBKidy/3nS4TtJlLhgMFOEQpfia5ZwHouQuZ6CKZuIEJB
         F5wA==
X-Gm-Message-State: AJcUukc4cX66oKYxwUDgHpEi/HvkdIv1waGoNyEzRlr7KGbQeibXrmKw
        fZMt6++EfOuot7QoMzbctaYOUXXGjhBF8aPKUIh7uC84FEWF
X-Google-Smtp-Source: ALg8bN6fBXQHiZ/PxN77M1FzRkyo10NeZAh2O8eqi85L89NUGSrGHIm/1f9I6B+Ki//J89f0XwrkMxpPPnOWP+g5PiY6a8FV0ywY
MIME-Version: 1.0
X-Received: by 2002:a6b:5a02:: with SMTP id o2mr31637855iob.17.1546141262990;
 Sat, 29 Dec 2018 19:41:02 -0800 (PST)
Date:   Sat, 29 Dec 2018 19:41:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0d438057e35101e@google.com>
Subject: WARNING in wiphy_register (3)
From:   syzbot <syzbot+73fd8b0aa60c67fa4b60@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    90cadbbf341d Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17053c9b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d41c8529d7e7362
dashboard link: https://syzkaller.appspot.com/bug?extid=73fd8b0aa60c67fa4b60
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17211a57400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+73fd8b0aa60c67fa4b60@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
8021q: adding VLAN 0 to HW filter on device team0
8021q: adding VLAN 0 to HW filter on device team0
8021q: adding VLAN 0 to HW filter on device team0
netlink: 'syz-executor4': attribute type 23 has an invalid length.
WARNING: CPU: 0 PID: 9553 at net/wireless/core.c:581  
wiphy_verify_combinations net/wireless/core.c:581 [inline]
WARNING: CPU: 0 PID: 9553 at net/wireless/core.c:581  
wiphy_register+0x147e/0x28d0 net/wireless/core.c:784
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9553 Comm: syz-executor4 Not tainted 4.20.0-rc7+ #360
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d3/0x2c6 lib/dump_stack.c:113
  panic+0x2ad/0x55c kernel/panic.c:188
  __warn.cold.8+0x20/0x45 kernel/panic.c:540
  report_bug+0x254/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:wiphy_verify_combinations net/wireless/core.c:581 [inline]
RIP: 0010:wiphy_register+0x147e/0x28d0 net/wireless/core.c:784
Code: f0 ff ff e8 74 30 2b fa 0f 0b bb ea ff ff ff e9 10 f0 ff ff e8 63 30  
2b fa 0f 0b bb ea ff ff ff e9 ff ef ff ff e8 52 30 2b fa <0f> 0b bb ea ff  
ff ff e9 ee ef ff ff e8 41 30 2b fa 0f 0b bb ea ff
kobject: 'loop1' (00000000a0078c7e): kobject_uevent_env
RSP: 0018:ffff8881d798edb0 EFLAGS: 00010293
RAX: ffff8881cd55e040 RBX: 0000000000000001 RCX: ffffffff8753236b
RDX: 0000000000000000 RSI: ffffffff8753292e RDI: 0000000000000001
RBP: ffff8881d798ef38 R08: ffff8881cd55e040 R09: ffffed103a4a0680
R10: ffffed103a4a0680 R11: ffff8881d2503405 R12: 000000000000002f
R13: ffffffff88f0ba60 R14: ffff8881d2505e74 R15: 0000000000000000
kobject: 'loop1' (00000000a0078c7e): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
  ieee80211_register_hw+0x15cd/0x40e0 net/mac80211/main.c:1109
  mac80211_hwsim_new_radio+0x2025/0x3630  
drivers/net/wireless/mac80211_hwsim.c:2921
kobject: 'loop5' (000000003dbebf8f): kobject_uevent_env
kobject: 'loop5' (000000003dbebf8f): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
  hwsim_new_radio_nl+0xd3a/0x14b0 drivers/net/wireless/mac80211_hwsim.c:3469
  genl_family_rcv_msg+0x8a7/0x11a0 net/netlink/genetlink.c:601
  genl_rcv_msg+0xc6/0x168 net/netlink/genetlink.c:626
  netlink_rcv_skb+0x16c/0x430 net/netlink/af_netlink.c:2477
  genl_rcv+0x28/0x40 net/netlink/genetlink.c:637
  netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
  netlink_unicast+0x59f/0x750 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0xa18/0xfc0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:621 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:631
  ___sys_sendmsg+0x7fd/0x930 net/socket.c:2116
  __sys_sendmsg+0x11d/0x280 net/socket.c:2154
  __do_sys_sendmsg net/socket.c:2163 [inline]
  __se_sys_sendmsg net/socket.c:2161 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2161
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457759
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3a2a64fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457759
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3a2a6506d4
R13: 00000000004c49c9 R14: 00000000004d80a0 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

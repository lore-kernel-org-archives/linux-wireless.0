Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB563C282C6
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F582184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfAXSXE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:23:04 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39683 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfAXSXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:23:04 -0500
Received: by mail-io1-f69.google.com with SMTP id q23so5394145ior.6
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 10:23:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MkjuG0Ckg9P9f+qdSlSIbB3enlHQkanR0iPGk6sH5LU=;
        b=LBADbOKQIIXBNUJnF9BL4U04icZqaAwMtj0+5LIg+US9+uQVRia27PsU9kgGOyFkHU
         8QgHOmeEcUrmvXJ1kimcguMWfApA073DJ3bNrtijNgaGZdn1KPvLRtC93b8Gk6XutiX8
         u3pBCgJujAw+oS5nk9g1iWY2EwJo1L6KmH7Z8th25TzB9DBBxQKHJBGhv4TZqB4NRPaS
         nDlAjyZOXHyXxyQ9pYVWoBc7/FH2MII/vuK7TA+iXolqGxoQdgMnw3UHnAFJ7Tj2mgqk
         +mmGTrc/tSn1YqFh9vGU3aDzAsR4jeDYjtECB+IC0GyPHJ8+Mk8fE23ijLIjOKA8XtZR
         OVYQ==
X-Gm-Message-State: AHQUAuZCxYr3cylgutv/DRLGzpIxzHyCclM4h0hxIy40gj44Yz8SyZ7Y
        1Je2N1BqZAxHYv6Tt6+bwV3ZiM3lyPUPtcKPNCKnxzkusqrP
X-Google-Smtp-Source: ALg8bN5VZrAvbc3vq+QUB9+euZAOrSOlZh1pUr1jLeMKAxSl4eJYJFw7JmasVhLpg9/NONiYaAUwZzJhpfCJUO7+WMh5oGEMKu2Y
MIME-Version: 1.0
X-Received: by 2002:a6b:f815:: with SMTP id o21mr6344201ioh.16.1548354183143;
 Thu, 24 Jan 2019 10:23:03 -0800 (PST)
Date:   Thu, 24 Jan 2019 10:23:03 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012a69a0580384d50@google.com>
Subject: KASAN: global-out-of-bounds Read in validate_nla
From:   syzbot <syzbot+4157b036c5f4713b1f2f@syzkaller.appspotmail.com>
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

HEAD commit:    30bac164aca7 Revert "Change mincore() to count "mapped" pa..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b824c0c00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=505743eba4e4f68
dashboard link: https://syzkaller.appspot.com/bug?extid=4157b036c5f4713b1f2f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1137adcf400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16431b18c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4157b036c5f4713b1f2f@syzkaller.appspotmail.com

audit: type=1800 audit(1548293866.971:30): pid=7616 uid=0 auid=4294967295  
ses=4294967295 subj==unconfined op=collect_data cause=failed(directio)  
comm="startpar" name="rmnologin" dev="sda1" ino=2423 res=0
==================================================================
BUG: KASAN: global-out-of-bounds in validate_nla+0x12c4/0x1580  
lib/nlattr.c:169
Read of size 1 at addr ffffffff88f41fc0 by task syz-executor771/7789

CPU: 1 PID: 7789 Comm: syz-executor771 Not tainted 5.0.0-rc3+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1db/0x2d0 lib/dump_stack.c:113
  print_address_description.cold+0x5/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  validate_nla+0x12c4/0x1580 lib/nlattr.c:169
  nla_validate+0xc1/0x130 lib/nlattr.c:340
  validate_nla+0x711/0x1580 lib/nlattr.c:247
  __nla_parse+0x206/0x340 lib/nlattr.c:415
  nla_parse+0x45/0x60 lib/nlattr.c:439
  nlmsg_parse include/net/netlink.h:527 [inline]
  nl80211_dump_wiphy_parse.isra.0.constprop.0+0x133/0x610  
net/wireless/nl80211.c:2299
  nl80211_dump_wiphy+0x595/0x760 net/wireless/nl80211.c:2342
  genl_lock_dumpit+0x6d/0xa0 net/netlink/genetlink.c:481
  netlink_dump+0x5f2/0x1070 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x5b4/0x7e0 net/netlink/af_netlink.c:2352
  genl_family_rcv_msg+0xeb5/0x11a0 net/netlink/genetlink.c:549
  genl_rcv_msg+0xca/0x16c net/netlink/genetlink.c:626
  netlink_rcv_skb+0x17d/0x410 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:637
  netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
  netlink_unicast+0x574/0x770 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0xa05/0xf90 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:621 [inline]
  sock_sendmsg+0xdd/0x130 net/socket.c:631
  ___sys_sendmsg+0x7ec/0x910 net/socket.c:2116
  __sys_sendmsg+0x112/0x270 net/socket.c:2154
  __do_sys_sendmsg net/socket.c:2163 [inline]
  __se_sys_sendmsg net/socket.c:2161 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2161
  do_syscall_64+0x1a3/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4400d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd4f4bf478 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004400d9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000006 R09: 00000000004002c8
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000401960
R13: 00000000004019f0 R14: 0000000000000000 R15: 0000000000000000

The buggy address belongs to the variable:
  nl80211_pmsr_attr_policy+0x60/0x80

Memory state around the buggy address:
  ffffffff88f41e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffffff88f41f00: 00 00 00 00 00 00 00 00 fa fa fa fa 00 00 00 00
> ffffffff88f41f80: 00 00 00 00 00 00 00 00 fa fa fa fa 00 00 00 00
                                            ^
  ffffffff88f42000: 00 00 00 00 00 00 fa fa fa fa fa fa 00 00 00 00
  ffffffff88f42080: 00 00 fa fa fa fa fa fa 00 00 00 00 fa fa fa fa
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

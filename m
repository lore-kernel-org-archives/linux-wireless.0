Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8757C282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26362171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfDLLqx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:46:53 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:55752 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfDLLqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 07:46:13 -0400
Received: by mail-it1-f200.google.com with SMTP id g184so8865909ita.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 04:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ENy4F9rTcWLTqPNE6+J9Evm52EouIxRgZ0Kn90Fdp4M=;
        b=ILc4gN8USjwH+RE21AllaGN+qTYFgTIHFtYarAQIkDN/qRPS6FOvvttGCPO38DGo0J
         zEfUQGA3i071Jc3R+Q7bUMiMuaexGtOGF1ybfJYymr3eJxpPSbn0BzWerhW+vLMzr4ri
         x+nE6FPZdT75QyhTWgw1tVhhOTL0tJycXP93BOzZt7AteIcN7TGhDX390TgTpPSdrp2Z
         gmvKk0l4mWVnwF8jT5UOGCoC9Dsoup3DsHjJcBcCOs5u1Y6/NWUMAGEzlLk7pf9kgOfT
         iRd4Fj8uAFrvXxy3x3fK+NX+dgLR1gj9STk1dooCHiTV+56KEXWoudjCxIYhBYtSqbDn
         FjKg==
X-Gm-Message-State: APjAAAXIwCMx76hdEEsn9BUzGrlfjXo/m/m2AgbApK/8jqFIPGCU4Hzq
        rbj1HQ9+bn0YPZn9qhFPbjD9jpKoow4h31ucuFeiVhjqxk7v
X-Google-Smtp-Source: APXvYqw74ctPaHPh1MLSTkrvFAVH6hx3mTI6NpNfll7bal8ZvqzH6V1uSGVTcaIygdTRFl6KPzSKwTgqHDjfqF05QKO0SFEfB6A+
MIME-Version: 1.0
X-Received: by 2002:a6b:c403:: with SMTP id y3mr3171480ioa.38.1555069572325;
 Fri, 12 Apr 2019 04:46:12 -0700 (PDT)
Date:   Fri, 12 Apr 2019 04:46:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075a7a6058653d977@google.com>
Subject: WARNING in zd_mac_clear
From:   syzbot <syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, dsd@gentoo.org,
        kune@deine-taler.de, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan/tree/usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=101a06dd200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
dashboard link: https://syzkaller.appspot.com/bug?extid=74c65761783d66a9c97c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1170c22d200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1496adbb200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com

usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
usb 1-1: reset low-speed USB device number 2 using dummy_hcd
usb 1-1: read over firmware interface failed: -71
usb 1-1: reset low-speed USB device number 2 using dummy_hcd
WARNING: CPU: 1 PID: 21 at drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238  
zd_mac_clear+0xb0/0xe0 drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  panic+0x29d/0x5f2 kernel/panic.c:214
  __warn.cold+0x20/0x48 kernel/panic.c:571
  report_bug+0x262/0x2a0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:zd_mac_clear+0xb0/0xe0  
drivers/net/wireless/zydas/zd1211rw/zd_mac.c:238
Code: e8 85 d0 60 f8 48 8d bb f8 2b 00 00 be ff ff ff ff e8 54 5a 46 f8 31  
ff 89 c3 89 c6 e8 d9 d1 60 f8 85 db 75 d4 e8 60 d0 60 f8 <0f> 0b 5b 5d e9  
57 d0 60 f8 48 c7 c7 58 05 cb 93 e8 fb e0 97 f8 eb
RSP: 0018:ffff8880a85c7310 EFLAGS: 00010293
RAX: ffff8880a84de200 RBX: 0000000000000000 RCX: ffffffff8910f507
RDX: 0000000000000000 RSI: ffffffff8910f510 RDI: 0000000000000005
RBP: 0000000000000001 R08: ffff8880a84de200 R09: ffffed1012f83a0b
R10: ffffed1012f83a0a R11: ffff888097c1d057 R12: 00000000ffffffb9
R13: ffff888097c18b20 R14: ffff888099456630 R15: ffffffff8f979398
  probe+0x259/0x590 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1421
  usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
  really_probe+0x2da/0xb10 drivers/base/dd.c:509
  driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
  __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
  bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
  __device_attach+0x223/0x3a0 drivers/base/dd.c:844
  bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
  device_add+0xad2/0x16e0 drivers/base/core.c:2106
  usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
  generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
  usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
  really_probe+0x2da/0xb10 drivers/base/dd.c:509
  driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
  __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
  bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
  __device_attach+0x223/0x3a0 drivers/base/dd.c:844
  bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
  device_add+0xad2/0x16e0 drivers/base/core.c:2106
  usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

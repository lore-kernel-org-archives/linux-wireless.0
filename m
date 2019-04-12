Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C185FC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 919372171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfDLLqN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:46:13 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36107 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfDLLqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 07:46:13 -0400
Received: by mail-io1-f72.google.com with SMTP id a7so7635875ioq.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 04:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A5MbKlZV/gN0hGXRyGBiJJWLBqEoLEmnUi7jlNLzI4k=;
        b=Y7/kEbZ9cNxZnVhb2kudTgtFzgsOZe5nBpWi4ITwLy+aWwh9JMcMD+c0kNQs6u2NEK
         i1B26vsDoJJpErgP5xalmsHfNpSo9iJBNozZ4GJ6H+HaWKqYPwAGlFbhovXS9/qRTxms
         iXBvqgnkSWorePglXGIgqxVFHOZA/vcp0+fuDAw8LKg3VsDjqo1sw09Wk/1+G51JerIq
         4MscHeZqbHhV4B5G7Dpl01OXETs0+4BCvKk1Mxox5mHQdHQBOr5IXxilRVQc2Uos7Kd6
         9LWady/tehnIhLtgVX3bnNhAQTLhbAw+nxk9puykbZewsRS0fNOQS+cE6l0z3oZrpvXN
         oy3w==
X-Gm-Message-State: APjAAAW+guCOoiYfZ0IzxzSbaqXMmFvedeJhoi2dG04QbqZwJIXRxnTl
        AROGciGItOOduKb2oFNJEdbDDxznC2DPWBL62avO8jKNOcKH
X-Google-Smtp-Source: APXvYqz+jh+gWIfvK7INkXwjXU4lafC4oYeE4mijMTRpTVx05WeKKIK7pYDUopXIZbqjlWq3qqZasROTnPtk2P5f1X3/RQg5vtGn
MIME-Version: 1.0
X-Received: by 2002:a24:5c12:: with SMTP id q18mr3648769itb.13.1555069572113;
 Fri, 12 Apr 2019 04:46:12 -0700 (PDT)
Date:   Fri, 12 Apr 2019 04:46:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000727264058653d9a7@google.com>
Subject: INFO: trying to register non-static key in rtl_c2hcmd_launcher
From:   syzbot <syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pkshih@realtek.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan/tree/usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14d4c1af200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
dashboard link: https://syzkaller.appspot.com/bug?extid=1fcc5ef45175fc774231
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b6f0f3200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140c7c2d200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com

usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
rtl_usb: reg 0xf0, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
rtl8192cu: Chip version 0x10
rtl_usb: reg 0xa, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
rtl_usb: Too few input end points found
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:786 [inline]
  register_lock_class+0x11b8/0x1250 kernel/locking/lockdep.c:1095
  __lock_acquire+0xfb/0x37c0 kernel/locking/lockdep.c:3582
  lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x44/0x60 kernel/locking/spinlock.c:152
  rtl_c2hcmd_launcher+0xd1/0x390  
drivers/net/wireless/realtek/rtlwifi/base.c:2344
  rtl_deinit_core+0x25/0x2d0 drivers/net/wireless/realtek/rtlwifi/base.c:574
  rtl_usb_probe.cold+0x861/0xa70  
drivers/net/wireless/realtek/rtlwifi/usb.c:1093
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
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN PTI
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:rtl_free_entries_from_scan_list  
drivers/net/wireless/realtek/rtlwifi/base.c:1933 [inline]
RIP: 0010:rtl_deinit_core+0x84/0x2d0  
drivers/net/wireless/realtek/rtlwifi/base.c:575
Code: 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 52 02 00 00 4d 8b bc 24 c8 c4  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 22 02 00 00 4d 39 f7 4d 8b 2f 4c 89 ff 0f 84 3d
RSP: 0018:ffff8880a84b7278 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff27960ab
RDX: 0000000000000000 RSI: ffffffff88da7445 RDI: ffff888093c00b68
RBP: ffff888093c00b20 R08: ffff8880a8498000 R09: ffffed101278051d
R10: ffffed101278051c R11: ffff888093c028e3 R12: ffff888093c02540
R13: ffff88821add7848 R14: ffff888093c0ea08 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd01db19000 CR3: 000000009c01a000 CR4: 00000000001406f0
Call Trace:
  rtl_usb_probe.cold+0x861/0xa70  
drivers/net/wireless/realtek/rtlwifi/usb.c:1093
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
Modules linked in:
---[ end trace 38ab7b2a1beef511 ]---
RIP: 0010:rtl_free_entries_from_scan_list  
drivers/net/wireless/realtek/rtlwifi/base.c:1933 [inline]
RIP: 0010:rtl_deinit_core+0x84/0x2d0  
drivers/net/wireless/realtek/rtlwifi/base.c:575
Code: 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 52 02 00 00 4d 8b bc 24 c8 c4  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 22 02 00 00 4d 39 f7 4d 8b 2f 4c 89 ff 0f 84 3d
RSP: 0018:ffff8880a84b7278 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff27960ab
RDX: 0000000000000000 RSI: ffffffff88da7445 RDI: ffff888093c00b68
RBP: ffff888093c00b20 R08: ffff8880a8498000 R09: ffffed101278051d
R10: ffffed101278051c R11: ffff888093c028e3 R12: ffff888093c02540
R13: ffff88821add7848 R14: ffff888093c0ea08 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd01db19000 CR3: 000000009c01a000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

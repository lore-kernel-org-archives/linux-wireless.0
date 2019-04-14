Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC14AC10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 19:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9061620848
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 19:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfDNT4S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 15:56:18 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40302 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfDNT4G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 15:56:06 -0400
Received: by mail-io1-f71.google.com with SMTP id e72so12516932iof.7
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2019 12:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MUVaWCItQ5KZAjiybLX8Sr3AeFtFAmSiWGZpQ0Glmlg=;
        b=iOSKemveuak3bdYZW2kkw6x6Tpg21UtqzKUzw9vCCSwi6yYDHug3E4LAoqAh/0AemS
         KSXwLprxAE40Pg4setkwwKz5P7VoEpL1PgZqKbbhbOcALg0nKBQd6gbDReMN4XZIyKa/
         kJpRns2QNl6eNRjFwAp2zVHKw3mfD3fuNEewP4v9PXzvXF7rdmxNt14F86ujWbWHAb2L
         3rhndBLNZoNgaTc5Z4V3du/uoSoL0zdLzYHMeE/qWrb99wqf0QUeXDdOIxtL2sNVMUCz
         10ylRwlfoKriDHhaN/UQdpEo14nJToSaaznve+6F6ZnwYLj7HUzoTMAoKln+uCt6VlVd
         MzOg==
X-Gm-Message-State: APjAAAWEqpraoANRZhxpVx+PhurNGnysXEvVlMJdVyEgGytGikiY9a1f
        WzdT6d+5IJYs1DFBkP36O1QASYQt9SkqUy45uMo8JpvLlRNh
X-Google-Smtp-Source: APXvYqw9rQO7T2WFR69ECdZHalnlV7uGPqKQjrjFXmpdK+1gEF80ZOoRVwF26OH/mF0O+OTNx8suoTqJ1phb/vFSwpwvcc4mpvyF
MIME-Version: 1.0
X-Received: by 2002:a24:d94d:: with SMTP id p74mr5607026itg.20.1555271766029;
 Sun, 14 Apr 2019 12:56:06 -0700 (PDT)
Date:   Sun, 14 Apr 2019 12:56:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000024bbd7058682eda1@google.com>
Subject: WARNING: ODEBUG bug in rsi_probe
From:   syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, siva8118@gmail.com,
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
console output: https://syzkaller.appspot.com/x/log.txt?x=163713bb200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ab7cd3200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com

rsi_91x: rsi_load_firmware: REGOUT read failed
rsi_91x: rsi_hal_device_init: Failed to load TA instructions
rsi_91x: rsi_probe: Failed in device init
------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: timer_list hint:  
bl_cmd_timeout+0x0/0x50 drivers/net/wireless/rsi/rsi_91x_hal.c:577
WARNING: CPU: 0 PID: 5 at lib/debugobjects.c:325  
debug_print_object+0x162/0x250 lib/debugobjects.c:325
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
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
RIP: 0010:debug_print_object+0x162/0x250 lib/debugobjects.c:325
Code: dd e0 a1 b3 8e 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48  
8b 14 dd e0 a1 b3 8e 48 c7 c7 60 96 b3 8e e8 8e 93 d2 fd <0f> 0b 83 05 e9  
d6 59 10 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
RSP: 0018:ffff8880a846f110 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815b1e42 RDI: ffffed101508de14
RBP: 0000000000000001 R08: ffff8880a8444980 R09: ffffed1015a03edb
R10: ffffed1015a03eda R11: ffff8880ad01f6d7 R12: ffffffff917e7780
R13: ffffffff8161ec90 R14: ffffffff96d67928 R15: ffff88809927f060
  __debug_check_no_obj_freed lib/debugobjects.c:785 [inline]
  debug_check_no_obj_freed+0x2a3/0x42e lib/debugobjects.c:817
  slab_free_hook mm/slub.c:1426 [inline]
  slab_free_freelist_hook+0xfb/0x140 mm/slub.c:1456
  slab_free mm/slub.c:3003 [inline]
  kfree+0xce/0x290 mm/slub.c:3958
  rsi_probe+0xdf3/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:1178
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

======================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

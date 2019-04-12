Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6BDC10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063562083E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfDLO0M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 10:26:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53870 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfDLO0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 10:26:12 -0400
Received: by mail-io1-f69.google.com with SMTP id w11so7888487iom.20
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 07:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0m8hg4kBF1SrMNFuMiutdCm5MvTrhGleRyR3argUwfA=;
        b=t3axbqzRr39iRqhdz2/oYLdgXxbYws3tJ8kplFUF/M9NnZCFHPfqr7/ydUfpHNKnxZ
         fhHXffRmUcwzRJBzpyL1ovqWFQQgGeQWTqZ/0ZQR0F2Lbgpx2pV1xHtqs91AB54Wx017
         9jS1RQgkwTyVtOiTv63KvtIxoclAp5TmFZDMilh4pDeWqipneQk75dPjwD+I6HhheyMI
         CLQAdF80cnM0dbsjl127AN54fZeRHyVDvbbiHNwhB+LNBsqL3YSpdrW3iPDbDEK1bUIG
         CT5RPZQqrE/SOwS1OUR+rtbo2fwaL1wysj6lkU/ajNX4fqXfLBzglTgGxa77jerzNxD9
         nfCA==
X-Gm-Message-State: APjAAAV9B3+VsehQYU0Ug0BaSJhhwk7oOKL9/rOZCzUCOix/xHHzeAv8
        e/Pqfle3A48h8Stt5LNofktk0FpK03gGpw2wpnEBDVxkm68f
X-Google-Smtp-Source: APXvYqwI9Pxlphm5/0kKOg4B8wYKVLN5C4yYVhutG4IEe5DJqc7K1/MoR/1oxm5PtNYgnAJhEQKy4AHx9Q62OJPak51GXxTwEVZH
MIME-Version: 1.0
X-Received: by 2002:a24:32d7:: with SMTP id j206mr3730170ita.2.1555079170779;
 Fri, 12 Apr 2019 07:26:10 -0700 (PDT)
Date:   Fri, 12 Apr 2019 07:26:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000927a7b0586561537@google.com>
Subject: INFO: trying to register non-static key in del_timer_sync (2)
From:   syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        gbhat@marvell.com, huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        nishants@marvell.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan/tree/usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14793fa7200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
dashboard link: https://syzkaller.appspot.com/bug?extid=dc4127f950da51639216
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f8c22d200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16eeadbb200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dc4127f950da51639216@syzkaller.appspotmail.com

usb 1-1: string descriptor 0 read error: -71
usb 1-1: USB disconnect, device number 2
usb 1-1: Direct firmware load for mrvl/usb8801_uapsta.bin failed with error  
-2
usb 1-1: Failed to get firmware mrvl/usb8801_uapsta.bin
usb 1-1: info: _mwifiex_fw_dpc: unregister device
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:786 [inline]
  register_lock_class+0x11b8/0x1250 kernel/locking/lockdep.c:1095
  __lock_acquire+0xfb/0x37c0 kernel/locking/lockdep.c:3582
  lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
  del_timer_sync+0x4c/0x150 kernel/time/timer.c:1282
  mwifiex_usb_cleanup_tx_aggr  
drivers/net/wireless/marvell/mwifiex/usb.c:1358 [inline]
  mwifiex_unregister_dev+0x41b/0x690  
drivers/net/wireless/marvell/mwifiex/usb.c:1370
  _mwifiex_fw_dpc+0x711/0xdd0 drivers/net/wireless/marvell/mwifiex/main.c:651
  request_firmware_work_func+0x12d/0x249  
drivers/base/firmware_loader/main.c:785
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list  
hint:           (null)
WARNING: CPU: 0 PID: 12 at lib/debugobjects.c:325  
debug_print_object+0x162/0x250 lib/debugobjects.c:325
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
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
RSP: 0018:ffff8880a84b78d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815b1e42 RDI: ffffed1015096f0d
RBP: 0000000000000001 R08: ffff8880a849b100 R09: fffffbfff22f95ed
R10: fffffbfff22f95ec R11: ffffffff917caf63 R12: ffffffff917e7780
R13: ffffffff8161ec90 R14: 1ffff11015096f28 R15: ffff88809fc893f8
  debug_object_assert_init lib/debugobjects.c:694 [inline]
  debug_object_assert_init+0x23d/0x2f0 lib/debugobjects.c:665
  debug_timer_assert_init kernel/time/timer.c:723 [inline]
  debug_assert_init kernel/time/timer.c:775 [inline]
  try_to_del_timer_sync+0x72/0x110 kernel/time/timer.c:1222
  del_timer_sync+0x112/0x150 kernel/time/timer.c:1292
  mwifiex_usb_cleanup_tx_aggr  
drivers/net/wireless/marvell/mwifiex/usb.c:1358 [inline]
  mwifiex_unregister_dev+0x41b/0x690  
drivers/net/wireless/marvell/mwifiex/usb.c:1370
  _mwifiex_fw_dpc+0x711/0xdd0 drivers/net/wireless/marvell/mwifiex/main.c:651
  request_firmware_work_func+0x12d/0x249  
drivers/base/firmware_loader/main.c:785
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

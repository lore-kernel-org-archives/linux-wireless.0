Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067F3C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8958204EC
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfDWMgO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 08:36:14 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:45766 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbfDWMgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 08:36:11 -0400
Received: by mail-io1-f71.google.com with SMTP id j25so6840356ioj.12
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 05:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LFoGPFtYgGfzZbv4YukFVx1QbzRdWIcXb0v+NmiVzSA=;
        b=mu862m4uWKkrk/M+4yVdgWmAdkozIr+5ecHqkN+tsFZ8SrQEjfeheMvYR5nPAV5GUz
         Uq0q2WXIhutu8sFKtr4ecWXs6zHZN4dwYJdL6PpAD2zZ7P0X8anFvQ8MIJan6svs0rE9
         k2e0QDJCqcECWHEaITJBZG7oNwv25CM2KP/iE1llFmze5YYw52E781eIE7dRKan578Mn
         24FA+UIcQH9W7XiCDj/gAHjCprRGd+jFF1JGybtoSD7vqvb/pGlxp/ML3iTk+QoGqSdE
         L5TwaxfkP5cknnG6COCOBKku2yObsAD6S4/gWiQlFidbMldIvOVIXYiQHD4oJXydKhj+
         PhnA==
X-Gm-Message-State: APjAAAUduH5BvqOAJ4m7Q9LfhffnLnSXSFz6kSbXkGRkkgsiTgq6mpRP
        /6HPnEAkewBQNvDAln7iS7TxAkKaOhTflMvufTSvH4e0VZXe
X-Google-Smtp-Source: APXvYqwDsQ41Kdl1Iq3KGbCYp8bPy+Zbx0AOGIqWtWmtHmIFyAvGJpfoyGIpMpv6YMZqrhi1NlEwGGHY8N6CkqKz+mX0gskBm0ri
MIME-Version: 1.0
X-Received: by 2002:a24:10c6:: with SMTP id 189mr1663880ity.40.1556022969420;
 Tue, 23 Apr 2019 05:36:09 -0700 (PDT)
Date:   Tue, 23 Apr 2019 05:36:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ae4cd058731d407@google.com>
Subject: KASAN: invalid-free in rsi_91x_deinit
From:   syzbot <syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com>
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

HEAD commit:    d34f9519 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan/tree/usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14a79403200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
dashboard link: https://syzkaller.appspot.com/bug?extid=7c72edfb407b2bd866ce
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17547247200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147b3a1d200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com

usb 1-1: config 252 interface 115 altsetting 0 has 1 endpoint descriptor,  
different from the interface descriptor's value: 4
usb 1-1: New USB device found, idVendor=1618, idProduct=9113,  
bcdDevice=32.21
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
rsi_91x: rsi_probe: Failed to init usb interface
==================================================================
BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3003 [inline]
BUG: KASAN: double-free or invalid-free in kfree+0xce/0x280 mm/slub.c:3958

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc5-319617-gd34f951 #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  print_address_description+0x6c/0x236 mm/kasan/report.c:187
  kasan_report_invalid_free+0x66/0xa0 mm/kasan/report.c:278
  __kasan_slab_free+0x162/0x180 mm/kasan/common.c:438
  slab_free_hook mm/slub.c:1429 [inline]
  slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
  slab_free mm/slub.c:3003 [inline]
  kfree+0xce/0x280 mm/slub.c:3958
  rsi_91x_deinit+0x27b/0x300 drivers/net/wireless/rsi/rsi_91x_main.c:407
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
  hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 12:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:470
  rsi_init_sdio_interface drivers/net/wireless/rsi/rsi_91x_sdio.c:853  
[inline]
  rsi_probe+0x11a/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:965
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
  hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Freed by task 12:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
  slab_free_hook mm/slub.c:1429 [inline]
  slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
  slab_free mm/slub.c:3003 [inline]
  kfree+0xce/0x280 mm/slub.c:3958
  rsi_probe+0xf04/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:1196
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
  hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888214af0c80
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
  512-byte region [ffff888214af0c80, ffff888214af0e80)
The buggy address belongs to the page:
page:ffffea000852bc00 count:1 mapcount:0 mapping:ffff88812c3f4c00  
index:0xffff888214af1180 compound_mapcount: 0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 ffffea00086b3780 0000000800000008 ffff88812c3f4c00
raw: ffff888214af1180 00000000800c000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888214af0b80: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
  ffff888214af0c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff888214af0c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888214af0d00: fb fb fb fb fb fb f


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

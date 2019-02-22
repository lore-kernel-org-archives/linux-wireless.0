Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722B2C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 09:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F1C2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 09:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfBVJmw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 04:42:52 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:53706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbfBVJmw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 04:42:52 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E9EA2BA578E3DF553A4F;
        Fri, 22 Feb 2019 17:42:49 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.408.0; Fri, 22 Feb 2019
 17:42:43 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] cfg80211: reg: Fix use-after-free in call_crda
Date:   Fri, 22 Feb 2019 17:42:33 +0800
Message-ID: <20190222094233.21556-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

KASAN report this:

BUG: KASAN: use-after-free in kobject_uevent_env+0xedb/0xf20 lib/kobject_uevent.c:474
Read of size 8 at addr ffff8881e52d5dc0 by task kworker/0:2/1066

CPU: 0 PID: 1066 Comm: kworker/0:2 Not tainted 5.0.0-rc7+ #45
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Workqueue: events reg_todo [cfg80211]
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xfa/0x1ce lib/dump_stack.c:113
 print_address_description+0x65/0x270 mm/kasan/report.c:187
 kasan_report+0x149/0x18d mm/kasan/report.c:317
 kobject_uevent_env+0xedb/0xf20 lib/kobject_uevent.c:474
 reg_query_database+0x23e/0x390 [cfg80211]
 reg_process_hint+0x34a/0xc00 [cfg80211]
 reg_todo+0x3f0/0xa80 [cfg80211]
 process_one_work+0xc4d/0x1b40 kernel/workqueue.c:2173
 worker_thread+0x171/0x1130 kernel/workqueue.c:2319
 kthread+0x302/0x3c0 kernel/kthread.c:246
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 3500:
 set_track mm/kasan/common.c:85 [inline]
 __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:496
 kmalloc include/linux/slab.h:550 [inline]
 kzalloc include/linux/slab.h:740 [inline]
 platform_device_alloc+0x2a/0xf0 drivers/base/platform.c:268
 platform_device_register_full+0x6d/0x4d0 drivers/base/platform.c:509
 regulatory_init+0x13c/0x5e0 [cfg80211]
 cfg80211_init+0x7a/0x10f [cfg80211]
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2957:
 set_track mm/kasan/common.c:85 [inline]
 __kasan_slab_free+0x130/0x180 mm/kasan/common.c:458
 slab_free_hook mm/slub.c:1409 [inline]
 slab_free_freelist_hook mm/slub.c:1436 [inline]
 slab_free mm/slub.c:2986 [inline]
 kfree+0xe1/0x270 mm/slub.c:3938
 device_release+0x78/0x200 drivers/base/core.c:919
 kobject_cleanup lib/kobject.c:662 [inline]
 kobject_release lib/kobject.c:691 [inline]
 kref_put include/linux/kref.h:67 [inline]
 kobject_put+0x146/0x240 lib/kobject.c:708
 put_device+0x1c/0x30 drivers/base/core.c:2060
 request_firmware_work_func+0x16d/0x290 drivers/base/firmware_loader/main.c:786
 process_one_work+0xc4d/0x1b40 kernel/workqueue.c:2173
 worker_thread+0x171/0x1130 kernel/workqueue.c:2319
 kthread+0x302/0x3c0 kernel/kthread.c:246
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881e52d5d80
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 64 bytes inside of
 2048-byte region [ffff8881e52d5d80, ffff8881e52d6580)
The buggy address belongs to the page:
page:ffffea000794b400 count:1 mapcount:0 mapping:ffff8881f6c02800 index:0xffff8881e52d3300 compound_mapcount: 0
flags: 0x2fffc0000010200(slab|head)
raw: 02fffc0000010200 ffffea00079d5200 0000000400000004 ffff8881f6c02800
raw: ffff8881e52d3300 00000000800f000e 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881e52d5c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881e52d5d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881e52d5d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff8881e52d5e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881e52d5e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

In function reg_query_database, query_regdb_file call
request_firmware_nowait to do request_firmware asynchronously,
which need the caller hold the reference of dev, otherwise it will
do put_device freeing '&reg_pdev->dev'. After that, call_crda access
the dev will trigger use-after-free bug.
This patch fix this by holding a reference of dev in regulatory_init
after platform_device_register_simple registered successly, which
releasing in platform_device_unregister.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 007f6c5e6eb4 ("cfg80211: support loading regulatory database as firmware file")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/wireless/reg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index adfa58f..3de568f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3884,6 +3884,8 @@ int __init regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
+	get_device(&reg_pdev->dev);
+
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 	spin_lock_init(&reg_indoor_lock);
-- 
2.7.4



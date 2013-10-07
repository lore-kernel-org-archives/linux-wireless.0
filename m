Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60604 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3JGDWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Oct 2013 23:22:19 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com, Alex Dubov <oakad@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH V2] memstick: Fix memory leak in memstick_check() error path
Date: Sun,  6 Oct 2013 22:21:51 -0500
Message-Id: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131007_052235_409300_C2762671)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With kernel 3.12-rc3, kmemleak reports the following leak:

> unreferenced object 0xffff8800ae85c190 (size 16):
>   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>   hex dump (first 16 bytes):
>     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>   backtrace:
>     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>     [<ffffffff81069862>] process_one_work+0x1d2/0x670
>     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>     [<ffffffff81072ea6>] kthread+0xd6/0xe0
>     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0

This problem was introduced by commit 0252c3b "memstick: struct device -
replace bus_id with dev_name(), dev_set_name()" where the name is not freed
in the error path. The name is also leaked in memstick_free_card(). 

Thanks to Catalin Marinas for suggesting the fix.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 fixes the typos in the commit message, and frees the name in
memstick_free_card() as well as the error path in memstick_check().

Larry
---
 drivers/memstick/core/memstick.c | 2 ++
 1 file changed, 2 insertion(+)

Index: wireless-testing-save/drivers/memstick/core/memstick.c
===================================================================
--- wireless-testing-save.orig/drivers/memstick/core/memstick.c
+++ wireless-testing-save/drivers/memstick/core/memstick.c
@@ -195,6 +195,7 @@ static void memstick_free_card(struct de
 {
 	struct memstick_dev *card = container_of(dev, struct memstick_dev,
 						 dev);
+	kfree(card->dev.kobj.name);
 	kfree(card);
 }
 
@@ -415,6 +416,7 @@ static struct memstick_dev *memstick_all
 	return card;
 err_out:
 	host->card = old_card;
+	kfree(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }

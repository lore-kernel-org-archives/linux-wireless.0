Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36856 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934834AbcIUQtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 12:49:40 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: gregkh@linuxfoundation.org, Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] carl9170: fix debugfs crashes
Date: Wed, 21 Sep 2016 18:49:36 +0200
Message-Id: <238afe4926e979a46013129f8b8db48154e46963.1474476231.git.chunkeey@gmail.com> (sfid-20160921_184945_619573_1626D9DC)
In-Reply-To: <1927662.l0xhZ6GL0u@debian64>
References: <1927662.l0xhZ6GL0u@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear reported:
> I see lots of instability as soon as I load up the carl9710 NIC.
> My application is going to be poking at it's debugfs files...
>
> BUG: KASAN: slab-out-of-bounds in carl9170_debugfs_read+0xd5/0x2a0
> [carl9170] at addr 0xffff8801bc1208b0
> Read of size 8 by task btserver/5888
> =======================================================================
> BUG kmalloc-256 (Tainted: G        W      ): kasan: bad access detected
> -----------------------------------------------------------------------
>
> INFO: Allocated in seq_open+0x50/0x100 age=2690 cpu=2 pid=772
>...

This breakage was caused by the introduction of intermediate
fops in debugfs by commit 9fd4dcece43a
("debugfs: prevent access to possibly dead file_operations at file open")

Thankfully, the original/real fops are still available in d_fsdata.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Cc: stable <stable@vger.kernel.org> # 4.7+
---
 drivers/net/wireless/ath/carl9170/debug.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 6808db4..ec3a64e 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -75,7 +75,8 @@ static ssize_t carl9170_debugfs_read(struct file *file, char __user *userbuf,
 
 	if (!ar)
 		return -ENODEV;
-	dfops = container_of(file->f_op, struct carl9170_debugfs_fops, fops);
+	dfops = container_of(debugfs_real_fops(file),
+			     struct carl9170_debugfs_fops, fops);
 
 	if (!dfops->read)
 		return -ENOSYS;
@@ -127,7 +128,8 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 
 	if (!ar)
 		return -ENODEV;
-	dfops = container_of(file->f_op, struct carl9170_debugfs_fops, fops);
+	dfops = container_of(debugfs_real_fops(file),
+			     struct carl9170_debugfs_fops, fops);
 
 	if (!dfops->write)
 		return -ENOSYS;
-- 
2.9.3

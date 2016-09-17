Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33638 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbcIQTnL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 15:43:11 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: gregkh@linuxfoundation.org, Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/4] b43: fix debugfs crash
Date: Sat, 17 Sep 2016 21:43:03 +0200
Message-Id: <60f368dd08cafebc3d39de18996d1df85f525887.1474140477.git.chunkeey@gmail.com> (sfid-20160917_214416_672061_48780941)
In-Reply-To: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com>
References: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com>
In-Reply-To: <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
References: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com> <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a crash that happens because b43's
debugfs code expects file->f_op to be a pointer to
its own b43_debugfs_fops struct. This is no longer
the case since commit 9fd4dcece43a
("debugfs: prevent access to possibly dead file_operations at file open")

Reviewed-by: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index b4bcd94..7704638 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -524,7 +524,8 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 		goto out_unlock;
 	}
 
-	dfops = container_of(file->f_op, struct b43_debugfs_fops, fops);
+	dfops = container_of(debugfs_real_fops(file),
+			     struct b43_debugfs_fops, fops);
 	if (!dfops->read) {
 		err = -ENOSYS;
 		goto out_unlock;
@@ -585,7 +586,8 @@ static ssize_t b43_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	dfops = container_of(file->f_op, struct b43_debugfs_fops, fops);
+	dfops = container_of(debugfs_real_fops(file),
+			     struct b43_debugfs_fops, fops);
 	if (!dfops->write) {
 		err = -ENOSYS;
 		goto out_unlock;
-- 
2.9.3

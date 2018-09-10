Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:35270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbeIJID3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 04:03:29 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath9k: debug: remove set but not used variable 'fops_dump_nfcal'
Date: Mon, 10 Sep 2018 11:11:28 +0800
Message-ID: <20180910031128.12164-1-yuehaibing@huawei.com> (sfid-20180910_051156_138082_6BF01F07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'fops_dump_nfcal' is not used since commit 4447d815fd0f ("ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 0a6eb8a..c871b7e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -990,19 +990,6 @@ static int read_file_dump_nfcal(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int open_file_dump_nfcal(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_dump_nfcal, inode->i_private);
-}
-
-static const struct file_operations fops_dump_nfcal = {
-	.read = seq_read,
-	.open = open_file_dump_nfcal,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
-- 
2.7.0

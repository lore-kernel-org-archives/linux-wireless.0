Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:56177 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935192Ab3E3Lmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 07:42:37 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so85003bkc.16
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 04:42:35 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 May 2013 19:42:35 +0800
Message-ID: <CAPgLHd_naHj0Y9EsV_XZHBAiBieutbw=+w2Bgn_o0tAuO5DCkw@mail.gmail.com> (sfid-20130530_134249_441436_4E78959B)
Subject: [PATCH -next] cw1200: convert to use simple_open()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pizza@shaftnet.org, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/cw1200/debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/cw1200/debug.c
index b815181..eb40c9c 100644
--- a/drivers/net/wireless/cw1200/debug.c
+++ b/drivers/net/wireless/cw1200/debug.c
@@ -357,12 +357,6 @@ static const struct file_operations fops_counters = {
 	.owner = THIS_MODULE,
 };
 
-static int cw1200_generic_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #ifdef CONFIG_CW1200_ETF
 static int cw1200_etf_out_show(struct seq_file *seq, void *v)
 {
@@ -511,7 +505,7 @@ static ssize_t cw1200_wsm_dumps(struct file *file,
 }
 
 static const struct file_operations fops_wsm_dumps = {
-	.open = cw1200_generic_open,
+	.open = simple_open,
 	.write = cw1200_wsm_dumps,
 	.llseek = default_llseek,
 };


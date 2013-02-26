Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36928 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BZC3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 21:29:36 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so1620733bkc.38
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 18:29:35 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 26 Feb 2013 10:29:34 +0800
Message-ID: <CAPgLHd-bG936v1J73Ag1d9azE=TePh3JRgi-ZiN3B1unbFxorw@mail.gmail.com> (sfid-20130226_032940_084550_553D1A10)
Subject: [PATCH -next] wil6210: convert to use simple_open()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: qca_vkondrat@qca.qualcomm.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 65fc968..1e709bf 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -312,14 +312,6 @@ static const struct file_operations fops_memread = {
 	.llseek		= seq_lseek,
 };
 
-static int wil_default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
@@ -361,7 +353,7 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_ioblob = {
 	.read =		wil_read_file_ioblob,
-	.open =		wil_default_open,
+	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
@@ -396,7 +388,7 @@ static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
 
 static const struct file_operations fops_reset = {
 	.write = wil_write_file_reset,
-	.open  = wil_default_open,
+	.open  = simple_open,
 };
 /*---------Tx descriptor------------*/
 
@@ -526,7 +518,7 @@ static ssize_t wil_write_file_ssid(struct file *file, const char __user *buf,
 static const struct file_operations fops_ssid = {
 	.read = wil_read_file_ssid,
 	.write = wil_write_file_ssid,
-	.open  = wil_default_open,
+	.open  = simple_open,
 };
 
 /*----------------*/



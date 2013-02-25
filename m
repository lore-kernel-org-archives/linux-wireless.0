Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61660 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab3BYNYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 08:24:13 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so1265264bkc.39
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 05:24:11 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 25 Feb 2013 21:24:11 +0800
Message-ID: <CAPgLHd9VC5b+AVHcVEPMayewirKzPmmrNczS7y6OL59N2uCj8Q@mail.gmail.com> (sfid-20130225_142418_429739_A39EEC8D)
Subject: [PATCH -next] iwlwifi: convert to use simple_open()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linville@tuxdriver.com
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
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index c1bdb55..c9d5ea1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -69,12 +69,6 @@ struct iwl_dbgfs_mvm_ctx {
 	struct ieee80211_vif *vif;
 };
 
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t iwl_dbgfs_tx_flush_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
@@ -309,7 +303,7 @@ static ssize_t iwl_dbgfs_power_down_d3_allow_write(struct file *file,
 #define MVM_DEBUGFS_READ_FILE_OPS(name)					\
 static const struct file_operations iwl_dbgfs_##name##_ops = {	\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
@@ -317,14 +311,14 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {	\
 static const struct file_operations iwl_dbgfs_##name##_ops = {	\
 	.write = iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name)				\
 static const struct file_operations iwl_dbgfs_##name##_ops = {	\
 	.write = iwl_dbgfs_##name##_write,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 



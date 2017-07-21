Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36306 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdGUEY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:58 -0400
Received: by mail-oi0-f65.google.com with SMTP id c135so3403665oih.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:58 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 10/10] rtlwifi: Add phydm debug cmd to debugfs
Date: Thu, 20 Jul 2017 23:24:40 -0500
Message-Id: <20170721042440.15839-11-Larry.Finger@lwfinger.net> (sfid-20170721_062508_690410_EACBCCF5)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add an entry to set phydm debug parameters

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 77 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h  |  2 +
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index b44d4293b89e..1b8c1a3b666f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -412,6 +412,75 @@ static const struct file_operations file_ops_write_reg = {
 	.release = rtl_debugfs_close,
 };
 
+static ssize_t rtl_debugfs_phydm_cmd(struct file *filp,
+				     const char __user *buffer,
+				     size_t count, loff_t *loff)
+{
+	struct rtl_debgufs_priv *debugfs_priv = filp->private_data;
+	struct rtl_priv *rtlpriv = debugfs_priv->rtlpriv;
+
+	char tmp[64];
+
+	if (!rtlpriv->dbg.msg_buf)
+		return -ENOMEM;
+
+	if (!rtlpriv->phydm.ops)
+		return -EFAULT;
+
+	if (buffer && !copy_from_user(tmp, buffer, sizeof(tmp))) {
+		tmp[count] = '\0';
+
+		rtlpriv->phydm.ops->phydm_debug_cmd(rtlpriv, tmp, count,
+						    rtlpriv->dbg.msg_buf,
+						    80 * 25);
+	}
+
+	return count;
+}
+
+static int rtl_debug_get_phydm_cmd(struct seq_file *m, void *v)
+{
+	struct rtl_debgufs_priv *debugfs_priv = m->private;
+	struct rtl_priv *rtlpriv = debugfs_priv->rtlpriv;
+
+	if (rtlpriv->dbg.msg_buf)
+		seq_puts(m, rtlpriv->dbg.msg_buf);
+
+	return 0;
+}
+
+static int rtl_debugfs_open_rw(struct inode *inode, struct file *filp)
+{
+	if (filp->f_mode & FMODE_READ)
+		single_open(filp, rtl_debug_get_phydm_cmd, inode->i_private);
+	else
+		filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static int rtl_debugfs_close_rw(struct inode *inode, struct file *filp)
+{
+	if (filp->f_mode == FMODE_READ)
+		seq_release(inode, filp);
+
+	return 0;
+}
+
+static struct rtl_debgufs_priv rtl_debug_priv_phydm_cmd = {
+	.cb = NULL,
+	.cb_data = 0,
+};
+
+static const struct file_operations file_ops_phydm_cmd = {
+	.owner = THIS_MODULE,
+	.open = rtl_debugfs_open_rw,
+	.release = rtl_debugfs_close_rw,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.write = rtl_debugfs_phydm_cmd,
+};
+
 #define RTL_DEBUGFS_ADD_CORE(name, mode, fopname)			   \
 	do {								   \
 		rtl_debug_priv_ ##name.rtlpriv = rtlpriv;		   \
@@ -427,6 +496,8 @@ static const struct file_operations file_ops_write_reg = {
 		RTL_DEBUGFS_ADD_CORE(name, S_IFREG | 0444, common)
 #define RTL_DEBUGFS_ADD_W(name)						   \
 		RTL_DEBUGFS_ADD_CORE(name, S_IFREG | 0222, write_reg)
+#define RTL_DEBUGFS_ADD_RW(name)					   \
+		RTL_DEBUGFS_ADD_CORE(name, S_IFREG | 0666, phydm_cmd)
 
 void rtl_debug_add_one(struct ieee80211_hw *hw)
 {
@@ -434,6 +505,8 @@ void rtl_debug_add_one(struct ieee80211_hw *hw)
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct dentry *parent;
 
+	rtlpriv->dbg.msg_buf = vzalloc(80 * 25);
+
 	snprintf(rtlpriv->dbg.debugfs_name, 18, "%02x-%02x-%02x-%02x-%02x-%02x",
 		 rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
 		 rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
@@ -491,6 +564,8 @@ void rtl_debug_add_one(struct ieee80211_hw *hw)
 	RTL_DEBUGFS_ADD(btcoex);
 
 	RTL_DEBUGFS_ADD_W(write_reg);
+
+	RTL_DEBUGFS_ADD_RW(phydm_cmd);
 }
 EXPORT_SYMBOL_GPL(rtl_debug_add_one);
 
@@ -500,6 +575,8 @@ void rtl_debug_remove_one(struct ieee80211_hw *hw)
 
 	debugfs_remove_recursive(rtlpriv->dbg.debugfs_dir);
 	rtlpriv->dbg.debugfs_dir = NULL;
+
+	vfree(rtlpriv->dbg.msg_buf);
 }
 EXPORT_SYMBOL_GPL(rtl_debug_remove_one);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 92ce00819d2c..416c6f3a1ff3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2395,6 +2395,8 @@ struct rtl_debug {
 	/* add for debug */
 	struct dentry *debugfs_dir;
 	char debugfs_name[20];
+
+	char *msg_buf;
 };
 
 #define MIMO_PS_STATIC			0
-- 
2.12.3

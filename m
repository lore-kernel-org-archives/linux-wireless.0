Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33202 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZKYHOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 02:14:10 -0500
Received: by ewy19 with SMTP id 19so92455ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 23:14:15 -0800 (PST)
Date: Wed, 25 Nov 2009 10:14:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linville@tuxdriver.com, akpm@linux-foundation.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2x00: convert to seq_file
Message-ID: <20091125071412.GC3459@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/wireless/ipw2x00/libipw_module.c |   33 ++++++++++++++++++---------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -216,17 +216,22 @@ u32 libipw_debug_level = 0;
 EXPORT_SYMBOL_GPL(libipw_debug_level);
 static struct proc_dir_entry *libipw_proc = NULL;
 
-static int show_debug_level(char *page, char **start, off_t offset,
-			    int count, int *eof, void *data)
+static int debug_level_proc_show(struct seq_file *m, void *v)
 {
-	return snprintf(page, count, "0x%08X\n", libipw_debug_level);
+	seq_printf(m, "0x%08X\n", libipw_debug_level);
+	return 0;
 }
 
-static int store_debug_level(struct file *file, const char __user * buffer,
-			     unsigned long count, void *data)
+static int debug_level_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_level_proc_show, NULL);
+}
+
+static ssize_t debug_level_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[] = "0x00000000\n";
-	unsigned long len = min((unsigned long)sizeof(buf) - 1, count);
+	size_t len = min(sizeof(buf) - 1, count);
 	unsigned long val;
 
 	if (copy_from_user(buf, buffer, len))
@@ -240,6 +245,15 @@ static int store_debug_level(struct file *file, const char __user * buffer,
 
 	return strnlen(buf, len);
 }
+
+static const struct file_operations debug_level_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_level_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= debug_level_proc_write,
+};
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
 static int __init libipw_init(void)
@@ -254,16 +268,13 @@ static int __init libipw_init(void)
 				" proc directory\n");
 		return -EIO;
 	}
-	e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
-			      libipw_proc);
+	e = proc_create("debug_level", S_IRUGO | S_IWUSR, libipw_proc,
+			&debug_level_proc_fops);
 	if (!e) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		libipw_proc = NULL;
 		return -EIO;
 	}
-	e->read_proc = show_debug_level;
-	e->write_proc = store_debug_level;
-	e->data = NULL;
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42132 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZKYHMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 02:12:18 -0500
Received: by ewy19 with SMTP id 19so91574ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 23:12:23 -0800 (PST)
Date: Wed, 25 Nov 2009 10:12:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linville@tuxdriver.com, akpm@linux-foundation.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ray_cs: convert to proc_fops
Message-ID: <20091125071220.GB3459@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/wireless/ray_cs.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2865,18 +2865,8 @@ static int build_auth_frame(ray_dev_t *local, UCHAR *dest, int auth_type)
 
 /*===========================================================================*/
 #ifdef CONFIG_PROC_FS
-static void raycs_write(const char *name, write_proc_t *w, void *data)
-{
-	struct proc_dir_entry *entry =
-	    create_proc_entry(name, S_IFREG | S_IWUSR, NULL);
-	if (entry) {
-		entry->write_proc = w;
-		entry->data = data;
-	}
-}
-
-static int write_essid(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data)
+static ssize_t ray_cs_essid_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	static char proc_essid[33];
 	unsigned int len = count;
@@ -2890,8 +2880,13 @@ static int write_essid(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static int write_int(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+static const struct file_operations ray_cs_essid_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ray_cs_essid_proc_write,
+};
+
+static ssize_t int_proc_write(struct file *file, const char __user *buffer,
+			      size_t count, loff_t *pos)
 {
 	static char proc_number[10];
 	char *p;
@@ -2914,9 +2909,14 @@ static int write_int(struct file *file, const char __user *buffer,
 		nr = nr * 10 + c;
 		p++;
 	} while (--len);
-	*(int *)data = nr;
+	*(int *)PDE(file->f_path.dentry->d_inode)->data = nr;
 	return count;
 }
+
+static const struct file_operations int_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= int_proc_write,
+};
 #endif
 
 static struct pcmcia_device_id ray_ids[] = {
@@ -2951,9 +2951,9 @@ static int __init init_ray_cs(void)
 	proc_mkdir("driver/ray_cs", NULL);
 
 	proc_create("driver/ray_cs/ray_cs", 0, NULL, &ray_cs_proc_fops);
-	raycs_write("driver/ray_cs/essid", write_essid, NULL);
-	raycs_write("driver/ray_cs/net_type", write_int, &net_type);
-	raycs_write("driver/ray_cs/translate", write_int, &translate);
+	proc_create("driver/ray_cs/essid", S_IWUSR, NULL, &ray_cs_essid_proc_fops);
+	proc_create_data("driver/ray_cs/net_type", S_IWUSR, NULL, &int_proc_fops, &net_type);
+	proc_create_data("driver/ray_cs/translate", S_IWUSR, NULL, &int_proc_fops, &translate);
 #endif
 	if (translate != 0)
 		translate = 1;

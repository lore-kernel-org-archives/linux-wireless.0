Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50839 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab0AUV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix bluetooth capi build
Date: Thu, 21 Jan 2010 22:29:48 +0100
Message-Id: <1264109388-19746-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports patch 9a58a80a701bdb2d220cdab4914218df5b48d781
"proc_fops: convert drivers/isdn/ to seq_file" from linux-next.

compile tested only

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/21-capi-proc_fops.patch |   73 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 patches/21-capi-proc_fops.patch

diff --git a/patches/21-capi-proc_fops.patch b/patches/21-capi-proc_fops.patch
new file mode 100644
index 0000000..2f2ca7d
--- /dev/null
+++ b/patches/21-capi-proc_fops.patch
@@ -0,0 +1,73 @@
+Backport kernel patch 9a58a80a701bdb2d220cdab4914218df5b48d781
+proc_fops: convert drivers/isdn/ to seq_file
+
+--- a/net/bluetooth/cmtp/capi.c
++++ b/net/bluetooth/cmtp/capi.c
+@@ -21,8 +21,10 @@
+ */
+ 
+ #include <linux/module.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ #include <linux/proc_fs.h>
+ #include <linux/seq_file.h>
++#endif
+ #include <linux/types.h>
+ #include <linux/errno.h>
+ #include <linux/kernel.h>
+@@ -521,6 +523,7 @@ static char *cmtp_procinfo(struct capi_c
+ 	return "CAPI Message Transport Protocol";
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int cmtp_proc_show(struct seq_file *m, void *v)
+ {
+ 	struct capi_ctr *ctrl = m->private;
+@@ -553,6 +556,36 @@ static const struct file_operations cmtp
+ 	.release	= single_release,
+ };
+ 
++#else
++
++static int cmtp_ctr_read_proc(char *page, char **start, off_t off, int count, int *eof, struct capi_ctr *ctrl)
++{
++	struct cmtp_session *session = ctrl->driverdata;
++	struct cmtp_application *app;
++	struct list_head *p, *n;
++	int len = 0;
++
++	len += sprintf(page + len, "%s\n\n", cmtp_procinfo(ctrl));
++	len += sprintf(page + len, "addr %s\n", session->name);
++	len += sprintf(page + len, "ctrl %d\n", session->num);
++
++	list_for_each_safe(p, n, &session->applications) {
++		app = list_entry(p, struct cmtp_application, list);
++		len += sprintf(page + len, "appl %d -> %d\n", app->appl, app->mapping);
++	}
++
++	if (off + count >= len)
++		*eof = 1;
++
++	if (len < off)
++		return 0;
++
++	*start = page + off;
++
++	return ((count < len - off) ? count : len - off);
++}
++#endif
++
+ int cmtp_attach_device(struct cmtp_session *session)
+ {
+ 	unsigned char buf[4];
+@@ -591,7 +624,11 @@ int cmtp_attach_device(struct cmtp_sessi
+ 	session->ctrl.send_message  = cmtp_send_message;
+ 
+ 	session->ctrl.procinfo      = cmtp_procinfo;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	session->ctrl.proc_fops = &cmtp_proc_fops;
++#else
++	session->ctrl.ctr_read_proc = cmtp_ctr_read_proc;
++#endif
+ 
+ 	if (attach_capi_ctr(&session->ctrl) < 0) {
+ 		BT_ERR("Can't attach new controller");
-- 
1.6.3.3


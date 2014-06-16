Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53200 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaFPQiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:54 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 23/25] wil6210: add 'info' debugfs entry
Date: Mon, 16 Jun 2014 19:37:21 +0300
Message-ID: <1402936643-31819-24-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190458_128813_8CC1CE81)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'info' debugfs entry for misc. assorted information.
Start with indication whether platform is AC-powered;
will use it later for power related decisions

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d6acb30..8bf00ac 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
+#include <linux/power_supply.h>
 
 #include "wil6210.h"
 #include "txrx.h"
@@ -847,6 +848,29 @@ static const struct file_operations fops_link = {
 	.llseek		= seq_lseek,
 };
 
+/*---------info------------*/
+static int wil_info_debugfs_show(struct seq_file *s, void *data)
+{
+	int is_ac = power_supply_is_system_supplied();
+
+	/* >0 : AC; 0 : battery; <0 : error */
+	seq_printf(s, "AC powered : %d\n", is_ac);
+
+	return 0;
+}
+
+static int wil_info_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_info_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_info = {
+	.open		= wil_info_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*---------Station matrix------------*/
 static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 {
@@ -956,6 +980,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
 	debugfs_create_file("freq", S_IRUGO, dbg, wil, &fops_freq);
 	debugfs_create_file("link", S_IRUGO, dbg, wil, &fops_link);
+	debugfs_create_file("info", S_IRUGO, dbg, wil, &fops_info);
 
 	wil->rgf_blob.data = (void * __force)wil->csr + 0;
 	wil->rgf_blob.size = 0xa000;
-- 
1.9.1


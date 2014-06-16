Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaFPQiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:17 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 04/25] wil6210: trace wil->status on debugfs
Date: Mon, 16 Jun 2014 19:37:02 +0300
Message-ID: <1402936643-31819-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183827_583324_2C0D2BEC)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debug purposes

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 9d5db04..4fb3375 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -231,6 +231,26 @@ static struct dentry *wil_debugfs_create_iomem_x32(const char *name,
 				   &fops_iomem_x32);
 }
 
+static int wil_debugfs_ulong_set(void *data, u64 val)
+{
+	*(ulong *)data = val;
+	return 0;
+}
+static int wil_debugfs_ulong_get(void *data, u64 *val)
+{
+	*val = *(ulong *)data;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(wil_fops_ulong, wil_debugfs_ulong_get,
+			wil_debugfs_ulong_set, "%llu\n");
+
+static struct dentry *wil_debugfs_create_ulong(const char *name, umode_t mode,
+					       struct dentry *parent,
+					       ulong *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &wil_fops_ulong);
+}
+
 static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
 				      const char *name,
 				      struct dentry *parent, u32 off)
@@ -781,6 +801,8 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("ssid", S_IRUGO | S_IWUSR, dbg, wil, &fops_ssid);
 	debugfs_create_u32("secure_pcp", S_IRUGO | S_IWUSR, dbg,
 			   &wil->secure_pcp);
+	wil_debugfs_create_ulong("status", S_IRUGO | S_IWUSR, dbg,
+				 &wil->status);
 
 	wil6210_debugfs_create_ISR(wil, "USER_ICR", dbg,
 				   HOSTADDR(RGF_USER_USER_ICR));
-- 
1.9.1


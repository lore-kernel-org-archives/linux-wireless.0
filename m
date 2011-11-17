Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34324 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1KQWWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 2/4] compat: add CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP
Date: Thu, 17 Nov 2011 17:20:40 -0500
Message-Id: <1321568442-22758-2-git-send-email-linville@tuxdriver.com> (sfid-20111117_232237_263819_7CCD4E1D)
In-Reply-To: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
References: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some kernels have versions of (struct bin_attribute)->{read,write}
that require a struct file * as their first argument.  This change
accommodates them in the firmware loader class.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 compat/compat_firmware_class.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index 79cd543..4eb5ba7 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -314,9 +314,15 @@ static ssize_t firmware_loading_store(struct device *dev,
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
+#if defined(CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP)
+static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buffer, loff_t offset, size_t count)
+#else
 static ssize_t firmware_data_read(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
+#endif
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
@@ -407,9 +413,15 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
  *	Data written to the 'data' attribute will be later handed to
  *	the driver as a firmware image.
  **/
+#if defined(CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP)
+static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t offset, size_t count)
+#else
 static ssize_t firmware_data_write(struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t offset, size_t count)
+#endif
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
-- 
1.7.4.4


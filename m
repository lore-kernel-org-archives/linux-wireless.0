Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52503 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbcG1IFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:33 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 3/8] firmware: Factor out firmware load helpers
Date: Thu, 28 Jul 2016 09:55:07 +0200
Message-Id: <1469692512-16863-4-git-send-email-wagi@monom.org> (sfid-20160728_100601_807028_7957B70D)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Factor out the firmware loading synchronization code in order to allow
drivers to reuse it. This also documents more clearly what is
happening. This is especial useful the drivers which will be converted
afterwards. Not everyone has to come with yet another way to handle it.

We use swait instead completion. complete() would only wake up one
waiter, so complete_all() is used. complete_all() wakes max MAX_UINT/2
waiters which is plenty in all cases. Though withh swait we just wait
until the exptected status shows up and wake any waiter.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/base/firmware_class.c | 112 +++++++++++++++++++-----------------------
 include/linux/firmware.h      |  71 ++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 61 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 773fc30..bf1ca70 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -30,6 +30,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
 #include <linux/security.h>
+#include <linux/swait.h>
 
 #include <generated/utsrelease.h>
 
@@ -85,11 +86,36 @@ static inline bool fw_is_builtin_firmware(const struct firmware *fw)
 }
 #endif
 
-enum {
-	FW_STATUS_LOADING,
-	FW_STATUS_DONE,
-	FW_STATUS_ABORT,
-};
+
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
+
+static inline bool is_fw_sync_done(unsigned long status)
+{
+	return status == FW_STATUS_LOADED || status == FW_STATUS_ABORT;
+}
+
+int __firmware_stat_wait(struct firmware_stat *fwst,
+				long timeout)
+{
+	int err;
+	err = swait_event_interruptible_timeout(fwst->wq,
+				is_fw_sync_done(READ_ONCE(fwst->status)),
+				timeout);
+	if (err == 0 && fwst->status == FW_STATUS_ABORT)
+		return -ENOENT;
+
+	return err;
+}
+EXPORT_SYMBOL(__firmware_stat_wait);
+
+void __firmware_stat_set(struct firmware_stat *fwst, unsigned long status)
+{
+	WRITE_ONCE(fwst->status, status);
+	swake_up(&fwst->wq);
+}
+EXPORT_SYMBOL(__firmware_stat_set);
+
+#endif
 
 static int loading_timeout = 60;	/* In seconds */
 
@@ -138,9 +164,8 @@ struct firmware_cache {
 struct firmware_buf {
 	struct kref ref;
 	struct list_head list;
-	struct completion completion;
+	struct firmware_stat fwst;
 	struct firmware_cache *fwc;
-	unsigned long status;
 	void *data;
 	size_t size;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
@@ -194,7 +219,7 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 
 	kref_init(&buf->ref);
 	buf->fwc = fwc;
-	init_completion(&buf->completion);
+	firmware_stat_init(&buf->fwst);
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	INIT_LIST_HEAD(&buf->pending_list);
 #endif
@@ -292,15 +317,6 @@ static const char * const fw_path[] = {
 module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
 MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
 
-static void fw_finish_direct_load(struct device *device,
-				  struct firmware_buf *buf)
-{
-	mutex_lock(&fw_lock);
-	set_bit(FW_STATUS_DONE, &buf->status);
-	complete_all(&buf->completion);
-	mutex_unlock(&fw_lock);
-}
-
 static int fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
@@ -339,7 +355,7 @@ static int fw_get_filesystem_firmware(struct device *device,
 		}
 		dev_dbg(device, "direct-loading %s\n", buf->fw_id);
 		buf->size = size;
-		fw_finish_direct_load(device, buf);
+		fw_loading_done(buf->fwst);
 		break;
 	}
 	__putname(path);
@@ -457,12 +473,11 @@ static void __fw_load_abort(struct firmware_buf *buf)
 	 * There is a small window in which user can write to 'loading'
 	 * between loading done and disappearance of 'loading'
 	 */
-	if (test_bit(FW_STATUS_DONE, &buf->status))
+	if (is_fw_loading_done(buf->fwst))
 		return;
 
 	list_del_init(&buf->pending_list);
-	set_bit(FW_STATUS_ABORT, &buf->status);
-	complete_all(&buf->completion);
+	fw_loading_abort(buf->fwst);
 }
 
 static void fw_load_abort(struct firmware_priv *fw_priv)
@@ -475,9 +490,6 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 	fw_priv->buf = NULL;
 }
 
-#define is_fw_load_aborted(buf)	\
-	test_bit(FW_STATUS_ABORT, &(buf)->status)
-
 static LIST_HEAD(pending_fw_head);
 
 /* reboot notifier for avoid deadlock with usermode_lock */
@@ -577,7 +589,7 @@ static ssize_t firmware_loading_show(struct device *dev,
 
 	mutex_lock(&fw_lock);
 	if (fw_priv->buf)
-		loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
+		loading = is_fw_loading(fw_priv->buf->fwst);
 	mutex_unlock(&fw_lock);
 
 	return sprintf(buf, "%d\n", loading);
@@ -632,23 +644,20 @@ static ssize_t firmware_loading_store(struct device *dev,
 	switch (loading) {
 	case 1:
 		/* discarding any previous partial load */
-		if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
+		if (!is_fw_loading_done(fw_buf->fwst)) {
 			for (i = 0; i < fw_buf->nr_pages; i++)
 				__free_page(fw_buf->pages[i]);
 			vfree(fw_buf->pages);
 			fw_buf->pages = NULL;
 			fw_buf->page_array_size = 0;
 			fw_buf->nr_pages = 0;
-			set_bit(FW_STATUS_LOADING, &fw_buf->status);
+			fw_loading_start(fw_buf->fwst);
 		}
 		break;
 	case 0:
-		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
+		if (is_fw_loading(fw_buf->fwst)) {
 			int rc;
 
-			set_bit(FW_STATUS_DONE, &fw_buf->status);
-			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
-
 			/*
 			 * Several loading requests may be pending on
 			 * one same firmware buf, so let all requests
@@ -670,10 +679,11 @@ static ssize_t firmware_loading_store(struct device *dev,
 			 */
 			list_del_init(&fw_buf->pending_list);
 			if (rc) {
-				set_bit(FW_STATUS_ABORT, &fw_buf->status);
+				fw_loading_abort(fw_buf->fwst);
 				written = rc;
+			} else {
+				fw_loading_done(fw_buf->fwst);
 			}
-			complete_all(&fw_buf->completion);
 			break;
 		}
 		/* fallthrough */
@@ -681,7 +691,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
-		fw_load_abort(fw_priv);
+		fw_loading_abort(fw_buf->fwst);
 		break;
 	}
 out:
@@ -702,7 +712,7 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
 
 	mutex_lock(&fw_lock);
 	buf = fw_priv->buf;
-	if (!buf || test_bit(FW_STATUS_DONE, &buf->status)) {
+	if (!buf || is_fw_loading_done(buf->fwst)) {
 		ret_count = -ENODEV;
 		goto out;
 	}
@@ -799,7 +809,7 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
 
 	mutex_lock(&fw_lock);
 	buf = fw_priv->buf;
-	if (!buf || test_bit(FW_STATUS_DONE, &buf->status)) {
+	if (!buf || is_fw_loading_done(buf->fwst)) {
 		retval = -ENODEV;
 		goto out;
 	}
@@ -917,8 +927,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		timeout = MAX_JIFFY_OFFSET;
 	}
 
-	retval = wait_for_completion_interruptible_timeout(&buf->completion,
-			timeout);
+	retval = fw_loading_wait_timeout(buf->fwst, timeout);
 	if (retval == -ERESTARTSYS || !retval) {
 		mutex_lock(&fw_lock);
 		fw_load_abort(fw_priv);
@@ -927,7 +936,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		retval = 0;
 	}
 
-	if (is_fw_load_aborted(buf))
+	if (is_fw_loading_aborted(buf->fwst))
 		retval = -EAGAIN;
 	else if (!buf->data)
 		retval = -ENOMEM;
@@ -986,26 +995,6 @@ static inline void kill_requests_without_uevent(void) { }
 
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
-
-/* wait until the shared firmware_buf becomes ready (or error) */
-static int sync_cached_firmware_buf(struct firmware_buf *buf)
-{
-	int ret = 0;
-
-	mutex_lock(&fw_lock);
-	while (!test_bit(FW_STATUS_DONE, &buf->status)) {
-		if (is_fw_load_aborted(buf)) {
-			ret = -ENOENT;
-			break;
-		}
-		mutex_unlock(&fw_lock);
-		ret = wait_for_completion_interruptible(&buf->completion);
-		mutex_lock(&fw_lock);
-	}
-	mutex_unlock(&fw_lock);
-	return ret;
-}
-
 /* prepare firmware and firmware_buf structs;
  * return 0 if a firmware is already assigned, 1 if need to load one,
  * or a negative error code
@@ -1039,7 +1028,8 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 	firmware->priv = buf;
 
 	if (ret > 0) {
-		ret = sync_cached_firmware_buf(buf);
+		ret = fw_loading_wait_timeout(buf->fwst,
+					      firmware_loading_timeout());
 		if (!ret) {
 			fw_set_page_data(buf, firmware);
 			return 0; /* assigned */
@@ -1057,7 +1047,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
 	struct firmware_buf *buf = fw->priv;
 
 	mutex_lock(&fw_lock);
-	if (!buf->size || is_fw_load_aborted(buf)) {
+	if (!buf->size || is_fw_loading_aborted(buf->fwst)) {
 		mutex_unlock(&fw_lock);
 		return -ENOENT;
 	}
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5c41c5e..f584160 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -4,10 +4,17 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/gfp.h>
+#include <linux/swait.h>
 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
 
+enum {
+	FW_STATUS_LOADING,
+	FW_STATUS_LOADED,
+	FW_STATUS_ABORT,
+};
+
 struct firmware {
 	size_t size;
 	const u8 *data;
@@ -17,6 +24,11 @@ struct firmware {
 	void *priv;
 };
 
+struct firmware_stat {
+	unsigned long status;
+	struct swait_queue_head wq;
+};
+
 struct module;
 struct device;
 
@@ -49,6 +61,36 @@ int request_firmware_direct(const struct firmware **fw, const char *name,
 			    struct device *device);
 
 void release_firmware(const struct firmware *fw);
+
+static inline void firmware_stat_init(struct firmware_stat *fwst)
+{
+	init_swait_queue_head(&fwst->wq);
+}
+
+static inline unsigned long __firmware_stat_get(struct firmware_stat *fwst)
+{
+	return READ_ONCE(fwst->status);
+}
+void __firmware_stat_set(struct firmware_stat *fwst, unsigned long status);
+int __firmware_stat_wait(struct firmware_stat *fwst, long timeout);
+
+#define fw_loading_start(fwst)					\
+	__firmware_stat_set(&fwst, FW_STATUS_LOADING)
+#define fw_loading_done(fwst)					\
+	__firmware_stat_set(&fwst, FW_STATUS_LOADED)
+#define fw_loading_abort(fwst)					\
+	__firmware_stat_set(&fwst, FW_STATUS_ABORT)
+#define fw_loading_wait(fwst)					\
+	__firmware_stat_wait(&fwst, 0)
+#define fw_loading_wait_timeout(fwst, timeout)			\
+	__firmware_stat_wait(&fwst, timeout)
+#define is_fw_loading(fwst)					\
+	(__firmware_stat_get(&fwst) == FW_STATUS_LOADING)
+#define is_fw_loading_done(fwst)				\
+	(__firmware_stat_get(&fwst) == FW_STATUS_LOADED)
+#define is_fw_loading_aborted(fwst)				\
+	(__firmware_stat_get(&fwst) == FW_STATUS_ABORT)
+
 #else
 static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
@@ -75,5 +117,34 @@ static inline int request_firmware_direct(const struct firmware **fw,
 	return -EINVAL;
 }
 
+static inline void firmware_stat_init(struct firmware_stat *fwst)
+{
+}
+
+static inline unsigned long __firmware_stat_get(struct firmware_stat *fwst)
+{
+	return -EINVAL;
+}
+
+static inline void __firmware_stat_set(struct firmware_stat *fwst,
+				       unsigned long status)
+{
+}
+
+static inline int __firmware_stat_wait(struct firmware_stat *fwst,
+				       long timeout)
+{
+	return -EINVAL;
+}
+
+#define fw_loading_start(fwst)
+#define fw_loading_done(fwst)
+#define fw_loading_abort(fwst)
+#define fw_loading_wait(fwst)
+#define fw_loading_wait_timeout(fwst, timeout)
+#define is_fw_loading(fwst)		0
+#define is_fw_loading_done(fwst)	0
+#define is_fw_loading_aborted(fwst)	0
+
 #endif
 #endif
-- 
2.7.4

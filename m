Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51983 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762645Ab0HGNdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:33:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: update compat_firmware_class.c
Date: Sat,  7 Aug 2010 15:32:21 +0200
Message-Id: <1281187941-7168-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refresh code based on recent version in linux-next.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat_firmware_class.c |  290 ++++++++++++++++++++-------------------
 1 files changed, 149 insertions(+), 141 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index 02f38a2..70ab25c 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -88,27 +88,31 @@ static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
 	struct completion completion;
-	struct bin_attribute attr_data;
 	struct firmware *fw;
 	unsigned long status;
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
 	struct timer_list timeout;
+	struct device dev;
 	bool nowait;
 	char fw_id[];
 };
 
-static void
-fw_load_abort(struct firmware_priv *fw_priv)
+static struct firmware_priv *to_firmware_priv(struct device *dev)
+{
+	return container_of(dev, struct firmware_priv, dev);
+}
+
+static void fw_load_abort(struct firmware_priv *fw_priv)
 {
 	set_bit(FW_STATUS_ABORT, &fw_priv->status);
 	wmb();
 	complete(&fw_priv->completion);
 }
 
-static ssize_t
-firmware_timeout_show(struct class *class, char *buf)
+static ssize_t firmware_timeout_show(struct class *class,
+				     char *buf)
 {
 	return sprintf(buf, "%d\n", loading_timeout);
 }
@@ -125,12 +129,13 @@ firmware_timeout_show(struct class *class, char *buf)
  *
  *	Note: zero means 'wait forever'.
  **/
-static ssize_t
-firmware_timeout_store(struct class *class, const char *buf, size_t count)
+static ssize_t firmware_timeout_store(struct class *class,
+				      const char *buf, size_t count)
 {
 	loading_timeout = simple_strtol(buf, NULL, 10);
 	if (loading_timeout < 0)
 		loading_timeout = 0;
+
 	return count;
 }
 
@@ -142,14 +147,13 @@ static struct class_attribute firmware_class_attrs[] = {
 
 static void fw_dev_release(struct device *dev)
 {
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	int i;
 
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kfree(fw_priv->pages);
 	kfree(fw_priv);
-	kfree(dev);
 
 	module_put(THIS_MODULE);
 }
@@ -157,7 +161,7 @@ static void fw_dev_release(struct device *dev)
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 
 	if (add_uevent_var(env, "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
@@ -172,7 +176,7 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int firmware_uevent(struct device *dev, char **envp,
 			   int num_envp, char *buf, int size)
 {
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	int error, len = 0, i = 0;
 
 	error = add_uevent_var(envp, num_envp, &i,
@@ -209,11 +213,27 @@ static struct class firmware_class = {
 static ssize_t firmware_loading_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	int loading = test_bit(FW_STATUS_LOADING, &fw_priv->status);
+
 	return sprintf(buf, "%d\n", loading);
 }
 
+static void firmware_free_data(const struct firmware *fw)
+{
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+	int i;
+	vunmap(fw->data);
+	if (fw->pages) {
+		for (i = 0; i < PFN_UP(fw->size); i++)
+			__free_page(fw->pages[i]);
+		kfree(fw->pages);
+	}
+#else
+	vunmap(fw->data);
+#endif
+}
+
 /* Some architectures don't have PAGE_KERNEL_RO */
 #ifndef PAGE_KERNEL_RO
 #define PAGE_KERNEL_RO PAGE_KERNEL
@@ -221,7 +241,6 @@ static ssize_t firmware_loading_show(struct device *dev,
 /**
  * firmware_loading_store - set value in the 'loading' control file
  * @dev: device pointer
- * @attr: device attribute pointer
  * @buf: buffer to scan for loading control value
  * @count: number of bytes in @buf
  *
@@ -235,7 +254,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
@@ -246,21 +265,21 @@ static ssize_t firmware_loading_store(struct device *dev,
 			mutex_unlock(&fw_lock);
 			break;
 		}
-		vfree(fw_priv->fw->data);
-		fw_priv->fw->data = NULL;
+		firmware_free_data(fw_priv->fw);
+		memset(fw_priv->fw, 0, sizeof(struct firmware));
+		/* If the pages are not owned by 'struct firmware' */
 		for (i = 0; i < fw_priv->nr_pages; i++)
 			__free_page(fw_priv->pages[i]);
 		kfree(fw_priv->pages);
 		fw_priv->pages = NULL;
 		fw_priv->page_array_size = 0;
 		fw_priv->nr_pages = 0;
-		fw_priv->fw->size = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
 		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
-			vfree(fw_priv->fw->data);
+			vunmap(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
@@ -268,7 +287,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 				dev_err(dev, "%s: vmap() failed\n", __func__);
 				goto err;
 			}
-			/* Pages will be freed by vfree() */
+			/* Pages are now owned by 'struct firmware' */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+			fw_priv->fw->pages = fw_priv->pages;
+			fw_priv->pages = NULL;
+#endif
+
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
@@ -290,12 +314,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
-static ssize_t
-firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
-		   char *buffer, loff_t offset, size_t count)
+static ssize_t firmware_data_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t ret_count;
 
@@ -334,8 +358,7 @@ out:
 	return ret_count;
 }
 
-static int
-fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
+static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 {
 	int pages_needed = ALIGN(min_size, PAGE_SIZE) >> PAGE_SHIFT;
 
@@ -384,12 +407,12 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
  *	Data written to the 'data' attribute will be later handed to
  *	the driver as a firmware image.
  **/
-static ssize_t
-firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
-		    char *buffer, loff_t offset, size_t count)
+static ssize_t firmware_data_write(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t retval;
 
@@ -430,116 +453,103 @@ out:
 	return retval;
 }
 
-static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644},
+static struct bin_attribute firmware_attr_data = {
+	.attr = { .name = "data", .mode = 0644 },
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
 };
 
-static void
-firmware_class_timeout(u_long data)
+static void firmware_class_timeout(u_long data)
 {
 	struct firmware_priv *fw_priv = (struct firmware_priv *) data;
+
 	fw_load_abort(fw_priv);
 }
 
-static int fw_register_device(struct device **dev_p, const char *fw_name,
-			      struct device *device)
+static struct firmware_priv *
+fw_create_instance(struct firmware *firmware, const char *fw_name,
+		   struct device *device, bool uevent, bool nowait)
 {
-	int retval;
-	struct firmware_priv *fw_priv =
-		kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
-	struct device *f_dev = kzalloc(sizeof(*f_dev), GFP_KERNEL);
-
-	*dev_p = NULL;
+	struct firmware_priv *fw_priv;
+	struct device *f_dev;
+	int error;
 
-	if (!fw_priv || !f_dev) {
+	fw_priv = kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
+	if (!fw_priv) {
 		dev_err(device, "%s: kmalloc failed\n", __func__);
-		retval = -ENOMEM;
-		goto error_kfree;
+		error = -ENOMEM;
+		goto err_out;
 	}
 
+	fw_priv->fw = firmware;
+	fw_priv->nowait = nowait;
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
-	fw_priv->attr_data = firmware_attr_data_tmpl;
-	fw_priv->timeout.function = firmware_class_timeout;
-	fw_priv->timeout.data = (u_long) fw_priv;
-	init_timer(&fw_priv->timeout);
+	setup_timer(&fw_priv->timeout,
+		    firmware_class_timeout, (u_long) fw_priv);
 
+	f_dev = &fw_priv->dev;
+
+	device_initialize(f_dev);
 	dev_set_name(f_dev, "%s", dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
-	dev_set_drvdata(f_dev, fw_priv);
-	dev_set_uevent_suppress(f_dev, 1);
-	retval = device_register(f_dev);
-	if (retval) {
-		dev_err(device, "%s: device_register failed\n", __func__);
-		put_device(f_dev);
-		return retval;
-	}
-	*dev_p = f_dev;
-	return 0;
-
-error_kfree:
-	kfree(f_dev);
-	kfree(fw_priv);
-	return retval;
-}
 
-static int fw_setup_device(struct firmware *fw, struct device **dev_p,
-			   const char *fw_name, struct device *device,
-			   int uevent, bool nowait)
-{
-	struct device *f_dev;
-	struct firmware_priv *fw_priv;
-	int retval;
-
-	*dev_p = NULL;
-	retval = fw_register_device(&f_dev, fw_name, device);
-	if (retval)
-		goto out;
+	dev_set_uevent_suppress(f_dev, true);
 
 	/* Need to pin this module until class device is destroyed */
 	__module_get(THIS_MODULE);
 
-	fw_priv = dev_get_drvdata(f_dev);
-
-	fw_priv->nowait = nowait;
+	error = device_add(f_dev);
+	if (error) {
+		dev_err(device, "%s: device_register failed\n", __func__);
+		goto err_put_dev;
+	}
 
-	fw_priv->fw = fw;
-	sysfs_bin_attr_init(&fw_priv->attr_data);
-	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
-	if (retval) {
+	error = device_create_bin_file(f_dev, &firmware_attr_data);
+	if (error) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
-		goto error_unreg;
+		goto err_del_dev;
 	}
 
-	retval = device_create_file(f_dev, &dev_attr_loading);
-	if (retval) {
+	error = device_create_file(f_dev, &dev_attr_loading);
+	if (error) {
 		dev_err(device, "%s: device_create_file failed\n", __func__);
-		goto error_unreg;
+		goto err_del_bin_attr;
 	}
 
 	if (uevent)
-		dev_set_uevent_suppress(f_dev, 0);
-	*dev_p = f_dev;
-	goto out;
+		dev_set_uevent_suppress(f_dev, false);
+
+	return fw_priv;
+
+err_del_bin_attr:
+	device_remove_bin_file(f_dev, &firmware_attr_data);
+err_del_dev:
+	device_del(f_dev);
+err_put_dev:
+	put_device(f_dev);
+err_out:
+	return ERR_PTR(error);
+}
+
+static void fw_destroy_instance(struct firmware_priv *fw_priv)
+{
+	struct device *f_dev = &fw_priv->dev;
 
-error_unreg:
+	device_remove_file(f_dev, &dev_attr_loading);
+	device_remove_bin_file(f_dev, &firmware_attr_data);
 	device_unregister(f_dev);
-out:
-	return retval;
 }
 
-static int
-_request_firmware(const struct firmware **firmware_p, const char *name,
-		 struct device *device, int uevent, bool nowait)
+static int _request_firmware(const struct firmware **firmware_p,
+			     const char *name, struct device *device,
+			     bool uevent, bool nowait)
 {
-	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	int retval;
+	int retval = 0;
 
 	if (!firmware_p)
 		return -EINVAL;
@@ -560,41 +570,40 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (uevent)
 		dev_dbg(device, "firmware: requesting %s\n", name);
 
-	retval = fw_setup_device(firmware, &f_dev, name, device,
-				 uevent, nowait);
-	if (retval)
-		goto error_kfree_fw;
-
-	fw_priv = dev_get_drvdata(f_dev);
+	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
+	if (IS_ERR(fw_priv)) {
+		retval = PTR_ERR(fw_priv);
+		goto out;
+	}
 
 	if (uevent) {
-		if (loading_timeout > 0) {
-			fw_priv->timeout.expires = jiffies + loading_timeout * HZ;
-			add_timer(&fw_priv->timeout);
-		}
+		if (loading_timeout > 0)
+			mod_timer(&fw_priv->timeout,
+				  round_jiffies_up(jiffies +
+						   loading_timeout * HZ));
+
+		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
+	}
+
+	wait_for_completion(&fw_priv->completion);
 
-		kobject_uevent(&f_dev->kobj, KOBJ_ADD);
-		wait_for_completion(&fw_priv->completion);
-		set_bit(FW_STATUS_DONE, &fw_priv->status);
-		del_timer_sync(&fw_priv->timeout);
-	} else
-		wait_for_completion(&fw_priv->completion);
+	set_bit(FW_STATUS_DONE, &fw_priv->status);
+	del_timer_sync(&fw_priv->timeout);
 
 	mutex_lock(&fw_lock);
-	if (!fw_priv->fw->size || test_bit(FW_STATUS_ABORT, &fw_priv->status)) {
+	if (!fw_priv->fw->size || test_bit(FW_STATUS_ABORT, &fw_priv->status))
 		retval = -ENOENT;
-		release_firmware(fw_priv->fw);
-		*firmware_p = NULL;
-	}
 	fw_priv->fw = NULL;
 	mutex_unlock(&fw_lock);
-	device_unregister(f_dev);
-	goto out;
 
-error_kfree_fw:
-	kfree(firmware);
-	*firmware_p = NULL;
+	fw_destroy_instance(fw_priv);
+
 out:
+	if (retval) {
+		release_firmware(firmware);
+		firmware_p = NULL;
+	}
+
 	return retval;
 }
 
@@ -629,8 +638,7 @@ void release_firmware(const struct firmware *fw)
 {
 	if (fw) {
 		if (!fw_is_builtin_firmware(fw))
-			vfree(fw->data);
-
+			firmware_free_data(fw);
 		kfree(fw);
 	}
 }
@@ -646,23 +654,24 @@ struct firmware_work {
 	int uevent;
 };
 
-static int
-request_firmware_work_func(void *arg)
+static int request_firmware_work_func(void *arg)
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
 	int ret;
+
 	if (!arg) {
 		WARN_ON(1);
 		return 0;
 	}
-	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
-		fw_work->uevent, true);
 
+	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
+				fw_work->uevent, true);
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
 	kfree(fw_work);
+
 	return ret;
 }
 
@@ -690,34 +699,33 @@ request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context))
 {
 	struct task_struct *task;
-	struct firmware_work *fw_work = kmalloc(sizeof (struct firmware_work),
-						gfp);
+	struct firmware_work *fw_work;
 
+	fw_work = kzalloc(sizeof (struct firmware_work), gfp);
 	if (!fw_work)
 		return -ENOMEM;
+
+	fw_work->module = module;
+	fw_work->name = name;
+	fw_work->device = device;
+	fw_work->context = context;
+	fw_work->cont = cont;
+	fw_work->uevent = uevent;
+
 	if (!try_module_get(module)) {
 		kfree(fw_work);
 		return -EFAULT;
 	}
 
-	*fw_work = (struct firmware_work) {
-		.module = module,
-		.name = name,
-		.device = device,
-		.context = context,
-		.cont = cont,
-		.uevent = uevent,
-	};
-
 	task = kthread_run(request_firmware_work_func, fw_work,
 			    "firmware/%s", name);
-
 	if (IS_ERR(task)) {
 		fw_work->cont(NULL, fw_work->context);
 		module_put(fw_work->module);
 		kfree(fw_work);
 		return PTR_ERR(task);
 	}
+
 	return 0;
 }
 
-- 
1.7.0.4


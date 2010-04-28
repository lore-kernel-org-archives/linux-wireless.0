Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50221 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0D1V2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:28:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: update compat_firmware_class.c to new version
Date: Wed, 28 Apr 2010 23:28:11 +0200
Message-Id: <1272490092-31341-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat_firmware_class.c |  191 +++++++++++++++++++++-------------------
 include/linux/compat-2.6.30.h  |    7 ++
 include/linux/compat-2.6.34.h  |   33 +++++++
 3 files changed, 140 insertions(+), 91 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index 54ee8b9..02f38a2 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
@@ -26,6 +27,53 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+/* Builtin firmware support */
+
+//#ifdef CONFIG_FW_LOADER
+#if 0
+
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+
+static bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++) {
+		if (strcmp(name, b_fw->name) == 0) {
+			fw->size = b_fw->size;
+			fw->data = b_fw->data;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++)
+		if (fw->data == b_fw->data)
+			return true;
+
+	return false;
+}
+
+#else /* Module case - no builtin firmware support */
+
+static inline bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	return false;
+}
+
+static inline bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	return false;
+}
+#endif
+
 enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
@@ -39,7 +87,6 @@ static int loading_timeout = 60;	/* In seconds */
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char *fw_id;
 	struct completion completion;
 	struct bin_attribute attr_data;
 	struct firmware *fw;
@@ -47,19 +94,11 @@ struct firmware_priv {
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
-	const char *vdata;
 	struct timer_list timeout;
+	bool nowait;
+	char fw_id[];
 };
 
-//#ifdef CONFIG_FW_LOADER
-#if 0
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
-#else /* Module case. Avoid ifdefs later; it'll all optimise out */
-static struct builtin_fw *__start_builtin_fw;
-static struct builtin_fw *__end_builtin_fw;
-#endif
-
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -95,9 +134,25 @@ firmware_timeout_store(struct class *class, const char *buf, size_t count)
 	return count;
 }
 
-static CLASS_ATTR(timeout, 0644, firmware_timeout_show, firmware_timeout_store);
+static struct class_attribute firmware_class_attrs[] = {
+	__ATTR(timeout, S_IWUSR | S_IRUGO,
+		firmware_timeout_show, firmware_timeout_store),
+	__ATTR_NULL
+};
+
+static void fw_dev_release(struct device *dev)
+{
+	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < fw_priv->nr_pages; i++)
+		__free_page(fw_priv->pages[i]);
+	kfree(fw_priv->pages);
+	kfree(fw_priv);
+	kfree(dev);
 
-static void fw_dev_release(struct device *dev);
+	module_put(THIS_MODULE);
+}
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -108,6 +163,8 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return -ENOMEM;
 	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
 		return -ENOMEM;
+	if (add_uevent_var(env, "ASYNC=%d", fw_priv->nowait))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -129,6 +186,11 @@ static int firmware_uevent(struct device *dev, char **envp,
 			       "TIMEOUT=%i", loading_timeout);
 	if (error)
 		goto exit;
+	error = add_uevent_var(envp, num_envp, &i,
+			       buf, size, &len,
+			       "ASYNC=%i", fw_priv->nowait);
+	if (error)
+		goto exit;
 
 	return 0;
 exit:
@@ -139,6 +201,7 @@ exit:
 
 static struct class firmware_class = {
 	.name		= "compat_firmware",
+	.class_attrs	= firmware_class_attrs,
 	.dev_uevent	= firmware_uevent,
 	.dev_release	= fw_dev_release,
 };
@@ -374,21 +437,6 @@ static struct bin_attribute firmware_attr_data_tmpl = {
 	.write = firmware_data_write,
 };
 
-static void fw_dev_release(struct device *dev)
-{
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
-	int i;
-
-	for (i = 0; i < fw_priv->nr_pages; i++)
-		__free_page(fw_priv->pages[i]);
-	kfree(fw_priv->pages);
-	kfree(fw_priv->fw_id);
-	kfree(fw_priv);
-	kfree(dev);
-
-	module_put(THIS_MODULE);
-}
-
 static void
 firmware_class_timeout(u_long data)
 {
@@ -400,8 +448,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 			      struct device *device)
 {
 	int retval;
-	struct firmware_priv *fw_priv = kzalloc(sizeof(*fw_priv),
-						GFP_KERNEL);
+	struct firmware_priv *fw_priv =
+		kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
 	struct device *f_dev = kzalloc(sizeof(*f_dev), GFP_KERNEL);
 
 	*dev_p = NULL;
@@ -412,16 +460,9 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 		goto error_kfree;
 	}
 
+	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
 	fw_priv->attr_data = firmware_attr_data_tmpl;
-	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
-	if (!fw_priv->fw_id) {
-		dev_err(device, "%s: Firmware name allocation failed\n",
-			__func__);
-		retval = -ENOMEM;
-		goto error_kfree;
-	}
-
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
@@ -430,11 +471,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 	dev_set_uevent_suppress(f_dev, 1);
-#else
-	f_dev->uevent_suppress = 1;
-#endif
 	retval = device_register(f_dev);
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
@@ -452,7 +489,7 @@ error_kfree:
 
 static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 			   const char *fw_name, struct device *device,
-			   int uevent)
+			   int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
@@ -468,7 +505,10 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 
 	fw_priv = dev_get_drvdata(f_dev);
 
+	fw_priv->nowait = nowait;
+
 	fw_priv->fw = fw;
+	sysfs_bin_attr_init(&fw_priv->attr_data);
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
@@ -482,11 +522,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	}
 
 	if (uevent)
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 		dev_set_uevent_suppress(f_dev, 0);
-#else
-		f_dev->uevent_suppress = 0;
-#endif
 	*dev_p = f_dev;
 	goto out;
 
@@ -498,12 +534,11 @@ out:
 
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-		 struct device *device, int uevent)
+		 struct device *device, int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	struct builtin_fw *builtin;
 	int retval;
 
 	if (!firmware_p)
@@ -517,21 +552,16 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
-	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-	     builtin++) {
-		if (strcmp(name, builtin->name))
-			continue;
-		dev_info(device, "firmware: using built-in firmware %s\n",
-			 name);
-		firmware->size = builtin->size;
-		firmware->data = builtin->data;
+	if (fw_get_builtin_firmware(firmware, name)) {
+		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
 		return 0;
 	}
 
 	if (uevent)
-		dev_info(device, "firmware: requesting %s\n", name);
+		dev_dbg(device, "firmware: requesting %s\n", name);
 
-	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
+	retval = fw_setup_device(firmware, &f_dev, name, device,
+				 uevent, nowait);
 	if (retval)
 		goto error_kfree_fw;
 
@@ -588,26 +618,19 @@ request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
         int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent);
+        return _request_firmware(firmware_p, name, device, uevent, false);
 }
 
 /**
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
-void
-release_firmware(const struct firmware *fw)
+void release_firmware(const struct firmware *fw)
 {
-	struct builtin_fw *builtin;
-
 	if (fw) {
-		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-		     builtin++) {
-			if (fw->data == builtin->data)
-				goto free_fw;
-		}
-		vfree(fw->data);
-	free_fw:
+		if (!fw_is_builtin_firmware(fw))
+			vfree(fw->data);
+
 		kfree(fw);
 	}
 }
@@ -634,7 +657,7 @@ request_firmware_work_func(void *arg)
 		return 0;
 	}
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
-		fw_work->uevent);
+		fw_work->uevent, true);
 
 	fw_work->cont(fw, fw_work->context);
 
@@ -644,7 +667,7 @@ request_firmware_work_func(void *arg)
 }
 
 /**
- * request_firmware_nowait: asynchronous version of request_firmware
+ * request_firmware_nowait - asynchronous version of request_firmware
  * @module: module requesting the firmware
  * @uevent: sends uevent to copy the firmware image if this flag
  *	is non-zero else the firmware copy must be done manually.
@@ -698,26 +721,12 @@ request_firmware_nowait(
 	return 0;
 }
 
-static int __init
-firmware_class_init(void)
+static int __init firmware_class_init(void)
 {
-	int error;
-	error = class_register(&firmware_class);
-	if (error) {
-		printk(KERN_ERR "%s: class_register failed\n", __func__);
-		return error;
-	}
-	error = class_create_file(&firmware_class, &class_attr_timeout);
-	if (error) {
-		printk(KERN_ERR "%s: class_create_file failed\n",
-		       __func__);
-		class_unregister(&firmware_class);
-	}
-	return error;
-
+	return class_register(&firmware_class);
 }
-static void __exit
-firmware_class_exit(void)
+
+static void __exit firmware_class_exit(void)
 {
 	class_unregister(&firmware_class);
 }
diff --git a/include/linux/compat-2.6.30.h b/include/linux/compat-2.6.30.h
index f997d86..eface8c 100644
--- a/include/linux/compat-2.6.30.h
+++ b/include/linux/compat-2.6.30.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 
+#include <linux/device.h>
+
 #ifndef TP_PROTO
 #define TP_PROTO(args...)	TPPROTO(args)
 #endif
@@ -23,6 +25,11 @@ enum dpm_order {
 	DPM_ORDER_DEV_LAST,
 };
 
+static inline void dev_set_uevent_suppress(struct device *dev, int val)
+{
+	dev->uevent_suppress = val;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
 
 #endif /* LINUX_26_30_COMPAT_H */
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 736a2f0..18ae456 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -164,6 +164,39 @@ static inline void device_unlock(struct device *dev)
 
 #define rcu_dereference_check(p, c) rcu_dereference(p)
 
+/**
+ *	sysfs_attr_init - initialize a dynamically allocated sysfs attribute
+ *	@attr: struct attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct attribute so we can
+ *	make lockdep happy.  This is a new requirement for attributes
+ *	and initially this is only needed when lockdep is enabled.
+ *	Lockdep gives a nice error when your attribute is added to
+ *	sysfs if you don't have this.
+ */
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define sysfs_attr_init(attr)				\
+do {							\
+	static struct lock_class_key __key;		\
+							\
+	(attr)->key = &__key;				\
+} while(0)
+#else
+#define sysfs_attr_init(attr) do {} while(0)
+#endif
+
+/**
+ *	sysfs_bin_attr_init - initialize a dynamically allocated bin_attribute
+ *	@attr: struct bin_attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct bin_attribute so we
+ *	can make lockdep happy.  This is a new requirement for
+ *	attributes and initially this is only needed when lockdep is
+ *	enabled.  Lockdep gives a nice error when your attribute is
+ *	added to sysfs if you don't have this.
+ */
+#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.6.3.3


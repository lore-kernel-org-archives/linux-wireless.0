Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53675 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934102AbZHHMib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/7] [compat-2.6] Clean up compat-2.6.26.c
Date: Sat,  8 Aug 2009 14:38:13 +0200
Message-Id: <1249735096-27071-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The exported methods are not used.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.26.c |  107 ------------------------------------------------
 1 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/compat/compat-2.6.26.c b/compat/compat-2.6.26.c
index 206e2f1..960a79a 100644
--- a/compat/compat-2.6.26.c
+++ b/compat/compat-2.6.26.c
@@ -19,75 +19,6 @@
 /* All things not in 2.6.25 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
 
-#include <linux/kobject.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/stat.h>
-#include <linux/slab.h>
-
-static void device_create_release(struct device *dev)
-{
-	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
-	kfree(dev);
-}
-
-/**
- * device_create_vargs - creates a device and registers it with sysfs
- * @class: pointer to the struct class that this device should be registered to
- * @parent: pointer to the parent struct device of this new device, if any
- * @devt: the dev_t for the char device to be added
- * @drvdata: the data to be added to the device for callbacks
- * @fmt: string for the device's name
- * @args: va_list for the device's name
- *
- * This function can be used by char device classes.  A struct device
- * will be created in sysfs, registered to the specified class.
- *
- * A "dev" file will be created, showing the dev_t for the device, if
- * the dev_t is not 0,0.
- * If a pointer to a parent struct device is passed in, the newly created
- * struct device will be a child of that device in sysfs.
- * The pointer to the struct device will be returned from the call.
- * Any further sysfs files that might be required can be created using this
- * pointer.
- *
- * Note: the struct class passed to this function must have previously
- * been created with a call to class_create().
- */
-struct device *device_create_vargs(struct class *class, struct device *parent,
-				   dev_t devt, void *drvdata, const char *fmt,
-				   va_list args)
-{
-	struct device *dev = NULL;
-	int retval = -ENODEV;
-
-	if (class == NULL || IS_ERR(class))
-		goto error;
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		retval = -ENOMEM;
-		goto error;
-	}
-
-	dev->devt = devt;
-	dev->class = class;
-	dev->parent = parent;
-	dev->release = device_create_release;
-	dev_set_drvdata(dev, drvdata);
-
-	vsnprintf(dev->bus_id, BUS_ID_SIZE, fmt, args);
-	retval = device_register(dev);
-	if (retval)
-		goto error;
-
-	return dev;
-
-error:
-	kfree(dev);
-	return ERR_PTR(retval);
-}
-EXPORT_SYMBOL_GPL(device_create_vargs);
 
 /**
  * kobject_set_name_vargs - Set the name of an kobject
@@ -134,43 +65,5 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
-
-/**
- * device_create_drvdata - creates a device and registers it with sysfs
- * @class: pointer to the struct class that this device should be registered to
- * @parent: pointer to the parent struct device of this new device, if any
- * @devt: the dev_t for the char device to be added
- * @drvdata: the data to be added to the device for callbacks
- * @fmt: string for the device's name
- *
- * This function can be used by char device classes.  A struct device
- * will be created in sysfs, registered to the specified class.
- *
- * A "dev" file will be created, showing the dev_t for the device, if
- * the dev_t is not 0,0.
- * If a pointer to a parent struct device is passed in, the newly created
- * struct device will be a child of that device in sysfs.
- * The pointer to the struct device will be returned from the call.
- * Any further sysfs files that might be required can be created using this
- * pointer.
- *
- * Note: the struct class passed to this function must have previously
- * been created with a call to class_create().
- */
-struct device *device_create_drvdata(struct class *class,
-				     struct device *parent,
-				     dev_t devt,
-				     void *drvdata,
-				     const char *fmt, ...)
-{
-	va_list vargs;
-	struct device *dev;
-
-	va_start(vargs, fmt);
-	dev = device_create_vargs(class, parent, devt, drvdata, fmt, vargs);
-	va_end(vargs);
-	return dev;
-}
-EXPORT_SYMBOL_GPL(device_create_drvdata);
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26) */
 
-- 
1.6.2.1


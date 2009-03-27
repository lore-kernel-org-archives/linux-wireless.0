Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48432 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbZC0P6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:11 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/4] rfkill: prepare to export global states to userspace
Date: Fri, 27 Mar 2009 12:58:02 -0300
Message-Id: <1238169485-29298-2-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165814_193402_75789015)
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do some preparatory work in order to export the global states to userspace
through sysfs and uevents.

Add a platform device for use by rfkill (rfkill_global), which will allow
rfkill to export attributes over sysfs and issue uevents for global rfkill
events.

Since the ammount of runtime memory and text size used by the global states
userspace API are not going to be negligible, make it configurable.  Users
of rfkill_input don't need this userspace API, anyway.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/Kconfig  |   19 +++++++++
 net/rfkill/rfkill.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index ae0181f..5492314 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -20,6 +20,25 @@ config RFKILL_NO_CORE_UAPI
 	  API.  Use this on highly constrained systems when no userspace
 	  feedback or userspace-based rfkill control is needed.
 
+config RFKILL_GLOBAL_UAPI
+	bool "Export rfkill global control to userspace"
+	depends on RFKILL
+	depends on !RFKILL_NO_CORE_UAPI
+	default y
+	help
+	  Say Y here to export an userspace interface that allows
+	  the global control of rfkill switches in per-type groups,
+	  as well as other global rfkill behaviour (such as
+	  system-wide emergency transmitter power off).
+
+	  This option DOES NOT interfere with the per-device rfkill
+	  userspace interface, you will still be able to control
+	  single rfkill devices from userspace even if this option
+	  is disabled.
+
+	  Users of the rfkill_input kernel module can just say N
+	  here and save some memory.
+
 config RFKILL_INPUT
 	tristate "Input layer to RF switch connector"
 	depends on RFKILL && INPUT
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 80f0fa0..1369b56 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -25,6 +25,8 @@
 #include <linux/capability.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
 #include <linux/rfkill.h>
 
 /* Get declaration of rfkill_switch_all() to shut up sparse. */
@@ -889,6 +891,62 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 EXPORT_SYMBOL_GPL(rfkill_set_default);
 
 /*
+ * Rfkill platform device
+ */
+
+#if defined(CONFIG_RFKILL_GLOBAL_UAPI) && !defined(CONFIG_RFKILL_NO_CORE_UAPI)
+#define RFKILL_PDEV_NAME "rfkill_global"
+static struct platform_device *rfkill_pdev;
+
+struct rfkill_dev_attr {
+	struct device_attribute devattr; /* MUST be the first field */
+	unsigned int index;
+};
+
+static struct device_attribute rfkill_g_attrs[] = {
+	__ATTR_NULL
+};
+
+static int __init rfkill_create_g_attrs(struct platform_device *pdev)
+{
+	unsigned int i = 0;
+	int error = 0;
+
+	while (!error && rfkill_g_attrs[i].attr.name) {
+		error = device_create_file(&pdev->dev, &rfkill_g_attrs[i]);
+		i++;
+	};
+
+	if (unlikely(error)) {
+		i--;
+		while (i > 0) {
+			i--;
+			device_remove_file(&pdev->dev, &rfkill_g_attrs[i]);
+		}
+	}
+
+	return error;
+}
+
+static void rfkill_destroy_g_attrs(struct platform_device *pdev)
+{
+	unsigned int i = 0;
+
+	while (rfkill_g_attrs[i].attr.name) {
+		device_remove_file(&pdev->dev, &rfkill_g_attrs[i]);
+		i++;
+	}
+}
+
+static struct platform_driver rfkill_pdrv = {
+	.driver = {
+		.name = RFKILL_PDEV_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+#endif /* CONFIG_RFKILL_GLOBAL_UAPI && !CONFIG_RFKILL_NO_CORE_UAPI */
+
+/*
  * Rfkill module initialization/deinitialization.
  */
 static int __init rfkill_init(void)
@@ -910,11 +968,55 @@ static int __init rfkill_init(void)
 		return error;
 	}
 
+#ifdef CONFIG_RFKILL_NO_CORE_UAPI
+	return 0;
+#else
+  #ifdef CONFIG_RFKILL_GLOBAL_UAPI
+	error = platform_driver_register(&rfkill_pdrv);
+	if (error) {
+		printk(KERN_ERR
+			"rfkill: unable to register platform driver\n");
+		goto err_class_unregister;
+	}
+
+	rfkill_pdev = platform_device_register_simple(RFKILL_PDEV_NAME,
+							-1, NULL, 0);
+	if (IS_ERR(rfkill_pdev)) {
+		error = PTR_ERR(rfkill_pdev);
+		printk(KERN_ERR
+			"rfkill: unable to register platform device\n");
+		goto err_unregister_pdrv;
+	}
+
+	error = rfkill_create_g_attrs(rfkill_pdev);
+	if (error)
+		goto err_unregister_pdev;
+
+	return 0;
+
+err_unregister_pdev:
+	platform_device_unregister(rfkill_pdev);
+
+err_unregister_pdrv:
+	platform_driver_unregister(&rfkill_pdrv);
+
+err_class_unregister:
+	class_unregister(&rfkill_class);
+
+	return error;
+  #else /* CONFIG_RFKILL_GLOBAL_UAPI */
 	return 0;
+  #endif /* CONFIG_RFKILL_GLOBAL_UAPI */
+#endif /* CONFIG_RFKILL_NO_CORE_UAPI */
 }
 
 static void __exit rfkill_exit(void)
 {
+#if defined(CONFIG_RFKILL_GLOBAL_UAPI) && !defined(CONFIG_RFKILL_NO_CORE_UAPI)
+	rfkill_destroy_g_attrs(rfkill_pdev);
+	platform_device_unregister(rfkill_pdev);
+	platform_driver_unregister(&rfkill_pdrv);
+#endif
 	class_unregister(&rfkill_class);
 }
 
-- 
1.6.2.1


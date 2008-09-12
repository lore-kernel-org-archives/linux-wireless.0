Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.slamd64.com ([217.10.145.2]:48688 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYILToe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 15:44:34 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [RFC] acer-wmi: Add rfkill support for wireless and bluetooth (v4)
Date: Fri, 12 Sep 2008 20:44:26 +0100
Cc: linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <200808301206.56279.carlos@strangeworlds.co.uk> <200809071813.23730.carlos@strangeworlds.co.uk> <20080908032953.GA26459@khazad-dum.debian.net>
In-Reply-To: <20080908032953.GA26459@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809122044.27418.carlos@strangeworlds.co.uk> (sfid-20080912_214440_520416_7B23EF74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements rfkill support for the wireless and bluetooth devices
commonly found on Acer laptops.

For now, we will always poll these devices once a second to guarantee we can
catch state changes. On newer Acer laptops, it may be possible to rely on WMI
events to do this instead, and experimental support for this will be added in
a later patch.

3G has been deliberately left off for now, as we still have no way to detect
it, (nor, AFAIK, has any Linux user tried the code) and on laptops that don't
support 3G, trying to poll for the status will leave the logs full of ACPI
tracebacks.

The old sysfs interface for wireless and 3G will be removed in a later patch.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
---

 drivers/misc/Kconfig    |    1 
 drivers/misc/acer-wmi.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 1 deletions(-)


diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a726f3b..6abb959 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -145,6 +145,7 @@ config ACER_WMI
 	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
+	depends on RFKILL
 	select ACPI_WMI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index b2d9878..3da0a69 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -33,6 +33,8 @@
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
 #include <linux/i8042.h>
+#include <linux/rfkill.h>
+#include <linux/workqueue.h>
 #include <linux/debugfs.h>
 
 #include <acpi/acpi_drivers.h>
@@ -157,6 +159,9 @@ struct acer_debug {
 	u32 wmid_devices;
 };
 
+static struct rfkill *wireless_rfkill;
+static struct rfkill *bluetooth_rfkill;
+
 /* Each low-level interface must define at least some of the following */
 struct wmi_interface {
 	/* The WMI device type */
@@ -930,6 +935,126 @@ static void acer_backlight_exit(void)
 }
 
 /*
+ * Rfkill devices
+ */
+static struct workqueue_struct *rfkill_workqueue;
+
+static void acer_rfkill_update(struct work_struct *ignored);
+static DECLARE_DELAYED_WORK(acer_rfkill_work, acer_rfkill_update);
+static void acer_rfkill_update(struct work_struct *ignored)
+{
+	u32 state;
+	acpi_status status;
+
+	status = get_u32(&state, ACER_CAP_WIRELESS);
+	if (ACPI_SUCCESS(status))
+		rfkill_force_state(wireless_rfkill, state ?
+			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED);
+
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		status = get_u32(&state, ACER_CAP_BLUETOOTH);
+		if (ACPI_SUCCESS(status))
+			rfkill_force_state(bluetooth_rfkill, state ?
+				RFKILL_STATE_UNBLOCKED :
+				RFKILL_STATE_SOFT_BLOCKED);
+	}
+
+	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work,
+		round_jiffies_relative(HZ));
+}
+
+static int acer_rfkill_set(void *data, enum rfkill_state state)
+{
+	acpi_status status;
+	u32 *cap = data;
+	status = set_u32((u32) (state == RFKILL_STATE_UNBLOCKED), *cap);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+	return 0;
+}
+
+static int acer_rfkill_register(struct device *dev, struct rfkill **rfkill_dev,
+enum rfkill_type type, char *name, u32 cap)
+{
+	int err;
+	u32 state;
+	u32 *data;
+
+	*rfkill_dev = rfkill_allocate(dev, type);
+	if (!*rfkill_dev)
+		return -ENOMEM;
+	(*rfkill_dev)->name = name;
+	get_u32(&state, cap);
+	(*rfkill_dev)->state = state ? RFKILL_STATE_UNBLOCKED :
+		RFKILL_STATE_SOFT_BLOCKED;
+	data = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!data) {
+		rfkill_free(*rfkill_dev);
+		return -ENOMEM;
+	}
+	*data = cap;
+	(*rfkill_dev)->data = data;
+	(*rfkill_dev)->toggle_radio = acer_rfkill_set;
+	(*rfkill_dev)->user_claim_unsupported = 1;
+
+	err = rfkill_register(*rfkill_dev);
+	if (err) {
+		kfree((*rfkill_dev)->data);
+		rfkill_free(*rfkill_dev);
+		return err;
+	}
+	return 0;
+}
+
+static int acer_rfkill_init(struct device *dev)
+{
+	int err;
+
+	err = acer_rfkill_register(dev, &wireless_rfkill, RFKILL_TYPE_WLAN,
+		"acer-wireless", ACER_CAP_WIRELESS);
+	if (err)
+		return err;
+
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		err = acer_rfkill_register(dev, &bluetooth_rfkill,
+			RFKILL_TYPE_BLUETOOTH, "acer-bluetooth",
+			ACER_CAP_BLUETOOTH);
+		if (err) {
+			kfree(wireless_rfkill->data);
+			rfkill_unregister(wireless_rfkill);
+			return err;
+		}
+	}
+
+	rfkill_workqueue = create_singlethread_workqueue("rfkill_workqueue");
+	if (!rfkill_workqueue) {
+		if (has_cap(ACER_CAP_BLUETOOTH)) {
+			kfree(bluetooth_rfkill->data);
+			rfkill_unregister(bluetooth_rfkill);
+		}
+		kfree(wireless_rfkill->data);
+		rfkill_unregister(wireless_rfkill);
+		return -ENOMEM;
+	}
+	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work, HZ);
+
+	return 0;
+}
+
+static void acer_rfkill_exit(void)
+{
+	cancel_delayed_work_sync(&acer_rfkill_work);
+	destroy_workqueue(rfkill_workqueue);
+	kfree(wireless_rfkill->data);
+	rfkill_unregister(wireless_rfkill);
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		kfree(wireless_rfkill->data);
+		rfkill_unregister(bluetooth_rfkill);
+	}
+	return;
+}
+
+/*
  * Read/ write bool sysfs macro
  */
 #define show_set_bool(value, cap) \
@@ -1023,7 +1148,9 @@ static int __devinit acer_platform_probe(struct platform_device *device)
 			goto error_brightness;
 	}
 
-	return 0;
+	err = acer_rfkill_init(&device->dev);
+
+	return err;
 
 error_brightness:
 	acer_led_exit();
@@ -1037,6 +1164,8 @@ static int acer_platform_remove(struct platform_device *device)
 		acer_led_exit();
 	if (has_cap(ACER_CAP_BRIGHTNESS))
 		acer_backlight_exit();
+
+	acer_rfkill_exit();
 	return 0;
 }
 

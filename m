Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.slamd64.com ([217.10.145.2]:47320 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYH3PyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2008 11:54:10 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [RFC] acer-wmi: Add rfkill support for wireless and bluetooth (v2)
Date: Sat, 30 Aug 2008 16:54:02 +0100
Cc: linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <200808301206.56279.carlos@strangeworlds.co.uk> <20080830140730.GB12246@khazad-dum.debian.net>
In-Reply-To: <20080830140730.GB12246@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808301654.03329.carlos@strangeworlds.co.uk> (sfid-20080830_175416_449000_9BB2B8FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the comments - version 2 below.

Also, is there any particular reason why rfkill explicitly doesn't save &
restore states on hibernation/ suspend-to-disk?

-Carlos
---
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
 drivers/misc/acer-wmi.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 0 deletions(-)


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
index b2d9878..2b7ee77 100644
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
@@ -930,6 +935,93 @@ static void acer_backlight_exit(void)
 }
 
 /*
+ * Rfkill devices
+ */
+static struct workqueue_struct *rfkill_workqueue;
+
+#define ACER_RFKILL(device, cap) \
+static void device##_rfkill_update(struct work_struct *ignored); \
+static int device##_rfkill_set(void *data, enum rfkill_state state) \
+{ \
+	acpi_status status; \
+ 	status = set_u32((u32) (state == RFKILL_STATE_UNBLOCKED), cap); \
+	if (ACPI_FAILURE(status)) \
+		return -ENODEV; \
+	return 0; \
+} \
+static DECLARE_DELAYED_WORK(device##_rfkill_work, device##_rfkill_update); \
+static void device##_rfkill_update(struct work_struct *ignored) \
+{ \
+	u32 state; \
+	acpi_status status; \
+	status = get_u32(&state, cap); \
+	\
+	if (ACPI_SUCCESS(status)) \
+		rfkill_force_state(device##_rfkill, state); \
+	queue_delayed_work(rfkill_workqueue, &device##_rfkill_work, \
+		round_jiffies_relative(HZ)); \
+}
+
+ACER_RFKILL(wireless, ACER_CAP_WIRELESS);
+ACER_RFKILL(bluetooth, ACER_CAP_BLUETOOTH);
+
+static int acer_rfkill_init(struct device *dev)
+{
+	int err;
+	u32 state;
+
+	wireless_rfkill = rfkill_allocate(dev, RFKILL_TYPE_WLAN);
+	if (!wireless_rfkill)
+		return -ENOMEM;
+	wireless_rfkill->name = "acer-wireless";
+	get_u32(&state, ACER_CAP_WIRELESS);
+	wireless_rfkill->state = state ? RFKILL_STATE_UNBLOCKED :
+		RFKILL_STATE_SOFT_BLOCKED;
+	wireless_rfkill->toggle_radio = wireless_rfkill_set;
+	wireless_rfkill->user_claim_unsupported = 1;
+
+	err = rfkill_register(wireless_rfkill);
+	if (err)
+		return err;
+
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		bluetooth_rfkill = rfkill_allocate(dev, RFKILL_TYPE_BLUETOOTH);
+		if (!bluetooth_rfkill)
+			return -ENOMEM;
+		bluetooth_rfkill->name = "acer-bluetooth";
+		get_u32(&state, ACER_CAP_BLUETOOTH);
+		bluetooth_rfkill->state = state ? RFKILL_STATE_UNBLOCKED :
+			RFKILL_STATE_SOFT_BLOCKED;
+		bluetooth_rfkill->toggle_radio = bluetooth_rfkill_set;
+		bluetooth_rfkill->user_claim_unsupported = 1;
+		err = rfkill_register(bluetooth_rfkill);
+		if (err)
+			return err;
+	}
+
+	rfkill_workqueue = create_singlethread_workqueue("rfkill_workqueue");
+	if (!rfkill_workqueue)
+		return -ENOMEM;
+	queue_delayed_work(rfkill_workqueue, &wireless_rfkill_work, HZ);
+	queue_delayed_work(rfkill_workqueue, &bluetooth_rfkill_work, HZ);
+
+	return 0;
+}
+
+static void acer_rfkill_exit(void)
+{
+	cancel_delayed_work_sync(&wireless_rfkill_work);
+	cancel_delayed_work_sync(&bluetooth_rfkill_work);
+	destroy_workqueue(rfkill_workqueue);
+	rfkill_unregister(wireless_rfkill);
+	rfkill_free(wireless_rfkill);
+	if (has_cap(ACER_CAP_BLUETOOTH))
+		rfkill_unregister(bluetooth_rfkill);
+		rfkill_free(bluetooth_rfkill);
+	return;
+}
+
+/*
  * Read/ write bool sysfs macro
  */
 #define show_set_bool(value, cap) \
@@ -1023,8 +1115,14 @@ static int __devinit acer_platform_probe(struct platform_device *device)
 			goto error_brightness;
 	}
 
+	err = acer_rfkill_init(&device->dev);
+	if (err)
+		goto error_rfkill;
+
 	return 0;
 
+error_rfkill:
+	acer_rfkill_exit();
 error_brightness:
 	acer_led_exit();
 error_mailled:
@@ -1037,6 +1135,8 @@ static int acer_platform_remove(struct platform_device *device)
 		acer_led_exit();
 	if (has_cap(ACER_CAP_BRIGHTNESS))
 		acer_backlight_exit();
+
+	acer_rfkill_exit();
 	return 0;
 }
 

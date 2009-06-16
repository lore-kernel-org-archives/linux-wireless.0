Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51453 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbZFPNxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 09:53:53 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so6028523ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 06:53:56 -0700 (PDT)
Message-ID: <4A37A3F0.80501@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 14:53:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] eeepc-laptop: read rfkill soft-blocked state on resume
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will respect state changes over hibernation, e.g. if the user
disables the wireless in the BIOS setup screen.

It reveals an issue where ACPI silently kills the wireless on
suspend.  Normally, the BIOS restores the correct state from
non-volatile storage on boot.  But when hibernation is aborted,
the wireless would remain killed.  Fortunately we can work around
this in the resume handler by simply writing back the same value we
read from NVS.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/eeepc-laptop.c |   42 +++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 01682ec..8153b3e 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -180,6 +180,7 @@ static struct key_entry eeepc_keymap[] = {
  */
 static int eeepc_hotk_add(struct acpi_device *device);
 static int eeepc_hotk_remove(struct acpi_device *device, int type);
+static int eeepc_hotk_resume(struct acpi_device *device);
 
 static const struct acpi_device_id eeepc_device_ids[] = {
 	{EEEPC_HOTK_HID, 0},
@@ -194,6 +195,7 @@ static struct acpi_driver eeepc_hotk_driver = {
 	.ops = {
 		.add = eeepc_hotk_add,
 		.remove = eeepc_hotk_remove,
+		.resume = eeepc_hotk_resume,
 	},
 };
 
@@ -512,15 +514,12 @@ static int notify_brn(void)
 	return -1;
 }
 
-static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+static void eeepc_rfkill_hotplug(void)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = pci_find_bus(0, 1);
 	bool blocked;
 
-	if (event != ACPI_NOTIFY_BUS_CHECK)
-		return;
-
 	if (!bus) {
 		printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
 		return;
@@ -551,6 +550,14 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 	rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill, blocked);
 }
 
+static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+{
+	if (event != ACPI_NOTIFY_BUS_CHECK)
+		return;
+
+	eeepc_rfkill_hotplug();
+}
+
 static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
 	static struct key_entry *key;
@@ -734,6 +741,33 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
+static int eeepc_hotk_resume(struct acpi_device *device)
+{
+	if (ehotk->eeepc_wlan_rfkill) {
+		bool wlan;
+
+		/* Workaround - it seems that _PTS disables the wireless
+		   without notification or changing the value read by WLAN.
+		   Normally this is fine because the correct value is restored
+		   from the non-volatile storage on resume, but we need to do
+		   it ourself if case suspend is aborted, or we lose wireless.
+		 */
+		wlan = get_acpi(CM_ASL_WLAN);
+		set_acpi(CM_ASL_WLAN, wlan);
+
+		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
+				    wlan != 1);
+
+		eeepc_rfkill_hotplug();
+	}
+
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_set_sw_state(ehotk->eeepc_bluetooth_rfkill,
+				    get_acpi(CM_ASL_BLUETOOTH) != 1);
+
+	return 0;
+}
+
 /*
  * Hwmon
  */
-- 
1.6.3.2




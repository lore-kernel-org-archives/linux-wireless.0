Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48543 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZDTIlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 04:41:23 -0400
Received: by gxk10 with SMTP id 10so325177gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 01:41:21 -0700 (PDT)
Message-ID: <49EC3366.7080206@tuffmail.co.uk> (sfid-20090420_104127_147948_F7994902)
Date: Mon, 20 Apr 2009 09:33:42 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rfkill rewrite bug
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk>	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>	 <49EA10F3.3070309@tuffmail.co.uk> (sfid-20090418_194244_839181_896F358B) <1240077571.25100.3.camel@johannes.local>
In-Reply-To: <1240077571.25100.3.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 18:42 +0100, Alan Jenkins wrote:
>
>   
>>> That's odd, I thought I added a set_sw_state() to rfkill which would
>>> disable that rfkill. But there's rfkill_set_global_sw_state() which
>>> should do what you want -- can you try replacing the EEE set_sw_state
>>> call with that?
>>>       
>
>   
>> Yes, that fixes it.  Now it works the same as the old code which used
>> rfkill_set_default().
>>     
>
> Cool.
>
>   
>> +static int eeepc_hotk_resume(struct acpi_device *device);
>>  
>>  static const struct acpi_device_id eeepc_device_ids[] = {
>>  	{EEEPC_HOTK_HID, 0},
>> @@ -191,6 +192,7 @@ static struct acpi_driver eeepc_hotk_driver = {
>>  	.ops = {
>>  		.add = eeepc_hotk_add,
>>  		.remove = eeepc_hotk_remove,
>> +		.resume = eeepc_hotk_resume
>>     
>
> Please add a , at the end so other people updating that in the future
> don't need to change that line too.
>
>   
>> +static void eeepc_rfkill_hotplug()
>>     
>
> Need (void) not ()
>
> If you change those and give me a S-o-b I'll integrate it into my patch
> with something like
>
> S-o-b: <you> [eeepc driver parts]
>
>   
> johannes

Ok, revised patch is below. Don't forget the set_sw_state() ->
set_global_sw_state() change; I didn't include that.


Note that there other pending changes to the rfkill code in eeepc-laptop.

"[PATCH] eee-laptop: Register as a pci-hotplug device"
<http://thread.gmane.org/gmane.linux.kernel/791730/focus=38724>

"[PATCH] eeepc-laptop: Work around rfkill firmware bug"
<http://thread.gmane.org/gmane.linux.acpi.devel/38424>

The second is mine; sorry for not warning about it sooner.  So you/we
probably need to co-ordinate with the maintainer.  I'd CC linux-acpi,
because that's where most platform driver changes are submitted.

---
Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 0e7a946..10366b2 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -177,6 +177,7 @@ static struct key_entry eeepc_keymap[] = {
  */
 static int eeepc_hotk_add(struct acpi_device *device);
 static int eeepc_hotk_remove(struct acpi_device *device, int type);
+static int eeepc_hotk_resume(struct acpi_device *device);
 
 static const struct acpi_device_id eeepc_device_ids[] = {
 	{EEEPC_HOTK_HID, 0},
@@ -191,6 +192,7 @@ static struct acpi_driver eeepc_hotk_driver = {
 	.ops = {
 		.add = eeepc_hotk_add,
 		.remove = eeepc_hotk_remove,
+		.resume = eeepc_hotk_resume,
 	},
 };
 
@@ -495,14 +497,11 @@ static void notify_brn(void)
 		bd->props.brightness = read_brightness(bd);
 }
 
-static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+static void eeepc_rfkill_hotplug(void)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = pci_find_bus(0, 1);
 
-	if (event != ACPI_NOTIFY_BUS_CHECK)
-		return;
-
 	if (!bus) {
 		printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
 		return;
@@ -530,6 +529,14 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 	}
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
@@ -695,6 +702,22 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
+static int eeepc_hotk_resume(struct acpi_device *device)
+{
+	if (ehotk->eeepc_wlan_rfkill) {
+		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
+				    get_acpi(CM_ASL_WLAN) != 1);
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



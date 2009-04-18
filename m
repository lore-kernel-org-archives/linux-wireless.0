Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63666 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZDRRmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 13:42:15 -0400
Received: by ewy24 with SMTP id 24so617351ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 10:42:13 -0700 (PDT)
Message-ID: <49EA10F3.3070309@tuffmail.co.uk> (sfid-20090418_194217_807728_85E39DB9)
Date: Sat, 18 Apr 2009 18:42:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rfkill rewrite bug
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk> (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
In-Reply-To: <1240057470.4755.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 10:43 +0100, Alan Jenkins wrote:
>
>   
>>>> When I looked at the code earlier, I saw no obvious replacement for 
>>>> rfkill_set_default().  So I tried disabling the wireless and rebooting 
>>>> to see what happened.  It didn't like that :-).
>>>>     
>>>>         
>>> Ok that wasn't too hard -- try this on top if you get a chance:
>>>   
>>>       
>> Great, that fixes the crash.
>>
>>
>> 1) I think we need to add a resume method to eeepc-laptop.
>>
>> Without this, funny things happen when I hibernate, disable wireless in
>> the BIOS, and resume:
>>
>>     ath5k phy0: failed to wake up the MAC chip
>>
>> It's an really stupid thing to do, but it can happen.  It's bad from a
>> UI point of view.  E.g. in network-manager, you can see a "wlan0"
>> device, but it doesn't work.
>>
>> The EEE rfkill is unusual in that it hotplugs the PCI device, making
>> eeepc-laptop something like a custom pci hotplug driver.  With your
>> rewrite, eeepc-laptop doesn't notice the state change on resume. 
>> Previously, the rfkill-core would restore the pre-hibernation state,
>> which would sort everything out.  I don't think anything else does this,
>> so we can just add a resume method to eeepc-laptop.  The resume method
>> would re-check the state and do the PCI hotplug dance if necessary.
>>
>> If you agree, I can do the patch for this and send it to you.
>>     
>
> Sounds good to me, yeah.
>
> I could make the rfkill core do that at resume, but I'm not really sure
> it's what we want -- there are too many cases imho:
>  * hard rfkill might have changed
>  * soft rfkill might still be ok in hw
>  * soft rfkill might need reconfiguring
> etc. I think generally it's saner to let the driver sort it out -- it
> can always ask for the current state by using set_hw_state() or so.
>
>   
>> 2) Do you have any thoughts about an rfkill_set_default() equivalent? 
>> AFAICS your current patch simply removes it.
>>
>> This means that when I boot linux, it doesn't respect the previous
>> rfkill state.  I can no longer disable the wireless in the BIOS setup
>> screen, and the rfkill state won't be preserved over reboots.
>>
>> I don't have a strong feeling about reboots _on their own_.  But I would
>> be annoyed if the option in the BIOS setup screen stopped working in a
>> future version of linux.  Admittedly it's only a matter of principle /
>> nostalgia - since the eeepc-laptop was fixed to implement rfkill
>> properly, I've never used the BIOS option in anger.
>>     
>
> That's odd, I thought I added a set_sw_state() to rfkill which would
> disable that rfkill. But there's rfkill_set_global_sw_state() which
> should do what you want -- can you try replacing the EEE set_sw_state
> call with that?
>
> johannes
>   

Yes, that fixes it.  Now it works the same as the old code which used
rfkill_set_default().

Here's my resume code for eeepc-laptop.

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index c822bfa..5f594c6 100644
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
+		.resume = eeepc_hotk_resume
 	},
 };
 
@@ -495,14 +497,11 @@ static void notify_brn(void)
 		bd->props.brightness = read_brightness(bd);
 }
 
-static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+static void eeepc_rfkill_hotplug()
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




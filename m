Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbcCQULC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 16:11:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: rtl8xxxu 4.4.5(from f23): I get a panic adding a new device to the driver
References: <56E89DD2.7000000@gmail.com> <wrfjfuvqr0cb.fsf@redhat.com>
	<wrfja8lxnfsm.fsf@redhat.com> <56EB0D15.9040103@gmail.com>
Date: Thu, 17 Mar 2016 16:11:00 -0400
In-Reply-To: <56EB0D15.9040103@gmail.com> (poma's message of "Thu, 17 Mar 2016
	21:01:25 +0100")
Message-ID: <wrfj60wkn9uz.fsf@redhat.com> (sfid-20160317_211105_766501_83E52CB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

poma <pomidorabelisima@gmail.com> writes:
> On 17.03.2016 19:02, Jes Sorensen wrote:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
>>>> Hi,
>>>>
>>>> If I do:
>>>> # echo "0bda 8176" > /sys/bus/usb/drivers/rtl8xxxu/new_id
>>>
>>> Hi Xose,
>>>
>>> Yes please don't do that. The rtl8xxxu driver relies on the .driver_info
>>> field in struct use_device_id to carry information for the different
>>> types of devices. If you hot add a device like above, the driver will
>>> fail because that field now contains a NULL pointer.
>>>
>>> I should probably add a check for it in the probe function, but it will
>>> simply be there to spit out a warning that it doesn't work to hot add a
>>> device like this.
>>>
>>> If you build it with CONFIG_RTL8XXXU_UNTESTED the 0bda:8176 should be
>>> included in the device list.
>>>
>>> Cheers,
>>> Jes
>> 
>> Hi Xose,
>> 
>> I added the following patch to my tree to avoid this.
>> 
>> Cheers,
>> Jes
>> 
>> commit 9202f4947aac1d60084ee79c9b5294eb42ba59dc
>> Author: Jes Sorensen <Jes.Sorensen@redhat.com>
>> Date:   Thu Mar 17 13:53:48 2016 -0400
>> 
>>     rtl8xxxu: Fix OOPS if user tries to add device via /sys
>>     
>>     This driver relies on driver_info in struct usb_device_id, hence
>>     adding a device via  /sys/bus/usb/drivers/rtl8xxxu/new_id would result
>>     in a NULL pointer dereference.
>>     
>>     Instead print a message and return -ENODEV
>>     
>>     Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>     Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 8d893f4..55fc00e 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -9671,6 +9671,15 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>>  
>>  	udev = usb_get_dev(interface_to_usbdev(interface));
>>  
>> +	if (!id->driver_info) {
>> +		dev_warn(&udev->dev,
>> +			 "rtl8xxxu relies on driver_info in struct usb_device_id.\n");
>> +		dev_warn(&udev->dev,
>> +			 "Adding a device via /sys/bus/usb/drivers/rtl8xxxu/new_id is not supported!\n");
>> +		ret = -ENODEV;
>> +		goto exit;
>> +	}
>> +
>>  	switch (id->idVendor) {
>>  	case USB_VENDOR_ID_REALTEK:
>>  		switch(id->idProduct) {
>
> Dynamic adding and removing a new device IDs to a USB device drivers
> via /sys/bus/usb/drivers/.../[new_id|remove_id]
> https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-bus-usb
>
> is not supported only with rtl8xxxu?

Dynamically adding one will not work. The driver relies on driver_info
in struct usb_device_id() to carry the struct fileops associated with
the device type and you cannot specify this via the USB add operation.

Jes

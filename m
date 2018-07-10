Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:63455 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732237AbeGJWJI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 18:09:08 -0400
From: "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:RFKILL" <linux-wireless@vger.kernel.org>,
        "Holtmann, Marcel" <marcel.holtmann@intel.com>,
        "Tumkur Narayan, Chethan" <chethan.tumkur.narayan@intel.com>,
        "Pierres, Arnaud" <arnaud.pierres@intel.com>
Subject: RE: RFkill for Bluetooth hard reset
Date: Tue, 10 Jul 2018 22:07:18 +0000
Message-ID: <D73ECEF0C711E34A8F972E4B87F540058FB58327@ORSMSX114.amr.corp.intel.com> (sfid-20180711_000805_808649_08416CF1)
References: <D73ECEF0C711E34A8F972E4B87F540058FB55F8D@ORSMSX114.amr.corp.intel.com>
 <A1EF6CA6-71AB-4EF6-BF59-53450958A6AA@holtmann.org>
In-Reply-To: <A1EF6CA6-71AB-4EF6-BF59-53450958A6AA@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Tuesday, July 10, 2018 11:46 AM
>To: Ghorai, Sukumar <sukumar.ghorai@intel.com>
>Cc: Johannes Berg <johannes@sipsolutions.net>; David S. Miller
><davem@davemloft.net>; open list:RFKILL <linux-wireless@vger.kernel.org>;
>Holtmann, Marcel <marcel.holtmann@intel.com>; Tumkur Narayan, Chethan
><chethan.tumkur.narayan@intel.com>
>Subject: Re: RFkill for Bluetooth hard reset
>
>Hi Sukumar,
>
>> We need an option to reset Bluetooth using GPIO toggle for a Linux
>> product when BT connected over USB (HCI interface). i.e I need out of
>> band(OOB) signal for USB to control/reset the BT. hence I opt to add
>> ACPI device in RfKill gpio driver(rfkill-gpio.c).
>>
>> localhost /sys/class/rfkill # ls -l
>> total 0
>> lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill0 ->
>> ../../devices/platform/INTL6205:00/rfkill/rfkill0
>> lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill2 ->
>> ../../devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy0/rfki
>> ll2 lrwxrwxrwx. 1 root root 0 Jul  8 15:35 rfkill3 ->
>> ../../devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/bluetooth/hci0/
>> rfkill3
>>
>> I try to use RFkill soft block option to hold/reset (toggle) GPIO. And
>> changes in rfkill-gpio.c as follows.
>> 1/ reset pin configured as GPIOD_OUT_LOW, hence HW controller is not
>> out of reset.  I changed to high to work with our controller.
>> How to configured as Low/High as a generic solution?
>>
>> 2/ As per existing implementation, the Shutdown gpio is mandatory for
>> the framework to use. I feel we can make it an optional.
>>
>> 3/ Followed by /sys/class/rfkill/rfkill0/soft (1/0) is not in sync
>> with /sys/class/rfkill/rfkill0/uvent (RFKILL_STATE=0/1)
>>
>> Please guide me to add an ACPI method to toggle the GPIO to reset the
>bluetooth.
I appreciate how imaginative you are. I appreciate your support.

>if the setup is that when these GPIOs are triggered, then the Bluetooth USB
>device disappears from the USB bus (and with that from sysfs), then it is fine to
>use an external RFKILL switch. This is similar to what Thinkpads used to do.
>
Platform exposes the ACPI device node. Platform GPIO binds to use for 
controlling reset lines of Bluetooth controller.  Sets the GPIO address low to 
chip disable i.e Device(bt controller) will disconnect from the bus. And config
gpio high triggered bt-chip reset line to boot and host re-enumerate the device. 
Hence OS UI/application can use the Linux system interface 
/sys/class/rfkill/rfkillx/ type and state) with airplane-mode or bluetooth OFF/ON. 
Or similar dbus interface.

>It is kinda okay to use RFKILL_TYPE_BLUETOOTH for this, but in reality this is
>RFKILL_TYPE_USB since it is killing the USB device. That Bluetooth gets also
>killed is just a side effect.
The platform will expose the dedicated ACPI device node (INTL6205) to control 
all Intel bluetooth controller only, when supported.

>One thing that would be nice if ACPI would kinda link the RFKILL switch entry to
>the USB port so that you could relate on which USB device will be actually taken
>off the USB bus.
>
>If this is _not_ killing the USB power to the device and taking it off the bus, then
>this way is all wrong. For wakeup and reset GPIOs, this then needs to be build
>into btusb.c like has been done for all the UART drivers.
To control the Bluetooth hardware, the driver to a combination of in-band bus
communication(USB) and coordinate with out-of-band signaling through
GPIO pins. And still looking for possibility to add the Out-of-band ACPI 
signaling mechanism to hook with btusb.c. 

>Bluetooth at the moment does not have a hard kill switch in its subsystem (like
>WiFi does), but that could be added if the Bluetooth device stays on the bus and
>needs an external RFKILL switch. Bluetooth however does have a soft kill switch,
>but that is not going to help here.
This GPIO based device (BT- controller) OFF/ON is similar to hard kill, as the device
disappears from USB bus and followed by re-enumerate after reset (OFF and ON) 

>So first of all state what the current behavior and design is.
>
>Regards
>Marcel

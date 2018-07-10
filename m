Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:53093 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732278AbeGJSqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 14:46:36 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.4 \(3445.8.2\))
Subject: Re: RFkill for Bluetooth hard reset
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <D73ECEF0C711E34A8F972E4B87F540058FB55F8D@ORSMSX114.amr.corp.intel.com>
Date: Tue, 10 Jul 2018 20:46:17 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:RFKILL" <linux-wireless@vger.kernel.org>,
        Marcel Holtmann <marcel.holtmann@intel.com>,
        "Tumkur Narayan, Chethan" <chethan.tumkur.narayan@intel.com>
Message-Id: <A1EF6CA6-71AB-4EF6-BF59-53450958A6AA@holtmann.org> (sfid-20180710_205132_051270_B5B5AFCE)
References: <D73ECEF0C711E34A8F972E4B87F540058FB55F8D@ORSMSX114.amr.corp.intel.com>
To: "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sukumar,

> We need an option to reset Bluetooth using GPIO toggle for a Linux product when
> BT connected over USB (HCI interface). i.e I need out of band(OOB) signal for
> USB to control/reset the BT. hence I opt to add ACPI device in RfKill gpio
> driver(rfkill-gpio.c).
> 
> localhost /sys/class/rfkill # ls -l
> total 0
> lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill0 -> ../../devices/platform/INTL6205:00/rfkill/rfkill0
> lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill2 -> ../../devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy0/rfkill2
> lrwxrwxrwx. 1 root root 0 Jul  8 15:35 rfkill3 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/bluetooth/hci0/rfkill3
> 
> I try to use RFkill soft block option to hold/reset (toggle) GPIO. And changes
> in rfkill-gpio.c as follows.
> 1/ reset pin configured as GPIOD_OUT_LOW, hence HW controller is not out of
> reset.  I changed to high to work with our controller. 
> How to configured as Low/High as a generic solution?
> 
> 2/ As per existing implementation, the Shutdown gpio is mandatory for the 
> framework to use. I feel we can make it an optional.
> 
> 3/ Followed by /sys/class/rfkill/rfkill0/soft (1/0) is not in sync with
> /sys/class/rfkill/rfkill0/uvent (RFKILL_STATE=0/1)
> 
> Please guide me to add an ACPI method to toggle the GPIO to reset the bluetooth. 

if the setup is that when these GPIOs are triggered, then the Bluetooth USB device disappears from the USB bus (and with that from sysfs), then it is fine to use an external RFKILL switch. This is similar to what Thinkpads used to do.

It is kinda okay to use RFKILL_TYPE_BLUETOOTH for this, but in reality this is RFKILL_TYPE_USB since it is killing the USB device. That Bluetooth gets also killed is just a side effect.

One thing that would be nice if ACPI would kinda link the RFKILL switch entry to the USB port so that you could relate on which USB device will be actually taken off the USB bus.

If this is _not_ killing the USB power to the device and taking it off the bus, then this way is all wrong. For wakeup and reset GPIOs, this then needs to be build into btusb.c like has been done for all the UART drivers.

Bluetooth at the moment does not have a hard kill switch in its subsystem (like WiFi does), but that could be added if the Bluetooth device stays on the bus and needs an external RFKILL switch. Bluetooth however does have a soft kill switch, but that is not going to help here.

So first of all state what the current behavior and design is.

Regards

Marcel

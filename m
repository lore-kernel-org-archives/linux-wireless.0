Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaIKPki (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 11:40:38 -0400
Message-ID: <5411C2BE.6090702@intel.com> (sfid-20140911_174046_316020_F14C8884)
Date: Thu, 11 Sep 2014 17:41:50 +0200
From: Loic Poulain <loic.poulain@intel.com>
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Realtek GPIO chipset, for Baytrail?
References: <1410256608.4077.7.camel@hadess.net> <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
In-Reply-To: <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

Your device is a child of 80860F0A (UART) which is driven by the 8250_dw 
driver.
OBDA8723 is the BT part of the realtek 8723 WiFi/BT combo chip.
acpi_platform should create a platform device from the ACPI desc.
Then, you can add the OBDA8723 acpi id to the rfkill-gpio platform 
driver (net/rfkill) which
seems to handle correctly the basic power management of this chip.

You need to use hciattach to attach the chip to the BT stack (with 
H5/3-wire proto).

Regards,
Loic

On 11/09/2014 17:06, Marcel Holtmann wrote:
> Hi Bastien,
>
>> I have a tablet that seems to be using Realtek chips to do wireless
>> communications (hopefully, this time I won't be wrong[1]).
>>
>> The device, under the gpio class in /sys, shows with a modalias of
>> "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
>> Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
>> the RTL8723AE chipset).
>>
>> It shows up under:
>> /sys/devices/platform/80860F0A:00/subsystem/devices
>>
>> Does anyone have details on how this chipset is actually hooked up? Can
>> a portion of the existing RTL8723AE driver code be reused?
> so after a little bit of digging, this seems to be the UART device for the Bluetooth chip. Can you try using 8250_dw.ko driver and see if it binds to it and you get a new serial port.
>
> If I am correct then you have to run H:5 UART transport protocol to enable Bluetooth for this device.
>
> Please double check that this ACPI tables really wrongly declare this as a Broadcom chip. This seems to be a firmware bug then. Unfortunately I think that for Broadcom you run H:4 UART transport protocol and for Realtek you have to run H:5 UART transport protocol. So no idea how to nicely differentiate these.
>
> Regards
>
> Marcel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel Open Source Technology Center
http://oss.intel.com/


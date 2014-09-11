Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36522 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaIKQgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 12:36:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1410451261.32328.11.camel@hadess.net>
Date: Thu, 11 Sep 2014 09:37:14 -0700
Cc: Loic Poulain <loic.poulain@intel.com>,
	linux-wireless@vger.kernel.org
Message-Id: <5F46C78F-1749-480F-B90C-702509D963AD@holtmann.org> (sfid-20140911_183641_222030_73819191)
References: <1410256608.4077.7.camel@hadess.net> <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org> <5411C2BE.6090702@intel.com> <1410451261.32328.11.camel@hadess.net>
To: Bastien Nocera <hadess@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

>> Your device is a child of 80860F0A (UART) which is driven by the 8250_dw 
>> driver.
>> OBDA8723 is the BT part of the realtek 8723 WiFi/BT combo chip.
>> acpi_platform should create a platform device from the ACPI desc.
> 
> That does show up already in udev, so I should be fine.
> 
>> Then, you can add the OBDA8723 acpi id to the rfkill-gpio platform 
>> driver (net/rfkill) which
>> seems to handle correctly the basic power management of this chip.
> 
> OK. Something like that should do:
> http://paste.fedoraproject.org/132832/14104505
> 
>> You need to use hciattach to attach the chip to the BT stack (with 
>> H5/3-wire proto).
> 
> Will that be required to enable Bluetooth at every boot?
> 
> After inserting the above module, I ran:
> hciattach -n ttyS0 3wire
> 
> But no Bluetooth adapters showed up in hciconfig. The rfkill device did
> show up in rfkill list though.

my bet is that you need to start with the correct default speed, load some firmware and do more settings and then switch to the faster speed. There is an effort ongoing for the USB version of Realtek Bluetooth, but even that one has not yet completed.

Regards

Marcel


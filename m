Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45153 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaIKQBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 12:01:22 -0400
Message-ID: <1410451261.32328.11.camel@hadess.net> (sfid-20140911_180126_001914_99FE1F09)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Loic Poulain <loic.poulain@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 18:01:01 +0200
In-Reply-To: <5411C2BE.6090702@intel.com>
References: <1410256608.4077.7.camel@hadess.net>
	 <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
	 <5411C2BE.6090702@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Loic,

On Thu, 2014-09-11 at 17:41 +0200, Loic Poulain wrote:
> Hi Bastien,
> 
> Your device is a child of 80860F0A (UART) which is driven by the 8250_dw 
> driver.
> OBDA8723 is the BT part of the realtek 8723 WiFi/BT combo chip.
> acpi_platform should create a platform device from the ACPI desc.

That does show up already in udev, so I should be fine.

> Then, you can add the OBDA8723 acpi id to the rfkill-gpio platform 
> driver (net/rfkill) which
> seems to handle correctly the basic power management of this chip.

OK. Something like that should do:
http://paste.fedoraproject.org/132832/14104505

> You need to use hciattach to attach the chip to the BT stack (with 
> H5/3-wire proto).

Will that be required to enable Bluetooth at every boot?

After inserting the above module, I ran:
hciattach -n ttyS0 3wire

But no Bluetooth adapters showed up in hciconfig. The rfkill device did
show up in rfkill list though.

Cheers


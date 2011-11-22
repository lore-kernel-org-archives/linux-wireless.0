Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4943 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466Ab1KVLun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 06:50:43 -0500
Message-ID: <4ECB8C82.5040003@broadcom.com> (sfid-20111122_125047_346426_BACBE9A4)
Date: Tue, 22 Nov 2011 12:50:26 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	"=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?=" <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma USB Host driver
References: <4ECAC919.4080408@hauke-m.de>
In-Reply-To: <4ECAC919.4080408@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 10:56 PM, Hauke Mehrtens wrote:
> Hi,
> 
> To provide ehci and ohci at the same time I came up with some solutions:
> 
> 1. The OHCI driver also initializes the EHCI driver, when it gets load
> and is an USB 2.0 device. This is how it is done in OpenWrt and I do not
> like it [1].
> 2. bcma provides two devices with different identification and there are
> two independ drivers working with it.

When doing this the wrapper access (bcma_aread/awrite) will have effect
on both not-so-independent drivers.

> 3. bcma handles the usb registration directly and all code goes to
> drivers/bcma/

Sound like mixing device driver functionality in a bus driver. It does
not feel right to me, but bcma is already handling chipcommon, and
pci(e) cores.

Main question would be whether a linux device driver can provide
multiple system functions. I tend to say it can. So I would suggest to
have a single device driver providing OHCI and EHCI functionality.

> 4. Is there some way like a platform device with a memory address which
> I could register and which is then handled by the usb system?
> 
> Are there any better approaches on how to do this? I do not think I am
> the first person with such a problem.
> 
> Hauke
> 

Gr. AvS

ps.: I polled again internally about et driver support. Keep you posted.


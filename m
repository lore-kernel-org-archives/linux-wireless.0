Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48127 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1KYX4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 18:56:20 -0500
Message-ID: <4ED02B1D.7030409@hauke-m.de> (sfid-20111126_005638_031072_33008E8E)
Date: Sat, 26 Nov 2011 00:56:13 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma USB Host driver
References: <4ECAC919.4080408@hauke-m.de> <4ECB8C82.5040003@broadcom.com>
In-Reply-To: <4ECB8C82.5040003@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 11/22/2011 12:50 PM, Arend van Spriel wrote:
> On 11/21/2011 10:56 PM, Hauke Mehrtens wrote:
>> Hi,
>>
>> To provide ehci and ohci at the same time I came up with some solutions:
>>
>> 1. The OHCI driver also initializes the EHCI driver, when it gets load
>> and is an USB 2.0 device. This is how it is done in OpenWrt and I do not
>> like it [1].
>> 2. bcma provides two devices with different identification and there are
>> two independ drivers working with it.
> 
> When doing this the wrapper access (bcma_aread/awrite) will have effect
> on both not-so-independent drivers.
Yes that will be a workaround for this problem and will probably cause
problems when some other new features are added as we have an additional
corner case to handle.

>> 3. bcma handles the usb registration directly and all code goes to
>> drivers/bcma/
> 
> Sound like mixing device driver functionality in a bus driver. It does
> not feel right to me, but bcma is already handling chipcommon, and
> pci(e) cores.
> 
> Main question would be whether a linux device driver can provide
> multiple system functions. I tend to say it can. So I would suggest to
> have a single device driver providing OHCI and EHCI functionality.

@USB guys, how do I design a driver for a linux device providing ohci
and ehci functionality at the same time. The device has two address
spaces one for ehci and one for ohci functions.
I thought about registering one controller (ehci or ohci) with
usb_create_shared_hcd(). The code then will be in an own module and not
in echi_hcd.ko and ochi_hcd.ko like for pci, I hope this works.
Is there a better solution to do this, is there an other driver with the
same problem already solved?

>> 4. Is there some way like a platform device with a memory address which
>> I could register and which is then handled by the usb system?
>>
>> Are there any better approaches on how to do this? I do not think I am
>> the first person with such a problem.
>>
>> Hauke
>>
> 
> Gr. AvS
> 
> ps.: I polled again internally about et driver support. Keep you posted.
> 

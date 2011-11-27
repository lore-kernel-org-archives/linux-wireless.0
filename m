Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55308 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab1K0ATF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 19:19:05 -0500
Message-ID: <4ED181F1.40009@hauke-m.de> (sfid-20111127_012031_724178_06522C4E)
Date: Sun, 27 Nov 2011 01:18:57 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma USB Host driver
References: <Pine.LNX.4.44L0.1111252022490.14777-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111252022490.14777-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

On 11/26/2011 02:27 AM, Alan Stern wrote:
> On Sat, 26 Nov 2011, Hauke Mehrtens wrote:
> 
>>> Main question would be whether a linux device driver can provide
>>> multiple system functions. I tend to say it can. So I would suggest to
>>> have a single device driver providing OHCI and EHCI functionality.
>>
>> @USB guys, how do I design a driver for a linux device providing ohci
>> and ehci functionality at the same time. The device has two address
>> spaces one for ehci and one for ohci functions.
> 
> How many IRQ lines?
The ehci and ohci controller are sharing one IRQ line.
> 
> And incidentally, in what sense is this _one_ device?  Are you sure 
> it's not _two_ devices in one package?
This is an SoC, so in hardware it is a chip with many functionality. On
the internal bus it is connected as one device, which offers two address
spaces. I do not have access to the detailed hardware specs just some
other driver source code.
> 
>> I thought about registering one controller (ehci or ohci) with
>> usb_create_shared_hcd(). The code then will be in an own module and not
>> in echi_hcd.ko and ochi_hcd.ko like for pci, I hope this works.
>> Is there a better solution to do this, is there an other driver with the
>> same problem already solved?
> 
> I don't know of any other driver that does this.  Your best solution is 
> probably write a driver that registers two child platform devices, and 
> write two corresponding platform drivers, one for the EHCI part and one 
> for the OHCI part.
Thanks for this tip. I did this and it is working nicely. It has an
other advantage, for the ssb bus I was able to use the same platform
drivers as used for the bcma bus.
> 
> Alan Stern
> 

Hauke


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59085 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032860Ab2CPPgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:36:01 -0400
Message-ID: <4F635DCF.7060101@hauke-m.de> (sfid-20120316_163609_067491_7F4F6B88)
Date: Fri, 16 Mar 2012 16:35:43 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"ralf@linux-mips.org" <ralf@linux-mips.org>,
	"m@bues.ch" <m@bues.ch>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"zajec5@gmail.com" <zajec5@gmail.com>
Subject: Re: [PATCH v5 4/4] USB: OHCI: remove old SSB OHCI driver
References: <1331851799-5968-1-git-send-email-hauke@hauke-m.de> <1331851799-5968-5-git-send-email-hauke@hauke-m.de> <4F630267.5050909@broadcom.com>
In-Reply-To: <4F630267.5050909@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 10:05 AM, Arend van Spriel wrote:
> On 03/15/2012 11:49 PM, Hauke Mehrtens wrote:
>> This is now replaced by the new ssb USB driver, which also supports
>> devices with an EHCI controller.
>>
>> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
>> ---
>>   drivers/usb/host/Kconfig    |    7 +-
>>   drivers/usb/host/ohci-hcd.c |   21 +----
>>   drivers/usb/host/ohci-ssb.c |  260
>> -------------------------------------------
>>   3 files changed, 7 insertions(+), 281 deletions(-)
>>   delete mode 100644 drivers/usb/host/ohci-ssb.c
>>
>> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
>> index 2fc5637..00b6fc8 100644
>> --- a/drivers/usb/host/Kconfig
>> +++ b/drivers/usb/host/Kconfig
>> @@ -373,10 +373,15 @@ config USB_OHCI_HCD_PCI
>>         If unsure, say Y.
>>
>>   config USB_OHCI_HCD_SSB
>> -    bool "OHCI support for Broadcom SSB OHCI core"
>> +    bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
>>       depends on USB_OHCI_HCD&&  (SSB = y || SSB = USB_OHCI_HCD)&& 
>> EXPERIMENTAL
>> +    select USB_HCD_SSB
>> +    select USB_OHCI_HCD_PLATFORM
>>       default n
>>       ---help---
>> +      This option is deprecated now and the driver was removed, use
>> +      USB_HCD_SSB and USB_OHCI_HCD_PLATFORM instead.
>> +
>>         Support for the Sonics Silicon Backplane (SSB) attached
>>         Broadcom USB OHCI core.
> 
> Looks fine as it helps transitioning old .config files. Should the
> select statements be mentioned in the help section, ie. 'using' iso 'use'.

I think "use" is better as USB_OHCI_HCD_SSB will be removed in some time
and it should not be used any more. If someone generated the config or a
base config with some other script it should be changed to USB_HCD_SSB
and USB_OHCI_HCD_PLATFORM.

Hauke

Hauke


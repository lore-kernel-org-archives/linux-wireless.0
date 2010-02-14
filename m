Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:55432 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab0BNJVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 04:21:20 -0500
Message-ID: <4B77C089.9090403@gmail.com>
Date: Sun, 14 Feb 2010 10:21:13 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/3] rt2x00: Reorganize RT chipset setting for PCI/SOC
 devices.
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com> <1266090949-5468-2-git-send-email-gwingerde@gmail.com> <1266090949-5468-3-git-send-email-gwingerde@gmail.com> <201002140215.14535.IvDoorn@gmail.com>
In-Reply-To: <201002140215.14535.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/10 02:15, Ivo van Doorn wrote:
> Hi,
> 
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -40,6 +40,9 @@
>>  #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
>>  #include "rt2x00usb.h"
>>  #endif
>> +#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
>> +#include "rt2x00pci.h"
>> +#endif
> 
> this is very ugly, but apparently it is unavoidable to make rt2800lib free from
> PCI and USB specific code... :(
> 

Actually, this is a temporary situation, and this chunk can be removed again after
patch 3 of the series has been applied.

I'll create a cleanup patch to exactly to that.

With respect to the USB specific code, I have to look at if there is a way to
resolve that, as the USB specific code is only there in 1 place. Maybe a call-back
function to the bus-specific rt2800 drivers could help here.

---
Gertjan.

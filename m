Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28256 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaALOdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 09:33:36 -0500
Message-ID: <52D2A7B5.2030003@broadcom.com> (sfid-20140112_153339_649230_4CE2B206)
Date: Sun, 12 Jan 2014 15:33:25 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>	<52B2E638.8060906@hauke-m.de>	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>	<52B300FC.7070204@hauke-m.de>	<52B31392.2070705@broadcom.com>	<CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>	<52B43718.504@broadcom.com> <CACna6rx_6yyJ88YZ2A5=XjK61xC=F2fX9B54MQcuzcZBOotOrg@mail.gmail.com>
In-Reply-To: <CACna6rx_6yyJ88YZ2A5=XjK61xC=F2fX9B54MQcuzcZBOotOrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2014 03:17 PM, Rafał Miłecki wrote:
> 2013/12/20 Arend van Spriel <arend@broadcom.com>:
>> On 12/20/2013 08:57 AM, Rafał Miłecki wrote:
>>> 2013/12/19 Arend van Spriel <arend@broadcom.com>:
>>>> It is in the kernel tree under
>>>> 'drivers/net/wireless/brcm80211/brcmfmac'. We only support rev 3 because
>>>> rev 2 and earlier do not have enough memory to run fullmac firmware.
>>>> However, I have not found any rev 3 on the market. If you have please
>>>> let me know.
>>>
>>> Could you say something more about rev 2? How does it work with
>>> internal Broadcom driver? Is the firmware stored somewhere else? Does
>>> it have some another kind of memory?
>>
>> It has a split-mac design. So at one end the spectrum there is
>> mac80211-type drivers and at the other side are fullmac drivers like
>> brcmfmac. rev 2 driver sits right in the middle of that with part of the
>> 802.11 stack running on the host and part on the device. This device has
>> not enough memory to run the fullmac firmware.
> 
> Thanks for your explanation. I think I understand now what means
> WLC_HIGH, WLC_LOW, WLC_SPLIT you can see in
> 0001-Staging-Add-initial-release-of-brcm80211-Broadcom-80.patch. I
> guess that softmac devices need WLC_HIGH and WLC_LOW, split devices
> (like BCM43231) need WLC_HIGH (because LOW is implemented in firmware)
> and full MAC devices need none of above.

Yeah. The brcmfmac driver for fullmac devices is a separate driver
design based on bcmdhd.

> As questions about these chipset come over and over, I added a new
> section to the brcm80211 wiki page:
> http://wireless.kernel.org/en/users/Drivers/brcm80211#Unsupported_Chips
> I hope it's OK for you.

Fine and thanks. Let's see how often another such question pops up.

> Btw. if anyone is interested, I've written a minimal user-space app to
> read device info (DL_GETVER) from Broadcom USB dongle.
> gcc -lusb-1.0 main.c -o bcmid

I see fixed definition for vendor and device id. Given that they differ
from what we have in brcmfmac it may be good to use command line
argument(s) for these.

Regards,
Arend

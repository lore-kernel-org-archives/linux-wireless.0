Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1304 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935233Ab2JXQf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 12:35:57 -0400
Message-ID: <508818DB.8060603@broadcom.com> (sfid-20121024_183606_031210_D17CB1E3)
Date: Wed, 24 Oct 2012 18:35:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Franky Lin" <frankyl@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Driver for USB device with ID 050d:615a
References: <5087035E.9010609@lwfinger.net>
 <5087CA82.5070902@broadcom.com>
 <CACna6rxysanXp-TYwcet_76s4OKtEZCnmh61GkjL5cRwrb6xRA@mail.gmail.com>
In-Reply-To: <CACna6rxysanXp-TYwcet_76s4OKtEZCnmh61GkjL5cRwrb6xRA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 06:04 PM, Rafał Miłecki wrote:
> 2012/10/24 Arend van Spriel <arend@broadcom.com>:
>> On 10/23/2012 10:51 PM, Larry Finger wrote:
>>>
>>> Arend and Franky,
>>>
>>> I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to
>>> get the model with a Realtek RTL8192DU chip. Instead I got a version
>>> with a Broadcom chip, which lsusb identifies as
>>>
>>> Bus 001 Device 005: ID 050d:615a Belkin Components F7D4101 / F9L1101
>>> 802.11abgn Wireless Adapter [Broadcom BCM4323]
>>>
>>> I have since acquired a different device with the Realtek chip, thus It
>>> could return the Belkin device; however, the cost was minimal and I will
>>> keep it if there is a driver for it. Is it a brcmfmac device that is not
>>> yet in the device tables, or is it some other sort of unit that may
>>> never be supported under Linux?
>>
>>
>> Hi Larry,
>>
>> I went digging and this chip requires a different driver model (basically a
>> split stack between host and dongle). This model is being abandoned for
>> newer chips so we decided not to support it in mainline linux.
>
> What do you think about listing not supported chipsets on your
> brcm80211 wiki page? Thay way users will get clear overview of this
> situation. I think I already heard similar answer about BCM43236 V2
> (found by Hauke in his router).

It has been suggested before (by you if I recall correctly). Howeverm 
the number of chip programs is extensive and it is hard to find out 
which went into production and are available to end-users. So we decided 
only list what we know.

> Btw. your http://wireless.kernel.org/en/users/Drivers/brcm80211
> doesn't say anything about BCM43143, which (I believe) is supported by
> brcmfmac.
> Oh and one more thing: I believe putting minimal kernel version
> requires is also a good idea. Something like:
> "BCM43143 - supported since 3.123"
>

The bcm43143 (and bcm43242) support is in the driver, but the firmware 
for these chips have not been released yet. With that I mean not 
released at all so we can not submit any firmware for those chips to the 
linux-firmware git repository. Consequently, it does not make sense to 
list them on wireless.kernel.org.

Thanks for the kernel version suggestion. I will add that info although 
there is always compat-wireless...eh...compat-drivers ;-)

Gr. AvS


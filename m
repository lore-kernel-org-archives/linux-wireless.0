Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36019 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbGWIIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 04:08:06 -0400
Received: by wicgb10 with SMTP id gb10so131180050wic.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 01:08:04 -0700 (PDT)
Message-ID: <55B0A0E1.9090300@gmail.com> (sfid-20150723_100814_673304_7A9B8B8D)
Date: Thu, 23 Jul 2015 10:08:01 +0200
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: rolf.anderegg@weiss.ch,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de> <55A3A672.1060502@weiss.ch> <55A79B5C.7010501@rempel-privat.de> <55AFC6E1.7060706@weiss.ch> <55AFCFDE.7060902@rempel-privat.de>
In-Reply-To: <55AFCFDE.7060902@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/22/2015 07:16 PM, Oleksij Rempel wrote:
> Am 22.07.2015 um 18:37 schrieb Rolf Anderegg:
>>
>> On 16/07/15 13:54, Oleksij Rempel wrote:
>>> Am 13.07.2015 um 13:52 schrieb Rolf Anderegg:
>>>>
>>>> I suspect that there are bandwidth/speed issues when dealing with USB
>>>> adapters, but that does not inherently mean that the connection is prone
>>>> to drop, right? Doesn't that mean that I am leaking packages somewhere
>>>> along the way? What else could I be looking for?
>>>
>>> The packages can drop if you will do channel scan. STA mode need some
>>> seconds to complete channel scan. It means AP will be all the time
>>> unavailable.
>>
>> Ok, that may be. Then again why am I not experiencing the same
>> connection drop on my ath5k setup? Because the channel scan is more
>> likely to be completed in due time?
>
> Yes, channel scantime on usb device is match longer then on pci.
>

May I ask for the reason it takes a longer time to complete the scanning 
on a USB device compared to a PCI device? I assume the internals of an 
ath9k PCI device is similar as that of an ath9k_htc USB device, so is it 
purely the bus speed that affects this time? Or is the USB device a 
smaller version of the chipset on the PCI device and therefore with a 
lower speed due to power concerns?

If it is due to the bus speed, would it be possible to decouple the 
scanning process from the bus, that is, I assume that the hardware 
performs all the necessary channel switching and channel sensing, so why 
not allow the hardware to gather such information and transfer the 
results in a single burst to the host over the USB bus? Or is the 
channel switching controlled by the host and it takes a lot of time due 
to the duration of transmitting the channel switching commands to the 
USB device?

Thanks,

Wim.


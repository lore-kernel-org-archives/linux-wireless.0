Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1617 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaIHJAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 05:00:37 -0400
Message-ID: <540D7033.5010104@broadcom.com> (sfid-20140908_110040_840836_DB0BC9A3)
Date: Mon, 8 Sep 2014 11:00:35 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: Broadcom Wi-Fi/Bluetooth on GPIO? (Baytrail tablet)
References: <1409870378.19259.9.camel@hadess.net> <CACna6rxj7wJjWrvcLsTzFPKJP+g-an1qOwJSXZNCp99uKnhF8Q@mail.gmail.com>
In-Reply-To: <CACna6rxj7wJjWrvcLsTzFPKJP+g-an1qOwJSXZNCp99uKnhF8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/14 10:06, Rafał Miłecki wrote:
> On 5 September 2014 00:39, Bastien Nocera<hadess@hadess.net>  wrote:
>> On this tablet, based on a Baytrail SoC, I found reference of this
>> Broadcom device in the DSDT, and I believe it could be the
>> Bluetooth/Wi-Fi chipset (this one[1]?):
>> ---8<---
>> Device (BRC3)
>> {
>>      Name (_ADR, One)  // _ADR: Address
>>      Name (_DEP, Package (0x01)  // _DEP: Dependencies
>>      {
>>          GPO2
>>      })
>>      Name (_HID, "BCM4321")  // _HID: Hardware ID
>>      Name (_CID, "BCM43241")  // _CID: Compatible ID
>>      Name (GMOD, ResourceTemplate ()
>>      {
>>          GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
>> IoRestrictionOutputOnly,
>>              "\\_SB.GPO2", 0x00, ResourceConsumer, ,
>>              )
>>              {   // Pin list
>>                  0x0014
>>              }
>>      })
>> ---8<---
>>
>> Am I correct in thinking that it's a Broadcom chipset? What would it
>> take to get this supported in the kernel? I'm currently stuck on a
>> slightly older kernel (3.16.0) due to Intel graphics driver problems,
>> but I couldn't find anything directly related to this in the current
>> linus tree.
>
> Most of wireless devices in phones/tables/etc. are full MAC devices.
> Broadcom wireless chipset names are a bit tricky. For example chipset
> 0x4322 can be found in soft MAC devices as well as in full MAC ones.
> However in case of Full MAC 0x4322 chipset Broadcom used marketing
> name BCM43231.
>
> So I think (it's just a guess) your device is a chipset identifying
> itself as 0x4321 in a Full MAC device with marketing name BCM43241.
>
> It seems that brcmfmac already supports BCM43241 as SDIO device. So
> unless your tables uses some different (unsupported) chip revision, it
> should be just a matter of interface to support your WiFi.

Correct. I suspect the tablet has 43241. So you can try brcmfmac driver. 
When you load it with 'debug=0x1416' you will probably get more from the 
kernel log regarding the chip revision. You need to have firmware in 
/lib/firmware/brcm. Which one depends on the chip id and/or revision.

Regards,
Arend

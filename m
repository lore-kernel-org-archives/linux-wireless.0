Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57614 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaIEIGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 04:06:18 -0400
Received: by mail-ie0-f178.google.com with SMTP id tp5so594500ieb.9
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 01:06:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409870378.19259.9.camel@hadess.net>
References: <1409870378.19259.9.camel@hadess.net>
Date: Fri, 5 Sep 2014 10:06:17 +0200
Message-ID: <CACna6rxj7wJjWrvcLsTzFPKJP+g-an1qOwJSXZNCp99uKnhF8Q@mail.gmail.com> (sfid-20140905_100625_845739_9673923A)
Subject: Re: Broadcom Wi-Fi/Bluetooth on GPIO? (Baytrail tablet)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 September 2014 00:39, Bastien Nocera <hadess@hadess.net> wrote:
> On this tablet, based on a Baytrail SoC, I found reference of this
> Broadcom device in the DSDT, and I believe it could be the
> Bluetooth/Wi-Fi chipset (this one[1]?):
> ---8<---
> Device (BRC3)
> {
>     Name (_ADR, One)  // _ADR: Address
>     Name (_DEP, Package (0x01)  // _DEP: Dependencies
>     {
>         GPO2
>     })
>     Name (_HID, "BCM4321")  // _HID: Hardware ID
>     Name (_CID, "BCM43241")  // _CID: Compatible ID
>     Name (GMOD, ResourceTemplate ()
>     {
>         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
> IoRestrictionOutputOnly,
>             "\\_SB.GPO2", 0x00, ResourceConsumer, ,
>             )
>             {   // Pin list
>                 0x0014
>             }
>     })
> ---8<---
>
> Am I correct in thinking that it's a Broadcom chipset? What would it
> take to get this supported in the kernel? I'm currently stuck on a
> slightly older kernel (3.16.0) due to Intel graphics driver problems,
> but I couldn't find anything directly related to this in the current
> linus tree.

Most of wireless devices in phones/tables/etc. are full MAC devices.
Broadcom wireless chipset names are a bit tricky. For example chipset
0x4322 can be found in soft MAC devices as well as in full MAC ones.
However in case of Full MAC 0x4322 chipset Broadcom used marketing
name BCM43231.

So I think (it's just a guess) your device is a chipset identifying
itself as 0x4321 in a Full MAC device with marketing name BCM43241.

It seems that brcmfmac already supports BCM43241 as SDIO device. So
unless your tables uses some different (unsupported) chip revision, it
should be just a matter of interface to support your WiFi.

I'm adding brcm80211 ML, they should be able to help a bit more.

[0] http://wireless.kernel.org/en/users/Drivers/brcm80211

-- 
Rafał

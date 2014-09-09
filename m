Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45538 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaIIJ3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 05:29:12 -0400
Message-ID: <1410254937.4077.5.camel@hadess.net> (sfid-20140909_112915_737249_1AF2C545)
Subject: Re: Broadcom Wi-Fi/Bluetooth on GPIO? (Baytrail tablet)
From: Bastien Nocera <hadess@hadess.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Date: Tue, 09 Sep 2014 11:28:57 +0200
In-Reply-To: <540D7033.5010104@broadcom.com>
References: <1409870378.19259.9.camel@hadess.net>
	 <CACna6rxj7wJjWrvcLsTzFPKJP+g-an1qOwJSXZNCp99uKnhF8Q@mail.gmail.com>
	 <540D7033.5010104@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Rafał, Arend,

On Mon, 2014-09-08 at 11:00 +0200, Arend van Spriel wrote:
> On 09/05/14 10:06, Rafał Miłecki wrote:
> > On 5 September 2014 00:39, Bastien Nocera<hadess@hadess.net>  wrote:
> >> On this tablet, based on a Baytrail SoC, I found reference of this
> >> Broadcom device in the DSDT, and I believe it could be the
> >> Bluetooth/Wi-Fi chipset (this one[1]?):
> >> ---8<---
> >> Device (BRC3)
> >> {
> >>      Name (_ADR, One)  // _ADR: Address
> >>      Name (_DEP, Package (0x01)  // _DEP: Dependencies
> >>      {
> >>          GPO2
> >>      })
> >>      Name (_HID, "BCM4321")  // _HID: Hardware ID
> >>      Name (_CID, "BCM43241")  // _CID: Compatible ID
> >>      Name (GMOD, ResourceTemplate ()
> >>      {
> >>          GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
> >> IoRestrictionOutputOnly,
> >>              "\\_SB.GPO2", 0x00, ResourceConsumer, ,
> >>              )
> >>              {   // Pin list
> >>                  0x0014
> >>              }
> >>      })
> >> ---8<---
> >>
> >> Am I correct in thinking that it's a Broadcom chipset? What would it
> >> take to get this supported in the kernel? I'm currently stuck on a
> >> slightly older kernel (3.16.0) due to Intel graphics driver problems,
> >> but I couldn't find anything directly related to this in the current
> >> linus tree.
> >
> > Most of wireless devices in phones/tables/etc. are full MAC devices.
> > Broadcom wireless chipset names are a bit tricky. For example chipset
> > 0x4322 can be found in soft MAC devices as well as in full MAC ones.
> > However in case of Full MAC 0x4322 chipset Broadcom used marketing
> > name BCM43231.
> >
> > So I think (it's just a guess) your device is a chipset identifying
> > itself as 0x4321 in a Full MAC device with marketing name BCM43241.
> >
> > It seems that brcmfmac already supports BCM43241 as SDIO device. So
> > unless your tables uses some different (unsupported) chip revision, it
> > should be just a matter of interface to support your WiFi.
> 
> Correct. I suspect the tablet has 43241. So you can try brcmfmac driver. 
> When you load it with 'debug=0x1416' you will probably get more from the 
> kernel log regarding the chip revision. You need to have firmware in 
> /lib/firmware/brcm. Which one depends on the chip id and/or revision.

It turns out that the device, though present in the decompiled ACPI DSDT
isn't actually present on the system. This tablet actually contains a
Realtek device (also present in the DSDT). Apologies for the misdirected
mail.

Cheers


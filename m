Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52774 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbcGFNlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 09:41:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
Date: Wed, 06 Jul 2016 15:42:38 +0200
Message-ID: <3354017.XSBSmHHtrQ@wuerfel> (sfid-20160706_154116_864073_84DA3F2E)
In-Reply-To: <CAF7Mx6qcwtwYQhrkNk8o+D6UQBLEQkL-ti7aMQyLVuRo+JMUfw@mail.gmail.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <26659199.PqqRaoPEho@wuerfel> <CAF7Mx6qcwtwYQhrkNk8o+D6UQBLEQkL-ti7aMQyLVuRo+JMUfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 6, 2016 10:08:55 AM CEST Arend Van Spriel wrote:
> On Tue, Jul 5, 2016 at 3:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday, July 4, 2016 8:36:05 PM CEST Arend van Spriel wrote:
> >> On 04-07-16 16:54, Arnd Bergmann wrote:
> >> > On Monday, July 4, 2016 11:08:38 AM CEST Arend Van Spriel wrote:
> >> >
> >> > In drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c I already see
> >> > over a dozen different chips being supported, bcm4329 is only one of
> >> > them. In particular, there seem to be some that have various modules:
> >> >
> >> >         BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
> >> >         BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43241_CHIP_ID, 0x00000020, 43241B4),
> >> >         BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43241_CHIP_ID, 0xFFFFFFC0, 43241B5),
> >> >
> >> > So if you have a bcm43241, that compatible string probably should
> >> > include both brcm,bcm43241-b4-fmac and brcm,bcm43241-fmac, possibly also
> >> > brcm,bcm4329-fmac, to show that it is a superset of the programming
> >> > interface of that one.
> >>
> >> Hi Arnd,
> >>
> >> I have to disagree here. The compatible string "brcm,bcm4329-fmac" is
> >> chosen as the bcm4329 chip was the first supported and we never added
> >> others as there is no other programming required. For all supported
> >> devices the same device tree properties apply and are handled the same.
> >> As such there is no need to come up with a new compatible string.
> >
> > Generally speaking, the way that the compatible strings work is that you
> > add a new one whenever you get a new piece of hardware, and you can leave
> > the first one as a fallback so you don't have to change the driver.
> >
> > Adding the new string for the actual device is important though,
> > since you might only discover later that they are not 100% compatible
> > and that you in fact need to know the difference.
> >
> > For discoverable buses like sdio or usb, it may actually be better
> > to not identify the device through the compatible property at all,
> > and instead use a string that is generated from the actual identifier
> > as the primary key, as e.g. documented in
> > Documentation/devicetree/bindings/usb/usb-device.txt
> 
> Well, that is my point. We do not need to identify the device here. We
> can obtain that info, ie. chip id and revision, from the device itself
> as our wifi chips have a discoverable AXI backplane. What is missing
> is that we have no way to tell what board/module this device is
> integrated on, which makes it impossible to select the correct nvram
> file. The model property can fill that gap just nicely.

We have multiple inconsistencies here, and it's not this driver that is
particularly messed up, but I think using the model property here
would make it worse:

All existing uses of the model property in arch/arm/boot/dts and most of
the ones in arch/powerpc/boot/dts are against the intended usage in
one way or another, but adding different kind of incorrect usage won't
improve that.

The only way I can see the model property being used correctly would
be to have it match the first entry in the compatible property, but
that is completely redundant, so we tend to omit it, except for the
root node in which it is required. For the root node however, the
historic practice that has crept in on ARM is to put something completely
different in there, which is a human-readable description of the
machine rather than something we can use as a unique indentifier.

I'd just consider the "model" property burned, and not use it for anything
that doesn't already use it, just like we handle "device_type": a few
things require it, nothing else should use it.

I agree with your point that the "compatible" property in case of brcmfmac
is really odd because it is not required to identify the hardware when
the SDIO device identification is sufficient, and we just need it to guard
the definition of the other properties. However it seems that now we
actually do need to identify the hardware because we cannot read the
board ID and revision that is supposed to come from nvram but also needed
to read the nvram contents from a file.

	Arnd

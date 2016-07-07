Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:52546 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824AbcGGIog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 04:44:36 -0400
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
Date: Thu, 07 Jul 2016 10:46:28 +0200
Message-ID: <3996482.D5xdKXDiGl@wuerfel> (sfid-20160707_104455_653187_0ABF5EA9)
In-Reply-To: <bb1beb8d-652d-aa97-e24b-e3e27397dd2e@broadcom.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <3354017.XSBSmHHtrQ@wuerfel> <bb1beb8d-652d-aa97-e24b-e3e27397dd2e@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 6, 2016 9:19:41 PM CEST Arend Van Spriel wrote:
> On 6-7-2016 15:42, Arnd Bergmann wrote:
> > On Wednesday, July 6, 2016 10:08:55 AM CEST Arend Van Spriel wrote:
> >> On Tue, Jul 5, 2016 at 3:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > All existing uses of the model property in arch/arm/boot/dts and most of
> > the ones in arch/powerpc/boot/dts are against the intended usage in
> > one way or another, but adding different kind of incorrect usage won't
> > improve that.
> > 
> > The only way I can see the model property being used correctly would
> > be to have it match the first entry in the compatible property, but
> > that is completely redundant, so we tend to omit it, except for the
> > root node in which it is required. For the root node however, the
> > historic practice that has crept in on ARM is to put something completely
> > different in there, which is a human-readable description of the
> > machine rather than something we can use as a unique indentifier.
> > 
> > I'd just consider the "model" property burned, and not use it for anything
> > that doesn't already use it, just like we handle "device_type": a few
> > things require it, nothing else should use it.
> 
> If that is the agreed approach in devicetree arena I am fine with it. I
> have been unaware of this and just looked at the suggestion from Jonas
> seeing a solution to the problem at hand.

I don't think it has been discussed or decided before as the question
has not come up, so for now this is my personal view. Maybe one of
the devicetree maintainers can comment on this.

> > I agree with your point that the "compatible" property in case of brcmfmac
> > is really odd because it is not required to identify the hardware when
> > the SDIO device identification is sufficient, and we just need it to guard
> > the definition of the other properties. However it seems that now we
> > actually do need to identify the hardware because we cannot read the
> > board ID and revision that is supposed to come from nvram but also needed
> > to read the nvram contents from a file.
> 
> The board ID and rev in the nvram may not be used if the device has
> these stored in OTP. However, the problem is that the device need
> firmware+nvram loaded into it before we can start the firmware on the
> device. Now if we were to add boardtype and boardrev properties in the
> binding to identify the hardware, I suppose a new compatible value would
> be required.

I'm a bit confused by the interdependencies now. You say that there are
board ID/rev values stored in OTP. What exactly prevents us from just
using those to generate a file name to look up the nvram file on disk
for the remaining values?

Do we require the firmware to be running before we can read the OTP,
or are there cases where the board ID in OTP is wrong or missing?

If we can't rely on OTP for one of those reasons and instead add two
properties for boardtype/boardrev, I don't think that requires a
change of the compatible string, we would just document those two
as optional properties.

	Arnd

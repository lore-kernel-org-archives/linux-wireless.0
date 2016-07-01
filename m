Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61765 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbcGAJSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 05:18:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Rob Herring <robh@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	devicetree <devicetree@vger.kernel.org>,
	linux-wireless@vger.kernel.org, linux-sunxi@googlegroups.com,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
Date: Fri, 01 Jul 2016 11:20:26 +0200
Message-ID: <4973367.zalLWgQG3c@wuerfel> (sfid-20160701_111901_611843_56CC298B)
In-Reply-To: <b18cd232-711a-b617-2f09-09c4bdf2c3c4@broadcom.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <20160701020836.GA1722@rob-hp-laptop> <b18cd232-711a-b617-2f09-09c4bdf2c3c4@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, July 1, 2016 10:17:37 AM CEST Arend Van Spriel wrote:
> 
> On 1-7-2016 4:08, Rob Herring wrote:
> > On Wed, Jun 29, 2016 at 04:04:31PM +0200, Hans de Goede wrote:
> >> Add a brcm,nvram_file_name dt property to allow overruling the default
> >> nvram filename for sdio devices. The idea is that we can specify a
> >> board specific nvram file, e.g. brcmfmac43362-ap6210.txt for boards
> >> with an ap6210 wifi sdio module and ship this in linux-firmware, so
> >> that wifi will work out of the box, without requiring users to find
> >> and then manually install the right nvram file for their board.
> > 
> > What about putting its contents directly into DT? It's just text 
> > key/value pairs so it would match up well.
> 
> It would be an option, but I have no clue how to dig up documentation of
> these key,value pairs. The file is typically obtained from a wifi module
> vendor which would need to be converted to DT format, ie. prefix with
> "brcm," etc. From driver perspective this would mean it need to know
> keys. Currently, it just takes the file contents and sends it to the device.

I can see multiple ways to do this here:

- create a child node for the nvram settings and document that the properties
  in there follow exactly the format that is used for the nvram file.

- have just one property that contains a copy of the entire nvram file,
  serving as a backing store for the file instead of pointing to the file.

- figure out more about the actual properties that are required and then
  document only the ones that are actually different between devices using
  the same chip. With a per-chip file that we can put into linux-firmware,
  and the data from the OTP ROM, we might need only a small subset here
  that fits well enough in the DT.

> >> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> index 5dbf169..2ba13a6 100644
> >> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> @@ -11,6 +11,7 @@ Required properties:
> >>  Optional properties:
> >>   - brcm,drive-strength : drive strength used for SDIO pins on device in mA
> >>  	(default = 6).
> >> + - brcm,nvram_file_name : name of the nvram file to load
> > 
> > The need for firmware file names has come up several times though 
> > nothing merged to yet. There has been at least some level of agreement 
> > to use "firmware-name" here. 
> 
> Do you mean with or without vendor prefix? Actually the device needs two
> files to initialize. The firmware that is needed to have anything
> running on the device and the nvram data that characterizes the device
> for that firmware.

I thought the outcome was to never put file names into DT for new bindings, because
it doesn't do what you want in the end: Either the "compatible" string correctly
identifies the device and can be used to construct or look up a file name, or
the compatible string is not enough to actually identify the device and should
be extended with a more specific one.

Having the module identifer in a property to use that along with the compatible
string for the file name would also work, but I think just using the compatible
string list by itself makes more sense.

	Arnd

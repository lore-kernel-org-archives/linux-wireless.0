Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:65446 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbcF2UGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 16:06:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Priit Laes <plaes@plaes.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
Date: Wed, 29 Jun 2016 22:07:21 +0200
Message-ID: <6119590.gPKNGsSJ3t@wuerfel> (sfid-20160629_220642_081194_ABDE1C5F)
In-Reply-To: <1467230078.2598.2.camel@plaes.org>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <6402170.5s0abZDqlD@wuerfel> <1467230078.2598.2.camel@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 29, 2016 10:54:38 PM CEST Priit Laes wrote:
> On Wed, 2016-06-29 at 21:33 +0200, Arnd Bergmann wrote:

> > What is the size of this nvram file? As it's board specific, I wonder
> > if we can simply include it inside of the DT verbatim. I remember
> > doing that (in the pre-dtb days, on real open firmware) for the
> > "spidernet"
> > ethernet driver.
> 
> It contains a bit too much info:
> 
> This is what CubieTruck requires:
> 
> http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/nvram_a
> p6210.txt

Ah, I had not realized that this is a text based interface rather than
a small binary blob with fixed offsets.

On the other hand, each line in there could be translated easily into
a separate DT property, and some of them (manfid/prodid, macaddr, ...)
look like they directly correspond to properties we already have.

As Arend said there is also the option of having a chip specific
nvram file (brcmfmac43362-sdio.txt) as a fallback when there is no
more specific module. How many of the lines in your example would
actually differ between the two? Does this affect all of them, or
just a subset that could be turned into a smaller set of DT
properties?

	Arnd

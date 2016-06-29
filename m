Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:33416 "EHLO plaes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbcF2TzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 15:55:01 -0400
Message-ID: <1467230078.2598.2.camel@plaes.org> (sfid-20160629_215505_927197_CD032CD5)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add
 brcm,nvram_file_name dt property
From: Priit Laes <plaes@plaes.org>
To: arnd@arndb.de, Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
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
Date: Wed, 29 Jun 2016 22:54:38 +0300
In-Reply-To: <6402170.5s0abZDqlD@wuerfel>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
	 <ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
	 <f8995599-115d-87e5-7928-c029b48584f1@broadcom.com>
	 <6402170.5s0abZDqlD@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-29 at 21:33 +0200, Arnd Bergmann wrote:
> On Wednesday, June 29, 2016 8:51:44 PM CEST Arend Van Spriel wrote:
> > > Typical wifi devices will have some sort of non volatile storage
> > > on board to not only store the ethernet(mac) address, but also
> > > to contain e.g. info about the antenna gain so that the firmware
> > > and/or the driver can take the antenna gain into account and
> > > ensure
> > > that they never exceed the maximum allowed broadcast strength.
> > > 
> > > However on some embedded devices there is no non-volatile storage
> > > for the wifi (for cost reasons) and instead this configuration
> > > info
> > > (which is board / pcb specific) is loaded in the form of a
> > > file which contains the contents which would normally be in the
> > > non-volatile storage.
> > > 
> > > Since we are dealing with a per-board config-file here, which is
> > > loaded from the os filesystem we really need to specify a
> > > basename
> > > here as the list of possible boards is endless, so we cannot
> > > have a lookup table in the driver.
> > 
> > As Jonas mentioned the general principle of device tree is to be
> > agnostic with regards to OS and/or driver as you undoubtedly know.
> > His
> > proposal seems like a usable solution for your problem while
> > complying
> > to the device tree principle. So instead of overriding the default
> > brcmfmac should modify it when dt specifies the "module" property,
> > ie:
> > 
> > no "module" in DT:      nvram filename = brcm/brcmfmac43362-
> > sdio.txt
> > "module=ap6210" in DT:  nvram filename = brcm/brcmfmac43362-
> > ap6210.txt
> > 
> > By the way, the example in the bindings file does not seem to
> > specify a
> > basename, but path+basename+fileext.
> 
> What is the size of this nvram file? As it's board specific, I wonder
> if we can simply include it inside of the DT verbatim. I remember
> doing that (in the pre-dtb days, on real open firmware) for the
> "spidernet"
> ethernet driver.

It contains a bit too much info:

This is what CubieTruck requires:

http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/nvram_a
p6210.txt


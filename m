Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53385 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZFKPIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:08:32 -0400
Received: by ewy6 with SMTP id 6so2101065ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 08:08:33 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
Date: Thu, 11 Jun 2009 17:08:28 +0200
Cc: Samuel Ortiz <samuel@sortiz.org>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, pierre@ossman.eu,
	kalle.valo@iki.fi, san@google.com
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <200906111659.29575.florian@openwrt.org> <69e28c910906110804t23c50bdbs7e23f6dd604e977e@mail.gmail.com>
In-Reply-To: <69e28c910906110804t23c50bdbs7e23f6dd604e977e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906111708.30481.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Thursday 11 June 2009 17:04:01 Gábor Stefanik, vous avez écrit :
> On Thu, Jun 11, 2009 at 4:59 PM, Florian Fainelli<florian@openwrt.org> 
wrote:
> > Le Thursday 11 June 2009 16:55:20 Samuel Ortiz, vous avez écrit :
> >> On Thu, 2009-06-11 at 16:38 +0200, Gábor Stefanik wrote:
> >> > On Thu, Jun 11, 2009 at 4:02 AM, Bob Copeland<me@bobcopeland.com> 
wrote:
> >> > > Here's v2 of the SDIO interface for wl12xx, still with a FIXME or
> >> > > two.
> >> > >
> >> > > For my part, this is mainly a port of the Google/TI Android SDIO
> >> > > interface logic to the existing SPI driver.  I have confirmed that
> >> > > the driver associates and sends some traffic.
> >> > >
> >> > > Pierre, hoping to get your perspective on the SDIO bits in patch 7,
> >> > > since I very likely don't know what I'm doing :)  Especially
> >> > > regarding the platform code setup, in which the correct GPIOs have
> >> > > to be written to turn on the device before probe will work.  For the
> >> > > SPI interface, we use spi_register_board_info() for a similar
> >> > > purpose, but I'm not sure if there is a standard way to do that for
> >> > > SDIO.  This copies Google's platform driver for now.
> >> > >
> >> > > Conversion to readl/writel etc where appropriate is TODO.
> >> > >
> >> > > Bob Copeland (7):
> >> > >  wl12xx: separate bus i/o code into io.c
> >> > >  wl12xx: use wiphy_dev instead of wl->spi->dev
> >> > >  wl12xx: introduce wl12xx_if_operations struct
> >> > >  wl12xx: make wl12xx_set_partition bus agnostic
> >> > >  wl12xx: move module probe methods into spi.c
> >> > >  wl12xx: split spi interface into separate module
> >> > >  wl12xx: add sdio support
> >> > >
> >> > >  drivers/net/wireless/wl12xx/Kconfig  |   24 +++-
> >> > >  drivers/net/wireless/wl12xx/Makefile |   10 +-
> >> > >  drivers/net/wireless/wl12xx/acx.c    |    3 +-
> >> > >  drivers/net/wireless/wl12xx/boot.c   |    3 +-
> >> > >  drivers/net/wireless/wl12xx/cmd.c    |   15 +-
> >> > >  drivers/net/wireless/wl12xx/event.c  |    6 +-
> >> > >  drivers/net/wireless/wl12xx/io.c     |  181 +++++++++++++++++++++
> >> > >  drivers/net/wireless/wl12xx/io.h     |   62 +++++++
> >> > >  drivers/net/wireless/wl12xx/main.c   |  152 ++++--------------
> >> > >  drivers/net/wireless/wl12xx/ps.c     |    3 +-
> >> > >  drivers/net/wireless/wl12xx/rx.c     |   10 +-
> >> > >  drivers/net/wireless/wl12xx/sdio.c   |  250
> >> > > +++++++++++++++++++++++++++++ drivers/net/wireless/wl12xx/spi.c    |
> >> > > 289 ++++++++++++++-------------------
> >> > > drivers/net/wireless/wl12xx/spi.h |   40 -----
> >> > >  drivers/net/wireless/wl12xx/tx.c     |   64 ++++----
> >> > >  drivers/net/wireless/wl12xx/wl1251.c |    9 +-
> >> > >  drivers/net/wireless/wl12xx/wl12xx.h |   14 ++-
> >> > >  17 files changed, 752 insertions(+), 383 deletions(-)
> >> > >  create mode 100644 drivers/net/wireless/wl12xx/io.c
> >> > >  create mode 100644 drivers/net/wireless/wl12xx/io.h
> >> > >  create mode 100644 drivers/net/wireless/wl12xx/sdio.c
> >> >
> >> > Can we expect vlynq any time soon?
> >>
> >> I guess we need:
> >>
> >> 1) A linux vlynq driver for that, and last thing I saw [1], it wasnt
> >> really pretty/ready
> >
> > That driver is perfectly functionnal on a TI AR7 and we have used it in
> > OpenWrt for months with the acx100/111 driver. What makes you think it is
> > not yet ready ? There was a couple of suggestions from a TI employee,
> > which are perfectly valid, but I have no hardware to implement what he is
> > suggesting (no daisy chaining ...).
>
> Better forget the acx1xx driver. There is legal controversy around it
> - the devs never released any documentation during the reverse
> engineering process, and development was quite slow until TI's
> copyrighted ti_ap.o driver's source code leaked...

This is why I ask if wl12xx can actually drive an acx111 chipset or the HW is 
completely different.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------

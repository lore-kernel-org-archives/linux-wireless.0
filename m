Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45426 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763147AbZFKOyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 10:54:36 -0400
Received: by ewy6 with SMTP id 6so2089811ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 07:54:37 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
Date: Thu, 11 Jun 2009 16:54:33 +0200
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	pierre@ossman.eu, kalle.valo@iki.fi, san@google.com
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <69e28c910906110738r54f8cecdv3c5f8dcd58b8b6c8@mail.gmail.com>
In-Reply-To: <69e28c910906110738r54f8cecdv3c5f8dcd58b8b6c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906111654.34324.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Thursday 11 June 2009 16:38:46 Gábor Stefanik, vous avez écrit :
> On Thu, Jun 11, 2009 at 4:02 AM, Bob Copeland<me@bobcopeland.com> wrote:
> > Here's v2 of the SDIO interface for wl12xx, still with a FIXME or two.
> >
> > For my part, this is mainly a port of the Google/TI Android SDIO
> > interface logic to the existing SPI driver.  I have confirmed that
> > the driver associates and sends some traffic.
> >
> > Pierre, hoping to get your perspective on the SDIO bits in patch 7,
> > since I very likely don't know what I'm doing :)  Especially regarding
> > the platform code setup, in which the correct GPIOs have to be written
> > to turn on the device before probe will work.  For the SPI interface,
> > we use spi_register_board_info() for a similar purpose, but I'm not
> > sure if there is a standard way to do that for SDIO.  This copies
> > Google's platform driver for now.
> >
> > Conversion to readl/writel etc where appropriate is TODO.
> >
> > Bob Copeland (7):
> >  wl12xx: separate bus i/o code into io.c
> >  wl12xx: use wiphy_dev instead of wl->spi->dev
> >  wl12xx: introduce wl12xx_if_operations struct
> >  wl12xx: make wl12xx_set_partition bus agnostic
> >  wl12xx: move module probe methods into spi.c
> >  wl12xx: split spi interface into separate module
> >  wl12xx: add sdio support
> >
> >  drivers/net/wireless/wl12xx/Kconfig  |   24 +++-
> >  drivers/net/wireless/wl12xx/Makefile |   10 +-
> >  drivers/net/wireless/wl12xx/acx.c    |    3 +-
> >  drivers/net/wireless/wl12xx/boot.c   |    3 +-
> >  drivers/net/wireless/wl12xx/cmd.c    |   15 +-
> >  drivers/net/wireless/wl12xx/event.c  |    6 +-
> >  drivers/net/wireless/wl12xx/io.c     |  181 +++++++++++++++++++++
> >  drivers/net/wireless/wl12xx/io.h     |   62 +++++++
> >  drivers/net/wireless/wl12xx/main.c   |  152 ++++--------------
> >  drivers/net/wireless/wl12xx/ps.c     |    3 +-
> >  drivers/net/wireless/wl12xx/rx.c     |   10 +-
> >  drivers/net/wireless/wl12xx/sdio.c   |  250
> > +++++++++++++++++++++++++++++ drivers/net/wireless/wl12xx/spi.c    |  289
> > ++++++++++++++------------------- drivers/net/wireless/wl12xx/spi.h    |
> >   40 -----
> >  drivers/net/wireless/wl12xx/tx.c     |   64 ++++----
> >  drivers/net/wireless/wl12xx/wl1251.c |    9 +-
> >  drivers/net/wireless/wl12xx/wl12xx.h |   14 ++-
> >  17 files changed, 752 insertions(+), 383 deletions(-)
> >  create mode 100644 drivers/net/wireless/wl12xx/io.c
> >  create mode 100644 drivers/net/wireless/wl12xx/io.h
> >  create mode 100644 drivers/net/wireless/wl12xx/sdio.c
>
> Can we expect vlynq any time soon?

That would be really great. FYI, vlynq bus support was added to -mm tree few 
days ago. Do you guys know how much wl12xx differs from acx111 ?
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------

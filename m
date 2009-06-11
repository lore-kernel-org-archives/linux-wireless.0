Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZFKPBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:01:43 -0400
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
From: Samuel Ortiz <samuel@sortiz.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	pierre@ossman.eu, kalle.valo@iki.fi, san@google.com
In-Reply-To: <1244732120.2465.3.camel@sortiz-mobl>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	 <69e28c910906110738r54f8cecdv3c5f8dcd58b8b6c8@mail.gmail.com>
	 <1244732120.2465.3.camel@sortiz-mobl>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Jun 2009 17:03:52 +0200
Message-Id: <1244732632.2465.5.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-11 at 16:55 +0200, Samuel Ortiz wrote:
> On Thu, 2009-06-11 at 16:38 +0200, Gábor Stefanik wrote:
> > On Thu, Jun 11, 2009 at 4:02 AM, Bob Copeland<me@bobcopeland.com> wrote:
> > > Here's v2 of the SDIO interface for wl12xx, still with a FIXME or two.
> > >
> > > For my part, this is mainly a port of the Google/TI Android SDIO
> > > interface logic to the existing SPI driver.  I have confirmed that
> > > the driver associates and sends some traffic.
> > >
> > > Pierre, hoping to get your perspective on the SDIO bits in patch 7,
> > > since I very likely don't know what I'm doing :)  Especially regarding
> > > the platform code setup, in which the correct GPIOs have to be written
> > > to turn on the device before probe will work.  For the SPI interface,
> > > we use spi_register_board_info() for a similar purpose, but I'm not
> > > sure if there is a standard way to do that for SDIO.  This copies
> > > Google's platform driver for now.
> > >
> > > Conversion to readl/writel etc where appropriate is TODO.
> > >
> > > Bob Copeland (7):
> > >  wl12xx: separate bus i/o code into io.c
> > >  wl12xx: use wiphy_dev instead of wl->spi->dev
> > >  wl12xx: introduce wl12xx_if_operations struct
> > >  wl12xx: make wl12xx_set_partition bus agnostic
> > >  wl12xx: move module probe methods into spi.c
> > >  wl12xx: split spi interface into separate module
> > >  wl12xx: add sdio support
> > >
> > >  drivers/net/wireless/wl12xx/Kconfig  |   24 +++-
> > >  drivers/net/wireless/wl12xx/Makefile |   10 +-
> > >  drivers/net/wireless/wl12xx/acx.c    |    3 +-
> > >  drivers/net/wireless/wl12xx/boot.c   |    3 +-
> > >  drivers/net/wireless/wl12xx/cmd.c    |   15 +-
> > >  drivers/net/wireless/wl12xx/event.c  |    6 +-
> > >  drivers/net/wireless/wl12xx/io.c     |  181 +++++++++++++++++++++
> > >  drivers/net/wireless/wl12xx/io.h     |   62 +++++++
> > >  drivers/net/wireless/wl12xx/main.c   |  152 ++++--------------
> > >  drivers/net/wireless/wl12xx/ps.c     |    3 +-
> > >  drivers/net/wireless/wl12xx/rx.c     |   10 +-
> > >  drivers/net/wireless/wl12xx/sdio.c   |  250 +++++++++++++++++++++++++++++
> > >  drivers/net/wireless/wl12xx/spi.c    |  289 ++++++++++++++-------------------
> > >  drivers/net/wireless/wl12xx/spi.h    |   40 -----
> > >  drivers/net/wireless/wl12xx/tx.c     |   64 ++++----
> > >  drivers/net/wireless/wl12xx/wl1251.c |    9 +-
> > >  drivers/net/wireless/wl12xx/wl12xx.h |   14 ++-
> > >  17 files changed, 752 insertions(+), 383 deletions(-)
> > >  create mode 100644 drivers/net/wireless/wl12xx/io.c
> > >  create mode 100644 drivers/net/wireless/wl12xx/io.h
> > >  create mode 100644 drivers/net/wireless/wl12xx/sdio.c
> > 
> > Can we expect vlynq any time soon?
> I guess we need:
> 
> 1) A linux vlynq driver for that, and last thing I saw [1], it wasnt
> really pretty/ready
This: http://lkml.org/lkml/2009/6/4/259 seems to be a bit better...

> 2) A device that would have a wl12xx chip connected to the host through
> vlynq.
> 
> Cheers,
> Samuel.
> 
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/0906.0/00155.html
> 
> 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


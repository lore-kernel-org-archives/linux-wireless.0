Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1639 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbZFKCDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 0/7] wl12xx SDIO interface
Date: Wed, 10 Jun 2009 22:02:53 -0400
Message-Id: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's v2 of the SDIO interface for wl12xx, still with a FIXME or two.

For my part, this is mainly a port of the Google/TI Android SDIO
interface logic to the existing SPI driver.  I have confirmed that
the driver associates and sends some traffic.

Pierre, hoping to get your perspective on the SDIO bits in patch 7,
since I very likely don't know what I'm doing :)  Especially regarding
the platform code setup, in which the correct GPIOs have to be written
to turn on the device before probe will work.  For the SPI interface,
we use spi_register_board_info() for a similar purpose, but I'm not
sure if there is a standard way to do that for SDIO.  This copies
Google's platform driver for now.

Conversion to readl/writel etc where appropriate is TODO.

Bob Copeland (7):
  wl12xx: separate bus i/o code into io.c
  wl12xx: use wiphy_dev instead of wl->spi->dev
  wl12xx: introduce wl12xx_if_operations struct
  wl12xx: make wl12xx_set_partition bus agnostic
  wl12xx: move module probe methods into spi.c
  wl12xx: split spi interface into separate module
  wl12xx: add sdio support

 drivers/net/wireless/wl12xx/Kconfig  |   24 +++-
 drivers/net/wireless/wl12xx/Makefile |   10 +-
 drivers/net/wireless/wl12xx/acx.c    |    3 +-
 drivers/net/wireless/wl12xx/boot.c   |    3 +-
 drivers/net/wireless/wl12xx/cmd.c    |   15 +-
 drivers/net/wireless/wl12xx/event.c  |    6 +-
 drivers/net/wireless/wl12xx/io.c     |  181 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h     |   62 +++++++
 drivers/net/wireless/wl12xx/main.c   |  152 ++++--------------
 drivers/net/wireless/wl12xx/ps.c     |    3 +-
 drivers/net/wireless/wl12xx/rx.c     |   10 +-
 drivers/net/wireless/wl12xx/sdio.c   |  250 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/spi.c    |  289 ++++++++++++++-------------------
 drivers/net/wireless/wl12xx/spi.h    |   40 -----
 drivers/net/wireless/wl12xx/tx.c     |   64 ++++----
 drivers/net/wireless/wl12xx/wl1251.c |    9 +-
 drivers/net/wireless/wl12xx/wl12xx.h |   14 ++-
 17 files changed, 752 insertions(+), 383 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/io.c
 create mode 100644 drivers/net/wireless/wl12xx/io.h
 create mode 100644 drivers/net/wireless/wl12xx/sdio.c



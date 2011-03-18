Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60325 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab1CROT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:19:59 -0400
Received: by mail-ww0-f48.google.com with SMTP id 33so3270467wwc.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:19:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 00/14] wl12xx: 1281/1283 support
Date: Fri, 18 Mar 2011 16:19:15 +0200
Message-Id: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We have been discussing internally and fixing this series of patches
for a couple of weeks now and I think it's time to get the initial
support included in wl12xx.git.  There are still some issues that we
are going to address in separate patches on top of this series.  These
changes are quite widespread and we have already been working on them
for a very long time, so we need to apply them so we don't have to
keep rebasing them all the time.  It will also give the opportunity
for more people to test this work.

I have touched many of the patches myself, which I marked in the
commit log with [comments inside braces -- Luca] so that people know
what I have changed compared to the original ones sent by Shahar.

Cheers,
Luca.

Arik Nemtsov (1):
  wl12xx: 1281/1283 support - Use different FW file for AP mode
    wl127x/wl128x chips

Luciano Coelho (3):
  wl12xx: add new board_tcxo_clock element to the platform data
  wl12xx: 1281/1283 support - add block size handling for sdio and spi
  wl12xx: use 1 spare TX block instead of two

Shahar Levi (10):
  wl12xx: 1281/1283 support - move IRQ polarity
  wl12xx: 1281/1283 support - Add Definitions
  wl12xx: 1281/1283 support - Add acx commands
  wl12xx: 1281/1283 support - New radio structs and functions
  wl12xx: 1281/1283 support - Loading FW & NVS
  wl12xx: 1281/1283 support - New boot sequence
  wl12xx: 1281/1283 support - use dynamic memory for the RX/TX pools
  wl12xx: 1281/1283 support - Improve Tx & Rx path
  wl12xx: 1281/1283 support - Add dummy packet support
  wl12xx: 1281/1283 support - enable chip support

 drivers/net/wireless/wl12xx/Kconfig     |    2 +-
 drivers/net/wireless/wl12xx/acx.c       |   61 ++++++--
 drivers/net/wireless/wl12xx/acx.h       |   11 ++
 drivers/net/wireless/wl12xx/boot.c      |  282 ++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/boot.h      |   48 ++++++
 drivers/net/wireless/wl12xx/cmd.c       |   97 ++++++++++-
 drivers/net/wireless/wl12xx/cmd.h       |   34 ++++
 drivers/net/wireless/wl12xx/conf.h      |    7 +-
 drivers/net/wireless/wl12xx/event.c     |    6 +
 drivers/net/wireless/wl12xx/event.h     |    5 +-
 drivers/net/wireless/wl12xx/ini.h       |   98 +++++++++++-
 drivers/net/wireless/wl12xx/init.c      |   45 +++++-
 drivers/net/wireless/wl12xx/init.h      |    1 +
 drivers/net/wireless/wl12xx/io.c        |   10 +
 drivers/net/wireless/wl12xx/io.h        |    2 +
 drivers/net/wireless/wl12xx/main.c      |  166 ++++++++++++++++--
 drivers/net/wireless/wl12xx/reg.h       |   15 +--
 drivers/net/wireless/wl12xx/rx.c        |   31 ++--
 drivers/net/wireless/wl12xx/sdio.c      |   23 +++-
 drivers/net/wireless/wl12xx/sdio_test.c |   17 ++-
 drivers/net/wireless/wl12xx/spi.c       |    8 +-
 drivers/net/wireless/wl12xx/testmode.c  |   10 +-
 drivers/net/wireless/wl12xx/tx.c        |  159 +++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h        |   53 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h    |   50 +++++-
 include/linux/wl12xx.h                  |   15 ++-
 26 files changed, 1077 insertions(+), 179 deletions(-)


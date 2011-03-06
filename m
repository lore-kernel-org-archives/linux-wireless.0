Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44342 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1CFO2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:08 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ES79I026257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:08 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 00/15] wl12xx: 1281/1283 support
Date: Sun,  6 Mar 2011 16:32:05 +0200
Message-Id: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding support to 1281/1283 WLAN TI chip (Quattro).
That support required changes in boot sequence, Tx&Rx path, ISR
polarity, SDIO block size padding, dynamic TX mem blocks, Dummy
packet event support, interrupt pacing and more.
Auto detection support between wl127x and wl128x that add the ability to operate
in each of them automatically.

Note:
That patch doesn't add support for wl128x with SPI bus.

Arik Nemtsov (2):
  wl12xx: 1281/1283 support - Use different FW file for AP mode
    wl127x/wl128x chips
  wl12xx: 1281/1283 support - disable TX aggregation for AP mode in
    wl128x

Shahar Levi (13):
  wl12xx: 1281/1283 support - move IRQ polarity
  wl12xx: 1281/1283 support - Add Definitions
  wl12xx: 1281/1283 support - Add acx commands
  wl12xx: 1281/1283 support - New radio struc & func
  wl12xx: 1281/1283 support - Loading FW & NVS
  wl12xx: 1281/1283 support - New boot sequence
  wl12xx: 1281/1283 support - Set mem conf & dynamic mem
  wl12xx: 1281/1283 support - Improve Tx & Rx path
  wl12xx: 1281/1283 support - Add dummy packet support
  wl12xx: 1281/1283 support - Set WiFi & BT cox
  wl12xx: 1281/1283 support - Add chip interrupt pacing
  wl12xx: 1281/1283 support - Use 1 spare blocks for 128x STA, and 2
    for the rest
  wl12xx: 1281/1283 support - enable chip support

 drivers/net/wireless/wl12xx/Kconfig     |    2 +-
 drivers/net/wireless/wl12xx/acx.c       |   71 ++++++--
 drivers/net/wireless/wl12xx/acx.h       |   11 +
 drivers/net/wireless/wl12xx/boot.c      |  307 ++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/boot.h      |   59 ++++++
 drivers/net/wireless/wl12xx/cmd.c       |   97 +++++++++-
 drivers/net/wireless/wl12xx/cmd.h       |   34 ++++
 drivers/net/wireless/wl12xx/conf.h      |   17 ++-
 drivers/net/wireless/wl12xx/event.c     |    6 +
 drivers/net/wireless/wl12xx/event.h     |    5 +-
 drivers/net/wireless/wl12xx/ini.h       |   96 ++++++++++-
 drivers/net/wireless/wl12xx/init.c      |   37 ++++-
 drivers/net/wireless/wl12xx/io.c        |    5 +
 drivers/net/wireless/wl12xx/io.h        |    2 +
 drivers/net/wireless/wl12xx/main.c      |  154 ++++++++++++++--
 drivers/net/wireless/wl12xx/reg.h       |   15 +--
 drivers/net/wireless/wl12xx/rx.c        |   34 ++--
 drivers/net/wireless/wl12xx/sdio.c      |   20 ++-
 drivers/net/wireless/wl12xx/sdio_test.c |   17 ++-
 drivers/net/wireless/wl12xx/spi.c       |   16 ++-
 drivers/net/wireless/wl12xx/testmode.c  |   22 ++-
 drivers/net/wireless/wl12xx/tx.c        |  172 ++++++++++++++----
 drivers/net/wireless/wl12xx/tx.h        |   53 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h    |   24 ++-
 include/linux/wl12xx.h                  |    1 +
 25 files changed, 1092 insertions(+), 185 deletions(-)


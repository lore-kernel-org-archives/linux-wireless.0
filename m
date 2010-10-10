Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34395 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0JJIgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:36:46 -0400
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Subject: [PATCH 0/3] wl1251: move to a separate directory
Date: Sun, 10 Oct 2010 11:28:30 +0300
Message-Id: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently wl1251 and wl1271 are in the same directory named wl12xx,
even though they are totally separate drivers. There's only one header
file which is shared by the two.

To make it easier to develop wl1271 and add new features, move wl1251
out from wl12xx.

Kalle Valo (3):
  wl1251: create a copy of wl12xx_80211.h for wl1251
  wl1251: move to it's own directory
  wl1251: update the new location to the maintainers file

 MAINTAINERS                                        |    3 +-
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/wl1251/Kconfig                |   33 ++++
 drivers/net/wireless/wl1251/Makefile               |    7 +
 .../wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} |    8 +-
 .../wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} |    2 +-
 .../{wl12xx/wl1251_boot.c => wl1251/boot.c}        |   12 +-
 .../{wl12xx/wl1251_boot.h => wl1251/boot.h}        |    0
 .../wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} |   10 +-
 .../wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} |    0
 .../{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c}  |    6 +-
 .../{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h}  |    0
 .../{wl12xx/wl1251_event.c => wl1251/event.c}      |    8 +-
 .../{wl12xx/wl1251_event.h => wl1251/event.h}      |    0
 .../{wl12xx/wl1251_init.c => wl1251/init.c}        |    8 +-
 .../{wl12xx/wl1251_init.h => wl1251/init.h}        |    0
 .../wireless/{wl12xx/wl1251_io.c => wl1251/io.c}   |    4 +-
 .../wireless/{wl12xx/wl1251_io.h => wl1251/io.h}   |    0
 .../{wl12xx/wl1251_main.c => wl1251/main.c}        |   20 ++--
 .../wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c}   |    8 +-
 .../wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h}   |    2 +-
 .../wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} |    0
 .../wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c}   |   10 +-
 .../wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h}   |    0
 .../{wl12xx/wl1251_sdio.c => wl1251/sdio.c}        |    0
 .../wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} |    4 +-
 .../wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} |    6 +-
 .../wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c}   |    8 +-
 .../wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h}   |    2 +-
 drivers/net/wireless/{wl12xx => wl1251}/wl1251.h   |    0
 drivers/net/wireless/wl1251/wl12xx_80211.h         |  156 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/Kconfig                |   34 -----
 drivers/net/wireless/wl12xx/Makefile               |    9 -
 34 files changed, 258 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/wireless/wl1251/Kconfig
 create mode 100644 drivers/net/wireless/wl1251/Makefile
 rename drivers/net/wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.c => wl1251/boot.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.h => wl1251/boot.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.c => wl1251/event.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.h => wl1251/event.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.c => wl1251/init.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.h => wl1251/init.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.c => wl1251/io.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.h => wl1251/io.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_main.c => wl1251/main.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_sdio.c => wl1251/sdio.c} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h} (99%)
 rename drivers/net/wireless/{wl12xx => wl1251}/wl1251.h (100%)
 create mode 100644 drivers/net/wireless/wl1251/wl12xx_80211.h


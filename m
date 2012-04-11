Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40918 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab2DKJiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:16 -0400
Received: by lahe6 with SMTP id e6so651997lah.32
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:13 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 00/16] wl12xx/wl1251/wlcore: reorganize drivers part 1
Date: Wed, 11 Apr 2012 12:37:47 +0300
Message-Id: <1334137083-13490-1-git-send-email-coelho@ti.com> (sfid-20120411_113820_185918_ACED94CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the first batch of patches from the reorganization our drivers and
preparation for the inclusion of the new wl18xx driver.

First of all, we moved all the TI wireless drivers into a new subdirectory
drivers/net/wireless/ti so we can keep all our drivers in the same place.

Then, we started splitting the wl12xx driver into a core module (wlcore) and a
lower driver (wl12xx).  This was done because the wl18xx driver shares a lot of
the same code.  The wlcore module will eventually become a kind of common
library for the different lower drivers to use.  This patchset contains only
the initial part of this work.  More will follow soon.

John, please let me know if it's okay to include the first patch, with which I
moved stuff around, in my tree so we can keep things in sync more easily.

Please review.

Cheers,
Luca.

Arik Nemtsov (1):
  wlcore/wl12xx: create per-chip-family private storage

Luciano Coelho (15):
  wireless/wl12xx/wl1251: move TI WLAN modules to a common ti
    subdirectory
  wl12xx/wlcore: rename wl12xx to wlcore
  wl12xx/wlcore: spin out the wl12xx probe from wlcore to a new wl12xx
  wl12xx/wlcore: initial split of probe
  wl12xx/wlcore: move wl1271 struct to wlcore and add ops
  wlcore/wl12xx: implement chip-specific partition tables
  wlcore/wl12xx: implement chip-specific register tables
  wlcore/wl12xx: add chip-specific identify chip operation
  wlcore/wl12xx: move get_pg_ver to the lower driver
  wlcore/wl12xx: move top initialization to wl12xx
  wlcore/wl12xx: move MAC address reading operation to lower driver
  wlcore/wl12xx: add command trigger and event ack operations
  wlcore/wl12xx: add quirk for legacy NVS support
  wlcore: remove some unnecessary event mailbox address reads
  wlcore: add quirk to disable ELP

 MAINTAINERS                                        |   27 +-
 drivers/net/wireless/Kconfig                       |    3 +-
 drivers/net/wireless/Makefile                      |    4 +-
 drivers/net/wireless/ti/Kconfig                    |   14 +
 drivers/net/wireless/ti/Makefile                   |    4 +
 drivers/net/wireless/{ => ti}/wl1251/Kconfig       |    0
 drivers/net/wireless/{ => ti}/wl1251/Makefile      |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.h        |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.c     |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.h     |    0
 drivers/net/wireless/{ => ti}/wl1251/event.c       |    0
 drivers/net/wireless/{ => ti}/wl1251/event.h       |    0
 drivers/net/wireless/{ => ti}/wl1251/init.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/init.h        |    0
 drivers/net/wireless/{ => ti}/wl1251/io.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/io.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/main.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/reg.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/sdio.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/wl1251.h      |    0
 .../net/wireless/{ => ti}/wl1251/wl12xx_80211.h    |    0
 drivers/net/wireless/ti/wl12xx/Kconfig             |    8 +
 drivers/net/wireless/ti/wl12xx/Makefile            |    3 +
 drivers/net/wireless/ti/wl12xx/main.c              |  716 ++++++++++++++++++
 drivers/net/wireless/{ => ti}/wl12xx/reg.h         |  315 ++++----
 drivers/net/wireless/ti/wlcore/Kconfig             |   41 +
 drivers/net/wireless/ti/wlcore/Makefile            |   15 +
 drivers/net/wireless/{wl12xx => ti/wlcore}/acx.c   |    3 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/acx.h   |    2 +-
 drivers/net/wireless/ti/wlcore/boot.c              |  447 +++++++++++
 drivers/net/wireless/ti/wlcore/boot.h              |   54 ++
 drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.c   |   32 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.h   |   16 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/conf.h  |    1 -
 drivers/net/wireless/{wl12xx => ti/wlcore}/debug.h |    1 +
 .../net/wireless/{wl12xx => ti/wlcore}/debugfs.c   |    2 +-
 .../net/wireless/{wl12xx => ti/wlcore}/debugfs.h   |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/event.c |   19 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/event.h |    1 -
 drivers/net/wireless/{wl12xx => ti/wlcore}/ini.h   |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/init.c  |   20 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/init.h  |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/io.c    |  191 ++----
 drivers/net/wireless/{wl12xx => ti/wlcore}/io.h    |   88 ++-
 drivers/net/wireless/{wl12xx => ti/wlcore}/main.c  |  232 ++-----
 drivers/net/wireless/{wl12xx => ti/wlcore}/ps.c    |    8 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/ps.h    |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/rx.c    |   24 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/rx.h    |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/scan.c  |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/scan.h  |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/sdio.c  |    6 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/spi.c   |    4 +-
 .../net/wireless/{wl12xx => ti/wlcore}/testmode.c  |    3 +-
 .../net/wireless/{wl12xx => ti/wlcore}/testmode.h  |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/tx.c    |   23 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/tx.h    |    0
 .../net/wireless/{wl12xx => ti/wlcore}/wl12xx.h    |  242 ------
 .../wireless/{wl12xx => ti/wlcore}/wl12xx_80211.h  |    0
 .../{wl12xx => ti/wlcore}/wl12xx_platform_data.c   |    0
 drivers/net/wireless/ti/wlcore/wlcore.h            |  399 ++++++++++
 drivers/net/wireless/wl12xx/Kconfig                |   48 --
 drivers/net/wireless/wl12xx/Makefile               |   15 -
 drivers/net/wireless/wl12xx/boot.c                 |  794 --------------------
 drivers/net/wireless/wl12xx/boot.h                 |  120 ---
 78 files changed, 2132 insertions(+), 1823 deletions(-)
 create mode 100644 drivers/net/wireless/ti/Kconfig
 create mode 100644 drivers/net/wireless/ti/Makefile
 rename drivers/net/wireless/{ => ti}/wl1251/Kconfig (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/Makefile (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/main.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/reg.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/sdio.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl1251.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl12xx_80211.h (100%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl12xx/main.c
 rename drivers/net/wireless/{ => ti}/wl12xx/reg.h (71%)
 create mode 100644 drivers/net/wireless/ti/wlcore/Kconfig
 create mode 100644 drivers/net/wireless/ti/wlcore/Makefile
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/acx.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/acx.h (99%)
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.c
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.h
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.c (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/conf.h (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debug.h (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/event.c (94%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/event.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ini.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/init.c (97%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/init.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/io.c (55%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/io.h (71%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/main.c (96%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ps.c (97%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ps.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/rx.c (94%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/rx.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/scan.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/scan.h (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/sdio.c (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/spi.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/tx.c (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/tx.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx.h (68%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_80211.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_platform_data.c (100%)
 create mode 100644 drivers/net/wireless/ti/wlcore/wlcore.h
 delete mode 100644 drivers/net/wireless/wl12xx/Kconfig
 delete mode 100644 drivers/net/wireless/wl12xx/Makefile
 delete mode 100644 drivers/net/wireless/wl12xx/boot.c
 delete mode 100644 drivers/net/wireless/wl12xx/boot.h

-- 
1.7.5.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36942 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaFYUUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:20:52 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so2588186wgh.14
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:20:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 00/34] staging: vt6656: mac80211 conversion remove legacy code 
Date: Wed, 25 Jun 2014 21:19:37 +0100
Message-Id: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222058_374759_C51D07A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following conversion to mac80211 the following patches remove dead code.

Malcolm Priestley (34):
  staging: vt6656: dead code remove zonetypes
  staging: vt6656: move life time macros to rxtx.h
  staging: vt6656: dpc remove dead code.
  staging: vt6656: main_usb removed dead code
  staging: vt6656: deadcode iwctl.c/h
  staging: vt6656: wcmd remove dead code
  staging: vt6656: rxtx remove dead code
  staging: vt6656: dead code remove wmgr.c
  staging: vt6656: dead code remove bssdb.c
  staging: vt6656: dead code wpactl
  staging: vt6656: dead code remove wpa2.c
  staging: vt6656: remove dead code wpa
  staging: vt6656: dead code remove wctl
  staging: vt6656: dead code remove tkip.c/h
  staging: vt6656: dead code remove micheal.c/h
  staging: vt6656: dead code remove rc4.c/h
  staging: vt6656: dead code remove iowpa.h
  staging: vt6656: decode remove tether.c/h
  staging: vt6656: remove dead code datarate
  staging: vt6656: dead code remove 80211mgr.c/h
  staging: vt6656: remove dead code from power.c/h
  staging: vt6656: dead code remove old key functions
  staging: vt6656: dead code remove tmacro.h
  staging: vt6656: dead codead remove bssdb.h header
  staging: vt6656: dpc remove dead code RXvMngWorkItem
  staging: vt6656: Remove vnt_set_channel from device_init_registers
  staging: vt6656: remove old rx receive list
  staging: vt6656: dead code remove wmgr.h
  staging: vt6656: remove old channel tables
  staging: vt6656: dead code remove 80211hdr.h
  staging: vt6656: device_init_registers remove unused variables
  staging: vt6656: dead code remove variables device_set_options
  staging: vt6656: device.h remove dead strutures and variables
  staging: vt6656: remove unneeded config and headers

 drivers/staging/vt6656/80211hdr.h           |  324 --
 drivers/staging/vt6656/80211mgr.c           |  861 ------
 drivers/staging/vt6656/80211mgr.h           |  808 -----
 drivers/staging/vt6656/Kconfig              |    2 -
 drivers/staging/vt6656/Makefile             |   13 -
 drivers/staging/vt6656/baseband.c           |   42 +-
 drivers/staging/vt6656/baseband.h           |    1 -
 drivers/staging/vt6656/bssdb.c              | 1466 ---------
 drivers/staging/vt6656/bssdb.h              |  276 --
 drivers/staging/vt6656/card.c               |    4 -
 drivers/staging/vt6656/channel.c            |  436 ---
 drivers/staging/vt6656/channel.h            |    9 -
 drivers/staging/vt6656/country.h            |  162 -
 drivers/staging/vt6656/datarate.c           |  364 ---
 drivers/staging/vt6656/datarate.h           |   62 -
 drivers/staging/vt6656/desc.h               |    2 -
 drivers/staging/vt6656/device.h             |  275 +-
 drivers/staging/vt6656/dpc.c                |  861 +-----
 drivers/staging/vt6656/dpc.h                |    5 -
 drivers/staging/vt6656/int.c                |    2 -
 drivers/staging/vt6656/iocmd.h              |   38 -
 drivers/staging/vt6656/iowpa.h              |   75 -
 drivers/staging/vt6656/iwctl.c              | 1802 -----------
 drivers/staging/vt6656/iwctl.h              |  138 -
 drivers/staging/vt6656/key.c                |  694 -----
 drivers/staging/vt6656/key.h                |   72 +-
 drivers/staging/vt6656/mac.c                |    3 -
 drivers/staging/vt6656/mac.h                |    1 -
 drivers/staging/vt6656/main_usb.c           |  612 +---
 drivers/staging/vt6656/michael.c            |  167 -
 drivers/staging/vt6656/michael.h            |   52 -
 drivers/staging/vt6656/power.c              |  161 -
 drivers/staging/vt6656/power.h              |    7 -
 drivers/staging/vt6656/rc4.c                |   87 -
 drivers/staging/vt6656/rc4.h                |   46 -
 drivers/staging/vt6656/rf.c                 |    1 -
 drivers/staging/vt6656/rxtx.c               | 1266 --------
 drivers/staging/vt6656/rxtx.h               |    8 +-
 drivers/staging/vt6656/tether.c             |   60 -
 drivers/staging/vt6656/tether.h             |  101 -
 drivers/staging/vt6656/tkip.c               |  246 --
 drivers/staging/vt6656/tkip.h               |   45 -
 drivers/staging/vt6656/tmacro.h             |   52 -
 drivers/staging/vt6656/usbpipe.c            |    2 -
 drivers/staging/vt6656/vntconfiguration.dat |    6 -
 drivers/staging/vt6656/wcmd.c               |  844 ------
 drivers/staging/vt6656/wcmd.h               |    4 +-
 drivers/staging/vt6656/wctl.c               |  244 --
 drivers/staging/vt6656/wctl.h               |   94 -
 drivers/staging/vt6656/wmgr.c               | 4362 ---------------------------
 drivers/staging/vt6656/wmgr.h               |  397 ---
 drivers/staging/vt6656/wpa.c                |  314 --
 drivers/staging/vt6656/wpa.h                |   72 -
 drivers/staging/vt6656/wpa2.c               |  235 --
 drivers/staging/vt6656/wpa2.h               |   53 -
 drivers/staging/vt6656/wpactl.c             |  247 --
 drivers/staging/vt6656/wpactl.h             |   47 -
 57 files changed, 12 insertions(+), 18618 deletions(-)
 delete mode 100644 drivers/staging/vt6656/80211hdr.h
 delete mode 100644 drivers/staging/vt6656/80211mgr.c
 delete mode 100644 drivers/staging/vt6656/80211mgr.h
 delete mode 100644 drivers/staging/vt6656/bssdb.c
 delete mode 100644 drivers/staging/vt6656/bssdb.h
 delete mode 100644 drivers/staging/vt6656/country.h
 delete mode 100644 drivers/staging/vt6656/datarate.c
 delete mode 100644 drivers/staging/vt6656/datarate.h
 delete mode 100644 drivers/staging/vt6656/iocmd.h
 delete mode 100644 drivers/staging/vt6656/iowpa.h
 delete mode 100644 drivers/staging/vt6656/iwctl.c
 delete mode 100644 drivers/staging/vt6656/iwctl.h
 delete mode 100644 drivers/staging/vt6656/michael.c
 delete mode 100644 drivers/staging/vt6656/michael.h
 delete mode 100644 drivers/staging/vt6656/rc4.c
 delete mode 100644 drivers/staging/vt6656/rc4.h
 delete mode 100644 drivers/staging/vt6656/tether.c
 delete mode 100644 drivers/staging/vt6656/tether.h
 delete mode 100644 drivers/staging/vt6656/tkip.c
 delete mode 100644 drivers/staging/vt6656/tkip.h
 delete mode 100644 drivers/staging/vt6656/tmacro.h
 delete mode 100644 drivers/staging/vt6656/vntconfiguration.dat
 delete mode 100644 drivers/staging/vt6656/wctl.c
 delete mode 100644 drivers/staging/vt6656/wctl.h
 delete mode 100644 drivers/staging/vt6656/wmgr.c
 delete mode 100644 drivers/staging/vt6656/wmgr.h
 delete mode 100644 drivers/staging/vt6656/wpa.c
 delete mode 100644 drivers/staging/vt6656/wpa.h
 delete mode 100644 drivers/staging/vt6656/wpa2.c
 delete mode 100644 drivers/staging/vt6656/wpa2.h
 delete mode 100644 drivers/staging/vt6656/wpactl.c
 delete mode 100644 drivers/staging/vt6656/wpactl.h

-- 
1.9.1


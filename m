Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55483 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJYTRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:17:05 -0400
Received: by mail-wg0-f44.google.com with SMTP id y10so3095812wgg.27
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:17:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 00/48] staging: vt6655: remove dead code
Date: Sat, 25 Oct 2014 09:39:38 +0100
Message-Id: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211718_636127_A40DB239)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following conversion to mac80211 the following patches remove dead code.

Malcolm Priestley (48):
  staging: vt6655: s_cbFillTxBufHead remove unused parameters
  staging: vt6655: deadcode remove zone file operations and
    vntconfiguration.dat
  staging: vt6655: dead code remove zones and channel table elements
  staging: vt6655: dead code remove net device code
  staging: vt6655: dead code remove iwctl.c/h
  staging: vt6655: dead code remove ioctl.c/h
  staging: vt6655: dead code remove legacy hostap.c/h
  staging: vt6655: dead code remove wpactl.c/h
  staging: vt6655: dpc.c/h remove dead functions
  staging: vt6655: remove dead functions in power.c/h
  staging: vt6655: dead code remove wmgr.c
  staging: vt6655: dead code remove wcmd.c
  staging: vt6655: rxtx remove dead functions
  staging: vt6655: dead code remove bssdb.c
  staging: vt6655: dead code datarate.c/h
  staging: vt6655: dead code remove IEEE11.h.c/h
  staging: vt6655: card.c/h remove dead functions
  staging: vt6655: deadcode remove wroute.c/h
  staging: vt6655: dead code remove wpa/wpa2
  staging: vt6655: deadcode remove aes_ccmp/rc4/tkip
  staging: vt6655: dead code remove michael.c/h
  staging: vt6655: dead code remove vntwifi.c functions
  staging: vt6655: key.c remove dead functions
  staging: vt6655: mib remove unused functions and structure members
  staging: vt6655L remove tether.c functions
  staging: vt6655: dead code remove tcrc.c/h
  staging: vt6655: dead code remove 80211mgr.c and functions
  staging: vt6655: dead code remove wctl.c/h
  staging: vt6655: channel.c remove dead functions
  staging: vt6655: move all RATE_* macros to device.h
  staging: vt6655: dead code remove vntwifi.h
  staging: vt6655: wmgr.h remove management structures
  staging: vt6655: dead code remove ndis and pmkid strutures.
  staging: vt6655: dead remove wcmd.h and typedefs
  staging: vt6655: dead code remove bssdb.h header
  staging: vt6655: dead code remove tether.h
  staging: vt6655: dead code remove 80211mgr.h
  staging: vt6655: dead code remove iowpa.h
  staging: vt6655: dead code remove iocmd.h
  staging: vt6655: dead code remove country.h
  staging: vt6655: struct vnt_private remove dead members
  staging: vt6655: device.h remove dead strutures and macros
  staging: vt6655: dead code remove 80211hdr.h
  staging: vt6655: remove typedef void *TimerFunction
  staging: vt6655: Move LIFETIME RES 64us macros to rxtx.h
  staging: vt6655: move MAKE_BEACON_RESERVED to device.h
  staging: vt6655: dead code remove wmgr.h
  staging: vt6655: dead code remove header type.h

 drivers/staging/vt6655/80211hdr.h           |  318 --
 drivers/staging/vt6655/80211mgr.c           | 1019 ------
 drivers/staging/vt6655/80211mgr.h           |  725 -----
 drivers/staging/vt6655/IEEE11h.c            |  141 -
 drivers/staging/vt6655/IEEE11h.h            |   42 -
 drivers/staging/vt6655/Makefile             |   23 +-
 drivers/staging/vt6655/aes_ccmp.c           |  374 ---
 drivers/staging/vt6655/aes_ccmp.h           |   37 -
 drivers/staging/vt6655/baseband.c           |    9 +-
 drivers/staging/vt6655/baseband.h           |    6 +-
 drivers/staging/vt6655/bssdb.c              | 1512 ---------
 drivers/staging/vt6655/bssdb.h              |  326 --
 drivers/staging/vt6655/card.c               |  746 -----
 drivers/staging/vt6655/card.h               |   76 -
 drivers/staging/vt6655/channel.c            |  717 -----
 drivers/staging/vt6655/channel.h            |   22 -
 drivers/staging/vt6655/country.h            |  161 -
 drivers/staging/vt6655/datarate.c           |  410 ---
 drivers/staging/vt6655/datarate.h           |   78 -
 drivers/staging/vt6655/desc.h               |    2 -
 drivers/staging/vt6655/device.h             |  306 +-
 drivers/staging/vt6655/device_cfg.h         |    2 -
 drivers/staging/vt6655/device_main.c        | 1311 +-------
 drivers/staging/vt6655/dpc.c                | 1278 --------
 drivers/staging/vt6655/dpc.h                |    8 -
 drivers/staging/vt6655/hostap.c             |  764 -----
 drivers/staging/vt6655/hostap.h             |   58 -
 drivers/staging/vt6655/iocmd.h              |  408 ---
 drivers/staging/vt6655/ioctl.c              |  582 ----
 drivers/staging/vt6655/ioctl.h              |   36 -
 drivers/staging/vt6655/iowpa.h              |  130 -
 drivers/staging/vt6655/iwctl.c              | 1928 -----------
 drivers/staging/vt6655/iwctl.h              |  206 --
 drivers/staging/vt6655/key.c                |  760 -----
 drivers/staging/vt6655/key.h                |  124 -
 drivers/staging/vt6655/mac.c                |    1 -
 drivers/staging/vt6655/mac.h                |    1 -
 drivers/staging/vt6655/mib.c                |  423 ---
 drivers/staging/vt6655/mib.h                |  261 --
 drivers/staging/vt6655/michael.c            |  148 -
 drivers/staging/vt6655/michael.h            |   52 -
 drivers/staging/vt6655/power.c              |  174 -
 drivers/staging/vt6655/power.h              |   16 -
 drivers/staging/vt6655/rc4.c                |   88 -
 drivers/staging/vt6655/rc4.h                |   47 -
 drivers/staging/vt6655/rf.h                 |    1 -
 drivers/staging/vt6655/rxtx.c               | 1207 +------
 drivers/staging/vt6655/rxtx.h               |   40 +-
 drivers/staging/vt6655/srom.c               |    1 -
 drivers/staging/vt6655/srom.h               |    2 -
 drivers/staging/vt6655/tcrc.c               |  191 --
 drivers/staging/vt6655/tcrc.h               |   50 -
 drivers/staging/vt6655/tether.c             |  105 -
 drivers/staging/vt6655/tether.h             |  192 --
 drivers/staging/vt6655/tkip.c               |  268 --
 drivers/staging/vt6655/tkip.h               |   57 -
 drivers/staging/vt6655/tmacro.h             |    2 -
 drivers/staging/vt6655/ttype.h              |   42 -
 drivers/staging/vt6655/upc.h                |    1 -
 drivers/staging/vt6655/vntconfiguration.dat |    1 -
 drivers/staging/vt6655/vntwifi.c            |  698 ----
 drivers/staging/vt6655/vntwifi.h            |  273 --
 drivers/staging/vt6655/wcmd.c               | 1024 ------
 drivers/staging/vt6655/wcmd.h               |  123 -
 drivers/staging/vt6655/wctl.c               |  233 --
 drivers/staging/vt6655/wctl.h               |  105 -
 drivers/staging/vt6655/wmgr.c               | 4603 ---------------------------
 drivers/staging/vt6655/wmgr.h               |  420 ---
 drivers/staging/vt6655/wpa.c                |  300 --
 drivers/staging/vt6655/wpa.h                |   83 -
 drivers/staging/vt6655/wpa2.c               |  359 ---
 drivers/staging/vt6655/wpa2.h               |   77 -
 drivers/staging/vt6655/wpactl.c             |  893 ------
 drivers/staging/vt6655/wpactl.h             |   64 -
 drivers/staging/vt6655/wroute.c             |  187 --
 drivers/staging/vt6655/wroute.h             |   45 -
 76 files changed, 42 insertions(+), 27461 deletions(-)
 delete mode 100644 drivers/staging/vt6655/80211hdr.h
 delete mode 100644 drivers/staging/vt6655/80211mgr.c
 delete mode 100644 drivers/staging/vt6655/80211mgr.h
 delete mode 100644 drivers/staging/vt6655/IEEE11h.c
 delete mode 100644 drivers/staging/vt6655/IEEE11h.h
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.c
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.h
 delete mode 100644 drivers/staging/vt6655/bssdb.c
 delete mode 100644 drivers/staging/vt6655/bssdb.h
 delete mode 100644 drivers/staging/vt6655/country.h
 delete mode 100644 drivers/staging/vt6655/datarate.c
 delete mode 100644 drivers/staging/vt6655/datarate.h
 delete mode 100644 drivers/staging/vt6655/hostap.c
 delete mode 100644 drivers/staging/vt6655/hostap.h
 delete mode 100644 drivers/staging/vt6655/iocmd.h
 delete mode 100644 drivers/staging/vt6655/ioctl.c
 delete mode 100644 drivers/staging/vt6655/ioctl.h
 delete mode 100644 drivers/staging/vt6655/iowpa.h
 delete mode 100644 drivers/staging/vt6655/iwctl.c
 delete mode 100644 drivers/staging/vt6655/iwctl.h
 delete mode 100644 drivers/staging/vt6655/michael.c
 delete mode 100644 drivers/staging/vt6655/michael.h
 delete mode 100644 drivers/staging/vt6655/rc4.c
 delete mode 100644 drivers/staging/vt6655/rc4.h
 delete mode 100644 drivers/staging/vt6655/tcrc.c
 delete mode 100644 drivers/staging/vt6655/tcrc.h
 delete mode 100644 drivers/staging/vt6655/tether.c
 delete mode 100644 drivers/staging/vt6655/tether.h
 delete mode 100644 drivers/staging/vt6655/tkip.c
 delete mode 100644 drivers/staging/vt6655/tkip.h
 delete mode 100644 drivers/staging/vt6655/ttype.h
 delete mode 100644 drivers/staging/vt6655/vntconfiguration.dat
 delete mode 100644 drivers/staging/vt6655/vntwifi.c
 delete mode 100644 drivers/staging/vt6655/vntwifi.h
 delete mode 100644 drivers/staging/vt6655/wcmd.c
 delete mode 100644 drivers/staging/vt6655/wcmd.h
 delete mode 100644 drivers/staging/vt6655/wctl.c
 delete mode 100644 drivers/staging/vt6655/wctl.h
 delete mode 100644 drivers/staging/vt6655/wmgr.c
 delete mode 100644 drivers/staging/vt6655/wmgr.h
 delete mode 100644 drivers/staging/vt6655/wpa.c
 delete mode 100644 drivers/staging/vt6655/wpa.h
 delete mode 100644 drivers/staging/vt6655/wpa2.c
 delete mode 100644 drivers/staging/vt6655/wpa2.h
 delete mode 100644 drivers/staging/vt6655/wpactl.c
 delete mode 100644 drivers/staging/vt6655/wpactl.h
 delete mode 100644 drivers/staging/vt6655/wroute.c
 delete mode 100644 drivers/staging/vt6655/wroute.h

-- 
1.9.1


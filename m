Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:56012 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYUPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:08 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so2635214wes.14
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 00/17] staging: vt6656: conversion to mac80211
Date: Wed, 25 Jun 2014 21:14:21 +0100
Message-Id: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221514_650539_0969296A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patches in this series convert the driver to mac80211.

As well as infrastructure mode the driver now operates in
IBSS and access point modes.

Host access point is now working with hostapd in nl80211 mode.

These patches creates huge amount of dead code.

The driver nolonger supports WEP 256 mode due to no support in
mac80211. The vendors code had removed support for this in their
last version anyway.

Malcolm Priestley (17):
  staging: vt6656: mac80211 conversion: create rx function.
  staging: vt6656: mac80211 conversion: Create tx functions
  staging: vt6656: mac80211 conversion: add key functions
  staging: vt6656: mac80211 conversion: main_usb add functions and
    change usb_driver functions
  staging: vt6656: mac80211 conversion: add channel bands
  staging: vt6656: mac80211 conversion: add vnt_init to bScheduleCommand
  staging: vt6656: mac80211 conversion: vnt_update_ifs change basic
    rates
  staging: vt6656: mac80211 conversion: enable power saving
  staging: vt6656: mac80211 conversion: vRunCommand change beacon
  staging: vt6656: mac80211 conversion: change vnt_next_tbtt_wakeup
  staging: vt6656: mac80211 conversion: int.c changes
  staging: vt6656: mac80211 conversion: vRunCommand channel changes
  staging: vt6656: mac80211 conversion: move data rates to device.h
  staging: vt6656: mac80211 conversion: change vnt_rf_set_txpower
  staging: vt6656: vnt_mac_set_keyentry remove byLocalID check
  staging: vt6656: mac80211 conversion: device_alloc_bufs use dev_err
  staging: vt6656: mac80211 conversion: rxtx implement power save poll

 drivers/staging/vt6656/Kconfig    |   2 +-
 drivers/staging/vt6656/card.c     |  22 +-
 drivers/staging/vt6656/channel.c  | 139 +++++++++
 drivers/staging/vt6656/channel.h  |   2 +
 drivers/staging/vt6656/datarate.h |  14 -
 drivers/staging/vt6656/device.h   |  31 +-
 drivers/staging/vt6656/dpc.c      | 137 +++++++-
 drivers/staging/vt6656/dpc.h      |   3 +
 drivers/staging/vt6656/int.c      |  49 +--
 drivers/staging/vt6656/key.c      | 143 +++++++++
 drivers/staging/vt6656/key.h      |  13 +
 drivers/staging/vt6656/mac.c      |   4 -
 drivers/staging/vt6656/main_usb.c | 640 +++++++++++++++++++++++++++++++-------
 drivers/staging/vt6656/power.c    |  47 +--
 drivers/staging/vt6656/rf.c       |  23 +-
 drivers/staging/vt6656/rxtx.c     | 462 +++++++++++++++++++++++++--
 drivers/staging/vt6656/rxtx.h     |   7 +-
 drivers/staging/vt6656/usbpipe.c  |  32 +-
 drivers/staging/vt6656/wcmd.c     |  34 +-
 drivers/staging/vt6656/wcmd.h     |   2 +
 20 files changed, 1506 insertions(+), 300 deletions(-)

-- 
1.9.1


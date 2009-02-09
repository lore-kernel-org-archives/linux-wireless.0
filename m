Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30455 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZBIIAU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:20 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57764.650130.995504@gargle.gargle.HOWL> (sfid-20090209_090023_740424_88864ACA)
Date: Mon, 9 Feb 2009 13:26:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 00/10] ath9k: Driver Cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of patches cleaning up various parts of the driver.
Most of them address the items in:
http://linuxwireless.org/en/users/Drivers/ath9k#TODO

Sujith

Sujith (10):
  ath9k: Header file cleanup
  ath9k: Convert ANI channel to a pointer
  ath9k: Remove all the sc_ prefixes
  ath9k: Store HW version information in a separate structure
  ath9k: Move regulatory information to a separate structure
  ath9k: Remove duplicate variables
  ath9k: Merge ath_hal and ath_hal_5416 structures
  ath9k: Add callbacks hooks for EEPROM operations
  ath9k: Cleanup EEPROM operations
  ath9k: Remove all the useless ah_ variable prefixes

 drivers/net/wireless/ath9k/ahb.c    |   16 +-
 drivers/net/wireless/ath9k/ani.c    |  263 ++--
 drivers/net/wireless/ath9k/ani.h    |  138 ++
 drivers/net/wireless/ath9k/ath9k.h  | 1640 ++++++++------------
 drivers/net/wireless/ath9k/beacon.c |   96 +-
 drivers/net/wireless/ath9k/calib.c  |  190 +--
 drivers/net/wireless/ath9k/calib.h  |  124 ++
 drivers/net/wireless/ath9k/core.h   |  821 ----------
 drivers/net/wireless/ath9k/debug.c  |  136 +-
 drivers/net/wireless/ath9k/debug.h  |  153 ++
 drivers/net/wireless/ath9k/eeprom.c | 2922 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/eeprom.h |  473 ++++++
 drivers/net/wireless/ath9k/hw.c     | 1142 +++++++--------
 drivers/net/wireless/ath9k/hw.h     | 1568 +++++++------------
 drivers/net/wireless/ath9k/mac.c    |  175 +--
 drivers/net/wireless/ath9k/mac.h    |  676 ++++++++
 drivers/net/wireless/ath9k/main.c   |  418 +++---
 drivers/net/wireless/ath9k/pci.c    |   20 +-
 drivers/net/wireless/ath9k/phy.c    |  221 ++--
 drivers/net/wireless/ath9k/phy.h    |   14 +-
 drivers/net/wireless/ath9k/rc.c     |   14 +-
 drivers/net/wireless/ath9k/rc.h     |   17 +-
 drivers/net/wireless/ath9k/recv.c   |   48 +-
 drivers/net/wireless/ath9k/reg.h    |   53 +-
 drivers/net/wireless/ath9k/regd.c   |   70 +-
 drivers/net/wireless/ath9k/regd.h   |   26 +-
 drivers/net/wireless/ath9k/xmit.c   |   36 +-
 27 files changed, 5618 insertions(+), 5852 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ani.h
 create mode 100644 drivers/net/wireless/ath9k/calib.h
 delete mode 100644 drivers/net/wireless/ath9k/core.h
 create mode 100644 drivers/net/wireless/ath9k/debug.h
 create mode 100644 drivers/net/wireless/ath9k/eeprom.h
 create mode 100644 drivers/net/wireless/ath9k/mac.h


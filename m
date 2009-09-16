Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZIPCzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 22:55:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	zhifeng.cai@atheros.com, Stephen.Chen@atheros.com,
	kevin@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/3] atheros: final steps to let ar9271 use ath9k hw code
Date: Tue, 15 Sep 2009 22:55:51 -0400
Message-Id: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of building ar9271 by linking the same code together we
export the shared ath9k hw code to ath and leave the ath9k prefix
for ar9k family hw code.

This should help the development of ar9271 as you no longer need
to run scripts to fetch common hw code, instead all hw code will
now be built on ath.ko.

To get all pending patches to work on ar9271 you can now fetch a
new 2.2 MB file, which will apply on today's wireless-testing:

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-15.patch

Luis R. Rodriguez (3):
  Move common hw code between ath9k and ath9k_htc to ath
  ath: print device ID if not supported
  ath: add AR9271 srev and device ID to allow hw to support ar9271

 drivers/net/wireless/ath/Makefile                  |   13 +-
 drivers/net/wireless/ath/{ath9k => }/ani.c         |    2 +
 drivers/net/wireless/ath/{ath9k => }/ani.h         |    0
 drivers/net/wireless/ath/ath9k/Makefile            |   14 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    8 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   21 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                | 4218 -------------------
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h               | 1706 --------
 drivers/net/wireless/ath/{ath9k => }/btcoex.c      |    6 +
 drivers/net/wireless/ath/{ath9k => }/btcoex.h      |    0
 drivers/net/wireless/ath/{ath9k => }/calib.c       |    3 +
 drivers/net/wireless/ath/{ath9k => }/calib.h       |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom.c      |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom.h      |    2 +-
 drivers/net/wireless/ath/{ath9k => }/eeprom_4k.c   |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom_9287.c |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom_def.c  |    0
 drivers/net/wireless/ath/hw.c                      | 4256 +++++++++++++++++++-
 drivers/net/wireless/ath/{ath9k => }/hw.h          |   40 +-
 drivers/net/wireless/ath/{ath9k => }/initvals.h    |    0
 drivers/net/wireless/ath/{ath9k => }/mac.c         |   30 +
 drivers/net/wireless/ath/{ath9k => }/mac.h         |    0
 drivers/net/wireless/ath/{ath9k => }/phy.c         |    0
 drivers/net/wireless/ath/{ath9k => }/phy.h         |    0
 drivers/net/wireless/ath/{ath9k => }/rc.h          |    0
 drivers/net/wireless/ath/reg.h                     | 1688 ++++++++-
 29 files changed, 6044 insertions(+), 5971 deletions(-)
 rename drivers/net/wireless/ath/{ath9k => }/ani.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/ani.h (100%)
 delete mode 100644 drivers/net/wireless/ath/ath9k/hw.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/reg.h
 rename drivers/net/wireless/ath/{ath9k => }/btcoex.c (96%)
 rename drivers/net/wireless/ath/{ath9k => }/btcoex.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/calib.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/calib.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom.h (99%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_4k.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_9287.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_def.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/hw.h (95%)
 rename drivers/net/wireless/ath/{ath9k => }/initvals.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/mac.c (96%)
 rename drivers/net/wireless/ath/{ath9k => }/mac.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/phy.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/phy.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/rc.h (100%)


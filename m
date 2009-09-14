Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/11] atheros: finish hw abstraction work
Date: Mon, 14 Sep 2009 04:37:17 -0400
Message-Id: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fifth series finishes the hw code abstraction required
for ath9k_htc, or at least what I can see of it so far.

this series applies on top of sujith's patch, titled:
"ath9k: Fix bug in ANI channel handling"

Luis R. Rodriguez (11):
  atheros: add ieee80211_hw to ath_common
  ath9k: separate core driver and hw timer code
  atheros: add common debug printing
  atheros: move tx/rx chainmask to ath_common
  ath9k: remove ath9k 25 MHz HT40 spacing stuff
  ath9k: remove ath9k_ht_macmode
  ath9k: move ATH_AMPDU_LIMIT_MAX to hw.h
  ath9k: remove driver ASSERT, just use BUG_ON()
  ath9k: clarify what hw code is and remove ath9k.h from a few files
  ath9k: move ATH9K_RSSI_BAD to hw.h
  atheros: move bus ops to ath_common

 drivers/net/wireless/ath/Kconfig             |    8 +
 drivers/net/wireless/ath/Makefile            |    2 +
 drivers/net/wireless/ath/ath.h               |   18 ++
 drivers/net/wireless/ath/ath5k/base.c        |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig       |    4 +
 drivers/net/wireless/ath/ath9k/Makefile      |   10 +-
 drivers/net/wireless/ath/ath9k/ahb.c         |   19 +-
 drivers/net/wireless/ath/ath9k/ani.c         |  139 ++++++-----
 drivers/net/wireless/ath/ath9k/ath9k.h       |   29 +--
 drivers/net/wireless/ath/ath9k/beacon.c      |   83 ++++---
 drivers/net/wireless/ath/ath9k/btcoex.c      |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c       |  306 +++++++++++----------
 drivers/net/wireless/ath/ath9k/calib.h       |    2 +
 drivers/net/wireless/ath/ath9k/debug.c       |   26 +--
 drivers/net/wireless/ath/ath9k/debug.h       |   27 --
 drivers/net/wireless/ath/ath9k/eeprom.c      |    8 +-
 drivers/net/wireless/ath/ath9k/eeprom.h      |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   86 +++---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   97 ++++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   81 +++---
 drivers/net/wireless/ath/ath9k/hw.c          |  329 ++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h          |   20 +-
 drivers/net/wireless/ath/ath9k/mac.c         |  119 +++++----
 drivers/net/wireless/ath/ath9k/mac.h         |   10 -
 drivers/net/wireless/ath/ath9k/main.c        |  372 +++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/pci.c         |   21 +-
 drivers/net/wireless/ath/ath9k/phy.c         |   25 +-
 drivers/net/wireless/ath/ath9k/phy.h         |    1 +
 drivers/net/wireless/ath/ath9k/rc.c          |   36 ++--
 drivers/net/wireless/ath/ath9k/recv.c        |   40 ++--
 drivers/net/wireless/ath/ath9k/xmit.c        |  115 +++++----
 drivers/net/wireless/ath/debug.c             |   32 +++
 drivers/net/wireless/ath/debug.h             |   77 ++++++
 33 files changed, 1203 insertions(+), 945 deletions(-)
 create mode 100644 drivers/net/wireless/ath/debug.c
 create mode 100644 drivers/net/wireless/ath/debug.h


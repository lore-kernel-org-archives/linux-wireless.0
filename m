Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/15] ath9k: cleanups to help other core drivers
Date: Wed,  9 Sep 2009 19:44:46 -0400
Message-Id: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want the common hardware access stuff to not rely on a specific
driver core. We want this so that different driver cores can share
the same hw code, both for ath9k_htc and perhaps ath5k. I've spotted
a few places where we do use ath_softc internally on hw code, and
have strated to move core-specific code out and kept hw-related
code apart. This series addreses DPRINTF() usage and btcoex changes.

There'll be more of these, until we can bring up ath9k_htc with
shared code.

Luis R. Rodriguez (15):
  ath9k: use ath_hw for DPRINTF() and debug init/exit
  ath9k: move btcoex core driver info to its own struct
  ath9k: move hw specific btcoex info to ath_hw
  ath9k: split bluetooth hardware coex init into two helpers
  ath9k: move driver core helpers to main.c
  ath9k: split ath9k_hw_btcoex_enable() into two helpers
  ath9k: replaces SC_OP_BTCOEX_ENABLED with a bool
  ath9k: move bt_stomp_type to driver core
  ath9k: remove unused bt_duty_cycle
  ath9k: rename btcoex_scheme to just scheme
  ath9k: rename ath_btcoex_info to ath_btcoex_hw
  ath9k: simplify ath_btcoex_bt_stomp()
  ath9k: now move ath9k_hw_btcoex_set_weight() to btcoex.c
  ath9k: move ath_btcoex_config and ath_bt_mode to btcoex.c
  ath9k: rename ath_btcoex_supported() to ath9k_hw_btcoex_supported()

 drivers/net/wireless/ath/ath9k/ahb.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c         |   44 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h       |   24 ++-
 drivers/net/wireless/ath/ath9k/beacon.c      |   32 +-
 drivers/net/wireless/ath/ath9k/btcoex.c      |  375 ++++++++----------------
 drivers/net/wireless/ath/ath9k/btcoex.h      |   64 +----
 drivers/net/wireless/ath/ath9k/calib.c       |  102 ++++----
 drivers/net/wireless/ath/ath9k/debug.c       |   16 +-
 drivers/net/wireless/ath/ath9k/debug.h       |   15 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   24 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   24 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   24 +-
 drivers/net/wireless/ath/ath9k/hw.c          |  139 +++++-----
 drivers/net/wireless/ath/ath9k/hw.h          |    4 +
 drivers/net/wireless/ath/ath9k/mac.c         |   48 ++--
 drivers/net/wireless/ath/ath9k/main.c        |  399 +++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/phy.c         |   10 +-
 drivers/net/wireless/ath/ath9k/rc.c          |   15 +-
 drivers/net/wireless/ath/ath9k/recv.c        |   18 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   46 ++--
 20 files changed, 750 insertions(+), 675 deletions(-)


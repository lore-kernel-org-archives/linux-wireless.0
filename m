Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34780 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZHCTY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:24:56 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:24:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/24] ath9k: hw initiazliation cleanup
Date: Mon, 3 Aug 2009 12:24:32 -0700
Message-ID: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consists of a few hardware initialization cleanups
and small fixups. This goal was to make hardware initialization
easier to read but also make it easier to add support for new
hardware. The small fixups just came along the way.

Luis R. Rodriguez (24):
  ath9k: remove usage of AR_SREV_*() wrapper to detect supported hw
  ath9k: use a switch for revising supported hw mac revisions
  ath9k: propagate hw initialization errors
  ath9k: move memory allocation of ath_hw to ath_init()
  ath9k: move devid cache setting to ath_init()
  ath9k: move cache setting of softc ah prior to attach
  ath9k: call hw initializer directly
  ath9k: pass only one argument to hw attach
  ath9k: move hw macrevision checker to helper
  ath9k: rename ath9k_hw_newstate() to ath9k_hw_init_defaults()
  ath9k: rename  ath9k_hw_set_defaults() to ath9k_hw_init_config()
  ath9k: remove debug message for no memoery on ath_init()
  ath9k: break up hw initialization into a few more helpers
  ath9k: describe hw initialization better
  ath9k: distinguish between device initialization and ath_softc init
  ath9k: remove !NULL check before kfree()
  ath9k: use helper macro to kfree and nullify on ath9k_hw_rfdetach()
  ath9k: rename ath9k_hw_rfdetach() to ath9k_hw_rf_free()
  ath9k: rename ath9k_hw_ani_detach() to ath9k_hw_ani_disable()
  ath9k: set ah to null after freeing
  ath9k: set sc->sc_ah to NULL after freeing it
  ath9k: call ath9k_hw_detach() once upon hw init failure
  ath9k: remove dangling error check on keycache reset on hw init
  ath9k: remove spurious check for channel on keycache reset

 drivers/net/wireless/ath/ath9k/ahb.c    |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c    |    6 +-
 drivers/net/wireless/ath/ath9k/ani.h    |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |  259 +++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/hw.h     |    6 +-
 drivers/net/wireless/ath/ath9k/main.c   |   59 +++++---
 drivers/net/wireless/ath/ath9k/pci.c    |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c    |   53 ++-----
 11 files changed, 195 insertions(+), 202 deletions(-)


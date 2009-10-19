Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 00/15] ath9k_hw ar9271 updates & AR5416 force bias
Date: Mon, 19 Oct 2009 02:33:31 -0400
Message-Id: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series started off to extend support for ar9271 on ath9k_hw
but after review of the phy related code I noticed a fix for
AR5416 was only partially being implemented and used for all
chipsets. This series then adds the changes I've noticed so far
required for ar9271 but also fixes and completes the orientation
fix for AR5416 (force bias). Since I'm touching phy.c I also extend
documentation for it.

I don't have AR9285 cards with me but I do have an AR5416 cardbus
card -- I'd appreciate it if someone can give this a test on AR9285
but also more AR5416 cards -- this should help with TX on of AR5416
and AR5418 on the 2.4 GHz band.

Reports on issues or performance differences are greatly appreciated;
the only issue I'd expect you'd see on non AR5416 hardware is a BUG_ON()
which would be very obvious to notice and the performance enhancements
should be seen on AR5416 for TX -- not yet sure exactly under what
circumstances.

Luis R. Rodriguez (15):
  ath9k_hw: modify the rf control register for ar9271 revision 1.0
  ath9k_hw: update register initialization/reset values for ar9271
  ath9k_hw: change the way we initialize the pll for ar9271
  ath9k_hw: start documenting 802.11n RF anlong front ends
  ath9k_hw: bail out early on ath9k_hw_init_rf()
  ath9k_hw: simplify rf attach and rename to
    ath9k_hw_rf_alloc_ext_banks()
  ath9k_hw: simplify ath9k_hw_rf_alloc_ext_banks()
  ath9k_hw: rename ath9k_hw_rf_free() to ath9k_hw_rf_free_ext_banks()
  ath9k_hw: make both analog channel change routines return int
  ath9k_hw: use a callback for frequency change
  ath9k_hw: order phy.c code and integrate spur mitigation
  ath9k_hw: make spur mitigation a callback
  ath9k_hw: remove unused modesIndex param from ath9k_hw_write_regs()
  ath9k_hw: Fix and complete force bias for AR5416
  ath9k_hw: make ath9k_phy_modify_rx_buffer() static

 drivers/net/wireless/ath/ath9k/eeprom_4k.c |    4 +
 drivers/net/wireless/ath/ath9k/hw.c        |  580 ++-------------
 drivers/net/wireless/ath/ath9k/hw.h        |   20 +-
 drivers/net/wireless/ath/ath9k/initvals.h  |   29 +-
 drivers/net/wireless/ath/ath9k/phy.c       | 1100 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/phy.h       |   24 +-
 drivers/net/wireless/ath/ath9k/reg.h       |    3 +
 7 files changed, 1013 insertions(+), 747 deletions(-)


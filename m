Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/13] ath9k/ath9k_hw: AR9003 fixes for April
Date: Mon, 26 Apr 2010 15:04:28 -0400
Message-Id: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, this series contains a few fixes we've made to AR9003 over
the last few weeks. We've tested them considerably. Also included
is a change for AR9280 2.0 to enable fast PLL clock.

Happy Monday.

Felix Fietkau (10):
  ath9k_hw: update initvals for AR9003
  ath9k_hw: fix pll clock setting for 5ghz on AR9003
  ath9k_hw: fix typo in the AR9003 EEPROM data structure definition
  ath9k_hw: update EEPROM data structure for AR9280
  ath9k_hw: fix fast clock handling for 5GHz channels
  ath9k: wake queue after processing edma rx frames
  ath9k_hw: use the configured power limit for AR9003
  ath9k_hw: Fix typos in tx rate power level parsing for AR9003
  ath9k_hw: Fix endian bug in an AR9003 EEPROM field
  ath9k_hw: fix noisefloor timeout handling on AR9003

Luis R. Rodriguez (2):
  ath9k_hw: disable TX IQ calibration for AR9003
  ath9k_hw: Fix TX interrupt mitigation settings

Vasanthakumar Thiagarajan (1):
  ath9k_hw: Fix usec to hw clock conversion in 5Ghz for ar9003

 drivers/net/wireless/ath/ath9k/ar5008_phy.c      |    5 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c      |   16 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_initvals.h |  265 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c      |    3 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |   16 +-
 drivers/net/wireless/ath/ath9k/eeprom.h          |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c      |    2 +
 drivers/net/wireless/ath/ath9k/hw.c              |   24 ++-
 drivers/net/wireless/ath/ath9k/hw.h              |    8 +-
 drivers/net/wireless/ath/ath9k/mac.c             |   10 +-
 drivers/net/wireless/ath/ath9k/xmit.c            |    2 +
 14 files changed, 189 insertions(+), 178 deletions(-)


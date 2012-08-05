Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46299 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2HETf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 15:35:59 -0400
Received: by wgbdr13 with SMTP id dr13so2122688wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 12:35:58 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 0/5] ath5k: Various tx power fixes
Date: Sun,  5 Aug 2012 22:35:32 +0300
Message-Id: <1344195337-27461-1-git-send-email-mickflemm@gmail.com> (sfid-20120805_213603_146687_3CBF2A49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series fixes a few bugs on tx power processing code. Some more fixes
on EEPROM stuff are still pending.

Thanks to Thomas Huehn and Felix Fietkau for the feedback.

Nick Kossifidis (5):
  ath5k: Use correct value for min_pwr and cur_pwr
  ath5k: Fix range scaling when setting rate power table
  ath5k: Preserve tx power level requested from above on phy_init
  ath5k: Put power_level where it belongs and rename it
  ath5k: Return correct offset when reading frequencies

 drivers/net/wireless/ath/ath5k/ath5k.h        |    2 +-
 drivers/net/wireless/ath/ath5k/base.c         |    5 ++-
 drivers/net/wireless/ath/ath5k/eeprom.c       |    4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    4 +-
 drivers/net/wireless/ath/ath5k/phy.c          |   43 ++++++++++++++++++------
 5 files changed, 40 insertions(+), 18 deletions(-)

-- 
1.7.3.4


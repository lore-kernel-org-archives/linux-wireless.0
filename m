Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54743 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbbKWS1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:54 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 0/8] Regulatory and ath9k support for ITS-G5 band (5.9 GHz)
Date: Mon, 23 Nov 2015 19:27:13 +0100
Message-Id: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192757_832385_39FB12CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is another attempt to mainline support for ITS-G5
band (5.9 GHz) designated for Intelligent Transportation Systems.

Based on the discussion with Jouni [1], this version adds the
following restrictions for using the band:

1. Custom reg db must be provided by the user.
2. CONFIG_CFG80211_REG_ITSG5_BAND must be enabled.
3. The band is restricted to OCB mode. I.e. beaconing and scanning is
   disabled.

Patches 1-3 do some refactoring and cleanup. They are independent of
the rest of the series. Patches 4-7 add regulatory support (mainly the
points mentioned above) and finally patch 8 adds support for ITS-G5 to
the ath9k driver.

[1]: http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg13795.html


Michal Sojka (8):
  cfg80211: reg: Remove unused function parameter
  cfg80211: Remove unused cfg80211_can_use_iftype_chan()
  cfg80211: reg: Refactor calculation of bandwidth flags
  cfg80211: reg: Properly handle rules for 5 and 10 MHz channels
  cfg80211: Add support for OCB-only channels
  cfg80211: reg: Add NL80211_RRF_USER_REGD_NEEDED flag
  cfg80211: Add Kconfig option for ITS-G5 band (5.9 GHz)
  ath9k: Add support for ITS-G5 band (5.9 GHz)

 drivers/net/wireless/ath/ath9k/common-init.c |  19 +++++
 drivers/net/wireless/ath/ath9k/hw.h          |   2 +-
 drivers/net/wireless/ath/regd.c              |  23 +++--
 include/net/cfg80211.h                       |   5 ++
 include/uapi/linux/nl80211.h                 |   6 ++
 net/wireless/Kconfig                         |  27 ++++++
 net/wireless/chan.c                          |   6 +-
 net/wireless/core.h                          |   7 --
 net/wireless/ibss.c                          |  12 ++-
 net/wireless/mesh.c                          |   3 +-
 net/wireless/nl80211.c                       |  12 +--
 net/wireless/reg.c                           | 123 +++++++++++++--------------
 net/wireless/scan.c                          |   4 +-
 net/wireless/sme.c                           |   3 +-
 net/wireless/util.c                          | 114 -------------------------
 net/wireless/wext-sme.c                      |   3 +-
 16 files changed, 161 insertions(+), 208 deletions(-)

-- 
2.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZDFUQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 16:16:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/5] wireless: listen to reg bw preferences
Date: Mon,  6 Apr 2009 16:15:53 -0400
Message-Id: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com> (sfid-20090406_221613_778096_BCC239A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new series addresses Johannes comments. Gabor -- didn't have
time to rename variables in iwl for fat-->ht40, feel free to take a stab.

Luis R. Rodriguez (5):
  cfg80211: Process regulatory max bandwidth checks for HT40
  wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
  mac80211: check if HT40+/- is allowed before sending assoc
  cfg80211: check allowed channel type upon userspace requests
  mac80211: expose HT channel flags through debugfs

 drivers/net/wireless/ath/regd.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 +-
 include/net/wireless.h                    |   22 ++-
 net/mac80211/debugfs.c                    |   10 ++
 net/mac80211/ht.c                         |    8 +-
 net/mac80211/ieee80211_i.h                |    2 +
 net/mac80211/mlme.c                       |    4 +-
 net/wireless/nl80211.c                    |   47 ++++---
 net/wireless/reg.c                        |  200 +++++++++++++++++++++++------
 10 files changed, 230 insertions(+), 85 deletions(-)


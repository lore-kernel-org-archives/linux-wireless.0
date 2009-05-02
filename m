Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZEBEhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:37:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] cfg80211: HT bandwidth checks
Date: Sat,  2 May 2009 00:37:16 -0400
Message-Id: <1241239041-2367-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a respin of the HT40 bandwidth patches with the
fixes pointed out by Jouni. This time I leave out the debugfs
stuff for another series which will follow up.

Luis R. Rodriguez (5):
  cfg80211: Process regulatory max bandwidth checks for HT40
  wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
  mac80211: check if HT40+/- is allowed before sending assoc
  cfg80211: check allowed channel type upon userspace requests
  mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211

 drivers/net/wireless/ath/regd.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 +-
 include/net/cfg80211.h                    |   22 ++-
 net/mac80211/debugfs.c                    |   16 ---
 net/mac80211/ieee80211_i.h                |    4 -
 net/mac80211/mlme.c                       |   12 +-
 net/wireless/Kconfig                      |    8 +
 net/wireless/Makefile                     |    1 +
 net/wireless/core.c                       |    5 +
 net/wireless/core.h                       |   11 ++
 net/wireless/debugfs.c                    |   70 ++++++++++
 net/wireless/debugfs.h                    |   14 ++
 net/wireless/nl80211.c                    |   39 +++---
 net/wireless/reg.c                        |  201 +++++++++++++++++++++++------
 15 files changed, 319 insertions(+), 106 deletions(-)
 create mode 100644 net/wireless/debugfs.c
 create mode 100644 net/wireless/debugfs.h


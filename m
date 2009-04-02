Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760935AbZDBW0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:26:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] wireless: listen to bandwidths preferences
Date: Thu,  2 Apr 2009 18:26:01 -0400
Message-Id: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com> (sfid-20090403_002619_809680_EDA3AD8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an interim fix for dealing with bandwidth checks as
this will all be reworked later. We avoid problems in the future
by not exposing anything new over through an API. Debugfs can be used
to debug these new flags.

Luis R. Rodriguez (5):
  cfg80211: Process regulatory max bandwidth checks for HT40
  wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
  mac80211: check if HT40+/- is allowed before sending assoc
  cfg80211: check allowed channel type upon userspace requests
  mac80211: expose HT channel flags through debugfs

 drivers/net/wireless/ath/regd.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 +-
 include/net/wireless.h                    |   23 +++--
 net/mac80211/debugfs.c                    |   15 +++
 net/mac80211/ht.c                         |   11 ++-
 net/mac80211/ieee80211_i.h                |    3 +
 net/mac80211/mlme.c                       |    4 +-
 net/wireless/nl80211.c                    |   18 +++
 net/wireless/reg.c                        |  194 ++++++++++++++++++++++------
 10 files changed, 226 insertions(+), 64 deletions(-)


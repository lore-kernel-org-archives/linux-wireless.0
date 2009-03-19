Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZCSFyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:54:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/6] Use the regulatory bandwidth and export HT40 stuff
Date: Thu, 19 Mar 2009 01:54:34 -0400
Message-Id: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065450_760231_096A1FC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This took a little more consideration than I thought. This is a redesign
of the bandwidth regulatory stuff, it also keeps in mind preferences in
the future to use alternative bandwidths like 10 MHz and 5 MHz for things
like 802.11p.

Ultimately you'll now get proper interpretation of the regulatory
bandwidth supported, we'll export the bandwidth allowed per channel,
and we'll also export the channel HT40-/+ capabilities -- if they are
allowed or not.

This should also help considerably with testing regulatory settings.
And for users planning to use HT40 it'll give you a direct guide which
channels to pick on your AP.

This second series completely abandons our old strategy to use the channel
bandwidth to determine whether or not we support HT40, instead we use it for
to determine the supported actual bandwidth _per_channel_, not per channel
set (the pair of channels on an HT40 configuration).

Luis R. Rodriguez (6):
  cfg80211: Process regulatory max bandwidth checks for HT40
  wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
  mac80211: check if HT40+/- is allowed before sending assoc
  cfg80211: check allowed channel type upon userspace requests
  cfg80211: send channel max bandwidth to userspace
  cfg80211: send to userspace if HT40-/+ is allowed on each channel

 drivers/net/wireless/ath9k/regd.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 +-
 include/linux/nl80211.h                   |   18 +++
 include/net/wireless.h                    |   23 +++--
 net/mac80211/ht.c                         |   11 ++-
 net/mac80211/mlme.c                       |    4 +-
 net/wireless/nl80211.c                    |   27 ++++-
 net/wireless/reg.c                        |  194 ++++++++++++++++++++++------
 9 files changed, 234 insertions(+), 65 deletions(-)


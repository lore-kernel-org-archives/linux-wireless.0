Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40245 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GHNO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 09:14:26 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 0/5] add master channel switch announcement support
Date: Mon,  8 Jul 2013 15:14:05 +0200
Message-Id: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_151444_289777_A71D5D5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the 3rd edition of the CSA support patch series. This patchset adds
generic channel switch support for AP. This is required for DFS operation
(e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
be required for IBSS-DFS later.

Changes from PATCHv2:
 * change_channel function for channel context
 * announce csa support via wiphy flag/cmd
 * put offset into nested csa information for nl80211 command
 * various locking, style, documentation and some more minor issues
 * rebased on latest mac80211-next master

The rough design is:
 * userspace asks kernel to switch a channel using the new NL80211_CMD_CHANNEL_SWITCH
   command. It supplies IE information for the time while staying on the old channel and
   announcing the switch, and IE information for after the switch to the new channel. 
 * IE information contains the beacon and optionally probe responses, which should
   include (E)CSA IEs for the CSA case. Furthermore an offset is provided (for beacon
   and probe response) to point to the counter field within the channel switch IEs.
 * The driver gets the new beacons passed and must set them, and decrement the
   counter field. When it reaches 0, the channel is changed and userspace notified.

As always, any comments are appreciated.

Cheers,
	Simon 

Simon Wunderlich (5):
  nl80211/cfg80211: add channel switch command
  mac80211: add functions to duplicate a cfg80211_beacon
  mac80211: allow chanctx to change channels
  mac80211: add channel switch command and beacon callbacks
  ath9k: enable CSA functionality in ath9k

 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +
 drivers/net/wireless/ath/ath9k/beacon.c |   21 ++++
 drivers/net/wireless/ath/ath9k/init.c   |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++
 drivers/net/wireless/ath/ath9k/xmit.c   |    2 +
 include/net/cfg80211.h                  |   30 ++++++
 include/net/mac80211.h                  |   38 +++++++
 include/uapi/linux/nl80211.h            |   29 ++++++
 net/mac80211/cfg.c                      |  172 ++++++++++++++++++++++++++++++-
 net/mac80211/chan.c                     |   55 ++++++++++
 net/mac80211/driver-ops.h               |   13 +++
 net/mac80211/ieee80211_i.h              |   17 +++
 net/mac80211/iface.c                    |    2 +
 net/mac80211/trace.h                    |   26 +++++
 net/mac80211/tx.c                       |   80 ++++++++++++++
 net/wireless/nl80211.c                  |  126 +++++++++++++++++++++-
 16 files changed, 628 insertions(+), 3 deletions(-)

-- 
1.7.10.4


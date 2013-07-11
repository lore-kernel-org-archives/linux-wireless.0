Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55991 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3GKOJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 10:09:16 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 0/4] add master channel switch announcement support
Date: Thu, 11 Jul 2013 16:09:04 +0200
Message-Id: <1373551749-5107-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130711_160920_167223_EE17B243)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the 5th edition of the CSA support patch series. This patchset adds
generic channel switch support for AP. This is required for DFS operation
(e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
be required for IBSS-DFS later.

Changes from PATCHv4:
 * finally remove use_chanctx check (Michal)
 * squashed the chanctx channel change patch into the "main" channel switch command patch,
   as channel change command now checks if a CSA is currently in operation and therefore
   now depends on that.
 * add tracing for nl80211 part (Johannes)
 * removed BSS_CHANGED_CHANNEL (Johannes)
 * fix rcu_read lock (Johannes)
 * check for csa in chanctx change channel (Johannes)
 * ... and a few more minor changes

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

Simon Wunderlich (4):
  nl80211/cfg80211: add channel switch command
  mac80211: add functions to duplicate a cfg80211_beacon
  mac80211: add channel switch command and beacon callbacks
  ath9k: enable CSA functionality in ath9k

 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +
 drivers/net/wireless/ath/ath9k/beacon.c |   21 ++++
 drivers/net/wireless/ath/ath9k/init.c   |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++
 drivers/net/wireless/ath/ath9k/xmit.c   |    2 +
 include/net/cfg80211.h                  |   30 +++++
 include/net/mac80211.h                  |   36 ++++++
 include/uapi/linux/nl80211.h            |   29 +++++
 net/mac80211/cfg.c                      |  185 ++++++++++++++++++++++++++++++-
 net/mac80211/chan.c                     |   58 ++++++++++
 net/mac80211/driver-ops.h               |   13 +++
 net/mac80211/ieee80211_i.h              |   18 +++
 net/mac80211/iface.c                    |    9 ++
 net/mac80211/trace.h                    |   26 +++++
 net/mac80211/tx.c                       |   78 +++++++++++++
 net/wireless/nl80211.c                  |  124 ++++++++++++++++++++-
 net/wireless/rdev-ops.h                 |   12 ++
 net/wireless/trace.h                    |   33 ++++++
 18 files changed, 691 insertions(+), 3 deletions(-)

-- 
1.7.10.4


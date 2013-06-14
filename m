Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35778 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3FNMPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 08:15:37 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 0/5] add master channel switch announcement support
Date: Fri, 14 Jun 2013 14:15:18 +0200
Message-Id: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130614_141540_572468_94291381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a follow up from PATCHv1 last week. This patchset adds generic
channel switch support for AP. This is required for DFS operation
(e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
be required for IBSS-DFS later.

Changes from PATCHv1:
 * integrate Felix suggestion to perform the channel switch after the beacon send
   has been completed. This required a few minor design changes (i.e. split into
   functions for decrementation and check for csa completion in mac80211)
 * few minor changes (e.g. check for CSA in mac80211, documentation)

The rough design is:
 * userspace asks kernel to switch a channel using the new NL80211_CMD_CHANNEL_SWITCH
   command. It supplies IE information for the time while staying on the old channel and
   announcing the switch, and IE information for after the switch to the new channel. 
 * IE information contains the beacon and optionally probe responses, which should
   include (E)CSA IEs for the CSA case. Furthermore an offset is provided (for beacon
   and probe response) to point to the counter field within the channel switch IEs.
 * The driver gets the new beacons passed and must set them, and decrement the
   counter field. When it reaches 0, the channel is changed and userspace notified.

Discussion points:
 * Assembling all these IE information is a little bit tedious but doable (I've
   patched hostapd).
 * Other future users like IBSS/MESH will not get the beacon/probe response IEs, as they
   generate these beacons themselves. Therefore they need the COUNT attribute, which
   is kind of duplicate right now.
 * Userspace must generate/handle all IEs, which lifts the previous limitations of
   the RFC (e.g. no change of band allowed, no operation mode change allowed).
 * it currently works for me [TM] on my ath9k based machine

As always, any comments are appreciated.

Cheers,
	Simon 

Simon Wunderlich (5):
  nl80211: use attributes to parse beacons
  nl80211/cfg80211: add channel switch command
  mac80211: add functions to duplicate a cfg80211_beacon
  mac80211: add channel switch command and beacon callbacks
  ath9k: enable CSA functionality in ath9k

 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +
 drivers/net/wireless/ath/ath9k/beacon.c |   21 ++++
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++
 drivers/net/wireless/ath/ath9k/xmit.c   |    2 +
 include/net/cfg80211.h                  |   26 +++++
 include/net/mac80211.h                  |   33 ++++++
 include/uapi/linux/nl80211.h            |   29 +++++
 net/mac80211/cfg.c                      |  185 ++++++++++++++++++++++++++++++-
 net/mac80211/driver-ops.h               |   11 ++
 net/mac80211/ieee80211_i.h              |   11 ++
 net/mac80211/iface.c                    |    2 +
 net/mac80211/trace.h                    |   20 ++++
 net/mac80211/tx.c                       |   68 ++++++++++++
 net/wireless/nl80211.c                  |  171 +++++++++++++++++++++++-----
 14 files changed, 567 insertions(+), 31 deletions(-)

-- 
1.7.10.4


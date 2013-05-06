Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:49890 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3EFTOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:14:09 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 0/4] add master channel switch announcement support
Date: Mon,  6 May 2013 21:13:51 +0200
Message-Id: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130506_211415_896123_FFF4F9E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an early RFC of a possible channel switch announcement infrastructure.
It adds CSA/ECSA handling support for AP. This is required for DFS operation
(e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
be required for IBSS-DFS later.

I'd like to discuss if this design approach is going in the right direction.
What is currently working:

 * channels are announced by adding IEs (CSA and Extended CSA) in beacons
 * after some (configurable) time, the channel is switched
 * with the channel switch, CSA/ECSA IEs are removed and channel information
   is updated.
 * Userspace calls a new command NL80211_CMD_CHANNEL_SWITCH along with channel info
   (freq + width), whether traffic should be blocked and timing information
 * it currently works for me [TM] on my ath9k based machine

Questions:

 * We already have NL80211_CMD_CH_SWITCH_NOTIFY which is only used for notification.
   Maybe we can rename that and re-use it instead of adding a new command
   NL80211_CMD_CHANNEL_SWITCH?
 * Changes from HT20/NOHT to HT20/NOHT are handled with normal Channel Switch
   Announcements, everything else (for 40 MHz) is done with Extended Channel Switch
   Announcements. As far as I read the spec, we can't  use the secondary channel
   offset IE in beacons, but maybe I'm wrong here?
 * could other drivers (next to ath9k) work with this API?

Limitations:
 * only works for single interfaces (no plan to change that, due to lack of good concept)
 * Only changes in the same band (e.g. 2GHz -> 2GHz or 5GHz -> 5 GHz) and same
   operation mode (HT->HT or NOHT->NOHT) are supported. Especially the first
   restriction would be troublesome when rewriting the beacon (not only channel
   info has to be changed, but also basic rates, country information, etc ...).
   => What do you think about this approach?
   => (An alternative would be to require userspace to supply the next beacon too)
 * probe responses are not handled yet (have to look into it)
 * user notification is missing (we should send an event after this is finished)
 * locking and many corner cases are still broken (will fix that later)

As always, any comments are appreciated.

Cheers,
	Simon 

Simon Wunderlich (4):
  cfg80211: add chandef to operating class conversion
  nl80211/cfg80211: add channel switch command
  mac80211: add channel switch command and beacon callbacks
  ath9k: enable CSA functionality in ath9k

 drivers/net/wireless/ath/ath9k/main.c |    6 +
 include/linux/ieee80211.h             |    9 ++
 include/net/cfg80211.h                |   15 ++
 include/net/mac80211.h                |   21 +++
 include/uapi/linux/nl80211.h          |   20 +++
 net/mac80211/cfg.c                    |  262 +++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h             |   11 ++
 net/mac80211/ieee80211_i.h            |    9 ++
 net/mac80211/iface.c                  |    2 +
 net/mac80211/trace.h                  |   20 +++
 net/mac80211/tx.c                     |   59 ++++++++
 net/mac80211/util.c                   |  210 ++++++++++++++++++++++++++
 net/wireless/nl80211.c                |   76 +++++++++-
 net/wireless/util.c                   |  193 ++++++++++++++++++++++++
 14 files changed, 912 insertions(+), 1 deletion(-)

-- 
1.7.10.4


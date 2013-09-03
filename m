Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51718 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab3ICRne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 13:43:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 0/4] add IBSS-DFS support
Date: Tue,  3 Sep 2013 19:43:17 +0200
Message-Id: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130903_194339_082211_60A72C44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds DFS support for the IBSS mode. It builds on top of
the previously sent AP DFS mode and channel switch announcement support.

The implementation differs from the DFS support as described in IEEE 802.11.
It does not implement the DFS owner service or uses IBSS DFS elements as
described in IEEE 802.11-2012 10.9.8.3. The DFS owner service has various
shortcomings:

 * it requires synchronization to find one central IBSS owner
 * citation: "The potential for hidden nodes within an IBSS means that the
   IBSS channel switch protocol is best effort."
 * the mechanism does not provide any way to handle big adhoc cells like
   mesh networks (which is a major target).

Therefore, a stripped down approach is implemented:

 * userspace must announce that it wants support for DFS and will handle
   events using a flag for the ibss_join command.
 * if a radar is detected, inform userspace. Userspace should then select
   a channel (e.g. decide on it with the peers on higher level protocols
   before, or wait a random backoff time) and start a channel switch process.
 * if a channel switch announcement from another peeris received, adopt it
   and re-transmit it (this has been implemented in the IBSS-CSA patchset
   before)
 * channel switch announcements on DFS channels are interpreted as
   radar signals and will mark the channel as unusable.

As always, any comments are appreciated.

Cheers,
        Simon

Simon Wunderlich (4):
  nl80211: allow CAC only if no operation is going on
  nl80211/cfg80211: enable DFS for IBSS mode
  mac80211: enable DFS for IBSS mode
  ath9k: enable DFS for IBSS mode

 drivers/net/wireless/ath/ath9k/init.c |    3 +-
 include/net/cfg80211.h                |    6 ++++
 include/uapi/linux/nl80211.h          |    7 +++++
 net/mac80211/ibss.c                   |   50 +++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h            |    1 +
 net/wireless/chan.c                   |    3 +-
 net/wireless/ibss.c                   |   24 +++++++++++++---
 net/wireless/nl80211.c                |   11 ++++++--
 net/wireless/util.c                   |   11 ++++++--
 9 files changed, 101 insertions(+), 15 deletions(-)

-- 
1.7.10.4


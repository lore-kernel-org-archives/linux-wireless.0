Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48937 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3JGQlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:41:19 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 0/3] add IBSS-DFS support
Date: Mon,  7 Oct 2013 18:41:04 +0200
Message-Id: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20131007_184124_092097_00D6DB01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds DFS support for the IBSS mode. It builds on top of
the previously sent AP DFS mode and channel switch announcement support.

Changes to the previous patchset:
 * describe userspace requirements better in doc and commit message 
   (suggested by Johannes)
 * change variable/attribute names
 * first patch has already been merged, dropped from this patchset
 * safeguard as suggested by Johannes (to protect from crashed/hanging
   userspace) has NOT yet been implemented. I'll probably send a patch for
   this later, as this might be useful for AP mode as well.

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


Simon Wunderlich (3):
  nl80211/cfg80211: enable DFS for IBSS mode
  mac80211: enable DFS for IBSS mode
  ath9k: enable DFS for IBSS mode

 drivers/net/wireless/ath/ath9k/init.c |    3 +-
 include/net/cfg80211.h                |    6 ++++
 include/uapi/linux/nl80211.h          |    9 ++++++
 net/mac80211/ibss.c                   |   49 +++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h            |    1 +
 net/wireless/chan.c                   |    3 +-
 net/wireless/ibss.c                   |   24 +++++++++++++---
 net/wireless/nl80211.c                |    8 ++++--
 net/wireless/util.c                   |   11 ++++++--
 9 files changed, 99 insertions(+), 15 deletions(-)

-- 
1.7.10.4


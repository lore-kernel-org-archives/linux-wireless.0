Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41078 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3EISKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:10:48 -0400
From: a@pandem0nium
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 0/8] Add support for 5 and 10 MHz channels
Date: Thu,  9 May 2013 20:10:28 +0200
Message-Id: <1368123036-22721-1-git-send-email-a> (sfid-20130509_201057_479939_C96C6F7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

This patchset adds support for 5 and 10 MHz in nl80211/cfg80211/mac80211
and enables support in ath5k and ath9k, which already support this feature
on the driver side. 5 and 10 MHz wide channels might be useful for:

 * long shot links, as the transmissions are more robust
 * future support for 802.11y which allows some 5 and 10 MHz channels in
   3.6 GHz range
 * future support for 802.11p which uses 10 MHz in 5.9 GHz range
 * ... and more "special" applications.

Note that the transmissions are only defined for the OFDM PHY in the
standard and are therefore limited to 5 GHz, no HT or MIMO here. However,
at least my AR5K and AR9K based chips seem to support this mode on 2.4 GHz
as well. Datarates are halfed or quartered, leaving up to 27 Mbit/s or
13.5 Mbit/s gross rates respectively.

Some benchmark results (IBSS, iperf, ath9k on AR9220, ath5k on AR5213A):

 * ath5k -> ath5k:
	5.23 Mbit/s @ 5 MHz
	10.8 Mbit/s @ 10 MHz
	19.1 Mbit/s @ 20 MHz (NOHT mode)
 * ath9k -> ath9k:
	5.24 Mbit/s @ 5 MHz
	10.9 Mbit/s @ 10 MHz
	16.4 Mbit/s @ 20 MHz (NOHT mode, appears to be a little bit low though)

Comments:
 * Is there any special requirement for handling beacons? For example,
   rates are halfed or quartered, but some rates could not be represented
   in the rate IEs. For example, 2.25 mbit/s can not be represented as
   multiple of 500 kbps.
 * therefore, all rates are handled like the corresponding 20 MHz rates
   internally, which makes a lot of things easier (no changes required
   for rc-algos, beacon creation, etc...). We might consider adjusting the
   output of rates for nl80211 or radiotap, though.

As always, any comments are appreciated!
Cheers,
	Simon



Simon Wunderlich (8):
  nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
  mac80211: fix various components for the new 5 and 10 MHz widths
  mac80211: change IBSS channel state to chandef
  mac80211: fix timing for 5 MHz and 10 MHz channels
  nl80211: allow 5 and 10 MHz channels for IBSS
  ath9k: convert to chandef, enable support for 5/10 MHz channels
  ath9k: announce that ath9k supports 5/10 MHz
  ath5k: enable support for 5 MHz and 10 MHz channels

 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |   25 +++++++--
 drivers/net/wireless/ath/ath5k/base.h         |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++++++++++----------
 drivers/net/wireless/ath/ath9k/common.h       |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/init.c         |    5 +-
 drivers/net/wireless/ath/ath9k/main.c         |    8 ++-
 drivers/net/wireless/ath/ath9k/rc.c           |    4 +-
 include/net/cfg80211.h                        |    2 +
 include/uapi/linux/nl80211.h                  |    4 ++
 net/mac80211/ibss.c                           |   24 +++++----
 net/mac80211/ieee80211_i.h                    |   45 +++++++++++++++--
 net/mac80211/mesh.c                           |    4 +-
 net/mac80211/mesh_plink.c                     |    8 ++-
 net/mac80211/mlme.c                           |   12 +++++
 net/mac80211/rate.c                           |    8 ++-
 net/mac80211/rc80211_minstrel.c               |   14 ++++--
 net/mac80211/rc80211_minstrel_ht.c            |    8 +--
 net/mac80211/tx.c                             |   10 ++--
 net/mac80211/util.c                           |   43 +++++++++++-----
 net/wireless/chan.c                           |   29 +++++++++++
 net/wireless/nl80211.c                        |   23 +++++++--
 24 files changed, 266 insertions(+), 90 deletions(-)

-- 
1.7.10.4


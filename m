Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38297 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3GHO4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:18 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 00/18] Add support for 5 and 10 MHz channels
Date: Mon,  8 Jul 2013 16:55:48 +0200
Message-Id: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_172040_418874_4BFD82B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for 5 and 10 MHz in nl80211/cfg80211/mac80211
and enables support in ath5k and ath9k, which already support this feature
on the driver side. 5 and 10 MHz wide channels might be useful for:

 * long shot links, as the transmissions are more robust
 * future support for 802.11y which allows some 5 and 10 MHz channels in
   3.6 GHz range
 * future support for 802.11p which uses 10 MHz in 5.9 GHz range
 * ... and more "special" applications.

This patchset enables 5 and 10 MHz channels only for OFDM, and without
HT/MIMO/aggregation (for now). Support may be added later.

Changes to PATCHv5:

 * fix compile error/warnings when applying only parts of the patchset,
   move patch "mac80211: add radiotap flag and handling for 5/10 MHz" in front
   for the same reason
 * remove useless whitespace

As always, any comments are appreciated!
Cheers,
        Simon


Simon Wunderlich (18):
  nl80211: add scan width to bss and scan request structs
  mac80211/rc80211: add chandef to rate initialization
  mac80211: fix timing for 5 MHz and 10 MHz channels
  mac80211: add radiotap flag and handling for 5/10 MHz
  mac80211: select and adjust bitrates according to channel mode
  cfg80211/mac80211: get mandatory rates based on scan width
  cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
  mac80211: allow scanning for 5/10 MHz channels in IBSS
  mac80211: return if IBSS chandef can not be used
  nl80211: allow 5 and 10 MHz channels for IBSS
  ath9k: always use SIFS times from OFDM for 5/10 MHz
  ath9k: use chandef instead of channel_type
  ath9k: report 5/10 MHz channels
  ath9k: set 5/10 MHz supported channels and fix bitrate
  ath9k: announce that ath9k supports 5/10 MHz
  ath5k: report 5/10 MHz channels
  ath5k: set 5/10 MHz supported channels and fix duration
  ath5k: enable support for 5 MHz and 10 MHz channels

 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |   59 ++++++--
 drivers/net/wireless/ath/ath5k/base.h         |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c          |    2 +
 drivers/net/wireless/ath/ath5k/qcu.c          |   25 +++-
 drivers/net/wireless/ath/ath9k/common.c       |   67 +++++----
 drivers/net/wireless/ath/ath9k/common.h       |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    5 +-
 drivers/net/wireless/ath/ath9k/init.c         |   29 ++--
 drivers/net/wireless/ath/ath9k/main.c         |    8 +-
 drivers/net/wireless/ath/ath9k/rc.c           |   11 +-
 drivers/net/wireless/ath/ath9k/recv.c         |   11 ++
 drivers/net/wireless/iwlegacy/3945-rs.c       |    1 +
 drivers/net/wireless/iwlegacy/4965-rs.c       |    1 +
 drivers/net/wireless/iwlwifi/dvm/rs.c         |    3 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c         |    5 +-
 drivers/net/wireless/rtlwifi/rc.c             |    1 +
 include/net/cfg80211.h                        |   85 ++++++++++-
 include/net/ieee80211_radiotap.h              |    4 +
 include/net/mac80211.h                        |    6 +
 include/uapi/linux/nl80211.h                  |   18 +++
 net/mac80211/cfg.c                            |   45 +++---
 net/mac80211/ibss.c                           |  124 ++++++++++++----
 net/mac80211/ieee80211_i.h                    |   43 +++++-
 net/mac80211/iface.c                          |    2 +-
 net/mac80211/main.c                           |   15 +-
 net/mac80211/mesh.c                           |    3 +-
 net/mac80211/mesh_plink.c                     |    2 +-
 net/mac80211/mlme.c                           |   98 +++++++------
 net/mac80211/rate.c                           |   50 ++++---
 net/mac80211/rate.h                           |   22 ++-
 net/mac80211/rc80211_minstrel.c               |   33 ++++-
 net/mac80211/rc80211_minstrel_ht.c            |   15 +-
 net/mac80211/rc80211_pid_algo.c               |    1 +
 net/mac80211/rx.c                             |   28 ++--
 net/mac80211/scan.c                           |   72 ++++++++--
 net/mac80211/status.c                         |   17 ++-
 net/mac80211/tx.c                             |   25 +++-
 net/mac80211/util.c                           |  190 ++++++++++++++++++++-----
 net/wireless/mesh.c                           |    5 +-
 net/wireless/nl80211.c                        |    3 +
 net/wireless/scan.c                           |   31 ++--
 net/wireless/trace.h                          |   12 +-
 net/wireless/util.c                           |   14 +-
 46 files changed, 884 insertions(+), 320 deletions(-)

-- 
1.7.10.4


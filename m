Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36116 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3EOOTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:33 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
Date: Wed, 15 May 2013 16:18:51 +0200
Message-Id: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162018_958002_718BF24D)
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

Changes to PATCHv1:
 * the actual datarates are handled, not the corresponding 20MHz rates
   as before. This should make it compatible to freebsd, although I was
   informed that some other implementors might still use the corresponding
   20MHz rates. Anyway, from looking at the standard using the actual rates
   should be the right thing to do.
 * txpower is decremented according to channel bandwidth (the regulation I
   checked all define limits in dBm/MHz)
 * radiotap support for 5/10 MHz channel flag was added
 * some fixes for ath5k/ath9k were included to make them interoperable
   (having the same SIFS improved performance quite well, 
    300kbps -> 6600 kbps for 5 MHz channels :) )

As always, any comments are appreciated!
Cheers,
        Simon

Simon Wunderlich (18):
  nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
  nl80211: add half/quarter channel bitrate tables to supported band
    struct
  mac80211: fix various components for the new 5 and 10 MHz widths
  mac80211: fix timing for 5 MHz and 10 MHz channels
  mac80211: round rates to the next multiple of 500kbps
  mac80211: choose bitrate table according to bandwidth
  mac80211: add radiotap flag and handling for 5/10 MHz
  cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
  mac80211: change IBSS channel state to chandef
  nl80211: allow 5 and 10 MHz channels for IBSS
  ath9k: always use SIFS times from OFDM for 5/10 MHz
  ath9k: use chandef instead of channel_type
  ath9k: add and use 5/10 MHz bitrate tables
  ath9k: report 5/10 MHz channels
  ath9k: announce that ath9k supports 5/10 MHz
  ath5k: add and use 5/10 MHz bitrate tables
  ath5k: report 5/10 MHz channels
  ath5k: enable support for 5 MHz and 10 MHz channels

 drivers/net/wireless/ath/ath5k/ath5k.h        |   11 +-
 drivers/net/wireless/ath/ath5k/base.c         |  133 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/base.h         |    2 +-
 drivers/net/wireless/ath/ath5k/debug.c        |   23 ++++-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c          |   30 +++++-
 drivers/net/wireless/ath/ath5k/qcu.c          |   23 ++++-
 drivers/net/wireless/ath/ath9k/beacon.c       |   13 ++-
 drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++-----
 drivers/net/wireless/ath/ath9k/common.h       |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    5 +-
 drivers/net/wireless/ath/ath9k/init.c         |   68 +++++++++---
 drivers/net/wireless/ath/ath9k/main.c         |    8 +-
 drivers/net/wireless/ath/ath9k/rc.c           |   13 ++-
 drivers/net/wireless/ath/ath9k/recv.c         |   24 ++++-
 drivers/net/wireless/ath/ath9k/xmit.c         |   14 ++-
 include/net/cfg80211.h                        |   66 ++++++++++++
 include/net/ieee80211_radiotap.h              |    4 +
 include/net/mac80211.h                        |   40 ++++++-
 include/uapi/linux/nl80211.h                  |    4 +
 net/mac80211/cfg.c                            |   50 +++++++--
 net/mac80211/ibss.c                           |   58 +++++++----
 net/mac80211/ieee80211_i.h                    |   47 ++++++++-
 net/mac80211/iface.c                          |    7 +-
 net/mac80211/main.c                           |    7 +-
 net/mac80211/mesh.c                           |    4 +-
 net/mac80211/mesh_plink.c                     |   18 +++-
 net/mac80211/mlme.c                           |   84 ++++++++++-----
 net/mac80211/rate.c                           |  102 ++++++++++++------
 net/mac80211/rc80211_minstrel.c               |   59 +++++++----
 net/mac80211/rc80211_minstrel_ht.c            |   26 +++--
 net/mac80211/rc80211_pid.h                    |    2 +
 net/mac80211/rc80211_pid_algo.c               |   68 +++++++++---
 net/mac80211/rx.c                             |   52 +++++++---
 net/mac80211/status.c                         |   18 +++-
 net/mac80211/tx.c                             |   43 ++++++--
 net/mac80211/util.c                           |  138 +++++++++++++++++++------
 net/wireless/chan.c                           |   57 ++++++++--
 net/wireless/nl80211.c                        |   23 ++++-
 net/wireless/util.c                           |   58 +++++++++++
 41 files changed, 1179 insertions(+), 300 deletions(-)

-- 
1.7.10.4


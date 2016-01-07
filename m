Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46411 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbcAGV1C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 16:27:02 -0500
Message-ID: <1452202018.3141.28.camel@sipsolutions.net> (sfid-20160107_222720_036193_7B88886B)
Subject: pull-request: mac80211-next 2016-01-07
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Jan 2016 22:26:58 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Before we go into the merge window, I have some more updates - some are
things drivers will want soon, some are fixes for things we already
have in -next (and a few less important fixes for prior changes).

I didn't have the driver reorg in my tree, but git seems perfectly
happy to resolve it during merge. Let me know if there's any problem.

Thanks,
johannes

The following changes since commit 1b894521e60c1b91db1e8ba1278660e5c89f1b5f:

  mac80211: handle HW ROC expired properly (2015-12-07 11:06:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2016-01-07

for you to fetch changes up to e6a0cd058e1b165e9e17baf8a2d8c517ad7e3745:

  mac80211: Don't buffer non-bufferable MMPDUs (2016-01-06 12:00:57 +0100)

----------------------------------------------------------------
More -next updates with the following changes that we
accumulated over the holidays:
 * constify address in SET_IEEE80211_PERM_ADDR()
 * revert some hwsim API breakage - it's debug only but it
   broke some tools and the other could be adjusted easily
 * make regulatory messages less verbose
 * remain-on-channel operation fixes
 * sched scan vs. hardware restart fixes
 * fix for PS-poll (broken in a previous commit in -next)
 * track TX A-MSDU size limitations
 * MU-MIMO group membership action frame handling
 * preparations for handling BA reordering at a lower level
 * a few other small fixes, cleanups, documentation

----------------------------------------------------------------
Bjorn Andersson (1):
      mac80211: Make addr const in SET_IEEE80211_PERM_ADDR()

Bob Copeland (1):
      Revert "mac80211_hwsim: support any address in userspace"

Dave Young (1):
      wireless: change cfg80211 regulatory domain info as debug messages

Eliad Peller (3):
      mac80211: avoid ROC during hw restart
      mac80211: clear local->sched_scan_req properly on reconfig
      mac80211: handle sched_scan_stopped vs. hw restart race

Emmanuel Grumbach (2):
      mac80211: limit the A-MSDU Tx based on peer's capabilities
      mac80211: fix PS-Poll handling

Geliang Tang (1):
      cfg80211/mac80211: use to_delayed_work

Grzegorz Bajorski (1):
      mac80211: allow drivers to report (non-)monitor frames

Helmut Schaa (1):
      mac80211: Don't buffer non-bufferable MMPDUs

Ilan Peer (1):
      mac80211: Recalc min chandef when station is associated

Johannes Berg (6):
      mac80211: recalculate SW ROC only when needed
      mac80211: fix remain-on-channel cancellation
      cfg80211: remove CFG80211_REG_DEBUG
      regulatory: fix world regulatory domain data
      mac80211: document status.freq restrictions
      mac80211: refactor HT/VHT to chandef code

Ola Olsson (1):
      cfg80211: add more warnings for inconsistent ops

Sara Sharon (5):
      mac80211: process and save VHT MU-MIMO group frame
      mac80211: add flag for duplication check
      mac80211: pass RX aggregation window size to driver
      mac80211: pass block ack session timeout to to driver
      mac80211: support hw managing reorder logic

 drivers/net/wireless/ath/ath10k/mac.c              |   7 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   8 +-
 drivers/net/wireless/ath/carl9170/main.c           |   8 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   8 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   8 +-
 drivers/net/wireless/cw1200/sta.c                  |   4 +-
 drivers/net/wireless/cw1200/sta.h                  |   4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   8 +-
 drivers/net/wireless/iwlegacy/4965.h               |   4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   9 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   9 +-
 drivers/net/wireless/mac80211_hwsim.c              |  13 +-
 drivers/net/wireless/mediatek/mt7601u/main.c       |   8 +-
 drivers/net/wireless/mwl8k.c                       |  10 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   |   6 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   8 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  19 +--
 drivers/net/wireless/rt2x00/rt2800lib.c            |   7 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |   4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   8 +-
 include/linux/ieee80211.h                          |  26 ++++
 include/net/mac80211.h                             |  98 ++++++++++--
 net/mac80211/agg-rx.c                              |  49 +++++-
 net/mac80211/agg-tx.c                              |  53 ++++---
 net/mac80211/cfg.c                                 |  29 ++++
 net/mac80211/chan.c                                |   2 +-
 net/mac80211/debugfs.c                             |   1 +
 net/mac80211/driver-ops.c                          |  10 +-
 net/mac80211/driver-ops.h                          |   4 +-
 net/mac80211/ht.c                                  |   5 +
 net/mac80211/ibss.c                                |  10 +-
 net/mac80211/ieee80211_i.h                         |  12 +-
 net/mac80211/iface.c                               |  10 ++
 net/mac80211/main.c                                |   6 +
 net/mac80211/mesh.c                                |   9 +-
 net/mac80211/mlme.c                                |  51 ++-----
 net/mac80211/offchannel.c                          |  16 +-
 net/mac80211/rx.c                                  |  13 +-
 net/mac80211/scan.c                                |   8 +
 net/mac80211/sta_info.c                            |  11 +-
 net/mac80211/sta_info.h                            |  21 +--
 net/mac80211/status.c                              |   5 +
 net/mac80211/trace.h                               |  43 +++---
 net/mac80211/util.c                                |  73 +++++----
 net/mac80211/vht.c                                 |  42 ++++++
 net/wireless/Kconfig                               |  13 --
 net/wireless/core.c                                |  10 ++
 net/wireless/mlme.c                                |   3 +-
 net/wireless/reg.c                                 | 167 ++++++++-------------
 50 files changed, 593 insertions(+), 374 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35556 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaILHMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 03:12:41 -0400
Message-ID: <1410505951.2077.1.camel@jlt4.sipsolutions.net> (sfid-20140912_091245_742848_BA3A22FE)
Subject: pull-request: mac80211-next 2014-09-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 12 Sep 2014 09:12:31 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here's some more content for mac80211-next. Because we @Intel flushed
our patch queue it's actually bigger than the previous round, which is a
bit odd, but I think we're still well in the time where that's
acceptable :)

Let me know if there's any problem - though for a while you'll all just
have to deal with it when I'm out ...

Thanks,
johannes


The following changes since commit d0616613d9cf17919fbd46fa0274db4b0084ad62:

  net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs (2014-08-29 13:10:44 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-09-12

for you to fetch changes up to 0d8614b4b926d0f657d15d7eb5125bcb24b9fd41:

  mac80211: replace SMPS hw flags with wiphy feature bits (2014-09-11 13:37:02 +0200)

----------------------------------------------------------------
This time, I have some rate minstrel improvements, support for a very
small feature from CCX that Steinar reverse-engineered, dynamic ACK
timeout support, a number of changes for TDLS, early support for radio
resource measurement and many fixes. Also, I'm changing a number of
places to clear key memory when it's freed and Intel claims copyright
for code they developed.

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: set network header in TDLS frames

Assaf Krauss (3):
      nl80211: Allow declaring RRM-related features
      nl80211: Add flag attribute for RRM connections
      mac80211: Add RRM support to assoc request

Eliad Peller (7):
      cfg80211: avoid duplicate entries on regdomain intersection
      mac80211: adjust roc duration when combining ROCs
      mac80211: combine roc with the "next roc" if possible
      cfg80211/mac80211: add wmm info to assoc event
      cfg80211: allow requesting SMPS mode on ap start
      mac80211: set smps_mode according to ap params
      mac80211: replace SMPS hw flags with wiphy feature bits

Eyal Shapira (1):
      mac80211: fix broken use of VHT/20Mhz with some APs

Johannes Berg (10):
      mac80211: clean up ieee80211_i.h
      mac80211: add Intel Mobile Communications copyright
      cfg80211: add Intel Mobile Communications copyright
      mac80211: annotate MMIC head/tailroom warning
      cfg80211: clear connect keys when freeing them
      mac80211: clear key material when freeing keys
      cfg80211: clear wext keys when freeing and removing them
      cfg80211: don't put kek/kck/replay counter on the stack
      cfg80211: clear nl80211 messages carrying keys after processing
      cfg80211: add WMM traffic stream API

Liad Kaufman (2):
      mac80211: fix description comment of ieee80211_subif_start_xmit
      mac80211: add TDLS connection timeout

Lorenzo Bianconi (2):
      cfg80211: enable dynack through nl80211
      mac80211: extend set_coverage_class signature

Michal Kazior (1):
      mac80211: fix offloaded BA session traffic after hw restart

Steinar H. Gunderson (2):
      mac80211: split 802.11h parsing from transmit power policy
      mac80211: support DTPC IE (from Cisco Client eXtensions)

Thomas Huehn (2):
      mac80211: Unify rate statistic variables between Minstrel & Minstrel_HT
      mac80211: improve minstrel_ht rate sorting by throughput & probability

 drivers/net/wireless/ath/ath10k/mac.c         |   5 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/ath/ath9k/main.c         |   3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c      |   5 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   8 +-
 drivers/net/wireless/mac80211_hwsim.c         |   8 +-
 drivers/net/wireless/p54/main.c               |   3 +-
 include/linux/ieee80211.h                     |   8 +-
 include/net/cfg80211.h                        |  44 +++-
 include/net/mac80211.h                        |  20 +-
 include/uapi/linux/nl80211.h                  | 100 +++++++++
 net/mac80211/agg-rx.c                         |   5 +-
 net/mac80211/cfg.c                            | 101 ++++++---
 net/mac80211/debugfs.c                        |   6 +-
 net/mac80211/debugfs_netdev.c                 |   4 +-
 net/mac80211/debugfs_sta.c                    |   1 +
 net/mac80211/driver-ops.h                     |   2 +-
 net/mac80211/ibss.c                           |   1 +
 net/mac80211/ieee80211_i.h                    |   8 +-
 net/mac80211/iface.c                          |  15 +-
 net/mac80211/key.c                            |   3 +-
 net/mac80211/main.c                           |   1 +
 net/mac80211/mlme.c                           | 131 ++++++++---
 net/mac80211/rc80211_minstrel.c               |  98 +++++----
 net/mac80211/rc80211_minstrel.h               |  43 ++--
 net/mac80211/rc80211_minstrel_debugfs.c       |  19 +-
 net/mac80211/rc80211_minstrel_ht.c            | 303 +++++++++++++++++---------
 net/mac80211/rc80211_minstrel_ht.h            |  41 +---
 net/mac80211/rc80211_minstrel_ht_debugfs.c    |  10 +-
 net/mac80211/rx.c                             |  11 +
 net/mac80211/scan.c                           |   1 +
 net/mac80211/sta_info.c                       |   1 +
 net/mac80211/sta_info.h                       |   7 +
 net/mac80211/status.c                         |  22 +-
 net/mac80211/tdls.c                           |   4 +
 net/mac80211/trace.h                          |   4 +-
 net/mac80211/tx.c                             |   6 +-
 net/mac80211/util.c                           |  26 +++
 net/mac80211/wme.c                            |   1 +
 net/mac80211/wpa.c                            |   7 +-
 net/wireless/chan.c                           |   1 +
 net/wireless/core.c                           |   3 +-
 net/wireless/ibss.c                           |   4 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 233 ++++++++++++++++++--
 net/wireless/nl80211.h                        |   3 +-
 net/wireless/rdev-ops.h                       |  31 +++
 net/wireless/reg.c                            |  82 +++++--
 net/wireless/scan.c                           |   1 +
 net/wireless/sme.c                            |   6 +-
 net/wireless/trace.h                          |  45 ++++
 net/wireless/util.c                           |   3 +-
 net/wireless/wext-compat.c                    |   2 +
 net/wireless/wext-sme.c                       |   2 +-
 56 files changed, 1115 insertions(+), 399 deletions(-)



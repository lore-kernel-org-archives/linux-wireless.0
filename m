Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36831 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932755AbeGIQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 12:37:09 -0400
Subject: [RFC v2 0/4] Move TXQ scheduling into mac80211
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Mon, 09 Jul 2018 18:37:04 +0200
Message-ID: <153115421866.7447.6363834356268564403.stgit@alrua-x1> (sfid-20180709_183713_722111_6B29BAB3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an updated version of my previous patch series to move TXQ
scheduling into mac80211, allowing more drivers to take advantage of
airtime fairness scheduling. This version keeps compatibility with the
old wake_tx_queue API, so drivers can be ported to the new API one at a
time. For now, only ath9k is changed.

There's also an update to the scheduling to use a sequence number to
keep track of scheduling rounds, so drivers have a clean way to loop
through all queued TXQs exactly once without having to keep track of the
first TXQ seen in a round.

Finally, the airtime fairness scheduler also incorporates weights into
the scheduling, which allows userspace to implement policies for how
airtime is divided between stations. I have a patch series for hostapd
to implement configurable policies, that I will post separately once the
kernel side is in place.

---

Toke Høiland-Jørgensen (4):
      mac80211: Add TXQ scheduling API
      mac80211: Add airtime accounting and scheduling to TXQs
      cfg80211: Add airtime statistics and settings
      ath9k: Switch to mac80211 TXQ scheduling and airtime APIs


 drivers/net/wireless/ath/ath9k/ath9k.h     |   14 --
 drivers/net/wireless/ath/ath9k/debug.c     |    3 
 drivers/net/wireless/ath/ath9k/debug.h     |    8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |   54 ------
 drivers/net/wireless/ath/ath9k/init.c      |    3 
 drivers/net/wireless/ath/ath9k/recv.c      |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c      |  245 ++++++++--------------------
 include/net/cfg80211.h                     |   15 +-
 include/net/mac80211.h                     |   78 ++++++++-
 include/uapi/linux/nl80211.h               |   17 ++
 net/mac80211/agg-tx.c                      |    2 
 net/mac80211/cfg.c                         |    6 +
 net/mac80211/debugfs.c                     |    3 
 net/mac80211/debugfs_sta.c                 |   35 ++++
 net/mac80211/ieee80211_i.h                 |   10 +
 net/mac80211/main.c                        |    5 +
 net/mac80211/sta_info.c                    |   42 +++++
 net/mac80211/sta_info.h                    |   13 +
 net/mac80211/tx.c                          |  101 ++++++++++++
 net/wireless/core.c                        |    2 
 net/wireless/nl80211.c                     |   50 ++++++
 21 files changed, 449 insertions(+), 266 deletions(-)

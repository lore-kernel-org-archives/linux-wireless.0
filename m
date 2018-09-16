Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47131 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbeIPXFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 19:05:52 -0400
Subject: [PATCH RFC v4 0/4] Move TXQ scheduling into mac80211
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Date: Sun, 16 Sep 2018 19:42:11 +0200
Message-ID: <153711966150.9231.13481453399723518107.stgit@alrua-x1> (sfid-20180916_194317_752625_E6E12A5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another update, addressing most of the concerns raised in the last round:

- Added schedule_start()/end() functions that adds locking around the
  whole scheduling operation, which means we can get rid of the 'first'
  parameter to ieee80211_next_txq().

- Adds a callback in the wake_txqs tasklet which will ensure that any
  TXQs throttled by ieee80211_txq_may_transmit() will get woken up
  again. This also makes it possible to ensure all TXQs' deficits are
  increased in the case where the rotation in may_transmit is not
  effective because TXQs are not scheduled in round-robin order by the
  hardware. As part of this, bring back the flag that marks a TXQ as
  throttled.

- Rename ieee80211_schedule_txq() to ieee80211_return_txq() and add a
  check of empty TXQs inside it, so the driver can just call it
  unconditionally.

- Add a call to ieee80211_sta_register_airtime() from the existing
  tx_status path if tx_time is set in the tx_info status field.

- Reorder the patches to the cfg80211 airtime changes come before the
  changes to mac80211.

I didn't port over Kan's "airtime queue limits" stuff yet, partly
because I ran out of time, and partly because I wasn't use if he wanted
to do it himself :)

-Toke

---

Toke Høiland-Jørgensen (4):
      mac80211: Add TXQ scheduling API
      cfg80211: Add airtime statistics and settings
      mac80211: Add airtime accounting and scheduling to TXQs
      ath9k: Switch to mac80211 TXQ scheduling and airtime APIs


 drivers/net/wireless/ath/ath9k/ath9k.h     |   14 --
 drivers/net/wireless/ath/ath9k/debug.c     |    3 
 drivers/net/wireless/ath/ath9k/debug.h     |    8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |   54 ------
 drivers/net/wireless/ath/ath9k/init.c      |    3 
 drivers/net/wireless/ath/ath9k/recv.c      |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c      |  244 ++++++++--------------------
 include/net/cfg80211.h                     |   10 +
 include/net/mac80211.h                     |  114 +++++++++++++
 include/uapi/linux/nl80211.h               |   15 ++
 net/mac80211/agg-tx.c                      |    2 
 net/mac80211/cfg.c                         |    3 
 net/mac80211/debugfs.c                     |    3 
 net/mac80211/debugfs_sta.c                 |   51 ++++++
 net/mac80211/driver-ops.h                  |    9 +
 net/mac80211/ieee80211_i.h                 |   12 +
 net/mac80211/main.c                        |    6 +
 net/mac80211/sta_info.c                    |   51 ++++++
 net/mac80211/sta_info.h                    |   13 +
 net/mac80211/status.c                      |    6 +
 net/mac80211/tx.c                          |  134 +++++++++++++++
 net/mac80211/util.c                        |   55 ++++++
 net/wireless/nl80211.c                     |   29 +++
 23 files changed, 575 insertions(+), 273 deletions(-)

X-Clacks-Overhead: GNU Terry Pratchett

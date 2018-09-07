Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35791 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbeIHDF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 23:05:57 -0400
Subject: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Sat, 08 Sep 2018 00:22:50 +0200
Message-ID: <153635803319.14170.10011969968767927187.stgit@alrua-x1> (sfid-20180908_002304_387192_9DBCE4B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an updated version of the patch series to move TXQ scheduling and
airtime fairness scheduling into mac80211. I've only compile tested this
version, but thought it was better to get the conversation moving instead
of being blocked on me.

This addresses most of the comments from the last round. Specifically:

- It folds in Rajkumar's patches to keep per-AC TXQ lists, and to add an
  API that ath10k can use to check if a TXQ may transmit according even
  when not using get_next_txq(). I changed a few names and descriptions,
  but otherwise it's mostly the same. After the discussions we had in the
  last series, I *think* it will work this way, but I'm not entirely sure.

- I got rid of any mention of seqno in next_txq() and schedule_txq() - and
  removed the third parameter to schedule_txq() entirely, so drivers can no
  longer signal that a TXQ should be allowed to re-appear in a scheduling
  round. We can add that back if needed.

- Added a helper function to schedule and wake TXQs in a single call, for
  internal mac80211 use.

- Changed the default station weight to 256 and got rid of the per-phy
  quantum. This makes it possible to lower station weights without having
  to change the weights of every other station.

A few things that were discussed in the last round that I did *not* change:

- I did not add any locking around next_txq(); the driver is still supposed
  to maintain a lock that prevents two threads from trying to schedule the
  same AC at the same time. This is what drivers already do, so I figured it
  was easier to just keep it that way rather than do it in mac80211.

- I didn't get rid of the register_airtime() callback. As far as I can tell,
  only iwlwifi uses the tx_time field in the struct tx_info. Which means that
  we *could* probably use it for this and just make the other drivers set it;
  but I'm not sure what effects that would have in relation to WMM-AC for
  those drivers, so I chickened out. Will have to try it out, I guess; but it
  also depends on whether ath10k needs to be able to report airtime
  asynchronously anyway. So I'll hold off on that for a bit more.

-Toke

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
 include/net/cfg80211.h                     |   12 +
 include/net/mac80211.h                     |   97 +++++++++++
 include/uapi/linux/nl80211.h               |   15 ++
 net/mac80211/agg-tx.c                      |    2 
 net/mac80211/cfg.c                         |    3 
 net/mac80211/debugfs.c                     |    3 
 net/mac80211/debugfs_sta.c                 |   42 ++++-
 net/mac80211/driver-ops.h                  |    7 +
 net/mac80211/ieee80211_i.h                 |   11 +
 net/mac80211/main.c                        |    5 +
 net/mac80211/sta_info.c                    |   49 +++++-
 net/mac80211/sta_info.h                    |   13 +
 net/mac80211/tx.c                          |  125 ++++++++++++++
 net/wireless/nl80211.c                     |   25 +++
 21 files changed, 471 insertions(+), 274 deletions(-)

X-Clacks-Overhead: GNU Terry Pratchett

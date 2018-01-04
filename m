Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbeADPCO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:02:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-01-04
Date: Thu,  4 Jan 2018 16:02:07 +0100
Message-Id: <20180104150208.12908-1-johannes@sipsolutions.net> (sfid-20180104_160228_008243_F5F5E189)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

And here's a set for -next. It's not really big, and things
are all over the place. I'm thinking that Luca hasn't flushed
his queue out, but perhaps that'll then wait for the next
release, unless there are fixes that he still has.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 51e18a453f5f59a40c721d4aeab082b4e2e9fac6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2017-12-09 22:09:55 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-01-04

for you to fetch changes up to 3a3713ec360138f806c6fc368d1de570f692b347:

  mac80211: Fix setting TX power on monitor interfaces (2018-01-04 15:27:48 +0100)

----------------------------------------------------------------
We have things all over the place, no point listing them.

One thing is notable: I applied two patches and later
reverted them - we'll get back to that once all the driver
situation is sorted out.

----------------------------------------------------------------
Adiel Aloni (1):
      mac80211_hwsim: enforce PS_MANUAL_POLL to be set after PS_ENABLED

David Spinadel (2):
      mac80211: Add MIC space only for TX key option
      nl80211: send deauth reason if locally generated

Emmanuel Grumbach (1):
      mac80211: always update the PM state of a peer on MGMT / DATA frames

Gustavo A. R. Silva (1):
      mac80211: mark expected switch fall-throughs

Johannes Berg (6):
      mac80211: avoid looking up tid_tx/tid_rx from timers
      mac80211: make __ieee80211_start_rx_ba_session static
      nl80211: add a few extended error strings to key parsing
      mac80211: don't warn on AID field without top two MSBs set
      Revert "mac80211: Add airtime account and scheduling to TXQs"
      Revert "mac80211: Add TXQ scheduling API"

Luca Coelho (1):
      mac80211: remove BUG() when interface type is invalid

Peter Große (1):
      mac80211: Fix setting TX power on monitor interfaces

Sara Sharon (1):
      mac80211: call synchronize_net once in the restart flow

Sergey Matyukevich (1):
      cfg80211: cleanup signal strength units notation

Sunil Dutt (1):
      cfg80211: Scan results to also report the per chain signal strength

Toke Høiland-Jørgensen (2):
      mac80211: Add TXQ scheduling API
      mac80211: Add airtime account and scheduling to TXQs

Tova Mussai (1):
      cfg80211: IBSS: Add support for static WEP in driver for IBSS

Yingying Tang (1):
      mac80211: enable TDLS peer buffer STA feature

 drivers/net/wireless/mac80211_hwsim.c | 17 +++++----
 include/net/cfg80211.h                | 17 +++++++--
 include/net/mac80211.h                | 10 +++++-
 include/uapi/linux/nl80211.h          |  4 +++
 net/mac80211/agg-rx.c                 | 26 +++++---------
 net/mac80211/agg-tx.c                 | 34 ++++++------------
 net/mac80211/cfg.c                    | 31 +++++++++++++++-
 net/mac80211/debugfs.c                |  1 +
 net/mac80211/driver-ops.h             |  3 +-
 net/mac80211/ht.c                     |  1 +
 net/mac80211/ieee80211_i.h            |  4 ---
 net/mac80211/iface.c                  |  4 +--
 net/mac80211/key.c                    | 12 +++++--
 net/mac80211/main.c                   |  3 ++
 net/mac80211/mesh.c                   |  2 ++
 net/mac80211/mesh_hwmp.c              |  1 +
 net/mac80211/mesh_plink.c             |  2 +-
 net/mac80211/mlme.c                   | 10 +++---
 net/mac80211/offchannel.c             |  4 +--
 net/mac80211/rx.c                     | 17 +++------
 net/mac80211/tdls.c                   |  6 +++-
 net/mac80211/tx.c                     |  4 ++-
 net/mac80211/util.c                   | 19 +++++-----
 net/mac80211/wme.c                    |  1 +
 net/mac80211/wpa.c                    | 16 ++++++---
 net/wireless/ibss.c                   |  5 +++
 net/wireless/mlme.c                   |  6 ++--
 net/wireless/nl80211.c                | 68 ++++++++++++++++++++++++-----------
 net/wireless/scan.c                   |  5 +++
 net/wireless/trace.h                  | 12 +++----
 30 files changed, 219 insertions(+), 126 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46176 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeBVUIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 15:08:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-02-22
Date: Thu, 22 Feb 2018 21:08:39 +0100
Message-Id: <20180222200840.26982-1-johannes@sipsolutions.net> (sfid-20180222_210856_364386_33E5B26E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

A bunch of fixes, including the nla_put_string() issue
just in from Kees. Otherwise nothing really super urgent
or interesting.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit ba804bb4b72e57374b5f567b783aa0298fba0ce6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-01-26 09:03:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-02-22

for you to fetch changes up to 657308f73e674e86b60509a430a46e569bf02846:

  regulatory: add NUL to request alpha2 (2018-02-22 20:57:48 +0100)

----------------------------------------------------------------
Various fixes across the tree, the shortlog basically says it all:

  cfg80211: fix cfg80211_beacon_dup
  -> old bug in this code

  cfg80211: clear wep keys after disconnection
  -> certain ways of disconnecting left the keys

  mac80211: round IEEE80211_TX_STATUS_HEADROOM up to multiple of 4
  -> alignment issues with using 14 bytes

  mac80211: Do not disconnect on invalid operating class
  -> if the AP has a bogus operating class, let it be

  mac80211: Fix sending ADDBA response for an ongoing session
  -> don't send the same frame twice

  cfg80211: use only 1Mbps for basic rates in mesh
  -> interop issue with old versions of our code

  mac80211_hwsim: don't use WQ_MEM_RECLAIM
  -> it causes splats because it flushes work on a non-reclaim WQ

  regulatory: add NUL to request alpha2
  -> nla_put_string() issue from Kees

  mac80211: mesh: fix wrong mesh TTL offset calculation
  -> protocol issue

  mac80211: fix a possible leak of station stats
  -> error path might leak memory

  mac80211: fix calling sleeping function in atomic context
  -> percpu allocations need to be made with gfp flags

----------------------------------------------------------------
Arnd Bergmann (1):
      cfg80211: fix cfg80211_beacon_dup

Avraham Stern (1):
      cfg80211: clear wep keys after disconnection

Felix Fietkau (1):
      mac80211: round IEEE80211_TX_STATUS_HEADROOM up to multiple of 4

Ilan Peer (2):
      mac80211: Do not disconnect on invalid operating class
      mac80211: Fix sending ADDBA response for an ongoing session

Johannes Berg (3):
      cfg80211: use only 1Mbps for basic rates in mesh
      mac80211_hwsim: don't use WQ_MEM_RECLAIM
      regulatory: add NUL to request alpha2

Peter Oh (1):
      mac80211: mesh: fix wrong mesh TTL offset calculation

Sara Sharon (2):
      mac80211: fix a possible leak of station stats
      mac80211: fix calling sleeping function in atomic context

 drivers/net/wireless/mac80211_hwsim.c |  2 +-
 include/net/mac80211.h                |  2 +-
 include/net/regulatory.h              |  2 +-
 net/mac80211/agg-rx.c                 |  4 +---
 net/mac80211/cfg.c                    |  2 +-
 net/mac80211/ieee80211_i.h            |  2 +-
 net/mac80211/mesh.c                   | 17 ++++++-----------
 net/mac80211/spectmgmt.c              |  7 +++----
 net/mac80211/sta_info.c               |  3 ++-
 net/wireless/mesh.c                   | 25 ++++++++++++++++++++++---
 net/wireless/sme.c                    |  2 ++
 11 files changed, 41 insertions(+), 27 deletions(-)

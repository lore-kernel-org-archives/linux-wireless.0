Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756813AbeBPQNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 11:13:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Feb 2018 18:12:48 +0200
Message-Id: <20180216161301.29339-1-luca@coelho.fi> (sfid-20180216_171341_221565_F897EB1A)
Subject: [PATCH 00/13] cfg80211/mac80211 patches from our internal tree 2018-02-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Some patches with mac80211 and cfg80211 changes from our internal
tree.

Please review, though you have already reviewed most if not all of
them ;)

Cheers,
Luca.


Avraham Stern (1):
  cfg80211: clear wep keys after disconnection

Haim Dreyfuss (3):
  cfg80211: read wmm rules from regulatory database
  mac80211: limit wmm params to comply with ETSI requirements
  cfg80211: Add API to allow querying regdb for wmm_rule

Ilan Peer (4):
  mac80211: Call mgd_prep_tx before transmitting deauthentication
  mac80211: Do not disconnect on invalid operating class
  mac80211: Fix sending ADDBA response for an ongoing session
  mac80211: agg-rx: Accept ADDBA request update if timeout did not
    change

Johannes Berg (1):
  mac80211: support reporting A-MPDU EOF bit value/known

Sara Sharon (4):
  mac80211: fix a possible leak of station stats
  mac80211: ibss: send a probe request instead of allocating station
  mac80211: fix calling sleeping function in atomic context
  mac80211: add get TID helper

 include/linux/ieee80211.h          |  12 +++
 include/net/cfg80211.h             |  28 ++++++
 include/net/ieee80211_radiotap.h   |   2 +
 include/net/mac80211.h             |  18 ++++
 include/net/regulatory.h           |  28 ++++++
 net/mac80211/agg-rx.c              |  13 ++-
 net/mac80211/cfg.c                 |   3 +
 net/mac80211/debugfs.c             |   1 +
 net/mac80211/ibss.c                |  54 +---------
 net/mac80211/ieee80211_i.h         |   7 +-
 net/mac80211/iface.c               |   3 +-
 net/mac80211/michael.c             |   2 +-
 net/mac80211/mlme.c                |  19 +++-
 net/mac80211/rc80211_minstrel_ht.c |   2 +-
 net/mac80211/rx.c                  |  10 +-
 net/mac80211/spectmgmt.c           |   7 +-
 net/mac80211/sta_info.c            |   3 +-
 net/mac80211/tx.c                  |   9 +-
 net/mac80211/util.c                |  40 ++++++++
 net/mac80211/wpa.c                 |   8 +-
 net/wireless/reg.c                 | 200 +++++++++++++++++++++++++++++++++++--
 net/wireless/sme.c                 |   2 +
 22 files changed, 380 insertions(+), 91 deletions(-)

-- 
2.15.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49412 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751635AbcJRUMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 18 Oct 2016 23:12:06 +0300
Message-Id: <20161018201213.18873-1-luca@coelho.fi> (sfid-20161018_221225_241454_F0F4E881)
Subject: [PATCH 0/7] patches for mac80211/cfg80211 2016-10-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi Johannes,

Here are a few patches for mac80211/cfg80211 from our internal tree.
You're probably familiar with most of them, I'm just adding a cover
letter to make it easier for you to reply "Applied all" (hopefully).:)

Cheers,
Luca.


Emmanuel Grumbach (2):
  mac80211: allow the driver not to pass the tid to
    ieee80211_sta_uapsd_trigger
  mac80211: uapsd_queues is in QoS IE order

Ilan Peer (1):
  cfg80211: Call rdev_disconnect() when connection is in progress

Johannes Berg (3):
  wireless: radiotap: fix timestamp sampling position values
  mac80211: fix tid_agg_rx NULL dereference
  mac80211: improve RX aggregation data in debugfs

Sara Sharon (1):
  mac80211: add a HW flag for supporting HW TX fragmentation

 drivers/net/wireless/ath/ath10k/mac.c |  1 +
 drivers/net/wireless/ti/wlcore/main.c |  1 +
 include/net/cfg80211.h                | 10 ++++++----
 include/net/ieee80211_radiotap.h      |  4 ++--
 include/net/mac80211.h                | 17 ++++++++++++++---
 net/mac80211/agg-rx.c                 |  8 ++------
 net/mac80211/debugfs.c                |  1 +
 net/mac80211/debugfs_sta.c            |  9 +++++++--
 net/mac80211/ieee80211_i.h            |  2 ++
 net/mac80211/main.c                   |  4 ++++
 net/mac80211/mlme.c                   |  2 +-
 net/mac80211/rx.c                     |  6 ++++--
 net/mac80211/sta_info.c               | 13 ++++++++-----
 net/mac80211/sta_info.h               |  4 ++--
 net/mac80211/tx.c                     |  4 ++--
 net/mac80211/util.c                   |  7 +++++++
 net/mac80211/wpa.c                    |  2 +-
 net/wireless/sme.c                    |  2 +-
 18 files changed, 66 insertions(+), 31 deletions(-)

-- 
2.9.3

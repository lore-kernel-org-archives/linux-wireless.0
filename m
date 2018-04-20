Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40592 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754536AbeDTKte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 20 Apr 2018 13:49:17 +0300
Message-Id: <20180420104926.8816-1-luca@coelho.fi> (sfid-20180420_124937_775100_37B98ADE)
Subject: [PATCH 0/9] cfg80211/mac80211 patches from our internal tree 2018-04-20
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


Gregory Greenman (1):
  mac80211: add api to set CSA counter in mac80211

Haim Dreyfuss (1):
  nl80211: Add wmm rule attribute to NL80211_CMD_GET_WIPHY dump command.

Ilan Peer (2):
  mac80211: Adjust SAE authentication timeout
  mac80211: Support adding duration for prepare_tx() callback

Johannes Berg (4):
  mac80211: rename rtap_vendor_space to rtap_space
  mac80211: clean up rate info bandwidth setting
  mac80211: ethtool: memset the whole sinfo struct to 0
  mac80211: remove pointless flags=0 assignment

Sara Sharon (1):
  mac80211: use timeout from the AddBA response instead of the request

 drivers/net/wireless/ath/ath9k/main.c         |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  6 +-
 include/net/mac80211.h                        | 18 +++++-
 include/uapi/linux/nl80211.h                  | 28 +++++++++
 net/mac80211/agg-tx.c                         |  4 ++
 net/mac80211/driver-ops.h                     |  8 ++-
 net/mac80211/ethtool.c                        |  5 +-
 net/mac80211/mlme.c                           | 42 +++++++++-----
 net/mac80211/rx.c                             | 40 +++++++------
 net/mac80211/sta_info.c                       |  2 +-
 net/mac80211/trace.h                          | 25 +++++++-
 net/mac80211/tx.c                             | 28 ++++++++-
 net/mac80211/util.c                           |  6 +-
 net/wireless/nl80211.c                        | 57 +++++++++++++++++--
 14 files changed, 217 insertions(+), 55 deletions(-)

-- 
2.17.0

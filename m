Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751470AbdHEIpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:28 +0300
Message-Id: <20170805084438.12550-1-luca@coelho.fi> (sfid-20170805_104537_700300_FFC843D5)
Subject: [PATCH 00/10]  mac80211 patches from our internal tree 2017-08-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are some pending mac80211 patches from our internal tree.

The "mac80211: add api to start ba session timer expired flow" patch
is needed by an iwlwifi patch that I want to send for -fixes, so it
would have to be applied to -fixes as well.  Should I send a separate
patchset with these two so they can be both applied at the same time
(either in the mac80211 or in wireless-drivers tree)?

Please review.

Cheers,
Luca.

Avraham Stern (1):
  ieee80211: Add WFA TPC report element OUI type

Beni Lev (1):
  mac80211_hwsim: Add command to control rx status RSSI

Emmanuel Grumbach (1):
  cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}

Gregory Greenman (1):
  mac80211: recalculate some sta parameters after insertion

Johannes Berg (1):
  mac80211: simplify and clarify IE splitting

Liad Kaufman (2):
  mac80211: add MESH IE in the correct order
  mac80211: extend ieee80211_ie_split to support EXTENSION

Naftali Goldstein (1):
  mac80211: add api to start ba session timer expired flow

Sharon Dvir (1):
  mac80211: shorten debug prints using ht_dbg() to avoid warning

Tova Mussai (1):
  nl80211: return error for invalid center_freq in 40 MHz

 drivers/net/wireless/mac80211_hwsim.c | 36 ++++++++++++++++++++--
 include/linux/ieee80211.h             |  1 +
 include/net/cfg80211.h                |  6 ++--
 include/net/mac80211.h                | 15 +++++++++
 net/mac80211/agg-rx.c                 | 22 +++++++++++++-
 net/mac80211/agg-tx.c                 |  4 +--
 net/mac80211/mlme.c                   | 19 +++++-------
 net/mac80211/sta_info.c               | 57 ++++++++++++++++++++---------------
 net/mac80211/util.c                   | 23 ++++++--------
 net/wireless/nl80211.c                |  9 ++++++
 net/wireless/reg.c                    | 20 ++++++++++--
 net/wireless/util.c                   | 54 ++++++++++++++++++++++++++++-----
 12 files changed, 199 insertions(+), 67 deletions(-)

-- 
2.13.2

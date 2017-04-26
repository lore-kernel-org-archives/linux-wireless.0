Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:63273 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956638AbdDZH7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:45 +0300
Message-Id: <20170426075854.13546-1-luca@coelho.fi> (sfid-20170426_095912_313349_7D1A9468)
Subject: [PATCH 0/9] cfg80211/mac80211 patches from our internal tree 2017-04-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are some mac80211 and cfg80211 patches from our internal tree.

 * New AKM suite selectors in the ieee80211 header;
 * Some improvements in the roaming API in cfg80211;
 * Support for max BSS idle period in mac80211;
 * Some cleanups and an optimization;
 
Please review.

Cheers,
Luca.


Avraham Stern (3):
  mac80211: Add support for BSS max idle period element
  cfg80211: unify cfg80211_roamed() and cfg80211_roamed_bss()
  cfg80211/nl80211: add authorized flag to roaming event

Emmanuel Grumbach (1):
  mac80211: don't parse encrypted management frames in
    ieee80211_frame_acked

Johannes Berg (2):
  ieee80211: fix kernel-doc parsing errors
  mac80211: disentangle iflist_mtx and chanctx_mtx

Luca Coelho (3):
  ieee80211: add SUITE_B AKM selectors
  ieee80211: add FT-802.1X AKM suite selector
  mac80211: make multicast variable a bool in ieee80211_accept_frame()

 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 10 ++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 13 +++-
 drivers/net/wireless/rndis_wlan.c                  | 19 +++--
 drivers/staging/wlan-ng/cfg80211.c                 |  7 +-
 include/linux/ieee80211.h                          | 67 +++++++++++-----
 include/net/cfg80211.h                             | 62 +++++++--------
 include/net/mac80211.h                             | 14 +++-
 include/uapi/linux/nl80211.h                       | 14 ++++
 net/mac80211/cfg.c                                 |  6 +-
 net/mac80211/ieee80211_i.h                         |  1 +
 net/mac80211/main.c                                |  2 +
 net/mac80211/mlme.c                                | 14 +++-
 net/mac80211/rx.c                                  |  2 +-
 net/mac80211/status.c                              |  1 +
 net/mac80211/util.c                                | 18 ++++-
 net/wireless/core.h                                | 12 +--
 net/wireless/nl80211.c                             | 20 +++--
 net/wireless/nl80211.h                             |  5 +-
 net/wireless/sme.c                                 | 91 ++++++++++------------
 net/wireless/util.c                                |  4 +-
 20 files changed, 231 insertions(+), 151 deletions(-)

-- 
2.11.0

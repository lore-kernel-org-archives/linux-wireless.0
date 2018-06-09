Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48132 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751505AbeFIGOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 02:14:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  9 Jun 2018 09:14:41 +0300
Message-Id: <20180609061444.2859-1-luca@coelho.fi> (sfid-20180609_081608_521521_EF1C7C6D)
Subject: [PATCH V3 0/3] cfg80211/mac80211: add support for IEEE802.11ax
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third version of the patchset (there is no v2 for the cfg
and radiotap patches, since I just sent mac80211's out).  I just moved
one change (from ift to iftype) that I accidentally amended into the
wrong patch.  The rest is the same as v1 (cfg/radiotap) plus v2 (mac).

This series contain a squashed version of our internal series of
patches that add support for IEEE802.11ax draft v2.0.  It is a
combination of over 40 patches internal patches, which I have squashed
and split into 3 different ones, one for cfg80211, one for radiotap
and one for mac80211.

Please review.

Cheers,
Luca.


Luca Coelho (3):
  cfg80211: Add support for HE
  radiotap: add structs for HE
  mac80211: add support for HE

 drivers/net/wireless/realtek/rtlwifi/base.c |   2 +-
 drivers/staging/rtl8188eu/include/wifi.h    |   1 -
 drivers/staging/rtl8712/wifi.h              |   1 -
 drivers/staging/rtl8723bs/include/wifi.h    |   1 -
 include/linux/ieee80211.h                   | 437 +++++++++++++++++++-
 include/net/cfg80211.h                      | 106 ++++-
 include/net/ieee80211_radiotap.h            | 111 +++++
 include/net/mac80211.h                      |  64 ++-
 include/uapi/linux/nl80211.h                |  87 +++-
 net/mac80211/Makefile                       |   1 +
 net/mac80211/agg-rx.c                       |   8 +-
 net/mac80211/agg-tx.c                       |  19 +-
 net/mac80211/cfg.c                          |   5 +
 net/mac80211/he.c                           |  55 +++
 net/mac80211/ieee80211_i.h                  |  16 +
 net/mac80211/main.c                         |  19 +-
 net/mac80211/mlme.c                         | 288 ++++++++++++-
 net/mac80211/rx.c                           | 127 +++++-
 net/mac80211/sta_info.c                     |  15 +-
 net/mac80211/sta_info.h                     |  20 +-
 net/mac80211/trace.h                        |   2 +-
 net/mac80211/util.c                         | 120 +++++-
 net/wireless/core.c                         |  21 +-
 net/wireless/nl80211.c                      |  99 ++++-
 net/wireless/util.c                         |  82 ++++
 25 files changed, 1649 insertions(+), 58 deletions(-)
 create mode 100644 net/mac80211/he.c

-- 
2.17.1

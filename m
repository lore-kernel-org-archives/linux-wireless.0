Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751694AbeFHHMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 03:12:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Jun 2018 10:12:00 +0300
Message-Id: <20180608071203.20708-1-luca@coelho.fi> (sfid-20180608_091214_731506_932D31FD)
Subject: [PATCH 0/3] cfg80211/mac80211: add support for IEEE802.11ax
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the reworked version of the RFC I sent out a couple of weeks
ago, with modifications according to Arend's comments.

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
 net/mac80211/mlme.c                         | 285 ++++++++++++-
 net/mac80211/rx.c                           | 127 +++++-
 net/mac80211/sta_info.c                     |  15 +-
 net/mac80211/sta_info.h                     |  20 +-
 net/mac80211/trace.h                        |   2 +-
 net/mac80211/util.c                         | 120 +++++-
 net/wireless/core.c                         |  21 +-
 net/wireless/nl80211.c                      |  99 ++++-
 net/wireless/util.c                         |  82 ++++
 25 files changed, 1646 insertions(+), 58 deletions(-)
 create mode 100644 net/mac80211/he.c

-- 
2.17.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45062 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751696AbeEROFx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 10:05:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 May 2018 17:05:40 +0300
Message-Id: <20180518140543.13620-1-luca@coelho.fi> (sfid-20180518_160558_045501_F37EF668)
Subject: [RFC 0/3] cfg80211/mac80211: add support for IEEE802.11ax
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This series contain a squashed version of our internal series of
patches that add support for IEEE802.11ax draft v1.4.  It is a
combination of over 40 patches, so I may have made some mistakes when
squashing and splitting parts of to the right place, thus I'm sending
as an RFC.

I split it into 3 different patches, as you can see, one with cfg80211
changes, one with radiotap changes and one with mac80211 changes.

Please review them and let me know if anything needs to be changed.
I've been rather sparse in the commit logs, so suggestions for
improvements are welcome.

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
 include/linux/ieee80211.h                   | 431 +++++++++++++++++++-
 include/net/cfg80211.h                      | 102 ++++-
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
 net/mac80211/mlme.c                         | 277 ++++++++++++-
 net/mac80211/rx.c                           | 127 +++++-
 net/mac80211/sta_info.c                     |  15 +-
 net/mac80211/sta_info.h                     |  20 +-
 net/mac80211/trace.h                        |   2 +-
 net/mac80211/util.c                         | 120 +++++-
 net/wireless/core.c                         |  21 +-
 net/wireless/nl80211.c                      |  99 ++++-
 net/wireless/util.c                         |  82 ++++
 25 files changed, 1633 insertions(+), 53 deletions(-)
 create mode 100644 net/mac80211/he.c

-- 
2.17.0

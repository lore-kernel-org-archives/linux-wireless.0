Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39124 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935798AbeF2L7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:59:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-06-29
Date: Fri, 29 Jun 2018 13:59:05 +0200
Message-Id: <20180629115906.2045-1-johannes@sipsolutions.net> (sfid-20180629_135922_860219_9A4B4067)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's the next round of -next updates. This includes the promised
HE stuff but it's not all that big in the end, most of it is just
additions to the protocol header file :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f0dc7f9c6dd99891611fca5849cbc4c6965b690e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-06-10 19:25:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-06-29

for you to fetch changes up to a4217750586975dee7d6dd8829a1be24a7678b3d:

  mac80211: use BIT_ULL for NL80211_STA_INFO_* attribute types (2018-06-29 09:53:09 +0200)

----------------------------------------------------------------
This round's updates:
 * finally some of the promised HE code, but it turns
   out to be small - but everything kept changing, so
   one part I did in the driver was >30 patches for
   what was ultimately <200 lines of code ... similar
   here for this code.
 * improved scan privacy support - can now specify scan
   flags for randomizing the sequence number as well as
   reducing the probe request element content
 * rfkill cleanups
 * a timekeeping cleanup from Arnd
 * various other cleanups

----------------------------------------------------------------
Antonio Quartulli (1):
      nl80211: report 4ADDR status with GET_INTERFACE

Arnd Bergmann (1):
      cfg80211: track time using boottime

Gustavo A. R. Silva (1):
      mac80211: fix potential null pointer dereference

Johannes Berg (9):
      cfg80211: use better order for kcalloc() arguments
      nl80211: refactor common code in scan flags checks
      mac80211: add probe request building flags
      mac80211: split ieee80211_send_probe_req()
      nl80211: add scan features for improved scan privacy
      mac80211: support scan features for improved scan privacy
      ieee80211: bump IEEE80211_MAX_AMPDU_BUF to support HE
      rfkill: add header files to MAINTAINERS
      mac80211: remove unnecessary NULL check

Luca Coelho (3):
      cfg80211: Add support for HE
      radiotap: add structs for HE
      mac80211: add support for HE

Omer Efrat (2):
      cfg80211: use BIT_ULL for NL80211_STA_INFO_* attribute types
      mac80211: use BIT_ULL for NL80211_STA_INFO_* attribute types

Peter Meerwald (3):
      rfkill: Correctly document rkill subfolder range as >= 0 in sysfs-class-rfkill
      rfkill: Fix several typos in documentation
      rfkill: Fixes and cleanup of kernel-doc in the header file

 Documentation/ABI/stable/sysfs-class-rfkill |   6 +-
 Documentation/rfkill.txt                    |  18 +-
 MAINTAINERS                                 |   2 +
 drivers/net/wireless/realtek/rtlwifi/base.c |   2 +-
 drivers/staging/rtl8188eu/include/wifi.h    |   1 -
 drivers/staging/rtl8712/wifi.h              |   1 -
 drivers/staging/rtl8723bs/include/wifi.h    |   1 -
 drivers/staging/rtlwifi/base.c              |   2 +-
 include/linux/ieee80211.h                   | 437 +++++++++++++++++++++++++++-
 include/linux/rfkill.h                      |  20 +-
 include/net/cfg80211.h                      | 106 ++++++-
 include/net/ieee80211_radiotap.h            | 123 ++++++++
 include/net/mac80211.h                      |  64 +++-
 include/uapi/linux/nl80211.h                | 102 ++++++-
 net/mac80211/Makefile                       |   1 +
 net/mac80211/agg-rx.c                       |  10 +-
 net/mac80211/agg-tx.c                       |  19 +-
 net/mac80211/cfg.c                          |   7 +-
 net/mac80211/ethtool.c                      |   6 +-
 net/mac80211/he.c                           |  55 ++++
 net/mac80211/ht.c                           |   2 +-
 net/mac80211/ieee80211_i.h                  |  47 ++-
 net/mac80211/main.c                         |  36 ++-
 net/mac80211/mlme.c                         | 312 ++++++++++++++++++--
 net/mac80211/offchannel.c                   |   2 +-
 net/mac80211/rx.c                           | 129 +++++++-
 net/mac80211/scan.c                         |  56 +++-
 net/mac80211/sta_info.c                     | 101 ++++---
 net/mac80211/sta_info.h                     |  20 +-
 net/mac80211/trace.h                        |   2 +-
 net/mac80211/tx.c                           |  21 +-
 net/mac80211/util.c                         | 159 ++++++++--
 net/wireless/core.c                         |  21 +-
 net/wireless/core.h                         |   2 +-
 net/wireless/nl80211.c                      | 194 +++++++++---
 net/wireless/sysfs.c                        |   4 +-
 net/wireless/util.c                         |  87 +++++-
 net/wireless/wext-compat.c                  |  10 +-
 38 files changed, 1939 insertions(+), 249 deletions(-)
 create mode 100644 net/mac80211/he.c

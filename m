Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754205AbeEWMOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 08:14:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-05-23
Date: Wed, 23 May 2018 14:14:31 +0200
Message-Id: <20180523121432.9862-1-johannes@sipsolutions.net> (sfid-20180523_141451_307020_493DAA08)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's a new version of the pull request for net-next, now
with the stack size fixes included, which were the reason I
withdrew my earlier one. Other things are also included all
over the map.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1fe8c06c4a0d3b589f076cd00c25082840f10423:

  Merge branch 'qed-firmware-TLV' (2018-05-22 23:29:55 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-05-23

for you to fetch changes up to bad2929733635f80f99930b252757c70372356fe:

  nl80211: Reject disconnect commands except from conn_owner (2018-05-23 11:56:26 +0200)

----------------------------------------------------------------
For this round, we have various things all over the place, notably
 * a fix for a race in aggregation, which I want to let
   bake for a bit longer before sending to stable
 * some new statistics (ACK RSSI, TXQ)
 * TXQ configuration
 * preparations for HE, particularly radiotap
 * replace confusing "country IE" by "country element" since it's
   not referring to Ireland

Note that I merged net-next to get a fix from mac80211 that got
there via net, to apply one patch that would otherwise conflict.

----------------------------------------------------------------
Alexander Wetzel (1):
      mac80211: fix TX aggregation stop race

Amar Singhal (1):
      cfg80211: Call reg_notifier for self managed hints conditionally

Andrew Zaborowski (1):
      nl80211: Reject disconnect commands except from conn_owner

Arend Van Spriel (2):
      cfg80211: use separate struct for FILS parameters
      nl80211: add FILS related parameters to ROAM event

Arend van Spriel (1):
      cfg80211: dynamically allocate per-tid stats for station info

Balaji Pothunoori (2):
      cfg80211: average ack rssi support for data frames
      mac80211: average ack rssi support for data frames

Bjoern Johansson (1):
      mac80211_hwsim: indicate support for powersave.

Colin Ian King (2):
      mac80211: ethtool: avoid 32 bit multiplication overflow
      cfg80211: fix spelling mistake: "uknown" -> "unknown"

Denis Kenzior (2):
      nl80211: Fix compilation
      nl80211: Optimize cfg80211_bss_expire invocations

Gregory Greenman (1):
      mac80211: add api to set CSA counter in mac80211

Haim Dreyfuss (1):
      nl80211: Add wmm rule attribute to NL80211_CMD_GET_WIPHY dump command

Ilan Peer (1):
      mac80211: Support adding duration for prepare_tx() callback

Johannes Berg (9):
      mac80211: rename rtap_vendor_space to rtap_space
      mac80211: clean up rate info bandwidth setting
      mac80211: ethtool: memset the whole sinfo struct to 0
      mac80211: remove pointless flags=0 assignment
      cfg80211/mac80211: revert to stack allocation for sinfo
      mac80211: allocate and fill tidstats only when needed
      cfg80211: release station info tidstats where needed
      cfg80211: add missing kernel-doc
      Merge remote-tracking branch 'net-next/master' into mac80211-next

João Paulo Rechi Vita (2):
      rfkill: Rename rfkill_any_led_trigger* functions
      rfkill: Create rfkill-none LED trigger

Toke Høiland-Jørgensen (3):
      regulatory: Rename confusing 'country IE' in log output
      cfg80211: Expose TXQ stats and parameters to userspace
      mac80211: Support the new cfg80211 TXQ stats API

Vidyullatha Kanchanapally (1):
      nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS

 drivers/net/wireless/ath/ath9k/main.c             |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   6 +-
 drivers/net/wireless/mac80211_hwsim.c             |   1 +
 include/net/cfg80211.h                            | 131 ++++++++--
 include/net/mac80211.h                            |  18 +-
 include/uapi/linux/nl80211.h                      |  99 ++++++-
 net/mac80211/cfg.c                                | 103 +++++++-
 net/mac80211/driver-ops.h                         |   8 +-
 net/mac80211/ethtool.c                            |  13 +-
 net/mac80211/ht.c                                 |  44 ++--
 net/mac80211/ieee80211_i.h                        |   3 +
 net/mac80211/main.c                               |   3 +
 net/mac80211/mlme.c                               |  17 +-
 net/mac80211/rx.c                                 |  40 ++-
 net/mac80211/sta_info.c                           |  38 ++-
 net/mac80211/sta_info.h                           |   5 +-
 net/mac80211/status.c                             |   2 +
 net/mac80211/trace.h                              |  25 +-
 net/mac80211/tx.c                                 |  45 ++++
 net/mac80211/util.c                               |   6 +-
 net/rfkill/core.c                                 |  66 +++--
 net/wireless/core.c                               |   4 +
 net/wireless/nl80211.c                            | 304 ++++++++++++++++++++--
 net/wireless/rdev-ops.h                           |  12 +
 net/wireless/reg.c                                |  39 ++-
 net/wireless/sme.c                                |  88 +++++--
 net/wireless/trace.h                              |  14 +
 net/wireless/util.c                               |  11 +
 28 files changed, 968 insertions(+), 180 deletions(-)

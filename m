Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46310 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbeBVUQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 15:16:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-02-22
Date: Thu, 22 Feb 2018 21:16:18 +0100
Message-Id: <20180222201619.30037-1-johannes@sipsolutions.net> (sfid-20180222_211630_563351_7D0501BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Wireless is slow ... but we're preparing for HE (802.11ax),
so I guess soon we'll have a big chunk of work coming :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 91e6dd8284256ef62b43b78da6e7684e4f06ac2f:

  ipmr: Fix ptrdiff_t print formatting (2018-01-30 09:20:25 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-02-22

for you to fetch changes up to 94ba92713f8329c96e0a8e2880b3c1a785d1c95c:

  mac80211: Call mgd_prep_tx before transmitting deauthentication (2018-02-22 21:13:04 +0100)

----------------------------------------------------------------
Various updates across wireless.

One thing to note: I've included a new ethertype
that wireless uses (ETH_P_PREAUTH) in if_ether.h.

----------------------------------------------------------------
Ben Greear (1):
      mac80211: Add txq flags to debugfs

Benjamin Beichler (3):
      mac80211_hwsim: add permanent mac address option for new radios
      mac80211_hwsim: add nl_err_msg in hwsim_new_radio in netlink case
      mac80211_hwsim: add generation count for netlink dump operation

Colin Ian King (1):
      mac80211: remove redundant initialization to pointer 'hdr'

Denis Kenzior (1):
      uapi: Add 802.11 Preauthentication to if_ether

Ilan Peer (1):
      mac80211: Call mgd_prep_tx before transmitting deauthentication

Johannes Berg (2):
      nl80211: remove unnecessary genlmsg_cancel() calls
      mac80211: support reporting A-MPDU EOF bit value/known

Sara Sharon (1):
      mac80211: add get TID helper

Srinivas Dasari (4):
      cfg80211/nl80211: Optional authentication offload to userspace
      nl80211: Allow SAE Authentication for NL80211_CMD_CONNECT
      nl80211: Fix external_auth check for offloaded authentication
      ieee80211: Increase PMK maximum length to 64 bytes

Sunil Dutt (1):
      nl80211: Introduce scan flags to emphasize requested scan behavior

Venkateswara Naralasetty (2):
      cfg80211: send ack_signal to user in probe client response
      mac80211: Add tx ack signal support in sta info

tamizhr@codeaurora.org (2):
      cfg80211: Add support to notify station's opmode change to userspace
      mac80211: Add support to notify ht/vht opmode modification.

 drivers/net/wireless/ath/wil6210/cfg80211.c |   3 +-
 drivers/net/wireless/mac80211_hwsim.c       |  81 ++++++++---
 drivers/net/wireless/mac80211_hwsim.h       |   9 +-
 include/linux/ieee80211.h                   |  14 +-
 include/net/cfg80211.h                      | 104 +++++++++++++-
 include/net/ieee80211_radiotap.h            |   2 +
 include/net/mac80211.h                      |  19 +++
 include/uapi/linux/if_ether.h               |   1 +
 include/uapi/linux/nl80211.h                |  90 +++++++++++-
 net/mac80211/debugfs.c                      |   1 +
 net/mac80211/debugfs_sta.c                  |  10 +-
 net/mac80211/iface.c                        |   3 +-
 net/mac80211/michael.c                      |   2 +-
 net/mac80211/mlme.c                         |  18 ++-
 net/mac80211/rc80211_minstrel_ht.c          |   2 +-
 net/mac80211/rx.c                           |  24 +++-
 net/mac80211/sta_info.c                     |   6 +
 net/mac80211/sta_info.h                     |   2 +
 net/mac80211/status.c                       |  11 +-
 net/mac80211/tx.c                           |  11 +-
 net/mac80211/vht.c                          |   9 ++
 net/mac80211/wpa.c                          |   8 +-
 net/wireless/nl80211.c                      | 203 +++++++++++++++++++++++-----
 net/wireless/rdev-ops.h                     |  15 ++
 net/wireless/trace.h                        |  23 ++++
 25 files changed, 584 insertions(+), 87 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:41892 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbeIENfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 09:35:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-09-05
Date: Wed,  5 Sep 2018 11:05:41 +0200
Message-Id: <20180905090542.21790-1-johannes@sipsolutions.net> (sfid-20180905_110609_223341_53ECA693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's a pull request for net-next. Thanks for including
net, that way I could include Stanislaw's patch to check
the regulatory WMM data.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 36302685f59345959de96d0d70a5ad20a3a3451b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-09-04 21:33:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-09-05

for you to fetch changes up to 014f5a250fc49fa8c6cd50093e725e71f3ae52da:

  cfg80211: validate wmm rule when setting (2018-09-05 10:16:59 +0200)

----------------------------------------------------------------
This time, we have some pretty impactful work. Among
the changes:
 * changes to make PTK rekeying work better, or actually
   better/safely if drivers get updated
 * VHT extended NSS support - some APs had capabilities
   that didn't fit into the VHT (11ac) spec, so the spec
   was updated and we follow that now
 * some TXQ and A-MSDU building work - will allow iwlwifi
   to use this soon
 * more HE work, including aligning to 802.11ax Draft 3.0
 * L-SIG and 0-length-PSDU support in radiotap

----------------------------------------------------------------
Alexander Wetzel (2):
      nl80211: Add CAN_REPLACE_PTK0 API
      mac80211: Fix PTK rekey freezes and clear text leak

Gustavo A. R. Silva (1):
      mac80211: remove unnecessary NULL check

Ido Yariv (1):
      mac80211: Add he_capa debugfs entry

Johannes Berg (7):
      mac80211: remove pointless 'params' NULL checks
      mac80211: use le16_encode_bits() instead of open-coding
      mac80211: add an optional TXQ for other PS-buffered frames
      ieee80211: add new VHT capability fields/parsing
      mac80211: introduce capability flags for VHT EXT NSS support
      mac80211: add ability to parse CCFS2
      mac80211: copy VHT EXT NSS BW Support/Capable data to station

Naftali Goldstein (1):
      mac80211: fix saving a few HE values

Sara Sharon (4):
      ieee80211: remove redundant leading zeroes
      mac80211: add an option for station management TXQ
      mac80211: allow AMSDU size limitation per-TID
      mac80211: add an option for drivers to check if packets can be aggregated

Shaul Triebitz (5):
      cfg80211: add he_capabilities (ext) IE to AP settings
      mac80211: in AP mode, set bss_conf::he_supported
      mac80211: support radiotap L-SIG data
      mac80211: support reporting 0-length PSDU in radiotap
      wireless: align to draft 11ax D3.0

Stanislaw Gruszka (1):
      cfg80211: validate wmm rule when setting

Wen Gong (1):
      mac80211: Store sk_pacing_shift in ieee80211_hw

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  51 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   4 -
 drivers/net/wireless/mac80211_hwsim.c              |  18 +-
 include/linux/ieee80211.h                          | 111 +++++--
 include/net/cfg80211.h                             |   2 +
 include/net/ieee80211_radiotap.h                   |  21 ++
 include/net/mac80211.h                             |  80 ++++-
 include/uapi/linux/nl80211.h                       |   6 +
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/debugfs.c                             |   4 +
 net/mac80211/debugfs_sta.c                         | 364 ++++++++++++++++++++-
 net/mac80211/driver-ops.h                          |  10 +
 net/mac80211/ibss.c                                |   4 +-
 net/mac80211/ieee80211_i.h                         |   7 +-
 net/mac80211/key.c                                 | 111 +++++--
 net/mac80211/main.c                                |  65 ++++
 net/mac80211/mesh.c                                |   5 +-
 net/mac80211/mlme.c                                |  23 +-
 net/mac80211/rx.c                                  |  37 ++-
 net/mac80211/spectmgmt.c                           |   5 +-
 net/mac80211/sta_info.c                            |  21 +-
 net/mac80211/tx.c                                  |  64 +++-
 net/mac80211/util.c                                |  48 ++-
 net/mac80211/vht.c                                 |  20 ++
 net/wireless/nl80211.c                             |   3 +
 net/wireless/reg.c                                 |  64 ++--
 net/wireless/util.c                                | 109 ++++++
 27 files changed, 1088 insertions(+), 178 deletions(-)

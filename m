Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45280 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727191AbeHaMh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:37:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:02 +0300
Message-Id: <20180831083130.15525-1-luca@coelho.fi> (sfid-20180831_103149_730121_01876D5D)
Subject: [PATCH 00/28] cfg80211/mac80211 patches from our internal tree 2018-08-31
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


Andrei Otcheretianski (3):
  cfg80211: reg: Init wiphy_idx in regulatory_hint_core()
  mac80211: Always report TX status
  mac80211: Don't wake up from PS for offchannel TX

Dreyfuss, Haim (1):
  mac80211: fix WMM TXOP calculation

Emmanuel Grumbach (4):
  mac80211: fix a race between restart and CSA flows
  mac80211: pass the TWT support bits in extended caps to the driver
  mac80211: don't Tx a deauth frame if the AP forbade Tx
  mac80211: shorten the IBSS debug messages

Ido Yariv (1):
  mac80211: Add he_capa debugfs entry

Ilan Peer (1):
  mac80211: Fix station bandwidth setting after channel switch

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

Sara Sharon (5):
  ieee80211: remove redundant leading zeroes
  mac80211: avoid kernel panic when building AMSDU from non-linear SKB
  mac80211: add an option for station management TXQ
  mac80211: allow AMSDU size limitation per-TID
  mac80211: add an option for drivers to check if packets can be
    aggregated

Shaul Triebitz (5):
  cfg80211: add he_capabilities (ext) IE to AP settings
  mac80211: in AP mode, set bss_conf::he_supported
  mac80211: support radiotap L-SIG data
  mac80211: support reporting 0-length PSDU in radiotap
  wireless: align to draft 11ax D3.0

 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  51 ++-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 -
 drivers/net/wireless/mac80211_hwsim.c         |  18 +-
 include/linux/ieee80211.h                     | 115 ++++--
 include/net/cfg80211.h                        |   2 +
 include/net/ieee80211_radiotap.h              |  21 +
 include/net/mac80211.h                        |  67 +++-
 net/mac80211/cfg.c                            |  16 +-
 net/mac80211/debugfs.c                        |   4 +
 net/mac80211/debugfs_sta.c                    | 364 +++++++++++++++++-
 net/mac80211/driver-ops.h                     |  10 +
 net/mac80211/ibss.c                           |  26 +-
 net/mac80211/ieee80211_i.h                    |   7 +-
 net/mac80211/main.c                           |  74 +++-
 net/mac80211/mesh.c                           |   5 +-
 net/mac80211/mlme.c                           |  80 +++-
 net/mac80211/rx.c                             |  37 +-
 net/mac80211/spectmgmt.c                      |   5 +-
 net/mac80211/sta_info.c                       |  21 +-
 net/mac80211/status.c                         |   7 +-
 net/mac80211/tx.c                             |  94 +++--
 net/mac80211/util.c                           |  51 ++-
 net/mac80211/vht.c                            |  20 +
 net/wireless/nl80211.c                        |   3 +
 net/wireless/reg.c                            |   1 +
 net/wireless/util.c                           | 109 ++++++
 26 files changed, 1060 insertions(+), 152 deletions(-)

-- 
2.18.0

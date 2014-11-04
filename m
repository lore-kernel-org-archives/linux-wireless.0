Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52712 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaKDK3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 05:29:51 -0500
Message-ID: <1415096975.2064.16.camel@sipsolutions.net> (sfid-20141104_113006_407297_514B360E)
Subject: pull-request: mac80211-next 2014-11-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 04 Nov 2014 11:29:35 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This comes relatively late, but between other things I didn't get around
to it until now, sorry about that.

We have quite a bit of content, see below.

Let me know if there's any problem.

johannes

---

The following changes since commit 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-10-08 21:40:54 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-11-04

for you to fetch changes up to bd2bc23292ccf5b75e32fa3090162c38c0826352:

  mac80211: replace restart_complete() with reconfig_complete() (2014-11-04 11:18:19 +0100)

----------------------------------------------------------------
This relatively large batch of changes is comprised of the
following:
 * large mac80211-hwsim changes from Ben, Jukka and a bit myself
 * OCB/WAVE/11p support from Rostislav on behalf of the Czech Technical
   University in Prague and Volkswagen Group Research
 * minstrel VHT work from Karl
 * more CSA work from Luca
 * WMM admission control support in mac80211 (myself)
 * various smaller fixes, spelling corrections, and minor API additions

----------------------------------------------------------------
Andrei Otcheretianski (2):
      mac80211: export IE splitting function
      mac80211: increase U-APSD max service period length

Arik Nemtsov (4):
      mac80211: fix network header breakage during encryption
      mac80211: expose TDLS-initiator value to low level driver
      mac80211: add stations in order to the station list
      mac80211: expose API allowing station iteration

Ben Greear (13):
      mac80211_hwsim: fix memory leak on netlink TX failure
      mac80211_hwsim: fix typo, remove unnecessary goto
      mac80211-hwsim: add ethtool stats support
      mac80211-hwsim: support destroying radio by name
      cfg80211: support creating wiphy with suggested name
      mac80211: allow creating wiphy devices with suggested name
      mac80211-hwsim: support creating radios with specific name
      mac80211: support creating wiphy w/out creating wlanX
      mac80211-hwsim: support creating wiphy w/out creating wlanX
      cfg80211: support configuring vif mac addr on create
      mac80211: support creating vifs with specified mac address
      mac80211-hwsim: add frequency attribute to netlink pkts
      mac80211-hwsim: support SGI-20

Eliad Peller (1):
      mac80211: replace restart_complete() with reconfig_complete()

Emmanuel Grumbach (1):
      mac80211: don't flush when probing the AP

Eran Harary (1):
      ieee80211: add "max length of AMPDU" enum for VHT

Fabian Frederick (4):
      net: rfkill: kernel-doc warning fixes
      mac80211: directly return ieee80211_vif_use_reserved_context()
      mac80211: remove unnecessary null test before debugfs_remove()
      cfg80211: fix set but not used warning in nl80211_channel_switch()

Felix Fietkau (1):
      mac80211: add support for driver tx power reporting

Henning Rogge (2):
      cfg80211: add ops to query mesh proxy path table
      mac80211: implement cfg80211_ops to query mesh proxy path table

Johannes Berg (11):
      mac80211: fix change flags variable signedness
      Merge branch 'mac80211' into mac80211-next
      cfg80211: make WMM TSPEC support flag an nl80211 feature flag
      mac80211: sanity check CW_min/CW_max towards driver
      mac80211: add WMM admission control support
      mac80211: don't remove tainted keys after not programming
      cfg80211: fix integer signedness in chandef_primary_freqs()
      mac80211-hwsim: remove spurious newline
      mac80211-hwsim: add missing policy entries
      cfg80211: avoid using default in interface type switch
      mac80211: handle RIC data element in reassociation request

Jouni Malinen (2):
      cfg80211: Convert del_station() callback to use a param struct
      cfg80211: Specify frame and reason code for NL80211_CMD_DEL_STATION

Jukka Rissanen (4):
      mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
      mac80211-hwsim: Rename CREATE and DESTROY radio to NEW and DEL radio
      mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
      mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO

Karl Beldan (10):
      mac80211: minstrel_ht: fix MCS_GROUP_RATES usage
      cfg80211: set the rates mask in connection probes over specified freq
      mac80211: fix typo in starting baserate for rts_cts_rate_idx
      mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats
      mac80211: minstrel_ht: Increase the range of handled rate indexes
      mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
      mac80211: minstrel_ht: include type (cck/ht) in rates flag
      mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
      mac80211: minstrel_ht: use group flags instead of index to display rates
      mac80211: minstrel_ht: do not always skip ht rates vht_only is true

Liad Kaufman (1):
      mac80211: fix warning on htmldocs for last_tdls_pkt_time

Luciano Coelho (8):
      mac80211: return the vif's chandef in ieee80211_cfg_get_channel()
      nl80211: sanity check the channel switch counter value
      mac80211: add device_timestamp to the ieee80211_channel_switch struct
      mac80211: add extended channel switching capability if the driver supports CSA
      mac80211: add pre_channel_switch driver operation
      mac80211: add post_channel_switch driver operation
      mac80211: wait for the first beacon on the new channel after CSA
      mac80211: allow channel switch with multiple channel contexts

Michal Kazior (1):
      mac80211: enable DFS with channel contexts

Rostislav Lisovy (2):
      cfg80211: 802.11p OCB mode handling
      mac80211: 802.11p OCB mode support

Stephen Hemminger (1):
      mac80211: fix spelling errors

 drivers/net/wireless/ath/ath10k/core.h             |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   8 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   4 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   5 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   8 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   2 +-
 drivers/net/wireless/iwlegacy/4965.h               |   5 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  20 +-
 drivers/net/wireless/mac80211_hwsim.c              | 462 +++++++++++++++++----
 drivers/net/wireless/mac80211_hwsim.h              |  25 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   9 +-
 drivers/net/wireless/ti/wlcore/main.c              |  23 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |   4 +-
 include/linux/ieee80211.h                          |  22 +-
 include/net/cfg80211.h                             |  79 +++-
 include/net/mac80211.h                             | 138 +++++-
 include/uapi/linux/nl80211.h                       |  32 +-
 net/mac80211/Kconfig                               |  18 +
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/agg-tx.c                              |   5 -
 net/mac80211/cfg.c                                 | 180 +++++++-
 net/mac80211/chan.c                                |   5 +-
 net/mac80211/debug.h                               |  10 +
 net/mac80211/debugfs_key.c                         |  12 +-
 net/mac80211/driver-ops.h                          |  74 +++-
 net/mac80211/ieee80211_i.h                         |  80 +++-
 net/mac80211/iface.c                               |  30 +-
 net/mac80211/key.c                                 |  11 +-
 net/mac80211/main.c                                |  38 +-
 net/mac80211/mesh.h                                |   3 +
 net/mac80211/mesh_pathtbl.c                        |  31 ++
 net/mac80211/mlme.c                                | 281 +++++++++++--
 net/mac80211/ocb.c                                 | 250 +++++++++++
 net/mac80211/rate.c                                |   2 +-
 net/mac80211/rc80211_minstrel.c                    |   2 +-
 net/mac80211/rc80211_minstrel_debugfs.c            |  12 +-
 net/mac80211/rc80211_minstrel_ht.c                 | 313 +++++++++++---
 net/mac80211/rc80211_minstrel_ht.h                 |  40 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c         |  48 ++-
 net/mac80211/rx.c                                  |  35 ++
 net/mac80211/sta_info.c                            |   4 +-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/status.c                              |   3 +-
 net/mac80211/tdls.c                                |   8 +-
 net/mac80211/trace.h                               | 100 ++++-
 net/mac80211/tx.c                                  |  15 +
 net/mac80211/util.c                                | 132 ++++--
 net/mac80211/wep.c                                 |   2 -
 net/mac80211/wme.c                                 |  33 +-
 net/mac80211/wme.h                                 |   2 -
 net/mac80211/wpa.c                                 |   5 -
 net/rfkill/core.c                                  |   4 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/chan.c                                |  10 +-
 net/wireless/core.c                                |  77 +++-
 net/wireless/core.h                                |  12 +
 net/wireless/nl80211.c                             | 206 ++++++++-
 net/wireless/ocb.c                                 |  88 ++++
 net/wireless/rdev-ops.h                            |  55 ++-
 net/wireless/sme.c                                 |  13 +-
 net/wireless/trace.h                               |  97 ++++-
 net/wireless/util.c                                |   5 +-
 63 files changed, 2753 insertions(+), 453 deletions(-)
 create mode 100644 net/mac80211/ocb.c
 create mode 100644 net/wireless/ocb.c



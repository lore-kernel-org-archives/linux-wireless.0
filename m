Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47922 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbaKTP3F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 10:29:05 -0500
Message-ID: <1416497339.8557.8.camel@sipsolutions.net> (sfid-20141120_162914_356977_AD6A0457)
Subject: pull-request: mac80211-next 2014-11-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Nov 2014 16:28:59 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's another relatively large batch of changes - arguably the most
important being the VHT fix from Felix :-)

Let me know of any problems!

johannes

The following changes since commit 47b6308b643302e642ca2a5cb6470926f7e1c428:

  ath9k: Move roc completion to the offchannel timer (2014-11-17 15:32:17 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-11-20

for you to fetch changes up to 75769c80e381653994293b5aa5a8cfec50088f9f:

  mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check (2014-11-19 19:31:07 +0100)

----------------------------------------------------------------
It has been a while since my last pull request, so we accumulated
another relatively large set of changes:
 * TDLS off-channel support set from Arik/Liad, with some support
   patches I did
 * custom regulatory fixes from Arik
 * minstrel VHT fix (and a small optimisation) from Felix
 * add back radiotap vendor namespace support (myself)
 * random MAC address scanning for cfg80211/mac80211/hwsim (myself)
 * CSA improvements (Luca)
 * WoWLAN Net Detect (wake on network found) support (Luca)
 * and lots of other smaller changes from many people

----------------------------------------------------------------
Arik Nemtsov (12):
      cfg80211: introduce regulatory flags controlling bw
      mac80211: add supported channels IE during TDLS setup
      mac80211: add BSS coex IE to TDLS setup frames
      cfg/mac80211: define TDLS channel switch feature bit
      mac80211: track AP and peer STA TDLS chan-switch support
      mac80211: prepare TDLS mgmt code for channel-switch templates
      cfg80211: introduce TDLS channel switch commands
      mac80211: add parsing of TDLS specific IEs
      mac80211: introduce TDLS channel switch ops
      mac80211: add TDLS channel-switch Rx flow
      cfg80211: update missing fields in custom regulatory path
      cfg80211: explicitly initialize some fields in custom reg path

Eliad Peller (2):
      mac80211: remove redundant check
      mac80211: don't allow 40MHz tx rates in case of 20MHz chandef

Felix Fietkau (2):
      mac80211: skip legacy rate mask handling for VHT rates
      mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check

Henning Rogge (1):
      cfg80211: fix nl80211 cmd id in nl80211_send_mpath()

Johannes Berg (12):
      mac80211: add back support for radiotap vendor namespace data
      mac80211: refactor duplicate detection
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      mac80211: move skb info band assignment out
      mac80211: factor out 802.11 header building code
      mac80211: add function to create data frame template including key
      cfg80211: allow drivers to support random MAC addresses for scan
      mac80211: rcu-ify scan and scheduled scan request pointers
      mac80211: allow drivers to support NL80211_SCAN_FLAG_RANDOM_ADDR
      mac80211_hwsim: support scanning with random MAC address
      mac80211-hwsim: remove unnecessary hwname check
      mac80211: notify drivers on sta rate table changes

Jukka Rissanen (2):
      mac80211-hwsim: hwname is always known so use the value from wiphy
      nl80211: Replace interface socket owner attribute with more generic one

Liad Kaufman (4):
      mac80211: add option for setting skb flags before xmit
      mac80211: retransmit TDLS teardown packet through AP if not ACKed
      mac80211: add specific-queue flushing support
      mac80211: synchronously reserve TID per station

Luciano Coelho (7):
      mac80211: fix order of setting ch_switch and drv_pre_channel_switch call
      mac80211: add device_timestamp to the drv_pre_channel_switch trace
      cfg80211: add channel switch started notification
      mac80211: send channel switch started notifications
      cfg80211/mac80211: allow any interface to send channel switch notifications
      cfg80211: refactor nl80211_start_sched_scan so it can be reused
      cfg80211: add wowlan net-detect support

Patrik Flykt (2):
      mac80211-hwsim: Factor out netlink attribute appending
      mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command

Rafał Miłecki (1):
      cfg80211: protect fools returning NULL in add_virtual_intf

Tomasz Bursztyka (1):
      nl80211: Broadcast CMD_NEW_INTERFACE and CMD_DEL_INTERFACE

 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   6 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   7 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   7 +-
 drivers/net/wireless/b43/main.c                    |   7 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   7 +-
 drivers/net/wireless/cw1200/scan.c                 |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              | 279 ++++++--
 drivers/net/wireless/mac80211_hwsim.h              |   3 +
 drivers/net/wireless/mwl8k.c                       |   7 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   7 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   7 +-
 drivers/net/wireless/rtlwifi/core.c                |   7 +-
 drivers/net/wireless/ti/wl1251/main.c              |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   2 +-
 drivers/staging/vt6656/main_usb.c                  |   7 +-
 include/linux/ieee80211.h                          |  49 ++
 include/net/cfg80211.h                             |  94 +++
 include/net/mac80211.h                             | 149 +++-
 include/uapi/linux/nl80211.h                       | 108 ++-
 net/mac80211/agg-tx.c                              |   7 +
 net/mac80211/cfg.c                                 |  27 +-
 net/mac80211/debugfs_sta.c                         |  11 +-
 net/mac80211/driver-ops.h                          |  83 ++-
 net/mac80211/ieee80211_i.h                         |  42 +-
 net/mac80211/iface.c                               |   2 +
 net/mac80211/main.c                                |   6 +
 net/mac80211/mlme.c                                |  28 +-
 net/mac80211/rate.c                                |   5 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   6 +-
 net/mac80211/rx.c                                  | 146 +++-
 net/mac80211/scan.c                                | 129 ++--
 net/mac80211/sta_info.c                            |  15 +-
 net/mac80211/sta_info.h                            |  11 +
 net/mac80211/status.c                              |  55 +-
 net/mac80211/tdls.c                                | 792 ++++++++++++++++++++-
 net/mac80211/trace.h                               | 142 +++-
 net/mac80211/tx.c                                  | 303 ++++++--
 net/mac80211/util.c                                |  60 +-
 net/mac80211/vht.c                                 |   2 +
 net/mac80211/wme.c                                 |  39 +
 net/wireless/core.c                                |   4 +
 net/wireless/core.h                                |   1 +
 net/wireless/nl80211.c                             | 522 ++++++++++++--
 net/wireless/rdev-ops.h                            |  24 +
 net/wireless/reg.c                                 |  49 +-
 net/wireless/trace.h                               |  58 ++
 48 files changed, 2951 insertions(+), 384 deletions(-)



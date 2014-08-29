Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59433 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaH2OZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 10:25:34 -0400
Message-ID: <1409322323.4577.25.camel@jlt4.sipsolutions.net> (sfid-20140829_162538_055738_4F584E4C)
Subject: pull-request: mac80211-next 2014-08-29
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 Aug 2014 16:25:23 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

And another pull request, for mac80211-next. Hope this works for you.

johannes

The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:

  Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-08-14 18:13:46 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-08-29

for you to fetch changes up to d0616613d9cf17919fbd46fa0274db4b0084ad62:

  net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs (2014-08-29 13:10:44 +0200)

----------------------------------------------------------------
Not that much content this time. Some RCU cleanups, crypto
performance improvements, and various patches all over,
rather than listing them one might as well look into the
git log instead.

----------------------------------------------------------------
Andreea-Cristina Bernat (2):
      mac80211: scan: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
      mac80211: Replace rcu_dereference() with rcu_access_pointer()

Andrei Otcheretianski (1):
      ieee80211: Support parsing TPC report element in action frames

Bob Copeland (1):
      mac80211: mesh_plink: use get_unaligned_le16 instead of memcpy

Eliad Peller (1):
      mac80211: disable 40MHz support in case of 20MHz AP

Ido Yariv (2):
      mac80211: Fix accounting of the tailroom-needed counter
      mac80211: don't resize skbs needlessly

Johannes Berg (4):
      mac80211: don't duplicate station QoS capability data
      mac80211: make ieee80211_vif_use_reserved_switch static
      cfg80211: clarify BSS probe response vs. beacon data
      cfg80211: allow passing frame type to cfg80211_inform_bss()

Michal Kazior (2):
      cfg80211: re-enable CSA for drivers that support it
      mac80211: fix chantype recalc warning

Mika Westerberg (1):
      net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs

Vladimir Kondratiev (1):
      cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  48 ++----
 drivers/net/wireless/ath/wil6210/wmi.c             |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  18 +-
 drivers/net/wireless/libertas/cfg.c                |   2 +
 drivers/net/wireless/mwifiex/cfg80211.c            |   1 +
 drivers/net/wireless/mwifiex/scan.c                |   3 +-
 drivers/net/wireless/mwifiex/util.c                |   2 +-
 drivers/net/wireless/orinoco/scan.c                |  14 +-
 drivers/net/wireless/rndis_wlan.c                  |  14 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |   2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |   5 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   1 +
 include/linux/ieee80211.h                          |  65 +++++++
 include/net/cfg80211.h                             |  25 ++-
 include/net/mac80211.h                             |  14 +-
 include/uapi/linux/nl80211.h                       |  16 +-
 net/mac80211/cfg.c                                 |  13 +-
 net/mac80211/chan.c                                | 191 ++++++++++-----------
 net/mac80211/debugfs_sta.c                         |   3 +-
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   1 -
 net/mac80211/key.c                                 |  12 +-
 net/mac80211/mesh_pathtbl.c                        |   4 +-
 net/mac80211/mesh_plink.c                          |  14 +-
 net/mac80211/mlme.c                                |  33 ++--
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/scan.c                                |   2 +-
 net/mac80211/sta_info.c                            |   4 +-
 net/mac80211/sta_info.h                            |   2 -
 net/mac80211/tdls.c                                |   3 +-
 net/mac80211/tx.c                                  |  11 +-
 net/mac80211/wme.c                                 |   4 +-
 net/rfkill/rfkill-gpio.c                           |   1 +
 net/wireless/core.c                                |   6 -
 net/wireless/mlme.c                                |   4 +-
 net/wireless/nl80211.c                             |  16 +-
 net/wireless/scan.c                                |  21 ++-
 39 files changed, 344 insertions(+), 246 deletions(-)



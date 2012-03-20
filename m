Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab2CTOkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:02 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 20 Mar 2012 13:21:15 +0100
Subject: [RFC 00/12] multi-channel support
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154008_038091_B257E507)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The following patches prepare mac80211 to support multi-channel capable
hardware. The patchset prepares to channel per-vif split.

Work still needs to be done:
 * powersave per-vif
 * queue locking per-vif
 * offchannel rework (hw_config, work_work)
 * and a bit more

Questions:

 * monitor interfaces:
   Currently ieee80211_set_channel gets netdev==NULL when iface is
   a monitor. Is there a particular reason behind it?

 * ieee80211_hw_config:
   Should we extend it to take ieee80211_sub_if_data or should we
   use ieee80211_bss_info_change_notify? If so, is ieee80211_hw_config
   eventually to be removed?

What do you think of this approach?


-- Pozdrawiam / Best regards, Michal Kazior.


Michal Kazior (12):
  mac80211: prepare ieee80211_mandatory_rates to per-vif
  mac80211: prepare ieee80211_sta_get_rates to per-vif
  mac80211: prepare ieee80211_frame_duration to per-vif
  mac80211: prepare ieee80211_get_tx_channel_type to per-vif
  mac80211: split channel state
  mac80211: move offchannel flag
  mac80211: change conf_is_ht* to take ieee80211_channel_conf
  mac80211: introduce IEEE80211_HW_SUPPORTS_MULTI_CHANNEL
  mac80211: add initial structures for multi-channel
  mac80211: rename ieee80211_offchannel_return
  mac80211: split offchannel functions to per-vif
  mac80211: return NULL from get_channel in multi-channel

 drivers/net/wireless/adm8211.c                     |    2 +-
 drivers/net/wireless/at76c50x-usb.c                |    4 +-
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    4 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    8 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    6 +-
 drivers/net/wireless/ath/ath9k/common.c            |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   26 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   12 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    8 +-
 drivers/net/wireless/ath/ath9k/main.c              |   14 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   18 ++--
 drivers/net/wireless/ath/ath9k/recv.c              |    8 +-
 drivers/net/wireless/ath/carl9170/debug.c          |    4 +-
 drivers/net/wireless/ath/carl9170/mac.c            |   12 +-
 drivers/net/wireless/ath/carl9170/main.c           |    6 +-
 drivers/net/wireless/ath/carl9170/phy.c            |   12 +-
 drivers/net/wireless/b43/b43.h                     |    2 +-
 drivers/net/wireless/b43/main.c                    |   12 +-
 drivers/net/wireless/b43/phy_ht.c                  |    4 +-
 drivers/net/wireless/b43/phy_lcn.c                 |    4 +-
 drivers/net/wireless/b43/phy_n.c                   |    4 +-
 drivers/net/wireless/b43legacy/main.c              |    8 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |    6 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |    8 +-
 drivers/net/wireless/iwlegacy/common.c             |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        |    2 +-
 drivers/net/wireless/libertas_tf/main.c            |    8 +-
 drivers/net/wireless/mac80211_hwsim.c              |    8 +-
 drivers/net/wireless/mwl8k.c                       |   30 +++---
 drivers/net/wireless/p54/fwio.c                    |    4 +-
 drivers/net/wireless/p54/main.c                    |    4 +-
 drivers/net/wireless/p54/txrx.c                    |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   26 ++--
 drivers/net/wireless/rt2x00/rt2x00config.c         |   16 ++--
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c     |    2 +-
 drivers/net/wireless/rtlwifi/base.c                |    4 +-
 drivers/net/wireless/rtlwifi/core.c                |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    4 +-
 drivers/net/wireless/wl1251/main.c                 |    4 +-
 drivers/net/wireless/wl12xx/main.c                 |   14 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    4 +-
 include/net/mac80211.h                             |   41 ++++--
 net/mac80211/cfg.c                                 |   57 ++++++----
 net/mac80211/chan.c                                |   12 ++-
 net/mac80211/debugfs.c                             |    5 +-
 net/mac80211/driver-trace.h                        |    4 +-
 net/mac80211/ibss.c                                |   32 +++--
 net/mac80211/ieee80211_i.h                         |   54 +++++++--
 net/mac80211/iface.c                               |   24 +++-
 net/mac80211/main.c                                |   50 ++++----
 net/mac80211/mesh.c                                |   20 ++--
 net/mac80211/mesh_hwmp.c                           |    3 +-
 net/mac80211/mesh_plink.c                          |   10 +-
 net/mac80211/mlme.c                                |   57 ++++++----
 net/mac80211/offchannel.c                          |  126 +++++++++++---------
 net/mac80211/rate.h                                |    3 +-
 net/mac80211/rc80211_minstrel.c                    |   12 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   13 ++-
 net/mac80211/rx.c                                  |    5 +-
 net/mac80211/scan.c                                |   10 +-
 net/mac80211/tx.c                                  |   19 ++-
 net/mac80211/util.c                                |   67 +++++++----
 net/mac80211/work.c                                |   23 ++--
 81 files changed, 608 insertions(+), 457 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56012 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1FMWef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:34:35 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 8CD8C18D18B
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:33 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 6537527D84
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:34:31 +0300 (EEST)
Subject: [PATCH v2 00/27] mac80211: create mac80211_ prefix
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:34:28 +0300
Message-ID: <20110613223029.10517.52197.stgit@localhost6.localdomain6> (sfid-20110614_003439_038660_03C7EB76)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has always annoyed me that mac80211 uses ieee80211_ prefix. For some time
already I have been planning to try to do something about it and finally I
started it. Here's my first shot at it. 

In this patchset I first fix some issues I found from the drivers, then
create mac80211-compat.h to make the transition as smooth as possible and
then start changing mac80211 itself.

I now changed only parts of mac80211_i.h, I anticipate there will be still
three or four patchsets before mac80211 has been converted. Once that is done
I'm planning to start converting the drivers, one at a time. Unless driver
maintainers beat me to it, of course. I'm hoping that the conversion would be
fast enough so that mac80211-compat.h would not be included in any of the
official linux releases.

v1 was RFC but I didn't get any comments. I'm now resending the series
so that it could be considered for inclusion. Changes from v1 are rebase
to latest wireless-testing and ack for the rtlwifi patch from Larry.

Kalle

---

Kalle Valo (27):
      iwlegacy: fix stop/wake queue hacks
      iwlwifi: fix stop/wake queue hacks
      zd1211rw: include mac80211.h from zd_chip.h
      rtlwifi: include mac80211.h from core.h
      mac80211: switch mac80211.h to use mac80211 prefix
      mac80211: rename ieee80211_i.h to mac80211_i.h
      mac80211: rename ieee80211_local to mac80211_local
      mac80211: rename ieee80211_fragment_entry to mac80211_fragment_entry
      mac80211: rename ieee80211_bss to mac80211_bss
      mac80211: rename ieee80211_tx_data to mac80211_tx_data
      mac80211: rename ieee80211_packet_rx_flags to mac80211_packet_rx_flags
      mac80211: rename ieee80211_rx_flags to mac80211_i_rx_flags
      mac80211: rename ieee80211_rx_data to mac80211_rx_data
      mac80211: rename ieee80211_if_ap to mac80211_if_ap
      mac80211: change ieee80211_if_wds and _vlan to use mac80211 prefix
      mac80211: rename ieee80211_work_type to mac80211_work_type
      mac80211: rename ieee80211_work to mac80211_work
      mac80211: rename ieee80211_sta_flags to mac80211_sta_flags
      mac80211: rename ieee80211_if_managed to mac80211_if_managed
      mac80211: rename ieee80211_if_ibss to mac80211_if_ibss
      mac80211: rename ieee80211_if_mesh to mac80211_if_mesh
      mac80211: rename ieee80211_sub_if_data_flags to mac80211_sub_if_data_flags
      mac80211: rename ieee80211_sdata_state_bits to mac80211_sdata_state_bits
      mac80211: ieee80211_sub_if_data to mac80211_sub_if_data
      mac80211: use mac80211 prefix with rx and tx msg flags
      mac80211: change queue stop reasons to use mac80211 prefix
      mac80211: use mac80211_hw


 drivers/net/wireless/iwlegacy/iwl-helpers.h |    9 
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    9 
 drivers/net/wireless/rtlwifi/core.h         |    2 
 drivers/net/wireless/zd1211rw/zd_chip.h     |    2 
 include/net/mac80211-compat.h               |  273 +++++
 include/net/mac80211.h                      | 1430 ++++++++++++++-------------
 net/mac80211/agg-rx.c                       |   12 
 net/mac80211/agg-tx.c                       |   60 +
 net/mac80211/cfg.c                          |  178 ++-
 net/mac80211/chan.c                         |   18 
 net/mac80211/debugfs.c                      |   32 -
 net/mac80211/debugfs.h                      |    4 
 net/mac80211/debugfs_key.c                  |    8 
 net/mac80211/debugfs_key.h                  |   12 
 net/mac80211/debugfs_netdev.c               |   56 +
 net/mac80211/debugfs_netdev.h               |   12 
 net/mac80211/debugfs_sta.c                  |    2 
 net/mac80211/driver-ops.h                   |  122 +-
 net/mac80211/driver-trace.h                 |  172 ++-
 net/mac80211/event.c                        |    4 
 net/mac80211/ht.c                           |   18 
 net/mac80211/ibss.c                         |   94 +-
 net/mac80211/ieee80211_i.h                  | 1406 ---------------------------
 net/mac80211/iface.c                        |  106 +-
 net/mac80211/key.c                          |   32 -
 net/mac80211/key.h                          |   22 
 net/mac80211/led.c                          |   44 -
 net/mac80211/led.h                          |   38 -
 net/mac80211/mac80211_i.h                   | 1406 +++++++++++++++++++++++++++
 net/mac80211/main.c                         |   80 +-
 net/mac80211/mesh.c                         |   92 +-
 net/mac80211/mesh.h                         |   86 +-
 net/mac80211/mesh_hwmp.c                    |   48 -
 net/mac80211/mesh_pathtbl.c                 |   34 -
 net/mac80211/mesh_plink.c                   |   32 -
 net/mac80211/mlme.c                         |  428 ++++----
 net/mac80211/offchannel.c                   |   44 -
 net/mac80211/pm.c                           |   12 
 net/mac80211/rate.c                         |   10 
 net/mac80211/rate.h                         |   16 
 net/mac80211/rc80211_minstrel.c             |    8 
 net/mac80211/rc80211_minstrel.h             |    2 
 net/mac80211/rc80211_minstrel_ht.c          |    6 
 net/mac80211/rc80211_pid_algo.c             |    2 
 net/mac80211/rx.c                           |  250 ++---
 net/mac80211/scan.c                         |   86 +-
 net/mac80211/spectmgmt.c                    |    8 
 net/mac80211/sta_info.c                     |   88 +-
 net/mac80211/sta_info.h                     |   28 -
 net/mac80211/status.c                       |   26 
 net/mac80211/tkip.c                         |    4 
 net/mac80211/tx.c                           |  154 +--
 net/mac80211/util.c                         |  172 ++-
 net/mac80211/wep.c                          |   22 
 net/mac80211/wep.h                          |   12 
 net/mac80211/wme.c                          |   10 
 net/mac80211/wme.h                          |    8 
 net/mac80211/work.c                         |  142 +--
 net/mac80211/wpa.c                          |   22 
 net/mac80211/wpa.h                          |   18 
 60 files changed, 3918 insertions(+), 3615 deletions(-)
 create mode 100644 include/net/mac80211-compat.h
 delete mode 100644 net/mac80211/ieee80211_i.h
 create mode 100644 net/mac80211/mac80211_i.h


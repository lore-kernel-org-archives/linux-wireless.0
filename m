Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2CaSbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:31:40 -0400
Received: by pbcun15 with SMTP id un15so3022823pbc.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:31:39 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] Mesh synchronization
Date: Sat, 31 Mar 2012 11:31:29 -0700
Message-Id: <1333218693-30093-1-git-send-email-javier@cozybit.com> (sfid-20120331_203143_637693_A78F3F41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series implements mesh synchronization as defined in IEEE Std. 802.11-2012
If interested, you will find some implementation notes here:
https://github.com/cozybit/open80211s/wiki/Mesh-Synchronization---Implementation-Notes

Javier Cardona (4):
  mac80211_hwsim: Fill timestamp beacon at the time it is transmitted
  mac80211: Allow tsf increments via debugfs
  mac80211: Implement mesh synchronization framework
  {nl,cfg}80211: Support for mesh synchronization

 drivers/net/wireless/mac80211_hwsim.c |   26 ++--
 include/linux/ieee80211.h             |   12 ++
 include/linux/nl80211.h               |   12 ++
 include/net/cfg80211.h                |   14 ++-
 net/mac80211/Kconfig                  |   11 ++
 net/mac80211/Makefile                 |    3 +-
 net/mac80211/cfg.c                    |    8 +
 net/mac80211/debugfs_netdev.c         |   12 ++
 net/mac80211/debugfs_sta.c            |    5 +-
 net/mac80211/ieee80211_i.h            |   23 +++
 net/mac80211/mesh.c                   |   21 ++-
 net/mac80211/mesh.h                   |   19 ++
 net/mac80211/mesh_sync.c              |  296 +++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h               |    5 +
 net/mac80211/tx.c                     |    5 +
 net/wireless/mesh.c                   |    3 +
 net/wireless/nl80211.c                |   16 ++
 17 files changed, 467 insertions(+), 24 deletions(-)
 create mode 100644 net/mac80211/mesh_sync.c

-- 
1.7.5.4


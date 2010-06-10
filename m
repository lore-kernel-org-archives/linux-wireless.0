Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0FJI0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:03 -0400
Message-Id: <20100610082128.641664439@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/23] aggregation locking rework
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm finally happy with it now after having tested
it in more detail.

Also a big thanks to Sujith for testing and review.

I'll let the patch changelogs speak for themselves,
the overarching theme should be clear: ampdu_action
can sleep after this patch series.

For the curious:

 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 
 drivers/net/wireless/ath/ath9k/main.c         |    4 
 include/net/mac80211.h                        |   34 -
 net/mac80211/agg-rx.c                         |  133 ++--
 net/mac80211/agg-tx.c                         |  695 ++++++++++++++------------
 net/mac80211/debugfs_sta.c                    |   19 
 net/mac80211/driver-ops.h                     |    8 
 net/mac80211/ht.c                             |   62 +-
 net/mac80211/ibss.c                           |   77 --
 net/mac80211/ieee80211_i.h                    |   57 +-
 net/mac80211/iface.c                          |  191 +++++--
 net/mac80211/main.c                           |   19 
 net/mac80211/mesh.c                           |   83 ---
 net/mac80211/mesh.h                           |    2 
 net/mac80211/mesh_hwmp.c                      |    4 
 net/mac80211/mesh_pathtbl.c                   |    4 
 net/mac80211/mlme.c                           |  128 ----
 net/mac80211/pm.c                             |   18 
 net/mac80211/rc80211_minstrel_ht.c            |    2 
 net/mac80211/rx.c                             |  159 +++--
 net/mac80211/sta_info.c                       |   16 
 net/mac80211/sta_info.h                       |   63 +-
 net/mac80211/tx.c                             |   93 ++-
 net/mac80211/util.c                           |   31 -
 24 files changed, 998 insertions(+), 910 deletions(-)


johannes


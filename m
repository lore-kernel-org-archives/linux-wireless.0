Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2ATM6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:42 -0500
Message-Id: <20120120125516.000124996@sipsolutions.net> (sfid-20120120_135845_820468_851FFECD)
Date: Fri, 20 Jan 2012 13:55:16 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] station management & auth/assoc redesign
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the combination series of the station management
and auth/assoc redesign patches.

Together, they give drivers more flexibility as to when
to add the station entry to the device for connections.
The auth/assoc redesign also simplifies the connection
establishment process.

Combined diffstat:

 Documentation/DocBook/80211.tmpl |    1 
 include/net/cfg80211.h           |   53 -
 include/net/mac80211.h           |   30 
 net/mac80211/Makefile            |    4 
 net/mac80211/cfg.c               |    6 
 net/mac80211/debugfs_sta.c       |    4 
 net/mac80211/driver-ops.h        |   35 
 net/mac80211/driver-trace.h      |   32 
 net/mac80211/ieee80211_i.h       |   77 +-
 net/mac80211/iface.c             |    4 
 net/mac80211/key.c               |   38 -
 net/mac80211/main.c              |   13 
 net/mac80211/mlme.c              | 1412 +++++++++++++++++++++++++++------------
 net/mac80211/pm.c                |   23 
 net/mac80211/rate.c              |    2 
 net/mac80211/rate.h              |    1 
 net/mac80211/rx.c                |   22 
 net/mac80211/sta_info.c          |  274 +++----
 net/mac80211/sta_info.h          |   42 -
 net/mac80211/util.c              |   23 
 net/mac80211/work.c              |  815 ----------------------
 net/wireless/core.h              |   14 
 net/wireless/mlme.c              |  322 +-------
 net/wireless/nl80211.c           |   18 
 net/wireless/scan.c              |   12 
 net/wireless/sme.c               |   41 -
 26 files changed, 1453 insertions(+), 1865 deletions(-)

johannes


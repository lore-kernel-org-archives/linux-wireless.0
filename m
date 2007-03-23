Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48987 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933403AbXCWUn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:26 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Message-Id: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/19] d80211: pull request
Date: Fri, 23 Mar 2007 21:44:42 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry again for the long delay. I reviewed most of patches sent in last
three weeks, with one big exception of radiotap support (that's my task for
the next week :-)).

Please note that I renamed my tree to mac80211.git.

John, please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git master
to obtain following patches:

Hong Liu:
      mac80211: fix wrong keyidx will change default key
      mac80211: fix passing wrong pointer to ieee80211_dump_frame

Ivo van Doorn:
      mac80211: Prevent unregistering of unregistered hw
      mac80211: Add software sequence support

Jiri Benc:
      mac80211: drop packets from nonexisting interfaces in PS mode
      mac80211: remove useless callbacks from wmaster
      mac80211: fix rtnl locking in ieee80211_register_hw

Johannes Berg:
      mac80211: fix remaining sparse warnings

johannes@sipsolutions.net:
      mac80211: move PHY things to debugfs
      mac80211: move sta dir to debugfs
      mac80211: move per-netdev and key stuff to debugfs
      mac80211 debugfs Kconfig

Michael Buesch:
      mac80211: Fix pkt_type annotations
      mac80211: Properly kill tasklets before shutdown

Michael Wu:
      mac80211: Remove curr_rates and fix related concurrency issues
      mac80211: Remove tx_timeout callback
      mac80211: Set carrier status for STA interfaces
      mac80211: Stop virtual interfaces during scan
      mac80211: switch STA interfaces to PS mode during scan

 include/net/mac80211.h             |    7 
 net/mac80211/Kconfig               |    9 
 net/mac80211/Makefile              |    3 
 net/mac80211/debugfs.c             |  436 ++++++++++++++++++++++
 net/mac80211/debugfs.h             |   16 +
 net/mac80211/debugfs_key.c         |  253 +++++++++++++
 net/mac80211/debugfs_key.h         |   34 ++
 net/mac80211/debugfs_netdev.c      |  440 ++++++++++++++++++++++
 net/mac80211/debugfs_netdev.h      |   30 ++
 net/mac80211/debugfs_sta.c         |  242 ++++++++++++
 net/mac80211/debugfs_sta.h         |   12 +
 net/mac80211/ieee80211.c           |  298 +++++++--------
 net/mac80211/ieee80211_i.h         |  162 +++++++-
 net/mac80211/ieee80211_iface.c     |   25 -
 net/mac80211/ieee80211_ioctl.c     |  129 +++---
 net/mac80211/ieee80211_key.h       |   21 +
 net/mac80211/ieee80211_rate.h      |   47 +-
 net/mac80211/ieee80211_scan.c      |    2 
 net/mac80211/ieee80211_sta.c       |  138 +++++--
 net/mac80211/ieee80211_sysfs.c     |  718 ------------------------------------
 net/mac80211/ieee80211_sysfs.h     |   12 -
 net/mac80211/ieee80211_sysfs_sta.c |  438 ----------------------
 net/mac80211/rc80211_simple.c      |  139 ++++---
 net/mac80211/sta_info.c            |   82 ++--
 net/mac80211/sta_info.h            |   18 +
 25 files changed, 2102 insertions(+), 1609 deletions(-)

-- 
Jiri Benc
SUSE Labs

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaLOLZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 06:25:44 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v9 0/2] Stop scheduled scan if netlink client disappears
Date: Mon, 15 Dec 2014 13:25:37 +0200
Message-Id: <1418642739-11016-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141215_122547_530053_7D0B3D0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

v9:
- switched the patch order, now RCU fixes are done before the scheduled
  scan tweaks
- fix the RCU code according to comments from v8

v8:
- reworked the RCU code and placed it in patch 2

v7:
- convert the cfg80211_sched_scan_request to __rcu pointer in order
  to avoid races when accessing it
- reverting the patch v6, the port id is back in request struct

v6:
- moved owner netlink port id from cfg80211_sched_scan_request to
  rdev in order to avoid possible races

v5:
- discarded the locking changes in v4
- instead of trying to schedule sched_scan_stop worker from
  struct cfg80211_sched_scan_request, move the worker to wiphy
  as that makes it easier to manage the sched_scan_stop worker.
  There are also one scheduled scan / wiphy so it is also logical
  to do it like this.

v4:
- rtnl locking issues fixed in patch 2

v3:
- backward compatibility define tweaked in patch 1
- added missing signed-off-by:

v2:
- split the patch
- In patch 1, use a generic NL80211_ATTR_SOCKET_OWNER attribute and
  convert the old code that uses NL80211_ATTR_IFACE_SOCKET_OWNER to
  use the new value. A define is provided for backward compatibility.
- Any pending schedule scan stop worker is cancelled when interface is
  taken down in patch 2


Jukka Rissanen (2):
  nl80211: Convert sched_scan_req pointer to RCU pointer
  nl80211: Stop scheduled scan if netlink client disappears

 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 26 +++++++++++++++++++++++---
 net/wireless/core.h          |  4 +++-
 net/wireless/nl80211.c       | 35 +++++++++++++++++++++++++++--------
 net/wireless/scan.c          | 13 ++++++++-----
 6 files changed, 66 insertions(+), 17 deletions(-)

-- 
1.8.3.1


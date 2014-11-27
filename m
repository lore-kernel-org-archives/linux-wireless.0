Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaK0KVc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 05:21:32 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v8 0/2] Stop scheduled scan if netlink client disappears
Date: Thu, 27 Nov 2014 12:21:06 +0200
Message-Id: <1417083668-11958-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141127_112136_617300_23F6D1A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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
  nl80211: Stop scheduled scan if netlink client disappears
  nl80211: Convert sched_scan_req pointer to RCU pointer

 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 26 +++++++++++++++++++++++---
 net/wireless/core.h          |  4 +++-
 net/wireless/nl80211.c       | 37 +++++++++++++++++++++++++++++--------
 net/wireless/scan.c          | 20 +++++++++++++++-----
 6 files changed, 75 insertions(+), 17 deletions(-)

-- 
1.8.3.1


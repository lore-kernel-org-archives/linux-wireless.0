Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaKMP3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 10:29:47 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v5 0/2] Stop scheduled scan if netlink client disappears
Date: Thu, 13 Nov 2014 17:25:13 +0200
Message-Id: <1415892315-2911-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_162950_727724_8E6C6D01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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

Cheers,
Jukka


Jukka Rissanen (2):
  nl80211: Replace interface socket owner attribute with more generic
    one
  nl80211: Stop scheduled scan if netlink client disappears

 include/net/cfg80211.h       |  1 +
 include/uapi/linux/nl80211.h | 10 +++++++---
 net/wireless/core.c          | 17 +++++++++++++++++
 net/wireless/core.h          |  2 ++
 net/wireless/nl80211.c       | 19 +++++++++++++++++--
 5 files changed, 44 insertions(+), 5 deletions(-)

-- 
1.8.3.1


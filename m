Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaKMNt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:49:57 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v4 0/2] Stop scheduled scan if netlink client disappears
Date: Thu, 13 Nov 2014 15:49:50 +0200
Message-Id: <1415886592-18253-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_145000_277548_F3474789)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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

 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 10 +++++++---
 net/wireless/core.c          |  5 ++++-
 net/wireless/nl80211.c       | 39 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 50 insertions(+), 6 deletions(-)

-- 
1.8.3.1


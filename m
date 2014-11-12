Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43455 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaKLLgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 06:36:40 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] Stop scheduled scan if netlink client disappears
Date: Wed, 12 Nov 2014 13:36:35 +0200
Message-Id: <1415792197-23080-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141112_123644_132491_6AEFA19C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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
 include/uapi/linux/nl80211.h | 11 ++++++++---
 net/wireless/core.c          | 10 +++++++++-
 net/wireless/nl80211.c       | 38 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 55 insertions(+), 6 deletions(-)

-- 
1.8.3.1


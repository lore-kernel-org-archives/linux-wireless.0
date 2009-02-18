Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44353 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZBREWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 23:22:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 20:22:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 00/15] cfg80211: add a workqueue for regulatory processing
Date: Tue, 17 Feb 2009 20:21:47 -0800
Message-ID: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com> (sfid-20090218_052339_561771_45B35463)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a few cleanups and minor fixes but mainly
adds a workqueue for cfg80211 to use to process all regulatory
hints. This v3 changes _all_ regulatory hints to use this
workqueue.

I've combined this series with my later one that had only 3 patches.

This series is also rebased on today's pull of wl.

Luis R. Rodriguez (15):
  cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
  cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
  cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
  nl80211: disallow user requests prior to regulatory_init()
  cfg80211: add regulatory_hint_core() to separate the core reg hint
  cfg80211: propagate -ENOMEM during regulatory_init()
  cfg80211: add assert_cfg80211_lock() to ensure proper protection
  cfg80211: make regulatory_request use wiphy_idx instead of wiphy
  cfg80211: protect first access of last_request on 11d hint under
    mutex
  cfg80211: remove likely from an 11d hint case
  cfg80211: free rd on unlikely event on 11d hint
  cfg80211: move all regulatory hints to workqueue
  cfg80211: comments style cleanup
  cfg80211: allow drivers that agree on regulatory to agree
  cfg80211: rename regdom_changed to regdom_changes() and use it

 drivers/net/wireless/ath9k/main.c      |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 +-
 include/net/cfg80211.h                 |    8 +-
 include/net/wireless.h                 |    9 +-
 net/wireless/core.c                    |  102 ++++--
 net/wireless/core.h                    |   33 ++-
 net/wireless/nl80211.c                 |   47 ++-
 net/wireless/reg.c                     |  656 +++++++++++++++++++++++---------
 net/wireless/reg.h                     |    2 +
 net/wireless/sysfs.c                   |    2 +-
 10 files changed, 635 insertions(+), 238 deletions(-)


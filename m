Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27445 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZBNFeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 00/10] cfg80211: move reg hints to workqueue
Date: Fri, 13 Feb 2009 21:33:37 -0800
Message-ID: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063436_097775_B274E612)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series does prep work and then the actual work to move the
cfg80211 driver and userspace regulatory hints onto a workqueue.
This also cleans up the core reg hint onto its own routine which
addresses some of Johannes comments about the branching on the
assert_cfg80211_mutex(). We also now do a cleanup the comment
style on reg.c.

Luis R. Rodriguez (10):
  cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
  cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
  cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
  nl80211: disallow user requests prior to regulatory_init()
  cfg80211: add regulatory_hint_core() to separate the core reg hint
  cfg80211: propagate -ENOMEM during regulatory_init()
  cfg80211: add assert_cfg80211_lock() to ensure proper protection
  cfg80211: make regulatory_request use wiphy_idx instead of wiphy
  cfg80211: move regulatory hints to workqueue
  cfg80211: comments style cleanup

 drivers/net/wireless/ath9k/main.c      |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 +-
 include/net/cfg80211.h                 |    8 +-
 include/net/wireless.h                 |    9 +-
 net/wireless/core.c                    |   93 ++++--
 net/wireless/core.h                    |   42 ++-
 net/wireless/nl80211.c                 |   42 ++-
 net/wireless/reg.c                     |  578 +++++++++++++++++++++++---------
 net/wireless/reg.h                     |    2 +
 net/wireless/sysfs.c                   |    2 +-
 10 files changed, 572 insertions(+), 218 deletions(-)


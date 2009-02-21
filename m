Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZBUFEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 00/15] cfg80211: add a workqueue for regulatory processing
Date: Sat, 21 Feb 2009 00:04:18 -0500
Message-Id: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com> (sfid-20090221_060445_855813_991DFACA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found one bug in my v5 series on the workqueue patch -- I was
accessing wiphy->custom_regulatory without first checking if the
wiphy existed, in case there are any conflicts I am rebasing the
other patches and just sending a new version 6 series.

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
 net/wireless/reg.c                     |  665 +++++++++++++++++++++++--------
 net/wireless/reg.h                     |    2 +
 net/wireless/sysfs.c                   |    2 +-
 10 files changed, 644 insertions(+), 238 deletions(-)


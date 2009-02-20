Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZBTFm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 00:42:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 00/15] cfg80211: add a workqueue for regulatory processing
Date: Fri, 20 Feb 2009 00:42:35 -0500
Message-Id: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com> (sfid-20090220_064310_848478_F14949A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a few cleanups and minor fixes but mainly
adds a workqueue for cfg80211 to use to process all regulatory
hints. This v5 addresses one last comment from Johannes to remove
an unlikely() as a WARN_ON() already has it and most importantly
we do not call a spin_lock() before the cfg80211_mutex.

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


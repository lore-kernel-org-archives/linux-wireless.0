Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZBZCj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 21:39:59 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] cfg80211: send regulatory events to userspace
Date: Wed, 25 Feb 2009 21:39:46 -0500
Message-Id: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com> (sfid-20090226_034005_474383_DFEEF4A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series does the work to prep and then send regulatory
events to userspace. Userspace can now know if its requests
were applied or not and when.

This applies on top of Jouni's MLME patch for cfg80211.

Luis R. Rodriguez (3):
  cfg80211: remove REGDOM_SET_BY_INIT
  cfg80211: move enums reg_set_by and environment_cap to nl80211.h
  cfg80211: add regulatory netlink multicast group

 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/regd.c |   32 ++++++-----
 drivers/net/wireless/ath9k/regd.h |    3 +-
 include/linux/nl80211.h           |   54 +++++++++++++++++++
 include/net/cfg80211.h            |   40 +-------------
 net/wireless/core.c               |    2 +-
 net/wireless/core.h               |    5 +-
 net/wireless/nl80211.c            |   46 ++++++++++++++++
 net/wireless/nl80211.h            |    5 ++
 net/wireless/reg.c                |  105 +++++++++++++++++++++---------------
 10 files changed, 193 insertions(+), 101 deletions(-)


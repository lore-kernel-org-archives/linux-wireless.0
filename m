Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZCJCHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:07:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] cfg80211: regulatory netlink group
Date: Mon,  9 Mar 2009 22:07:39 -0400
Message-Id: <1236650862-17702-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032928_041072_C005B152)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the regulatory netlink group. With this userspace can find
out about cfg80211 regulatory changes including custom driver regulatory
uses.

Luis R. Rodriguez (3):
  cfg80211: remove REGDOM_SET_BY_INIT
  cfg80211: move enum reg_set_by to nl80211.h
  cfg80211: add regulatory netlink multicast group

 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/regd.c |   32 +++++++------
 drivers/net/wireless/ath9k/regd.h |    3 +-
 include/linux/nl80211.h           |   67 +++++++++++++++++++++++++
 include/net/cfg80211.h            |   27 +---------
 net/wireless/core.c               |   13 +++++-
 net/wireless/core.h               |    3 +-
 net/wireless/nl80211.c            |   62 +++++++++++++++++++++++
 net/wireless/nl80211.h            |    5 ++
 net/wireless/reg.c                |   97 ++++++++++++++++++++++---------------
 10 files changed, 228 insertions(+), 83 deletions(-)


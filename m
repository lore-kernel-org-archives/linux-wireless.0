Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZBZXXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:23:41 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/3] cfg80211: send regulatory events
Date: Thu, 26 Feb 2009 18:23:32 -0500
Message-Id: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com> (sfid-20090227_002349_045357_7B22B1EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series does the work to prep and then send regulatory
events to userspace. This v2 keeps the country IE environment
within cfg80211.h as we don't want to inform userspace about
details of the country IE. We also now add the defines to help
userspace determine when the kernel has the new command request
and attributes.

Luis R. Rodriguez (3):
  cfg80211: remove REGDOM_SET_BY_INIT
  cfg80211: move enum reg_set_by to nl80211.h
  cfg80211: add regulatory netlink multicast group

 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/regd.c |   32 +++++++------
 drivers/net/wireless/ath9k/regd.h |    3 +-
 include/linux/nl80211.h           |   45 +++++++++++++++++
 include/net/cfg80211.h            |   27 +---------
 net/wireless/core.c               |    2 +-
 net/wireless/core.h               |    3 +-
 net/wireless/nl80211.c            |   46 +++++++++++++++++
 net/wireless/nl80211.h            |    5 ++
 net/wireless/reg.c                |   97 ++++++++++++++++++++++---------------
 10 files changed, 179 insertions(+), 83 deletions(-)


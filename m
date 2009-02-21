Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZBUFUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:20:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/5] cfg80211: enhance world roaming
Date: Sat, 21 Feb 2009 00:20:36 -0500
Message-Id: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062056_481876_5C51A47F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v2 series addresses Johannes' comment on not making
the beacon reg hint extern, nor do we have to EXPORT_SYMBOL
it as only cfg80211 core is its user.

Luis R. Rodriguez (5):
  cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
  cfg80211: enable 5 GHz world roaming channels
  cfg80211: Add AP beacon regulatory hints
  ath9k: follow beacon hints on reg_notifier when world roaming
  cfg80211: default OLD_REG to n

 Documentation/feature-removal-schedule.txt |    5 +-
 drivers/net/wireless/ath9k/regd.c          |   93 +++++++----
 include/net/wireless.h                     |    5 +-
 net/wireless/Kconfig                       |    2 +-
 net/wireless/core.c                        |    5 +-
 net/wireless/reg.c                         |  238 +++++++++++++++++++++++++++-
 net/wireless/reg.h                         |   21 +++
 net/wireless/scan.c                        |    3 +
 8 files changed, 331 insertions(+), 41 deletions(-)


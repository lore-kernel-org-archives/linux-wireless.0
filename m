Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19365 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZAMT6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:20 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 00/12] cfg80211/mac80211: fixes/enhancements for reg_notifier()
Date: Tue, 13 Jan 2009 11:57:43 -0800
Message-ID: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205824_251428_1D313164)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few fixes for cfg80211 such as another
fix for parsing country IEs, but mostly contains work to help
drivers build a more useful reg_notifier(). While at it we remove
the CONFIG_WIRELESS_OLD_REGULATORY as we are now on road to 2.6.30.

Luis R. Rodriguez (12):
  cfg80211: print correct intersected regulatory domain
  cfg80211: add helper to indicate when to follow the driver regd
  cfg80211: add option for wiphys to disregard country IEs
  cfg80211: split wiphy_update_regulatory() in two
  cfg80211: add regulatory_set_custom_rd()
  cfg80211: add regdom_intersect_wiphy_regd()
  cfg80211: allow driver read access to cfg80211_regdomain
  cfg80211: export freq_reg_info()
  cfg80211: Fix sanity check on 5 GHz when processing country IE
  cfg80211: process user requests only after previous user/driver/core
    requests
  mac80211: allow mac80211 drivers to get to driver priv from wiphy
  cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY

 Documentation/feature-removal-schedule.txt |   18 --
 include/net/mac80211.h                     |   11 +
 include/net/wireless.h                     |   63 ++++++
 net/mac80211/util.c                        |    9 +
 net/wireless/Kconfig                       |   46 ++---
 net/wireless/reg.c                         |  293 ++++++++++------------------
 6 files changed, 199 insertions(+), 241 deletions(-)


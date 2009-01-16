Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10990 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686AbZAPAMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:12:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:12:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 00/13] cfg80211/mac80211: fixes/enhancements for reg_notifier()
Date: Thu, 15 Jan 2009 16:12:13 -0800
Message-ID: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011314_052305_7F5538D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few fixes for cfg80211 such as another
fix for parsing country IEs, but mostly contains work to help
drivers build a more useful reg_notifier(). While at it we remove
the CONFIG_WIRELESS_OLD_REGULATORY as we are now on road to 2.6.30.

This v2 of this series changes the way we deal with custom regulatory
domains and require them to be passed to cfg80211 prior to wiphy
registration. The trick and emphasis here is to use the channel orig_*
values to ensures they are respected. Another nice advantage of this
approach is after a regulatory_hint or a custom regulatory hint a user
regulatory_hint() will only be applied against the driver's regulatory
domain, not the previous user regulatory domain. This should allow
users who suspend/resume to travel and change regulatory domains manually
to help compliance without loosing channels based on previous locations.

Thanks to Johannes for his pointers.

Luis R. Rodriguez (13):
  cfg80211: print correct intersected regulatory domain
  cfg80211: add option for wiphys to disregard country IEs
  cfg80211: add wiphy_apply_custom_regulatory()
  cfg80211: export freq_reg_info()
  cfg80211: Fix sanity check on 5 GHz when processing country IE
  cfg80211: process user requests only after previous user/driver/core
    requests
  cfg80211: only export disable flag on channel disablement
  cfg80211: save original values on regulatory hints
  cfg80211: rename fw_handles_regulatory to custom_regulatory
  cfg80211: remove check for last_request on ignore_reg_update()
  cfg80211: move check for ignore_reg_update() on
    wiphy_update_regulatory()
  mac80211: allow mac80211 drivers to get to struct ieee80211_hw from
    wiphy
  cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY

 Documentation/feature-removal-schedule.txt  |   18 --
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 include/net/cfg80211.h                      |    4 +
 include/net/mac80211.h                      |   13 +
 include/net/wireless.h                      |   51 ++++-
 net/mac80211/util.c                         |    9 +
 net/wireless/Kconfig                        |   46 +---
 net/wireless/nl80211.c                      |    5 -
 net/wireless/reg.c                          |  354 ++++++++++++---------------
 10 files changed, 248 insertions(+), 256 deletions(-)


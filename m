Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42487 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447AbZAVXGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 00/12] cfg80211/mac80211: few fixes/enhancements for regulatory
Date: Thu, 22 Jan 2009 15:05:42 -0800
Message-ID: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000635_708170_A9FE8FBC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few fixes for cfg80211 such as another
fix for parsing country IEs, but mostly contains work to help
drivers build a more useful reg_notifier().

This new series handles strict regulatory settings by introducing
a wiphy->strict_regulatory setting. OLD_REGULATORY is left but
as can be seen it leaves room for cruft to build up.

Luis R. Rodriguez (12):
  cfg80211: print correct intersected regulatory domain
  cfg80211: add wiphy_apply_custom_regulatory()
  cfg80211: export freq_reg_info()
  cfg80211: Fix sanity check on 5 GHz when processing country IE
  cfg80211: process user requests only after previous user/driver/core
    requests
  cfg80211: ignore consecutive equal regulatory hints
  cfg80211: rename fw_handles_regulatory to custom_regulatory
  cfg80211: move check for ignore_reg_update() on
    wiphy_update_regulatory()
  cfg80211: pass more detailed regulatory request information on
    reg_notifier()
  cfg80211: Allow for strict regulatory settings
  mac80211: allow mac80211 drivers to get to struct ieee80211_hw from
    wiphy
  cfg80211: allow users to help a driver's compliance

 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 include/net/cfg80211.h                      |   45 ++++++
 include/net/mac80211.h                      |   13 ++
 include/net/wireless.h                      |   60 +++++++-
 net/mac80211/util.c                         |    9 +
 net/wireless/reg.c                          |  223 ++++++++++++++++++---------
 net/wireless/reg.h                          |    7 -
 8 files changed, 272 insertions(+), 89 deletions(-)


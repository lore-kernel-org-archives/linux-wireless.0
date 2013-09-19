Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f180.google.com ([209.85.213.180]:63920 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 12:18:17 -0400
Received: by mail-ye0-f180.google.com with SMTP id m15so3537946yen.11
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 09:18:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/4] ath: add dynamic user regulatory setting support
Date: Thu, 19 Sep 2013 11:18:06 -0500
Message-Id: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130919_181820_743296_4EB6E239)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds dynamic user regulatory domain support for the shared ath
module.

Luis R. Rodriguez (4):
  cfg80211: export reg_initiator_name()
  ath: move common dynamic regulatory domain setting to a helper
  ath: split user and driver reguluatory hint parsing
  ath: add support for proper dynamic regulatory hints

 drivers/net/wireless/ath/Kconfig |   17 +++++
 drivers/net/wireless/ath/regd.c  |  140 +++++++++++++++++++++++++++++++++-----
 include/net/cfg80211.h           |    9 +++
 net/wireless/reg.c               |   27 +++++---
 4 files changed, 165 insertions(+), 28 deletions(-)

-- 
1.7.10.4


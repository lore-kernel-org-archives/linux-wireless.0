Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28332 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZG3RWn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 13:22:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 10:22:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/3] wireless: fix 11d lockdep and move 11d hint to cfg80211
Date: Thu, 30 Jul 2009 10:22:39 -0700
Message-ID: <1248974562-8315-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cures the lockdep warning, now with a mutex instead of a spin_lock
to allow sleeping during the driver reg notifier, and we finish the
move of the regulatory_hint_11d() to cfg80211. We also add some missing
lock calls and remove the cfg80211 mutex usage from the driver custom
regulatory settings wiphy_apply_custom_regulatory(). This caller is now
used internally within cfg80211 automatically for all cfg80211 drivers.

Luis R. Rodriguez (3):
  cfg80211: use goto out on 11d reg hint failure
  cfg80211: decouple regulatory variables from cfg80211_mutex
  cfg80211: enable country IE support to all cfg80211 drivers

Sorry -- forgot to address John...

 include/net/cfg80211.h |   14 ------------
 net/mac80211/mlme.c    |    6 +----
 net/wireless/core.c    |    4 +--
 net/wireless/reg.c     |   53 +++++++++++++++++++++++++++++++++++------------
 net/wireless/reg.h     |   15 +++++++++++++
 net/wireless/sme.c     |   16 ++++++++++++++
 6 files changed, 72 insertions(+), 36 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56071 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZGaAiL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 20:38:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 17:38:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 0/4] wireless: fix reg lockdep and move country ie hint
Date: Thu, 30 Jul 2009 17:38:05 -0700
Message-ID: <1249000689-14970-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alright, this should be it, the snag I found is fixed by the new
patch 2/4 of this series. When we want to deal with conflicts
for multiple country IE hints (when we suspend for example)
we can deal with the conflict on the workqueue and lift the
early check out we have there now.

Luis R. Rodriguez (4):
  cfg80211: use goto out on country IE reg hint failure
  cfg80211: do not iterate over rdev list on country IE hint
  cfg80211: decouple regulatory variables from cfg80211_mutex
  cfg80211: enable country IE support to all cfg80211 drivers

 include/net/cfg80211.h |   14 ------
 net/mac80211/mlme.c    |    6 +--
 net/wireless/core.c    |    4 +-
 net/wireless/reg.c     |  107 +++++++++++++++++++++--------------------------
 net/wireless/reg.h     |   15 +++++++
 net/wireless/sme.c     |   16 +++++++
 6 files changed, 81 insertions(+), 81 deletions(-)


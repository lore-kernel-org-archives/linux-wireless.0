Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17652 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0LGCtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:49:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:48:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<amod.bodas@atheros.com>, <pstew@google.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] mac80211/ath9k: few suspend checks and fixes
Date: Mon, 6 Dec 2010 18:48:50 -0800
Message-ID: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few suspend fixes on both ath9k and mac80211. The issue
was mainly in mac80211 but since we know we *have* to be asleep
when going to suspend we place some warnings on a few places on
ath9k to ensure we get warning for these cases. I know at least
Ben has tested his setup with these warnings and he hasn't seen
issues. 3 of these patches are stable fixes.

Luis R. Rodriguez (5):
  ath9k: warn when we get a ATH9K_INT_TIM_TIMER and are idle
  ath9k: Fix power save count imbalance on ath_radio_enable()
  ath9k_hw: warn if we cannot change the power to the chip
  mac80211: fix idle change notifications upon device stop
  mac80211: fix issuing idle calls when device open count is 0

 drivers/net/wireless/ath/ath9k/hw.c   |    2 ++
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 net/mac80211/ieee80211_i.h            |   10 +++++++++-
 net/mac80211/iface.c                  |   25 ++++++++++++++++---------
 net/mac80211/main.c                   |    4 ++--
 net/mac80211/pm.c                     |    2 ++
 net/mac80211/scan.c                   |    2 +-
 net/mac80211/util.c                   |    1 +
 8 files changed, 36 insertions(+), 15 deletions(-)

-- 
1.7.3.2.90.gd4c43


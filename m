Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0H1HNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 03:13:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/3] mac80211: new API for handling broadcast / multicast on sw scan
Date: Sat, 28 Aug 2010 03:13:07 -0400
Message-Id: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's sw scan doesn't play nice with buffered broadcast and
multicast frames. Since drivers are required to keep track of the DTIM
count this series provides some new basic functionality to let drivers
help mac80211 make more prudent decisions for sw scan.

Tested with an AP with a beacon interval of 100 and then two dtim
intervals: 1, 2.

I'll send out the PS fix separately, its an RFC because I am not aware
of the impact of enabling PS after 2.6.34... did we *really* go on testing
without PS since then? The good news is that at least with these patches
my AR9003 device works well with PS enabled. Haven't tested the AR9002
family. You can force enable PS to test it by using iw:

	iw dev wlan0 set power_save on

I believe we can expand on this to move more of the code ath9k does into
mac80211 and just provide basic APIs for informating mac80211 what it
should do.

I'd appreciate if others would test, specially those without ath9k
and using sw scan.

Luis R. Rodriguez (3):
  ath9k: fix regression which disabled ps on ath9k on all cards
  mac80211: allow drivers to specify sw scan wait constraints
  ath9k: implement the sw scan wait constraints

 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    3 +-
 drivers/net/wireless/ath/ath9k/main.c  |   69 ++++++++++++++++++++++++++++++++
 include/net/mac80211.h                 |   12 ++++++
 net/mac80211/driver-ops.h              |   16 +++++++
 net/mac80211/driver-trace.h            |   18 ++++++++
 net/mac80211/ieee80211_i.h             |    2 +
 net/mac80211/scan.c                    |   42 +++++++++++++++++--
 8 files changed, 158 insertions(+), 5 deletions(-)


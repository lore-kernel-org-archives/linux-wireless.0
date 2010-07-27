Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0G0UdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 16:33:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] Revert of mac80211 scan complete callback move
Date: Tue, 27 Jul 2010 16:33:05 -0400
Message-Id: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two virtual wiphy messages seen on both ath9k and mac80211_hwsim was
debugged by Johannes and fixed but required a little more work on the
drivers end. So for now revert that fix and supress the messages.

We can address this for the next kernel release.

Luis R. Rodriguez (3):
  ath9k: remove the two wiphys scanning at the same time message
  mac80211_hwsim: supress scan conflict message
  Revert "mac80211: fix sw scan bracketing"

 drivers/net/wireless/ath/ath9k/main.c |   13 +++++++++----
 drivers/net/wireless/mac80211_hwsim.c |    4 +---
 net/mac80211/scan.c                   |    4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3475 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0AUEwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 23:52:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] ath5k: dont use external sleep clock in AP mode
Date: Wed, 20 Jan 2010 23:51:03 -0500
Message-Id: <1264049464-12292-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
References: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the external sleep clock in AP mode, the
TSF increments too quickly, causing beacon interval
to be much lower than it is supposed to be, resulting
in lots of beacon-not-ready interrupts.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 6690923..a35a7db 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1374,8 +1374,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
 	 * exists */
-	if (ah->ah_version == AR5K_AR5212)
-			ath5k_hw_set_sleep_clock(ah, true);
+	if (ah->ah_version == AR5K_AR5212 &&
+	    ah->ah_op_mode != NL80211_IFTYPE_AP)
+		ath5k_hw_set_sleep_clock(ah, true);
 
 	/*
 	 * Disable beacons and reset the register
-- 
1.6.3.3



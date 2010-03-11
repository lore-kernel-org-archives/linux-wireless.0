Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0CKXXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 18:23:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, mb@bu3sch.de, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] ath5k: dont use external sleep clock in AP mode
Date: Thu, 11 Mar 2010 18:23:48 -0500
Message-Id: <1268349829-3195-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
References: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

When using the external sleep clock in AP mode, the
TSF increments too quickly, causing beacon interval
to be much lower than it is supposed to be, resulting
in lots of beacon-not-ready interrupts.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 34e13c7..257ea18 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1382,8 +1382,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
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


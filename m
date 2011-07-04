Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linknet-ip-202.77.119.130.link.net.id ([202.77.119.130]:59119
	"EHLO ppac-jak-id-1.inter-touch.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab1GDGLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 02:11:05 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 7/8] ath5k: disable 32KHz sleep clock operation
Date: Mon,  4 Jul 2011 12:47:46 +0700
Message-Id: <1309758467-1712-7-git-send-email-nbd@openwrt.org> (sfid-20110704_081123_271265_6CB9BCF0)
In-Reply-To: <1309758467-1712-6-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
 <1309758467-1712-2-git-send-email-nbd@openwrt.org>
 <1309758467-1712-3-git-send-email-nbd@openwrt.org>
 <1309758467-1712-4-git-send-email-nbd@openwrt.org>
 <1309758467-1712-5-git-send-email-nbd@openwrt.org>
 <1309758467-1712-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While 32 KHz sleep clock might provide some power saving benefits,
it is also a major source of stability issues, on OpenWrt it produced
some reproducible data bus errors on register accesses on several
different MIPS platforms.

All the Atheros drivers that I can find do not enable this feature,
so it makes sense to leave it disabled in ath5k as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/reset.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 55276ce..192c0cb 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1285,15 +1285,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 	ath5k_hw_dma_init(ah);
 
-
-	/* Enable 32KHz clock function for AR5212+ chips
-	 * Set clocks to 32KHz operation and use an
-	 * external 32KHz crystal when sleeping if one
-	 * exists */
-	if (ah->ah_version == AR5K_AR5212 &&
-	    op_mode != NL80211_IFTYPE_AP)
-		ath5k_hw_set_sleep_clock(ah, true);
-
 	/*
 	 * Disable beacons and reset the TSF
 	 */
-- 
1.7.3.2


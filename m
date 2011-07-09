Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35867 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1GIENS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/9] ath9k_hw: fix MAC clock rate for AR9287 v1.3+
Date: Sat,  9 Jul 2011 11:12:49 +0700
Message-Id: <1310184774-32913-4-git-send-email-nbd@openwrt.org> (sfid-20110709_061322_909184_BBE36F5D)
In-Reply-To: <1310184774-32913-3-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
 <1310184774-32913-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This chip uses the async FIFO feature and runs the MAC at 117 MHz

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f69c62e..d4084d8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -87,7 +87,10 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned int clockrate;
 
-	if (!ah->curchan) /* should really check for CCK instead */
+	/* AR9287 v1.3+ uses async FIFO and runs the MAC at 117 MHz */
+	if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah))
+		clockrate = 117;
+	else if (!ah->curchan) /* should really check for CCK instead */
 		clockrate = ATH9K_CLOCK_RATE_CCK;
 	else if (conf->channel->band == IEEE80211_BAND_2GHZ)
 		clockrate = ATH9K_CLOCK_RATE_2GHZ_OFDM;
-- 
1.7.3.2


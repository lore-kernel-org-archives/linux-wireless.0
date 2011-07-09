Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35862 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1GIENQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/9] ath9k_hw: fix MAC clock for half/quarter rate
Date: Sat,  9 Jul 2011 11:12:48 +0700
Message-Id: <1310184774-32913-3-git-send-email-nbd@openwrt.org> (sfid-20110709_061331_708690_D5162593)
In-Reply-To: <1310184774-32913-2-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enabling half/quarter rate makes the MAC run at half/quarter clock speed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a6bb9c4..f69c62e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -99,6 +99,13 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 	if (conf_is_ht40(conf))
 		clockrate *= 2;
 
+	if (ah->curchan) {
+		if (IS_CHAN_HALF_RATE(ah->curchan))
+			clockrate /= 2;
+		if (IS_CHAN_QUARTER_RATE(ah->curchan))
+			clockrate /= 4;
+	}
+
 	common->clockrate = clockrate;
 }
 
-- 
1.7.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 048/102] ath9k_hw: rename PA calib for AR9287
Date: Thu,  8 Apr 2010 15:26:44 -0400
Message-Id: <1270754858-26266-49-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 156ae34..e2c427b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -671,7 +671,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 }
 EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
-static void ath9k_olc_temp_compensation_9287(struct ath_hw *ah)
+static void ar9287_hw_olc_temp_compensation(struct ath_hw *ah)
 {
 	u32 rddata;
 	int32_t delta, currPDADC, slope;
@@ -706,7 +706,7 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 	int delta, currPDADC, regval;
 
 	if (OLC_FOR_AR9287_10_LATER) {
-		ath9k_olc_temp_compensation_9287(ah);
+		ar9287_hw_olc_temp_compensation(ah);
 	} else {
 		rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
 		currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbZJ0Q7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:59:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/5] ath9k_hw: remove bogus register write on ath9k_hw_9271_pa_cal()
Date: Tue, 27 Oct 2009 12:59:37 -0400
Message-Id: <1256662777-20469-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
References: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An extra register was being written to for PA calibration
making the hardware unresponsive, remove it. Hardware
reset should now complete fine on ar9271.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 551f880..238a574 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -877,7 +877,7 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0);
 
 	/* find off_6_1; */
-	for (i = 6; i >= 0; i--) {
+	for (i = 6; i > 0; i--) {
 		regVal = REG_READ(ah, 0x7834);
 		regVal |= (1 << (20 + i));
 		REG_WRITE(ah, 0x7834, regVal);
-- 
1.6.0.4


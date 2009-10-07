Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZJGUW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 16:22:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] ath9k_hw: run the carrier leakage calibration fix for ar9271 as well
Date: Wed,  7 Oct 2009 16:22:18 -0400
Message-Id: <1254946939-4943-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required for the ar9271 hardware as well.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index f46bd05..7aa3d1d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -1070,6 +1070,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 }
 EXPORT_SYMBOL(ath9k_hw_calibrate);
 
+/* Carrier leakage Calibration fix */
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1115,7 +1116,7 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (AR_SREV_9285_12_OR_LATER(ah)) {
+	if (AR_SREV_9271(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_clc(ah, chan))
 			return false;
 	} else {
-- 
1.6.0.4


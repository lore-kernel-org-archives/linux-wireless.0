Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48468 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1ANUMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 15:12:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 12:12:30 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_hw: fix carrier leakage calibration for AR9271
Date: Sat, 15 Jan 2011 01:42:01 +0530
Message-ID: <1295035921-13097-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9285 carrier leakage calibration related workaround on high
temperature is not applicable for AR9271.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index ea2e7d7..14d7d2a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -805,7 +805,10 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (AR_SREV_9271(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
+	if (AR_SREV_9271(ah)) {
+		if (!ar9285_hw_cl_cal(ah, chan))
+			return false;
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_hw_clc(ah, chan))
 			return false;
 	} else {
-- 
1.7.3.5


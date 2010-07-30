Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42330 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760346Ab0G3TCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 15:02:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/4] ath9k_hw: fix periodic noise floor calibration on AR9003
Date: Fri, 30 Jul 2010 21:02:10 +0200
Message-Id: <1280516532-42721-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
References: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The periodic noise floor calibration is broken on this chip family, because
it keeps triggering a software-filtered noise floor calibration, but never
reads the result before uploading the history buffer value to the hardware.

Fix this with a call to ath9k_hw_getnf(), just like on AR9002.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 938365e..f51ab89 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -149,6 +149,12 @@ static bool ar9003_hw_calibrate(struct ath_hw *ah,
 	/* Do NF cal only at longer intervals */
 	if (longcal) {
 		/*
+		 * Get the value from the previous NF cal and update
+		 * history buffer.
+		 */
+		ath9k_hw_getnf(ah, chan);
+
+		/*
 		 * Load the NF from history buffer of the current channel.
 		 * NF is slow time-variant, so it is OK to use a historical
 		 * value.
-- 
1.6.4.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49436 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbCUIri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:47:38 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 08/18] ath9k: use one shot read in ath9k_hw_update_mibstats
Date: Sat, 21 Mar 2015 09:47:11 +0100
Message-Id: <1426927641-18474-9-git-send-email-linux@rempel-privat.de> (sfid-20150321_100417_690433_5E42FF3F)
In-Reply-To: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
References: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this will reduce some overhead on usb bus.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ani.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index ca01d17..25e45e4 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -107,11 +107,21 @@ static const struct ani_cck_level_entry cck_level_table[] = {
 static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 				     struct ath9k_mib_stats *stats)
 {
-	stats->ackrcv_bad += REG_READ(ah, AR_ACK_FAIL);
-	stats->rts_bad += REG_READ(ah, AR_RTS_FAIL);
-	stats->fcs_bad += REG_READ(ah, AR_FCS_FAIL);
-	stats->rts_good += REG_READ(ah, AR_RTS_OK);
-	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
+	u32 addr[5] = {AR_RTS_OK, AR_RTS_FAIL, AR_ACK_FAIL,
+		       AR_FCS_FAIL, AR_BEACON_CNT};
+	u32 data[5];
+
+	REG_READ_MULTI(ah, &addr[0], &data[0], 5);
+	/* AR_RTS_OK */
+	stats->rts_good += data[0];
+	/* AR_RTS_FAIL */
+	stats->rts_bad += data[1];
+	/* AR_ACK_FAIL */
+	stats->ackrcv_bad += data[2];
+	/* AR_FCS_FAIL */
+	stats->fcs_bad += data[3];
+	/* AR_BEACON_CNT */
+	stats->beacons += data[4];
 }
 
 static void ath9k_ani_restart(struct ath_hw *ah)
-- 
1.9.1


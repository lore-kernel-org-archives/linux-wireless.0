Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52818 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaKFHyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:40 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 14/21] ath9k: For AR9271 chipsets, set count = 0 for endless samples.
Date: Thu,  6 Nov 2014 08:53:31 +0100
Message-Id: <1415260418-14321-15-git-send-email-linux@rempel-privat.de> (sfid-20141106_085446_898399_5B34029F)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

not sure why.
Initially provided by Ashish Patro <patro@cs.wisc.edu>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 9a2afa2..fc08162 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -643,9 +643,12 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	 * and fix otherwise.
 	 */
 	count = param->count;
-	if (param->endless)
-		count = 0x80;
-	else if (count & 0x80)
+	if (param->endless) {
+		if (AR_SREV_9271(ah))
+			count = 0;
+		else
+			count = 0x80;
+	} else if (count & 0x80)
 		count = 0x7f;
 
 	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Madhan Jaganathan <madhan.jaganathan@atheros.com>
Subject: [PATCH 4/5] ath9k_hw: dynamically choose the SERDES array for low power
Date: Mon, 21 Jun 2010 18:38:50 -0400
Message-Id: <1277159931-7797-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
References: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The array we use will vary depending on whether or not we are
to go to lower power or not. The default values (iniPcieSerdes)
are a copy or what go into the registers through the INI files.

Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Madhan Jaganathan <madhan.jaganathan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 99bde5f..0641689 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -305,11 +305,15 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	 */
 	if (ah->config.pcieSerDesWrite) {
 		unsigned int i;
+		struct ar5416IniArray *array;
 
-		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
+		array = power_off ? &ah->iniPcieSerdes :
+				    &ah->iniPcieSerdesLowPower;
+
+		for (i = 0; i < array->ia_rows; i++) {
 			REG_WRITE(ah,
-				  INI_RA(&ah->iniPcieSerdesLowPower, i, 0),
-				  INI_RA(&ah->iniPcieSerdesLowPower, i, 1));
+				  INI_RA(array, i, 0),
+				  INI_RA(array, i, 1));
 		}
 	}
 }
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/14] ath9k: rename initvals.h to ar9002_initvals.h
Date: Wed, 10 Mar 2010 20:28:20 -0500
Message-Id: <1268270911-24568-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register initialization values we have so far are
only for the AR5008, AR9002 and AR9002 hardware families
and we've managed to get ar90002_hw.c to be its only user
so clarify this by renaming the initvals.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    6 +++---
 .../ath/ath9k/{initvals.h => ar9002_initvals.h}    |    0
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9002_initvals.h} (100%)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index e984a12..bf2a87c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -17,7 +17,7 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include "rc.h"
-#include "initvals.h"
+#include "ar9002_initvals.h"
 
 static void ar9002_hw_disablepcie(struct ath_hw *ah)
 {
@@ -610,8 +610,8 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			/*
 			 * AR9280 2.0 or later chips use SerDes values from the
-			 * initvals.h initialized depending on chipset during
-			 * __ath9k_hw_init()
+			 * ar9002_initvals.h initialized depending on chipset
+			 * during __ath9k_hw_init()
 			 */
 			for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
 				REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/initvals.h
rename to drivers/net/wireless/ath/ath9k/ar9002_initvals.h
-- 
1.6.3.3


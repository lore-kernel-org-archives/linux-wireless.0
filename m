Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23612 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0DAEn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 00:43:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 21:43:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19380.10543.783704.395748@gargle.gargle.HOWL>
Date: Thu, 1 Apr 2010 10:33:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_hw: Don't check devid for ath9k_htc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For USB devices, this check is invalid.
Remove the check so that new product IDs can be added.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   13 +++++++------
 drivers/net/wireless/ath/ath9k/hw.h |    2 --
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 77db932..8745a9a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -547,7 +547,6 @@ static bool ath9k_hw_devid_supported(u16 devid)
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
-	case AR9271_USB:
 	case AR2427_DEVID_PCIE:
 		return true;
 	default:
@@ -855,11 +854,13 @@ int ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unsupported device ID: 0x%0x\n",
-			  ah->hw_version.devid);
-		return -EOPNOTSUPP;
+	if (common->bus_ops->ath_bus_type != ATH_USB) {
+		if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
+			ath_print(common, ATH_DBG_FATAL,
+				  "Unsupported device ID: 0x%0x\n",
+				  ah->hw_version.devid);
+			return -EOPNOTSUPP;
+		}
 	}
 
 	ath9k_hw_init_defaults(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6b03e16..94d119c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -44,8 +44,6 @@
 
 #define AR5416_AR9100_DEVID	0x000b
 
-#define AR9271_USB             0x9271
-
 #define	AR_SUBVENDOR_ID_NOG	0x0e11
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 #define AR5416_MAGIC		0x19641014
-- 
1.7.0.3


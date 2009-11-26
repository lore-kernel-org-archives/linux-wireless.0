Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZKZCAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 21:00:25 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: remove unused ath9k_hw_devname() and ath9k_hw_probe()
Date: Wed, 25 Nov 2009 21:00:30 -0500
Message-Id: <1259200830-8612-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   30 ------------------------------
 1 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 493160c..22992b6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -343,30 +343,6 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 	return true;
 }
 
-static const char *ath9k_hw_devname(u16 devid)
-{
-	switch (devid) {
-	case AR5416_DEVID_PCI:
-		return "Atheros 5416";
-	case AR5416_DEVID_PCIE:
-		return "Atheros 5418";
-	case AR9160_DEVID_PCI:
-		return "Atheros 9160";
-	case AR5416_AR9100_DEVID:
-		return "Atheros 9100";
-	case AR9280_DEVID_PCI:
-	case AR9280_DEVID_PCIE:
-		return "Atheros 9280";
-	case AR9285_DEVID_PCIE:
-		return "Atheros 9285";
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
-		return "Atheros 9287";
-	}
-
-	return NULL;
-}
-
 static void ath9k_hw_init_config(struct ath_hw *ah)
 {
 	int i;
@@ -1263,12 +1239,6 @@ static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 }
 
-const char *ath9k_hw_probe(u16 vendorid, u16 devid)
-{
-	return vendorid == ATHEROS_VENDOR_ID ?
-		ath9k_hw_devname(devid) : NULL;
-}
-
 void ath9k_hw_detach(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-- 
1.6.5.2.155.gbb47


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33930 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcFWO5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id 187so11673655wmz.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:42 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/6] ath9k: remove return value from ath9k_hw_init_macaddr
Date: Thu, 23 Jun 2016 16:57:12 +0200
Message-Id: <20160623145714.20576-5-martin.blumenstingl@googlemail.com> (sfid-20160623_165751_092429_531818BC)
In-Reply-To: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_init_macaddr unconditionally returns 0 in all cases, making the
return value unnecessary.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4dd3aca..fa59117 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -471,7 +471,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 }
 
-static int ath9k_hw_init_macaddr(struct ath_hw *ah)
+static void ath9k_hw_init_macaddr(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
@@ -480,7 +480,7 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 
 	/* MAC address may already be loaded via ath9k_platform_data */
 	if (is_valid_ether_addr(common->macaddr))
-		return 0;
+		return;
 
 	for (i = 0; i < 3; i++) {
 		eeval = ah->eep_ops->get_eeprom(ah, EEP_MAC[i]);
@@ -489,7 +489,7 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	}
 
 	if (is_valid_ether_addr(common->macaddr))
-		return 0;
+		return;
 
 	ath_err(common, "eeprom contains invalid mac address: %pM\n",
 		common->macaddr);
@@ -498,7 +498,7 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	ath_err(common, "random mac address will be used: %pM\n",
 		common->macaddr);
 
-	return 0;
+	return;
 }
 
 static int ath9k_hw_post_init(struct ath_hw *ah)
@@ -637,12 +637,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
-	r = ath9k_hw_init_macaddr(ah);
-	if (r) {
-		ath_err(common, "Failed to initialize MAC address\n");
-		return r;
-	}
-
+	ath9k_hw_init_macaddr(ah);
 	ath9k_hw_init_hang_checks(ah);
 
 	common->state = ATH_HW_INITIALIZED;
-- 
2.9.0


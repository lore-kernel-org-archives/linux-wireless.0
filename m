Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33598 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcFWO5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id r201so11649419wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:41 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/6] ath9k: ath9k_hw_init_macaddr should not overwrite valid MAC addresses
Date: Thu, 23 Jun 2016 16:57:11 +0200
Message-Id: <20160623145714.20576-4-martin.blumenstingl@googlemail.com> (sfid-20160623_165745_355676_556375BC)
In-Reply-To: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently setting the MAC address via ath9k_platform_data works only due
to the order in which init.c sets common->macaddr, which is done after
ath9k_hw_init_macaddr was executed. It would be better if the latter
was independent of the order in which it's being called.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4f98ca0..4dd3aca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -478,21 +478,25 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	u16 eeval;
 	static const u32 EEP_MAC[] = { EEP_MAC_LSW, EEP_MAC_MID, EEP_MAC_MSW };
 
+	/* MAC address may already be loaded via ath9k_platform_data */
+	if (is_valid_ether_addr(common->macaddr))
+		return 0;
+
 	for (i = 0; i < 3; i++) {
 		eeval = ah->eep_ops->get_eeprom(ah, EEP_MAC[i]);
 		common->macaddr[2 * i] = eeval >> 8;
 		common->macaddr[2 * i + 1] = eeval & 0xff;
 	}
-	if (!is_valid_ether_addr(common->macaddr)) {
-		ath_err(common,
-			"eeprom contains invalid mac address: %pM\n",
-			common->macaddr);
 
-		random_ether_addr(common->macaddr);
-		ath_err(common,
-			"random mac address will be used: %pM\n",
-			common->macaddr);
-	}
+	if (is_valid_ether_addr(common->macaddr))
+		return 0;
+
+	ath_err(common, "eeprom contains invalid mac address: %pM\n",
+		common->macaddr);
+
+	random_ether_addr(common->macaddr);
+	ath_err(common, "random mac address will be used: %pM\n",
+		common->macaddr);
 
 	return 0;
 }
-- 
2.9.0


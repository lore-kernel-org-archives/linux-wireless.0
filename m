Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34808 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZHCTZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:19 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 17/24] ath9k: use helper macro to kfree and nullify on ath9k_hw_rfdetach()
Date: Mon, 3 Aug 2009 12:24:49 -0700
Message-ID: <1249327496-24629-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/phy.c |   41 ++++++++++++---------------------
 1 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 06fd057..98b1b56 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -266,32 +266,21 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 void
 ath9k_hw_rfdetach(struct ath_hw *ah)
 {
-	kfree(ah->analogBank0Data);
-	ah->analogBank0Data = NULL;
-
-	kfree(ah->analogBank1Data);
-	ah->analogBank1Data = NULL;
-
-	kfree(ah->analogBank2Data);
-	ah->analogBank2Data = NULL;
-
-	kfree(ah->analogBank3Data);
-	ah->analogBank3Data = NULL;
-
-	kfree(ah->analogBank6Data);
-	ah->analogBank6Data = NULL;
-
-	kfree(ah->analogBank6TPCData);
-	ah->analogBank6TPCData = NULL;
-
-	kfree(ah->analogBank7Data);
-	ah->analogBank7Data = NULL;
-
-	kfree(ah->addac5416_21);
-	ah->addac5416_21 = NULL;
-
-	kfree(ah->bank6Temp);
-	ah->bank6Temp = NULL;
+#define ATH_FREE_BANK(bank) do { \
+		kfree(bank); \
+		bank = NULL; \
+	} while (0);
+
+	ATH_FREE_BANK(ah->analogBank0Data);
+	ATH_FREE_BANK(ah->analogBank1Data);
+	ATH_FREE_BANK(ah->analogBank2Data);
+	ATH_FREE_BANK(ah->analogBank3Data);
+	ATH_FREE_BANK(ah->analogBank6Data);
+	ATH_FREE_BANK(ah->analogBank6TPCData);
+	ATH_FREE_BANK(ah->analogBank7Data);
+	ATH_FREE_BANK(ah->addac5416_21);
+	ATH_FREE_BANK(ah->bank6Temp);
+#undef ATH_FREE_BANK
 }
 
 bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
-- 
1.6.3.3


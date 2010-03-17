Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 17/20] ath9k_hw: provide a helper for managing the MIB control register
Date: Wed, 17 Mar 2010 18:28:10 -0400
Message-Id: <1268864893-11428-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will help with the hardware family abstraction.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   49 +++++++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index efe0bb9..024f8f6 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -833,6 +833,48 @@ static void ath9k_hw_clear_mib_counters(struct ath_hw *ah,
 		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
 }
 
+/**
+ * ath9k_hw_mibc_cmd - commands for the MIB control register (MIBC)
+ *
+ * @ATH9K_HW_MIBC_INIT: initializes the register
+ * @ATH9K_HW_MIBC_WARN_TEST: Warning test indicator
+ * @ATH9K_HW_MIBC_FREEZE: freeze all counters, useful prior to collecting
+ *	the MIB counters.
+ * @ATH9K_HW_MIBC_CLEAR: clear all counters, can be used after collecting
+ *	the MIB counters.
+ * @ATH9K_HW_MIBC_STROBE: MIB counter strobe, can increment every
+ *	counter by 1.
+ */
+enum ath9k_hw_mibc_cmd {
+	ATH9K_HW_MIBC_INIT = 0,
+	ATH9K_HW_MIBC_WARN_TEST,
+	ATH9K_HW_MIBC_FREEZE,
+	ATH9K_HW_MIBC_CLEAR,
+	ATH9K_HW_MIBC_STROBE,
+};
+
+static void ath9k_hw_send_mibc_cmd(struct ath_hw *ah,
+				   enum ath9k_hw_mibc_cmd cmd)
+{
+	switch (cmd) {
+	case ATH9K_HW_MIBC_INIT:
+		REG_WRITE(ah, AR_MIBC, 0);
+		break;
+	case ATH9K_HW_MIBC_WARN_TEST: /* unused */
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_COW);
+		break;
+	case ATH9K_HW_MIBC_FREEZE:
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
+		break;
+	case ATH9K_HW_MIBC_CLEAR:
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
+		break;
+	case ATH9K_HW_MIBC_STROBE: /* unused */
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_MCS);
+		break;
+	}
+}
+
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -841,8 +883,7 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	ath9k_hw_clear_mib_counters(ah, false);
-
-	REG_WRITE(ah, AR_MIBC, 0);
+	ath9k_hw_send_mibc_cmd(ah, ATH9K_HW_MIBC_INIT);
 	ath9k_hw_update_phy_err_masks(ah);
 }
 
@@ -853,9 +894,9 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 
 	ath_print(common, ATH_DBG_ANI, "Disable MIB counters\n");
 
-	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
+	ath9k_hw_send_mibc_cmd(ah, ATH9K_HW_MIBC_FREEZE);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-	REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
+	ath9k_hw_send_mibc_cmd(ah, ATH9K_HW_MIBC_CLEAR);
 
 	ath9k_hw_clear_mib_counters(ah, false);
 }
-- 
1.6.3.3


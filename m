Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/15] ath9k: split ath9k_hw_btcoex_enable() into two helpers
Date: Wed,  9 Sep 2009 19:44:52 -0400
Message-Id: <1252539901-20679-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One for 2-wire and another for 3-wire.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   57 ++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 6209a56..61a8e1d 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -117,30 +117,47 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
 }
 
+static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+
+	/* Configure the desired GPIO port for TX_FRAME output */
+	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+}
+
+static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+
+	/*
+	 * Program coex mode and weight registers to
+	 * enable coex 3-wire
+	 */
+	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_info->bt_coex_mode);
+	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_info->bt_coex_weights);
+	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_info->bt_coex_mode2);
+
+	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
+
+	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
+			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
+}
+
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
-	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
-		/* Configure the desired GPIO port for TX_FRAME output */
-		ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
-				AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
-	} else {
-		/*
-		 * Program coex mode and weight registers to
-		 * enable coex 3-wire
-		 */
-		REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_info->bt_coex_mode);
-		REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_info->bt_coex_weights);
-		REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_info->bt_coex_mode2);
-
-		REG_RMW_FIELD(ah, AR_QUIET1,
-				AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
-		REG_RMW_FIELD(ah, AR_PCU_MISC,
-				AR_PCU_BT_ANT_PREVENT_RX, 0);
-
-		ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
-				AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
+	switch (btcoex_info->btcoex_scheme) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_2WIRE:
+		ath9k_hw_btcoex_enable_2wire(ah);
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		ath9k_hw_btcoex_enable_3wire(ah);
+		break;
 	}
 
 	REG_RMW(ah, AR_GPIO_PDPU,
-- 
1.6.3.3


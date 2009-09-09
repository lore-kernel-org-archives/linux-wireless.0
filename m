Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/15] ath9k: move ath_btcoex_config and ath_bt_mode to btcoex.c
Date: Wed,  9 Sep 2009 19:45:00 -0400
Message-Id: <1252539901-20679-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are only used by btcoex.c on one routine, so stuff them
into that file.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/btcoex.h |   20 --------------------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 4cca023..ee2a834 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -16,8 +16,24 @@
 
 #include "ath9k.h"
 
-static const struct ath_btcoex_config ath_bt_config = { 0, true, true,
-			ATH_BT_COEX_MODE_SLOTTED, true, true, 2, 5, true };
+enum ath_bt_mode {
+	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
+	ATH_BT_COEX_MODE_UNSLOTTED,     /* untimed/unslotted mode */
+	ATH_BT_COEX_MODE_SLOTTED,       /* slotted mode */
+	ATH_BT_COEX_MODE_DISALBED,      /* coexistence disabled */
+};
+
+struct ath_btcoex_config {
+	u8 bt_time_extend;
+	bool bt_txstate_extend;
+	bool bt_txframe_extend;
+	enum ath_bt_mode bt_mode; /* coexistence mode */
+	bool bt_quiet_collision;
+	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
+	u8 bt_priority_time;
+	u8 bt_first_slot_time;
+	bool bt_hold_rx_clear;
+};
 
 static const u16 ath_subsysid_tbl[] = {
 	AR9280_COEX2WIRE_SUBSYSID,
@@ -46,6 +62,17 @@ bool ath_btcoex_supported(u16 subsysid)
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	const struct ath_btcoex_config ath_bt_config = {
+		.bt_time_extend = 0,
+		.bt_txstate_extend = true,
+		.bt_txframe_extend = true,
+		.bt_mode = ATH_BT_COEX_MODE_SLOTTED,
+		.bt_quiet_collision = true,
+		.bt_rxclear_polarity = true,
+		.bt_priority_time = 2,
+		.bt_first_slot_time = 5,
+		.bt_hold_rx_clear = true,
+	};
 	u32 i;
 
 	btcoex_hw->bt_coex_mode =
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 971d200..0dc5120 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -36,25 +36,6 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_3WIRE,
 };
 
-enum ath_bt_mode {
-	ATH_BT_COEX_MODE_LEGACY,	/* legacy rx_clear mode */
-	ATH_BT_COEX_MODE_UNSLOTTED,	/* untimed/unslotted mode */
-	ATH_BT_COEX_MODE_SLOTTED,	/* slotted mode */
-	ATH_BT_COEX_MODE_DISALBED,	/* coexistence disabled */
-};
-
-struct ath_btcoex_config {
-	u8 bt_time_extend;
-	bool bt_txstate_extend;
-	bool bt_txframe_extend;
-	enum ath_bt_mode bt_mode; /* coexistence mode */
-	bool bt_quiet_collision;
-	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
-	u8 bt_priority_time;
-	u8 bt_first_slot_time;
-	bool bt_hold_rx_clear;
-};
-
 struct ath_btcoex_hw {
 	enum ath_btcoex_scheme scheme;
 	bool enabled;
@@ -76,5 +57,4 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
-
 #endif
-- 
1.6.3.3


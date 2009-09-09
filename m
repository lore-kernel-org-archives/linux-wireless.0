Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/15] ath9k: rename ath_btcoex_supported() to ath9k_hw_btcoex_supported()
Date: Wed,  9 Sep 2009 19:45:01 -0400
Message-Id: <1252539901-20679-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also just pass the ath_hw as the parameter.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |    6 +++---
 drivers/net/wireless/ath/ath9k/btcoex.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index ee2a834..5d1095f 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -45,15 +45,15 @@ static const u16 ath_subsysid_tbl[] = {
  * Checks the subsystem id of the device to see if it
  * supports btcoex
  */
-bool ath_btcoex_supported(u16 subsysid)
+bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
 {
 	int i;
 
-	if (!subsysid)
+	if (!ah->hw_version.subsysid)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(ath_subsysid_tbl); i++)
-		if (subsysid == ath_subsysid_tbl[i])
+		if (ah->hw_version.subsysid == ath_subsysid_tbl[i])
 			return true;
 
 	return false;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 0dc5120..1ba31a7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -47,7 +47,7 @@ struct ath_btcoex_hw {
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
 };
 
-bool ath_btcoex_supported(u16 subsysid);
+bool ath9k_hw_btcoex_supported(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0fc4c6e..24157d2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3688,7 +3688,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
 	if (AR_SREV_9280_10_OR_LATER(ah) &&
-	    ath_btcoex_supported(ah->hw_version.subsysid)) {
+	    ath9k_hw_btcoex_supported(ah)) {
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
-- 
1.6.3.3


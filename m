Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbLUUwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 44/45] iwlwifi: fix printf specifier
Date: Mon, 21 Dec 2015 22:50:45 +0200
Message-Id: <1450731046-2796-44-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220101_342188_BD288836)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch warned about a bad specifier being used. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index b395854..c15f5be 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -454,11 +454,11 @@ static void iwl_eeprom_enhanced_txpower(struct device *dev,
 				 TXP_CHECK_AND_PRINT(COMMON_TYPE),
 				 txp->flags);
 		IWL_DEBUG_EEPROM(dev,
-				 "\t\t chain_A: 0x%02x chain_B: 0X%02x chain_C: 0X%02x\n",
+				 "\t\t chain_A: %d chain_B: %d chain_C: %d\n",
 				 txp->chain_a_max, txp->chain_b_max,
 				 txp->chain_c_max);
 		IWL_DEBUG_EEPROM(dev,
-				 "\t\t MIMO2: 0x%02x MIMO3: 0x%02x High 20_on_40: 0x%02x Low 20_on_40: 0x%02x\n",
+				 "\t\t MIMO2: %d MIMO3: %d High 20_on_40: 0x%02x Low 20_on_40: 0x%02x\n",
 				 txp->mimo2_max, txp->mimo3_max,
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
-- 
2.5.0


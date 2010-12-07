Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0LGRoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:44:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/3] iwlagn: rename enhanced txpower fields
Date: Tue,  7 Dec 2010 09:37:06 -0800
Message-Id: <1291743428-19642-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some fields we didn't previously use from the
enhanced TX power structure will be needed in
the next patch, so rename them to their correct
names to be able to use them and change code
reading them accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index a650bab..9651060 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -419,7 +419,8 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 		 * always check for valid entry before process
 		 * the information
 		 */
-		if (!enhanced_txpower->common || enhanced_txpower->reserved)
+		if (!(enhanced_txpower->flags || enhanced_txpower->channel) ||
+		    enhanced_txpower->delta_20_in_40)
 			continue;
 
 		for (element = 0; element < eeprom_section_count; element++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index d9b5906..310e345 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -127,21 +127,23 @@ struct iwl_eeprom_channel {
  *    Enhanced regulatory tx power portion of eeprom image can be broken down
  *    into individual structures; each one is 8 bytes in size and contain the
  *    following information
- * @common: (desc + channel) not used by driver, should _NOT_ be "zero"
+ * @flags: entry flags
+ * @channel: channel number
  * @chain_a_max_pwr: chain a max power in 1/2 dBm
  * @chain_b_max_pwr: chain b max power in 1/2 dBm
  * @chain_c_max_pwr: chain c max power in 1/2 dBm
- * @reserved: not used, should be "zero"
+ * @delta_20_in_40: 20-in-40 deltas (hi/lo)
  * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
  * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
  *
  */
 struct iwl_eeprom_enhanced_txpwr {
-	__le16 common;
+	u8 flags;
+	u8 channel;
 	s8 chain_a_max;
 	s8 chain_b_max;
 	s8 chain_c_max;
-	s8 reserved;
+	u8 delta_20_in_40;
 	s8 mimo2_max;
 	s8 mimo3_max;
 } __packed;
-- 
1.7.0.4


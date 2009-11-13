Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbZKMT4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:35 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/16] iwlwifi: validate enhanced tx power entry
Date: Fri, 13 Nov 2009 11:56:23 -0800
Message-Id: <1258142198-3223-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Validate enhanced tx power entry read from EEPROM before applying the
tx power value. Different versions of EEPROM might contain different size
of table; always a good idea to make sure the entry is valid before
applying to the targeted channel.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 8a0709e..143728c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -913,6 +913,16 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 		enhanced_txpower = (struct iwl_eeprom_enhanced_txpwr *)
 				iwl_eeprom_query_addr(priv, offset);
 
+		/*
+		 * check for valid entry -
+		 * different version of EEPROM might contain different set
+		 * of enhanced tx power table
+		 * always check for valid entry before process
+		 * the information
+		 */
+		if (!enhanced_txpower->common || enhanced_txpower->reserved)
+			continue;
+
 		for (element = 0; element < eeprom_section_count; element++) {
 			if (enhinfo[section].is_common)
 				max_txpower_avg =
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 5ba5a4e..5cd2b66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -127,19 +127,21 @@ struct iwl_eeprom_channel {
  *    Enhanced regulatory tx power portion of eeprom image can be broken down
  *    into individual structures; each one is 8 bytes in size and contain the
  *    following information
+ * @common: (desc + channel) not used by driver, should _NOT_ be "zero"
  * @chain_a_max_pwr: chain a max power in 1/2 dBm
  * @chain_b_max_pwr: chain b max power in 1/2 dBm
  * @chain_c_max_pwr: chain c max power in 1/2 dBm
+ * @reserved: not used, should be "zero"
  * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
  * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
  *
  */
 struct iwl_eeprom_enhanced_txpwr {
-	u16 reserved;
+	u16 common;
 	s8 chain_a_max;
 	s8 chain_b_max;
 	s8 chain_c_max;
-	s8 reserved1;
+	s8 reserved;
 	s8 mimo2_max;
 	s8 mimo3_max;
 } __attribute__ ((packed));
-- 
1.5.6.3


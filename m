Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0LGRoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:44:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/3] iwlwifi: minor txp entries fix
Date: Tue,  7 Dec 2010 09:37:08 -0800
Message-Id: <1291743428-19642-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

use le16_to_cpup instead of cpu_to_le16p

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index e777740..cb7d429 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -272,15 +272,17 @@ iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
-	int idx, entries;
+	int idx;
+	u16 entries;
 	__le16 *txp_len;
 	s8 max_txp_avg, max_txp_avg_halfdbm;
 
 	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
 
 	/* the length is in 16-bit words, but we want entries */
-	txp_len = (__le16 *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
-	entries = cpu_to_le16p(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
+	txp_len = (__le16 *)
+		iwlagn_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
 
 	txp_array = (void *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
 	for (idx = 0; idx < entries; idx++) {
-- 
1.7.0.4


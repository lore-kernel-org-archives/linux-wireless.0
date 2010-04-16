Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0DPVuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:50:23 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: correct 6000 EEPROM regulatory address
Date: Fri, 16 Apr 2010 14:50:14 -0700
Message-Id: <1271454614-14272-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454614-14272-1-git-send-email-reinette.chatre@intel.com>
References: <1271454614-14272-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

For 6000 series, the 2.4G HT40 band regulatory settings address in EEPROM
was off by 2.

Before the fix, you'll see this in dmesg:
[79535.788877] ieee80211 phy8: U iwl_mod_ht40_chan_info HT40 Ch. 7 [2.4GHz]
WIDE (0x61 0dBm): Ad-Hoc not supported
[79535.788880] ieee80211 phy8: U iwl_mod_ht40_chan_info HT40 Ch. 11 [2.4GHz]
WIDE (0x61 0dBm): Ad-Hoc not supported

And after the fix:
[91132.688706] ieee80211 phy14: U iwl_mod_ht40_chan_info HT40 Ch. 7 [2.4GHz]
IBSS ACTIVE WIDE (0x6f 0dBm): Ad-Hoc supported
[91132.688709] ieee80211 phy14: U iwl_mod_ht40_chan_info HT40 Ch. 11 [2.4GHz]
IBSS ACTIVE WIDE (0x6f 0dBm): Ad-Hoc supported

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c4844ad..92b3e64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -259,7 +259,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
@@ -323,7 +323,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 4e1ba82..8171c70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -203,6 +203,10 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5000_REG_BAND_52_HT40_CHANNELS  ((0x92)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
 
+/* 6000 regulatory - indirect access */
+#define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
+
 /* 6000 and up regulatory tx power - indirect access */
 /* max. elements per section */
 #define EEPROM_MAX_TXPOWER_SECTION_ELEMENTS	(8)
-- 
1.6.3.3


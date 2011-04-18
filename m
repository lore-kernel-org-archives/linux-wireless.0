Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab1DRRFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlagn: no 5.2GHz/HT40 support for bgn devices
Date: Mon, 18 Apr 2011 09:44:14 -0700
Message-Id: <1303145057-6545-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For bgn devices, there were no HT40 channels value in EEPROM

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 946c7dc..a018718 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -195,7 +195,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_REG_BAND_4_CHANNELS,
 			EEPROM_REG_BAND_5_CHANNELS,
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index c8bb4a4..0bd9b14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -278,7 +278,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 			EEPROM_REG_BAND_4_CHANNELS,
 			EEPROM_REG_BAND_5_CHANNELS,
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
+			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-- 
1.7.0.4


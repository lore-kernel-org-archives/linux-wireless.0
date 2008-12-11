Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbYLKScn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: remove unused clip_groups priv member
Date: Thu, 11 Dec 2008 10:33:38 -0800
Message-Id: <1229020421-4823-4-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193251_604909_B4AFAA9D)
In-Reply-To: <1229020421-4823-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Remove clip_groups from priv and related structure.
This code is for 3945 only and was renamed to 4965 in
when code was split.
Also remove unused RATE definitions

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    6 ------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   10 ----------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 9873613..6649f7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -84,12 +84,6 @@
 #define IWL_CMD_FIFO_NUM        4
 #define IWL49_FIRST_AMPDU_QUEUE	7
 
-/* Tx rates */
-#define IWL_CCK_RATES 4
-#define IWL_OFDM_RATES 8
-#define IWL_HT_RATES 16
-#define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
-
 /* Time constants */
 #define SHORT_SLOT_TIME 9
 #define LONG_SLOT_TIME 20
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fc859f7..a520e47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -186,12 +186,6 @@ struct iwl_channel_info {
 	u8 fat_extension_channel; /* HT_IE_EXT_CHANNEL_* */
 };
 
-struct iwl4965_clip_group {
-	/* maximum power level to prevent clipping for each rate, derived by
-	 *   us from this band's saturation power in EEPROM */
-	const s8 clip_powers[IWL_MAX_RATES];
-};
-
 
 #define IWL_TX_FIFO_AC0	0
 #define IWL_TX_FIFO_AC1	1
@@ -793,10 +787,6 @@ struct iwl_priv {
 	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
-	/* each calibration channel group in the EEPROM has a derived
-	 * clip setting for each rate. */
-	const struct iwl4965_clip_group clip_groups[5];
-
 	/* thermal calibration */
 	s32 temperature;	/* degrees Kelvin */
 	s32 last_temperature;
-- 
1.5.4.3


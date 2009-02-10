Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZBJXPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:15:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: fix FAT channel config for 5000 series
Date: Tue, 10 Feb 2009 15:19:04 -0800
Message-Id: <1234307944-21820-4-git-send-email-reinette.chatre@intel.com> (sfid-20090211_001539_362506_DE433052)
In-Reply-To: <1234307944-21820-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
 <1234307944-21820-2-git-send-email-reinette.chatre@intel.com>
 <1234307944-21820-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The test to find out if we have FAT channels do not consider that
the value of regulatory_bands for the 5000 series is larger than its
eeprom size. Using the eeprom size is strange in itself.

Use a new EEPROM_REGULATORY_BAND_NO_FAT to indicate no FAT support
and test for that explicitly.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 ++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d2df494..d49e48b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2738,8 +2738,8 @@ static struct iwl_lib_ops iwl3945_lib = {
 			EEPROM_REGULATORY_BAND_3_CHANNELS,
 			EEPROM_REGULATORY_BAND_4_CHANNELS,
 			EEPROM_REGULATORY_BAND_5_CHANNELS,
-			IWL3945_EEPROM_IMG_SIZE,
-			IWL3945_EEPROM_IMG_SIZE,
+			EEPROM_REGULATORY_BAND_NO_FAT,
+			EEPROM_REGULATORY_BAND_NO_FAT,
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwl3945_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index d1d1d9b..75517d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -532,10 +532,10 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	}
 
 	/* Check if we do have FAT channels */
-	if (priv->cfg->ops->lib->eeprom_ops.regulatory_bands[5] >=
-	    priv->cfg->eeprom_size &&
-	    priv->cfg->ops->lib->eeprom_ops.regulatory_bands[6] >=
-	    priv->cfg->eeprom_size)
+	if (priv->cfg->ops->lib->eeprom_ops.regulatory_bands[5] ==
+	    EEPROM_REGULATORY_BAND_NO_FAT &&
+	    priv->cfg->ops->lib->eeprom_ops.regulatory_bands[6] ==
+	    EEPROM_REGULATORY_BAND_NO_FAT)
 		return 0;
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 17fed49..3479153 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -370,6 +370,8 @@ struct iwl_eeprom_calib_info {
  */
 #define EEPROM_4965_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
 
+#define EEPROM_REGULATORY_BAND_NO_FAT			(0)
+
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
 	int (*verify_signature) (struct iwl_priv *priv);
-- 
1.5.4.3


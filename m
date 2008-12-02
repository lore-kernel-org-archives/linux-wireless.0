Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYLBAba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 19:31:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: 5150 compute ct kill threshold
Date: Mon,  1 Dec 2008 16:32:20 -0800
Message-Id: <1228177942-25137-4-git-send-email-reinette.chatre@intel.com> (sfid-20081202_013136_642151_87137366)
In-Reply-To: <1228177942-25137-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-2-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds computation of ct kill threshold
for 5150. Threshold is computed from calibration
data in the EEPROM.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   13 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 +
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c1e7a42..26e04ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -426,6 +426,17 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 	return &priv->eeprom[address];
 }
 
+static s32 iwl5150_get_ct_threshold(struct iwl_priv *priv)
+{
+	const s32 volt2temp_coef = -5;
+	u16 *temp_calib = (u16 *)iwl_eeprom_query_addr(priv,
+						EEPROM_5000_TEMPERATURE);
+	/* offset =  temperate -  voltage / coef */
+	s32 offset = temp_calib[0] - temp_calib[1] / volt2temp_coef;
+	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD) - offset;
+	return threshold * volt2temp_coef;
+}
+
 /*
  *  Calibration
  */
@@ -859,7 +870,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	case CSR_HW_REV_TYPE_5150:
 		/* 5150 wants in Kelvin */
 		priv->hw_params.ct_kill_threshold =
-				CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+				iwl5150_get_ct_threshold(priv);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 997f23c..8f6b05f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -147,6 +147,7 @@ struct iwl_eeprom_channel {
 /*5000 calibrations */
 #define EEPROM_5000_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
 #define EEPROM_5000_XTAL	((2*0x128) | EEPROM_5000_CALIB_ALL)
+#define EEPROM_5000_TEMPERATURE ((2*0x12A) | EEPROM_5000_CALIB_ALL)
 
 /* 5000 links */
 #define EEPROM_5000_LINK_HOST             (2*0x64)
-- 
1.5.4.3


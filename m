Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891AbZKXDaR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/8] iwmc3200wifi: Update wireless_mode with eeprom values
Date: Tue, 24 Nov 2009 11:33:29 +0800
Message-Id: <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The iwmc3200wifi eeprom contains information about the available PHYs on
the chip. We should update our wireless_mode setting and profile according
to it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/eeprom.c |   20 ++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/eeprom.h |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c   |   19 ++++++++++++++++++-
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.c b/drivers/net/wireless/iwmc3200wifi/eeprom.c
index c574f58..8091421 100644
--- a/drivers/net/wireless/iwmc3200wifi/eeprom.c
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.c
@@ -176,6 +176,26 @@ int iwm_eeprom_fat_channels(struct iwm_priv *iwm)
 	return 0;
 }
 
+u32 iwm_eeprom_wireless_mode(struct iwm_priv *iwm)
+{
+	u16 sku_cap;
+	u32 wireless_mode = 0;
+
+	sku_cap = *((u16 *)iwm_eeprom_access(iwm, IWM_EEPROM_SKU_CAP));
+
+	if (sku_cap & IWM_EEPROM_SKU_CAP_BAND_24GHZ)
+		wireless_mode |= WIRELESS_MODE_11G;
+
+	if (sku_cap & IWM_EEPROM_SKU_CAP_BAND_52GHZ)
+		wireless_mode |= WIRELESS_MODE_11A;
+
+	if (sku_cap & IWM_EEPROM_SKU_CAP_11N_ENABLE)
+		wireless_mode |= WIRELESS_MODE_11N;
+
+	return wireless_mode;
+}
+
+
 int iwm_eeprom_init(struct iwm_priv *iwm)
 {
 	int i, ret = 0;
diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.h b/drivers/net/wireless/iwmc3200wifi/eeprom.h
index 0f7f226..4e3a3fd 100644
--- a/drivers/net/wireless/iwmc3200wifi/eeprom.h
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.h
@@ -122,5 +122,6 @@ int iwm_eeprom_init(struct iwm_priv *iwm);
 void iwm_eeprom_exit(struct iwm_priv *iwm);
 u8 *iwm_eeprom_access(struct iwm_priv *iwm, u8 eeprom_id);
 int iwm_eeprom_fat_channels(struct iwm_priv *iwm);
+u32 iwm_eeprom_wireless_mode(struct iwm_priv *iwm);
 
 #endif
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 365f3fc..e61265a 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -80,7 +80,8 @@ static struct iwm_conf def_iwm_conf = {
 
 	.assoc_timeout		= 2,
 	.roam_timeout		= 10,
-	.wireless_mode		= WIRELESS_MODE_11A | WIRELESS_MODE_11G,
+	.wireless_mode		= WIRELESS_MODE_11A | WIRELESS_MODE_11G |
+				  WIRELESS_MODE_11N,
 	.coexist_mode		= COEX_MODE_CM,
 
 	/* IBSS */
@@ -630,6 +631,7 @@ static int __iwm_up(struct iwm_priv *iwm)
 	int ret;
 	struct iwm_notif *notif_reboot, *notif_ack = NULL;
 	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	u32 wireless_mode;
 
 	ret = iwm_bus_enable(iwm);
 	if (ret) {
@@ -697,6 +699,21 @@ static int __iwm_up(struct iwm_priv *iwm)
 		goto err_fw;
 	}
 
+	/*
+	 * Read our SKU capabilities.
+	 * If it's valid, we overwrite the wireless mode conf entry and the
+	 * current profile one.
+	 */
+	wireless_mode = iwm_eeprom_wireless_mode(iwm);
+	if (wireless_mode) {
+		iwm->conf.wireless_mode = wireless_mode;
+		if (iwm->umac_profile)
+			iwm->umac_profile->wireless_mode =
+					iwm->conf.wireless_mode;
+	} else
+		IWM_ERR(iwm, "Wrong SKU capabilities: 0x%x\n",
+			*((u16 *)iwm_eeprom_access(iwm, IWM_EEPROM_SKU_CAP)));
+
 	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "L%s_U%s",
 		 iwm->lmac_version, iwm->umac_version);
 
-- 
1.6.0.4


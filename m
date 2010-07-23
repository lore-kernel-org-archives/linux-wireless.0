Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151Ab0GWQN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] iwlwifi: read multiple MAC addresses
Date: Fri, 23 Jul 2010 09:15:37 -0700
Message-Id: <1279901739-10541-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Some devices may have multiple MAC
addresses in their EEPROM, read them
and advertise them to cfg80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   17 ++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    3 +++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 573a81b..f8f8ea2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3932,8 +3932,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
-	u16 pci_cmd;
-	u8 perm_addr[ETH_ALEN];
+	u16 pci_cmd, num_mac;
 
 	/************************
 	 * 1. Allocating HW data
@@ -4051,9 +4050,17 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	iwl_eeprom_get_mac(priv, perm_addr);
-	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", perm_addr);
-	SET_IEEE80211_PERM_ADDR(priv->hw, perm_addr);
+	iwl_eeprom_get_mac(priv, priv->addresses[0].addr);
+	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
+	priv->hw->wiphy->addresses = priv->addresses;
+	priv->hw->wiphy->n_addresses = 1;
+	num_mac = iwl_eeprom_query16(priv, EEPROM_NUM_MAC_ADDRESS);
+	if (num_mac > 1) {
+		memcpy(priv->addresses[1].addr, priv->addresses[0].addr,
+		       ETH_ALEN);
+		priv->addresses[1].addr[5]++;
+		priv->hw->wiphy->n_addresses++;
+	}
 
 	/************************
 	 * 5. Setup HW constants
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4fa8cdd..5e4745d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1154,6 +1154,9 @@ struct iwl_priv {
 	u32  hw_wa_rev;
 	u8   rev_id;
 
+	/* EEPROM MAC addresses */
+	struct mac_address addresses[2];
+
 	/* uCode images, save to reload in case of failure */
 	int fw_index;			/* firmware we're trying to load */
 	u32 ucode_ver;			/* version of ucode, copy of
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index f8b707d..3209b37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -402,6 +402,7 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 #define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
 #define EEPROM_3945_M_VERSION               (2*0x4A)	/* 1  bytes */
+#define EEPROM_NUM_MAC_ADDRESS              (2*0x4C)	/* 2  bytes */
 
 /* The following masks are to be applied on EEPROM_RADIO_CONFIG */
 #define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
-- 
1.7.0.4


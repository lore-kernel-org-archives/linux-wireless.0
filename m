Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab0FFG4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/23] iwlwifi: remove mac_addr assignment
Date: Sat,  5 Jun 2010 23:56:18 -0700
Message-Id: <1275807398-18184-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

priv->mac_addr is the address of the operating
interface, not the permanent MAC address. They
are usually the same, but the user can override
the operating address, so we shouldn't set the
variable to the permanent one, it is assigned
when an interface is added.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 87ed28b..7c63c06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3656,6 +3656,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
 	u16 pci_cmd;
+	u8 perm_addr[ETH_ALEN];
 
 	/************************
 	 * 1. Allocating HW data
@@ -3776,9 +3777,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	iwl_eeprom_get_mac(priv, priv->mac_addr);
-	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->mac_addr);
-	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
+	iwl_eeprom_get_mac(priv, perm_addr);
+	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", perm_addr);
+	SET_IEEE80211_PERM_ADDR(priv->hw, perm_addr);
 
 	/************************
 	 * 5. Setup HW constants
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 42f1d33..5976166 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4015,9 +4015,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	eeprom = (struct iwl3945_eeprom *)priv->eeprom;
-	memcpy(priv->mac_addr, eeprom->mac_address, ETH_ALEN);
-	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->mac_addr);
-	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
+	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", eeprom->mac_address);
+	SET_IEEE80211_PERM_ADDR(priv->hw, eeprom->mac_address);
 
 	/***********************
 	 * 5. Setup HW Constants
-- 
1.7.0.4


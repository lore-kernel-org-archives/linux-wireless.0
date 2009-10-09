Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827AbZJIUV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:21:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/17 v2.6.32 and w-t] iwlwifi: change the order of freeing memory
Date: Fri,  9 Oct 2009 13:20:17 -0700
Message-Id: <1255119634-3060-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Need to free the dynamic allocated memory before ieee80211_free_hw();
once call ieee80211_free_hw(), should not reference to "priv" data
structure.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 046b571..8d7bc38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3156,8 +3156,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  out_pci_disable_device:
 	pci_disable_device(pdev);
  out_ieee80211_free_hw:
-	ieee80211_free_hw(priv->hw);
 	iwl_free_traffic_mem(priv);
+	ieee80211_free_hw(priv->hw);
  out:
 	return err;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ecbe036..c347d66 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4099,8 +4099,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
  out_ieee80211_free_hw:
-	ieee80211_free_hw(priv->hw);
 	iwl_free_traffic_mem(priv);
+	ieee80211_free_hw(priv->hw);
  out:
 	return err;
 }
-- 
1.5.6.3


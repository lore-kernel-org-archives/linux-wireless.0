Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYICDXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:23:02 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 9/9] iwlwifi: fix STATUS_EXIT_PENDING is not set on pci_remove
Date: Wed,  3 Sep 2008 11:18:50 +0800
Message-Id: <1220411930-15216-10-git-send-email-yi.zhu@intel.com> (sfid-20080903_052310_966239_D82DD18A)
In-Reply-To: <1220411930-15216-9-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-6-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-7-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-8-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch sets STATUS_EXIT_PENDING on pci_remove. Otherwise
iwl4965_down may fail to uninitialize the driver.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4e3d6c7..e01f048 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4372,15 +4372,18 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	iwl_dbgfs_unregister(priv);
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
+	/* ieee80211_unregister_hw call wil cause iwl4965_mac_stop to
+	 * to be called and iwl4965_down since we are removing the device
+	 * we need to set STATUS_EXIT_PENDING bit.
+	 */
+	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
 		priv->mac80211_registered = 0;
+	} else {
+		iwl4965_down(priv);
 	}
 
-	set_bit(STATUS_EXIT_PENDING, &priv->status);
-
-	iwl4965_down(priv);
-
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
 	 */
-- 
1.5.3.6


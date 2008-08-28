Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYH1J3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/11] iwlwifi: call apm stop on exit
Date: Thu, 28 Aug 2008 17:25:07 +0800
Message-Id: <1219915510-3647-9-git-send-email-yi.zhu@intel.com> (sfid-20080828_112921_322506_CA8BA163)
In-Reply-To: <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
accordingly. Without this patch hardware consumes power even after driver
is removed or suspended.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4986137..b1cefb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2189,7 +2189,10 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	udelay(5);
 
 	/* FIXME: apm_ops.suspend(priv) */
-	priv->cfg->ops->lib->apm_ops.reset(priv);
+	if (exit_pending || test_bit(STATUS_IN_SUSPEND, &priv->status))
+		priv->cfg->ops->lib->apm_ops.stop(priv);
+	else
+		priv->cfg->ops->lib->apm_ops.reset(priv);
 	priv->cfg->ops->lib->free_shared_mem(priv);
 
  exit:
@@ -4371,15 +4374,18 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbYICDbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:19 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 18/39] iwlwifi: call apm stop on exit
Date: Wed,  3 Sep 2008 11:26:38 +0800
Message-Id: <1220412419-15404-19-git-send-email-yi.zhu@intel.com> (sfid-20080903_053128_559906_D9B36ECC)
In-Reply-To: <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
accordingly.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e903aeb..2330ed1 100644
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
@@ -4375,15 +4378,18 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3GZI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/30] iwlwifi: pcie: don't disable L1 for newest NICs
Date: Fri, 26 Jul 2013 10:28:21 +0200
Message-Id: <1374827327-3464-5-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102908_769424_3EF9C7FF)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In newest NICs (7000 family and up), L1 is supported, so
avoid to disable it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |  1 +
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c | 14 ++++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 22b7fa5..7f61674 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -99,6 +99,7 @@ static const struct iwl_base_params iwl7000_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = true,
+	.pcie_l1_allowed = true,
 };
 
 static const struct iwl_ht_params iwl7000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 83b9ff6..87fe955 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -152,6 +152,7 @@ struct iwl_base_params {
 	unsigned int wd_timeout;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
+	const bool pcie_l1_allowed;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index bc908d3..cec0c89 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1418,10 +1418,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->reg_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	/* W/A - seems to solve weird behavior. We need to remove this if we
-	 * don't want to stay in L1 all the time. This wastes a lot of power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-			       PCIE_LINK_STATE_CLKPM);
+	if (!cfg->base_params->pcie_l1_allowed) {
+		/*
+		 * W/A - seems to solve weird behavior. We need to remove this
+		 * if we don't want to stay in L1 all the time. This wastes a
+		 * lot of power.
+		 */
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+				       PCIE_LINK_STATE_L1 |
+				       PCIE_LINK_STATE_CLKPM);
+	}
 
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
-- 
1.8.0


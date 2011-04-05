Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab1DERBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/25] iwlagn: remove rev_id
Date: Tue,  5 Apr 2011 09:42:09 -0700
Message-Id: <1302021732-21250-23-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The rev_id variable is only printed, we
don't need to store it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5912ede..a2f9237 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3685,8 +3685,10 @@ struct ieee80211_ops iwlagn_hw_ops = {
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	priv->rev_id = priv->pci_dev->revision;
-	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
+	u8 rev_id;
+
+	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
+	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 	return _iwl_read32(priv, CSR_HW_REV);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 892bcfa..460316b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1253,7 +1253,6 @@ struct iwl_priv {
 
 	/* pci hardware address support */
 	void __iomem *hw_base;
-	u8   rev_id;
 
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1DERBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/25] iwlagn: remove hw_wa_rev
Date: Tue,  5 Apr 2011 09:42:07 -0700
Message-Id: <1302021732-21250-21-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The variable is never used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3a8dd64..da515b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3686,7 +3686,6 @@ struct ieee80211_ops iwlagn_hw_ops = {
 static void iwl_hw_detect(struct iwl_priv *priv)
 {
 	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
-	priv->hw_wa_rev = _iwl_read32(priv, CSR_HW_REV_WA_REG);
 	priv->rev_id = priv->pci_dev->revision;
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fe096fd..f004dae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1254,7 +1254,6 @@ struct iwl_priv {
 	/* pci hardware address support */
 	void __iomem *hw_base;
 	u32  hw_rev;
-	u32  hw_wa_rev;
 	u8   rev_id;
 
 	/* microcode/device supports multiple contexts */
-- 
1.7.0.4


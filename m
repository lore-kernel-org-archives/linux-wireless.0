Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab1FRQFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/25] iwlagn: don't read the PCI_REVISION_ID from iwl-agn.c
Date: Sat, 18 Jun 2011 08:34:19 -0700
Message-Id: <1308411271-26093-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180554_854905_AA844E9C)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The PCI_REVISION_ID is read and printed in iwl_pci_probe anyway using pr_info

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eeb31bc..1ff8e4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3352,10 +3352,6 @@ struct ieee80211_ops iwlagn_hw_ops = {
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	u8 rev_id;
-
-	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 	return iwl_read32(priv, CSR_HW_REV);
 }
 
-- 
1.7.0.4


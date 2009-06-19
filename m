Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbZFSUpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:45:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: Check HW ready before prepare card.
Date: Fri, 19 Jun 2009 13:52:41 -0700
Message-Id: <1245444765-29079-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
References: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Hardware may be ready for us to manage it without us trying to prepare
it first. Check if this is the case.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6d1519e..63cba8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1812,6 +1812,11 @@ static int iwl_prepare_card_hw(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter \n");
 
+	ret = iwl_set_hw_ready(priv);
+	if (priv->hw_ready)
+		return ret;
+
+	/* If HW is not ready, prepare the conditions to check again */
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			CSR_HW_IF_CONFIG_REG_PREPARE);
 
@@ -1819,6 +1824,7 @@ static int iwl_prepare_card_hw(struct iwl_priv *priv)
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
+	/* HW should be ready by now, check again. */
 	if (ret != -ETIMEDOUT)
 		iwl_set_hw_ready(priv);
 
-- 
1.5.6.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYHDID6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/10] iwlwifi: grap nic access before accessing periphery registers
Date: Mon,  4 Aug 2008 16:00:47 +0800
Message-Id: <1217836848-24288-10-git-send-email-yi.zhu@intel.com> (sfid-20080804_100406_257426_B99E9615)
In-Reply-To: <1217836848-24288-9-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-7-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-8-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

We need to grap nic access before accessing periphery registers.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c5b104f..f3d139b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -241,9 +241,11 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	 iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+	iwl_grab_nic_access(priv);
+	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
-- 
1.5.3.6


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/47] iwlwifi: dump firmware build info in error case
Date: Mon, 10 May 2010 15:27:43 -0700
Message-Id: <1273530498-11876-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Dump the firmware version and build number in case of firmware SW
error. This would help firmware engineer analyze the error log.

Requested-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0c3b984..d609414 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1068,6 +1068,9 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
+	IWL_ERR(priv, "Loaded firmware version: %s\n",
+		priv->hw->wiphy->fw_version);
+
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
 	if (priv->cfg->ops->lib->dump_csr)
 		priv->cfg->ops->lib->dump_csr(priv);
-- 
1.6.3.3


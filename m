Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab1DERBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/25] iwlagn: init cmd_queue earlier
Date: Tue,  5 Apr 2011 09:42:05 -0700
Message-Id: <1302021732-21250-19-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We know after loading the ucode whether it will
support PAN or not, so we can also initialise
the cmd_queue variable much earlier.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f0d88ae..3a8dd64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1698,6 +1698,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	} else
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 
+	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+	else
+		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+
 	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BTSTATS ||
 	    (priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics))
 		priv->bt_statistics = true;
@@ -2519,12 +2524,6 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	/* must be initialised before iwl_hw_nic_init */
-	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
-		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
-	else
-		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
-
 	ret = iwlagn_hw_nic_init(priv);
 	if (ret) {
 		IWL_ERR(priv, "Unable to init nic\n");
-- 
1.7.0.4


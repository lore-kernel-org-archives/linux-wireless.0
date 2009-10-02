Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbZJBUtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Huaxu Wan <huaxu.wan@linux.intel.com>,
	Guo Chaohong <chaohong.guo@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/13] iwlwifi: clear the translate table area
Date: Fri,  2 Oct 2009 13:44:00 -0700
Message-Id: <1254516247-4085-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Huaxu Wan <huaxu.wan@linux.intel.com>

Driver should clear the translate table area after receiving "Alive"
response from uCode. This patch corrects a mistake when doing this.

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Guo Chaohong <chaohong.guo@linux.intel.com>
Acked-by: Ben M Cahill  <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4e492c1..0921e45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -663,7 +663,8 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr + IWL49_SCD_TRANSLATE_TBL_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < sizeof(u16) * priv->hw_params.max_txq_num; a += 4)
+	for (; a < priv->scd_base_addr +
+	       IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 660fd51..01d53eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -748,7 +748,8 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 	for (; a < priv->scd_base_addr + IWL50_SCD_TRANSLATE_TBL_OFFSET;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < sizeof(u16) * priv->hw_params.max_txq_num; a += 4)
+	for (; a < priv->scd_base_addr +
+	       IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
 	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
-- 
1.5.6.3


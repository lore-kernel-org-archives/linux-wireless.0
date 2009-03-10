Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbZCJVaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: add rf information in rate_scale debugfs command
Date: Tue, 10 Mar 2009 14:35:08 -0700
Message-Id: <1236720912-6502-3-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223018_815868_07D90D4D)
In-Reply-To: <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding more Radio information when displaying
rate_scale_table. This can help to understand how many antenna and the
current RF condition such as SISO, MIMO2, MIMO3.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 039ad57..9bcebf2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2527,6 +2527,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
 	struct iwl_priv *priv;
+	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 
 	priv = lq_sta->drv;
 	buff = kmalloc(1024, GFP_KERNEL);
@@ -2543,6 +2544,16 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
 	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
 	    (priv->hw_params.valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	desc += sprintf(buff+desc, "lq type %s\n",
+	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
+	if (is_Ht(tbl->lq_type)) {
+		desc += sprintf(buff+desc, " %s",
+		   (is_siso(tbl->lq_type)) ? "SISO" :
+		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
+		   desc += sprintf(buff+desc, " %s",
+		   (tbl->is_fat) ? "40MHz" : "20MHz");
+		desc += sprintf(buff+desc, " %s\n", (tbl->is_SGI) ? "SGI" : "");
+	}
 	desc += sprintf(buff+desc, "general:"
 		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
 		lq_sta->lq.general_params.flags,
-- 
1.5.6.3


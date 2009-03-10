Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZCJVaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: add valid tx antenna information in rate_scale_table debugfs
Date: Tue, 10 Mar 2009 14:35:07 -0700
Message-Id: <1236720912-6502-2-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223019_212814_60173C16)
In-Reply-To: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

when display rate_scale_table debugfs information, also display valid tx
antenna information, this will help user to select correct antenna when
issue fixed rate debugfs command

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 99da406..039ad57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2526,7 +2526,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
+	struct iwl_priv *priv;
 
+	priv = lq_sta->drv;
 	buff = kmalloc(1024, GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
@@ -2537,6 +2539,10 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
+	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
+	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (priv->hw_params.valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "general:"
 		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
 		lq_sta->lq.general_params.flags,
-- 
1.5.6.3


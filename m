Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbEZTSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/39] iwlwifi: mvm: Add debugfs entry for Tx power limit
Date: Tue, 26 May 2015 22:17:22 +0300
Message-Id: <1432667872-18092-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211826_832950_624DB8B4)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add debugfs entry for showing the different Tx power restrictions that are
caused due to various reasons.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 5f37eab..5c8a65d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -190,6 +190,21 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t iwl_dbgfs_tx_pwr_lmt_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	char buf[64];
+	int bufsz = sizeof(buf);
+	int pos;
+
+	pos = scnprintf(buf, bufsz, "bss limit = %d\n",
+			vif->bss_conf.txpower);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 static ssize_t iwl_dbgfs_pm_params_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos)
@@ -607,6 +622,7 @@ static ssize_t iwl_dbgfs_rx_phyinfo_read(struct file *file,
 	} while (0)
 
 MVM_DEBUGFS_READ_FILE_OPS(mac_params);
+MVM_DEBUGFS_READ_FILE_OPS(tx_pwr_lmt);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
@@ -641,6 +657,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
 					 S_IRUSR);
 
+	MVM_DEBUGFS_ADD_FILE_VIF(tx_pwr_lmt, mvmvif->dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
-- 
2.1.4


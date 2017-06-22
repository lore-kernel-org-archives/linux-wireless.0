Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34278 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753731AbdFVVVO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:45 +0300
Message-Id: <20170622212101.16422-10-luca@coelho.fi> (sfid-20170622_232120_864668_71551FD5)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: use scnprintf() instead of snprintf()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's safer to use scnprintf() here because the buffer might
be too short for the full format strings. In most cases
this isn't true because of external limits on the values.

In one case, this fixes a stack data leak.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 5d475b4850ae..a7ac281e5cde 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1304,11 +1304,11 @@ static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 	char buf[30] = {};
 	int len;
 
-	len = snprintf(buf, sizeof(buf) - 1,
-		       "traffic=%d\ndbgfs=%d\nvcmd=%d\n",
-		       mvmvif->low_latency_traffic,
-		       mvmvif->low_latency_dbgfs,
-		       mvmvif->low_latency_vcmd);
+	len = scnprintf(buf, sizeof(buf) - 1,
+			"traffic=%d\ndbgfs=%d\nvcmd=%d\n",
+			mvmvif->low_latency_traffic,
+			mvmvif->low_latency_dbgfs,
+			mvmvif->low_latency_vcmd);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -1385,10 +1385,12 @@ static ssize_t iwl_dbgfs_rx_phyinfo_read(struct file *file,
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	char buf[8];
+	int len;
 
-	snprintf(buf, sizeof(buf), "0x%04x\n", mvmvif->mvm->dbgfs_rx_phyinfo);
+	len = scnprintf(buf, sizeof(buf), "0x%04x\n",
+			mvmvif->mvm->dbgfs_rx_phyinfo);
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
 static void iwl_dbgfs_quota_check(void *data, u8 *mac,
@@ -1439,7 +1441,7 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
 	char buf[10];
 	int len;
 
-	len = snprintf(buf, sizeof(buf), "%d\n", mvmvif->dbgfs_quota_min);
+	len = scnprintf(buf, sizeof(buf), "%d\n", mvmvif->dbgfs_quota_min);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
-- 
2.11.0

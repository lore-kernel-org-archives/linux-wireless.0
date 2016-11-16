Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752955AbcKPNJ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:09:59 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 2/5] mwifiex: do not free firmware dump memory in shutdown_drv
Date: Wed, 16 Nov 2016 18:39:06 +0530
Message-ID: <1479301749-14803-2-git-send-email-akarwar@marvell.com> (sfid-20161116_141002_832022_0AAB4789)
In-Reply-To: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

mwifiex_upload_device_dump() already takes care of freeing firmware dump
memory. Doing the same thing in mwifiex_shutdown_drv() is redundant.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Same as v1. 
drv_info_dump and drv_info_size need not be in adapter structure. Saparate
patch is created for this (Dmitry Torokhov)
v3: Same as [v2,3/5]
---
 drivers/net/wireless/marvell/mwifiex/init.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index f581a15..87cda4f 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -408,8 +408,6 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
-	int idx;
-
 	if (!adapter) {
 		pr_err("%s: adapter is NULL\n", __func__);
 		return;
@@ -427,23 +425,6 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, INFO, "info: free cmd buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
-	for (idx = 0; idx < adapter->num_mem_types; idx++) {
-		struct memory_type_mapping *entry =
-				&adapter->mem_type_mapping_tbl[idx];
-
-		if (entry->mem_ptr) {
-			vfree(entry->mem_ptr);
-			entry->mem_ptr = NULL;
-		}
-		entry->mem_size = 0;
-	}
-
-	if (adapter->drv_info_dump) {
-		vfree(adapter->drv_info_dump);
-		adapter->drv_info_dump = NULL;
-		adapter->drv_info_size = 0;
-	}
-
 	if (adapter->sleep_cfm)
 		dev_kfree_skb_any(adapter->sleep_cfm);
 }
-- 
1.9.1

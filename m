Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0CHFRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 00:17:55 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] libipw: split ieee->networks into small pieces
Date: Mon,  8 Mar 2010 13:18:03 +0800
Message-Id: <1268025483-9267-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee->networks consists of 128 struct libipw_network entries. If
we allocate this chunk of memory altogether, it ends up with an
order 4 page allocation. High order page allocation is likely to fail
on system high load. This patch splits the big chunk memory allocation
into small pieces, each is 344 bytes, allocates them with 128 times.

The patch fixed bug http://bugzilla.kernel.org/show_bug.cgi?id=14989

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2x00/libipw.h        |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c |   37 ++++++++++++--------------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index bf45391..a6d5e42 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -797,7 +797,7 @@ struct libipw_device {
 	/* Probe / Beacon management */
 	struct list_head network_free_list;
 	struct list_head network_list;
-	struct libipw_network *networks;
+	struct libipw_network *networks[MAX_NETWORK_COUNT];
 	int scans;
 	int scan_age;
 
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 1ae0b2b..2fa5586 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -67,16 +67,17 @@ void *libipw_wiphy_privid = &libipw_wiphy_privid;
 
 static int libipw_networks_allocate(struct libipw_device *ieee)
 {
-	if (ieee->networks)
-		return 0;
-
-	ieee->networks =
-	    kzalloc(MAX_NETWORK_COUNT * sizeof(struct libipw_network),
-		    GFP_KERNEL);
-	if (!ieee->networks) {
-		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
-		       ieee->dev->name);
-		return -ENOMEM;
+	int i, j;
+
+	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
+		ieee->networks[i] = kzalloc(sizeof(struct libipw_network),
+					    GFP_KERNEL);
+		if (!ieee->networks[i]) {
+			LIBIPW_ERROR("Out of memory allocating beacons\n");
+			for (j = 0; j < i; j++)
+				kfree(ieee->networks[j]);
+			return -ENOMEM;
+		}
 	}
 
 	return 0;
@@ -97,15 +98,11 @@ static inline void libipw_networks_free(struct libipw_device *ieee)
 {
 	int i;
 
-	if (!ieee->networks)
-		return;
-
-	for (i = 0; i < MAX_NETWORK_COUNT; i++)
-		if (ieee->networks[i].ibss_dfs)
-			kfree(ieee->networks[i].ibss_dfs);
-
-	kfree(ieee->networks);
-	ieee->networks = NULL;
+	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
+		if (ieee->networks[i]->ibss_dfs)
+			kfree(ieee->networks[i]->ibss_dfs);
+		kfree(ieee->networks[i]);
+	}
 }
 
 void libipw_networks_age(struct libipw_device *ieee,
@@ -130,7 +127,7 @@ static void libipw_networks_initialize(struct libipw_device *ieee)
 	INIT_LIST_HEAD(&ieee->network_free_list);
 	INIT_LIST_HEAD(&ieee->network_list);
 	for (i = 0; i < MAX_NETWORK_COUNT; i++)
-		list_add_tail(&ieee->networks[i].list,
+		list_add_tail(&ieee->networks[i]->list,
 			      &ieee->network_free_list);
 }
 
-- 
1.6.3.3


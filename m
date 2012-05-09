Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:38481 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755426Ab2EIBch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:32:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 01/18] mwifiex: allocate space for one more mwifiex_private structure
Date: Tue,  8 May 2012 18:30:13 -0700
Message-Id: <1336527030-2045-2-git-send-email-bzhao@marvell.com> (sfid-20120509_033241_485096_9756A23E)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Reserve space for one more priv structure.
This will be used by AP interface.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |    2 +-
 drivers/net/wireless/mwifiex/main.c |   33 ++++++++++++++++++---------------
 drivers/net/wireless/mwifiex/wmm.c  |    4 ++++
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index d04aba4..6b8f912 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -28,7 +28,7 @@
 #include <linux/ieee80211.h>
 
 
-#define MWIFIEX_MAX_BSS_NUM         (1)
+#define MWIFIEX_MAX_BSS_NUM         (2)
 
 #define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
 					 *   + 4 byte alignment
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index be0f0e5..5ac0059 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -64,17 +64,17 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 	adapter->priv_num = 0;
 
-	/* Allocate memory for private structure */
-	adapter->priv[0] = kzalloc(sizeof(struct mwifiex_private), GFP_KERNEL);
-	if (!adapter->priv[0]) {
-		dev_err(adapter->dev,
-			"%s: failed to alloc priv[0]\n", __func__);
-		goto error;
-	}
-
-	adapter->priv_num++;
+	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
+		/* Allocate memory for private structure */
+		adapter->priv[i] =
+			kzalloc(sizeof(struct mwifiex_private), GFP_KERNEL);
+		if (!adapter->priv[i])
+			goto error;
 
-	adapter->priv[0]->adapter = adapter;
+		adapter->priv[i]->adapter = adapter;
+		adapter->priv[i]->bss_priority = i;
+		adapter->priv_num++;
+	}
 	mwifiex_init_lock_list(adapter);
 
 	init_timer(&adapter->cmd_timer);
@@ -836,13 +836,16 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	}
 
 	priv = adapter->priv[0];
-	if (!priv)
+	if (!priv || !priv->wdev)
 		goto exit_remove;
 
-	if (priv->wdev) {
-		wiphy_unregister(priv->wdev->wiphy);
-		wiphy_free(priv->wdev->wiphy);
-		kfree(priv->wdev);
+	wiphy_unregister(priv->wdev->wiphy);
+	wiphy_free(priv->wdev->wiphy);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv)
+			kfree(priv->wdev);
 	}
 
 	mwifiex_terminate_workqueue(adapter);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 429a1de..f3fc655 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -885,6 +885,10 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				tid_ptr = &(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
 
+				/* For non-STA ra_list_curr may be NULL */
+				if (!tid_ptr->ra_list_curr)
+					continue;
+
 				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
 						  flags);
 				is_list_empty =
-- 
1.7.0.2


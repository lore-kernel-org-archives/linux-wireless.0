Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48256 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161251Ab3DEDET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 23:04:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	<daniel@zonque.org>, Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 2/4] mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl
Date: Thu, 4 Apr 2013 20:03:51 -0700
Message-ID: <1365131033-7417-3-git-send-email-bzhao@marvell.com> (sfid-20130405_050429_127615_B50CB3F6)
In-Reply-To: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
References: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

ra_list_spinlock is used to protect struct mwifiex_wmm_desc and
embedded structures such as ra_list. tid_tbl_lock while more fine
grained, is not used but in one function. That function is not
called reentrantly. To protect ra_list from concurrent modification
ra_list_spinlock must be held.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    4 +---
 drivers/net/wireless/mwifiex/main.h |    2 --
 drivers/net/wireless/mwifiex/wmm.c  |    8 ++++----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 003c014..42d7f0a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -533,10 +533,8 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		if (!adapter->priv[i])
 			continue;
 		priv = adapter->priv[i];
-		for (j = 0; j < MAX_NUM_TID; ++j) {
+		for (j = 0; j < MAX_NUM_TID; ++j)
 			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);
-			spin_lock_init(&priv->wmm.tid_tbl_ptr[j].tid_tbl_lock);
-		}
 		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 		INIT_LIST_HEAD(&priv->sta_list);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fef89fd..622b17f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -213,8 +213,6 @@ struct mwifiex_ra_list_tbl {
 
 struct mwifiex_tid_tbl {
 	struct list_head ra_list;
-	/* spin lock for tid table */
-	spinlock_t tid_tbl_lock;
 	struct mwifiex_ra_list_tbl *ra_list_curr;
 };
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 1b039ba..c1d8488 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -927,12 +927,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				if (!tid_ptr->ra_list_curr)
 					continue;
 
-				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
-						  flags);
+				spin_lock_irqsave(&priv_tmp->wmm.
+						  ra_list_spinlock, flags);
 				is_list_empty =
 					list_empty(&tid_ptr->ra_list);
-				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
-						       flags);
+				spin_unlock_irqrestore(&priv_tmp->wmm.
+						       ra_list_spinlock, flags);
 				if (is_list_empty)
 					continue;
 
-- 
1.7.0.2


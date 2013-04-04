Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64951 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762570Ab3DDVBp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 17:01:45 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MCNrj-1UWLjV24wL-0099e7 for
 <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 23:01:44 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 2/4] mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
Date: Thu,  4 Apr 2013 23:01:23 +0200
Message-Id: <1365109286-5075-2-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130404_230156_446495_7B0F2225)
In-Reply-To: <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <20130404205706.GA29851@blumentopf>
 <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ra_list_spinlock is used to protect struct mwifiex_wmm_desc and embedded
structures such as ra_list. tid_tbl_lock while more fine grained, is not
used but in one function. That function is not called reentrantly. To
protect ra_list from concurrent modification ra_list_spinlock must be held.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 -
 drivers/net/wireless/mwifiex/main.h |    2 --
 drivers/net/wireless/mwifiex/wmm.c  |    8 ++++----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e38aa9b..ba9c5a5 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -535,7 +535,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		priv = adapter->priv[i];
 		for (j = 0; j < MAX_NUM_TID; ++j) {
 			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);
-			spin_lock_init(&priv->wmm.tid_tbl_ptr[j].tid_tbl_lock);
 		}
 		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 553adfb..d94406a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -210,8 +210,6 @@ struct mwifiex_ra_list_tbl {
 
 struct mwifiex_tid_tbl {
 	struct list_head ra_list;
-	/* spin lock for tid table */
-	spinlock_t tid_tbl_lock;
 	struct mwifiex_ra_list_tbl *ra_list_curr;
 };
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index b132c42..96eed2f 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -930,12 +930,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
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
1.7.10.4


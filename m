Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60798 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab3DBAJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 20:09:40 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M4EkX-1UeLg03RA3-00rqtg for
 <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 02:09:39 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 6/6] mwifiex: hold proper locks when accessing ra_list / bss_prio lists.
Date: Tue,  2 Apr 2013 02:08:45 +0200
Message-Id: <1364861325-30844-6-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130402_020953_801202_04F6B18D)
In-Reply-To: <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using forward iteration only, is no protection from calls to list_del.
Also due to list rotation, lists are modified frequently, and having
removed the head could lead to an infinite loop when calling
list_for_each. Currently this is not a problem, since list rotation
and dequeue always happen in the same thread.
But this is no proper lockfree technique, and hence proper locks
should be held when accessing those lists.
Patch also remove list_empty calls, relying on the embedded check in
list_for_each_entry.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/wmm.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 4d8a5ca..0a22656 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -883,20 +883,13 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	struct mwifiex_ra_list_tbl *ptr;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
-	int is_list_empty;
-	unsigned long flags;
+	unsigned long flags_bss, flags_ra;
 	int i, j;
 
 	/* check the BSS with highest priority first */
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				  flags);
-		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
-					   .bss_prio_head);
-		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				       flags);
-		if (is_list_empty)
-			continue;
+				  flags_bss);
 
 		/* iterate over BSS with the equal priority */
 		list_for_each_entry(adapter->bss_prio_tbl[j].bss_prio_cur,
@@ -916,33 +909,38 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 					tid_tbl_ptr[tos_to_tid[i]];
 
 				spin_lock_irqsave(&priv_tmp->wmm.
-						  ra_list_spinlock, flags);
-				is_list_empty =
-					list_empty(&tid_ptr->ra_list);
-				spin_unlock_irqrestore(&priv_tmp->wmm.
-						       ra_list_spinlock, flags);
-				if (is_list_empty)
-					continue;
+						  ra_list_spinlock, flags_ra);
 
 				/* iterate over receiver addresses */
 				list_for_each_entry(ptr, &tid_ptr->ra_list,
 						    list) {
 
-					if (!skb_queue_empty(&ptr->skb_head))
+					if (!skb_queue_empty(&ptr->skb_head)) {
+						/* holds both locks */
 						goto found;
+					}
 
 				}
+
+				spin_unlock_irqrestore(&priv_tmp->wmm.
+						       ra_list_spinlock,
+						       flags_ra);
 			}
 
 		}
+
+		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				       flags_bss);
 	}
 	return NULL;
 
 found:
-	spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
+	/* holds bss_prio_lock / ra_list_spinlock */
 	if (atomic_read(hqp) > i)
 		atomic_set(hqp, i);
-	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags);
+	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags_ra);
+	spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+			       flags_bss);
 
 	*priv = priv_tmp;
 	*tid = tos_to_tid[i];
-- 
1.7.10.4


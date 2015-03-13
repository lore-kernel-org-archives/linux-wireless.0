Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24841 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbbCMGir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:38:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2D6ckSL030184
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:47 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1t3m0fryac-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:46 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 6/9] mwifiex: remove_bss_prio_lock
Date: Fri, 13 Mar 2015 17:37:56 +0530
Message-ID: <1426248479-28451-7-git-send-email-patila@marvell.com> (sfid-20150313_073850_195047_6ABA6449)
In-Reply-To: <1426248479-28451-1-git-send-email-patila@marvell.com>
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch does away with spinlock in
mwifiex_wmm_get_highest_priolist_ptr in order to improve TP.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2d14dd5..a6db12c 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -944,14 +944,11 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	struct mwifiex_ra_list_tbl *ptr;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
-	unsigned long flags_bss, flags_ra;
+	unsigned long flags_ra;
 	int i, j;
 
 	/* check the BSS with highest priority first */
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
-		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				  flags_bss);
-
 		/* iterate over BSS with the equal priority */
 		list_for_each_entry(adapter->bss_prio_tbl[j].bss_prio_cur,
 				    &adapter->bss_prio_tbl[j].bss_prio_head,
@@ -987,19 +984,15 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 			}
 		}
 
-		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				       flags_bss);
 	}
 
 	return NULL;
 
 found:
-	/* holds bss_prio_lock / ra_list_spinlock */
+	/* holds ra_list_spinlock */
 	if (atomic_read(hqp) > i)
 		atomic_set(hqp, i);
 	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags_ra);
-	spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-			       flags_bss);
 
 	*priv = priv_tmp;
 	*tid = tos_to_tid[i];
-- 
1.8.1.4


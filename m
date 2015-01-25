Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbbAYIxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:41 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 10/10] wil6210: move Rx reorder buffer allocation out of spinlock
Date: Sun, 25 Jan 2015 10:52:51 +0200
Message-Id: <1422175971-8075-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_101445_381705_FBE49888)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes issue reported by Dan Carpenter:
The patch 3277213feb1b: "wil6210: ADDBA/DELBA flows" from Dec 23,
2014, leads to the following static checker warning:

        drivers/net/wireless/ath/wil6210/rx_reorder.c:205 wil_tid_ampdu_rx_alloc()
        error: scheduling with locks held: 'spin_lock:tid_rx_lock'

drivers/net/wireless/ath/wil6210/rx_reorder.c
   202  struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
   203                                                  int size, u16 ssn)
   204  {
   205          struct wil_tid_ampdu_rx *r = kzalloc(sizeof(*r), GFP_KERNEL);
                                                                 ^^^^^^^^^^
   206
   207          if (!r)
   208                  return NULL;
   209
   210          r->reorder_buf =
   211                  kcalloc(size, sizeof(struct sk_buff *), GFP_KERNEL);
                                                                ^^^^^^^^^^^
   212          r->reorder_time =
   213                  kcalloc(size, sizeof(unsigned long), GFP_KERNEL);
                                                             ^^^^^^^^^^^
   214          if (!r->reorder_buf || !r->reorder_time) {
   215                  kfree(r->reorder_buf);
   216                  kfree(r->reorder_time);
   217                  kfree(r);
   218                  return NULL;
   219          }
   220

[ snip ]

   331          spin_lock_bh(&sta->tid_rx_lock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
spin lock held.

   332
   333          wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
   334          sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function called with the lock held.

   335
   336          spin_unlock_bh(&sta->tid_rx_lock);

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 5522092..ca10dcf 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -292,6 +292,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	u16 agg_timeout = req->ba_timeout;
 	u16 status = WLAN_STATUS_SUCCESS;
 	u16 ssn = req->ba_seq_ctrl >> 4;
+	struct wil_tid_ampdu_rx *r;
 	int rc;
 
 	might_sleep();
@@ -328,11 +329,10 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 		return;
 
 	/* apply */
+	r = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
 	spin_lock_bh(&sta->tid_rx_lock);
-
 	wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
-	sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
-
+	sta->tid_rx[tid] = r;
 	spin_unlock_bh(&sta->tid_rx_lock);
 }
 
-- 
2.1.0


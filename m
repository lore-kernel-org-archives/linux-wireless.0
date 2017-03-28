Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:64799 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754641AbdC1I63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:29 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-wireless@vger.kernel.org,
        ganeshgr@chelsio.com, nbd@openwrt.org, blogic@openwrt.org,
        matthias.bgg@gmail.com, yishaih@mellanox.com, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com,
        ajk@comnets.uni-bremen.de, paulus@samba.org, j@w1.fi,
        kvalo@codeaurora.org, peterz@infradead.org, keescook@chromium.org,
        gregkh@linuxfoundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 05/16] drivers, net, mlx4: convert mlx4_srq.refcount from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:32 +0300
Message-Id: <1490691403-4016-6-git-send-email-elena.reshetova@intel.com> (sfid-20170328_110903_276213_17E6939B)
In-Reply-To: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/srq.c | 8 ++++----
 include/linux/mlx4/device.h              | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index f44d089..3369f65 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -49,7 +49,7 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
 	rcu_read_unlock();
 	if (srq)
-		atomic_inc(&srq->refcount);
+		refcount_inc(&srq->refcount);
 	else {
 		mlx4_warn(dev, "Async event for bogus SRQ %08x\n", srqn);
 		return;
@@ -57,7 +57,7 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 
 	srq->event(srq, event_type);
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 }
 
@@ -203,7 +203,7 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	if (err)
 		goto err_radix;
 
-	atomic_set(&srq->refcount, 1);
+	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
 
 	return 0;
@@ -232,7 +232,7 @@ void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
 	radix_tree_delete(&srq_table->tree, srq->srqn);
 	spin_unlock_irq(&srq_table->lock);
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 	wait_for_completion(&srq->free);
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 756ca22..8998807 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -766,7 +766,7 @@ struct mlx4_srq {
 	int			max_gs;
 	int			wqe_shift;
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
-- 
2.7.4
